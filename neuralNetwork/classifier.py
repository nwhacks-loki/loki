import sys
import json
import random

import peewee
import psycopg2
import coremltools
import numpy as np
from keras.models import Sequential
from keras.layers import Dense

sys.path.insert(0, '../data-backend')
from models import Emotion


class Computation:
    def feedForwardNetwork(self, datapoint, hidden_neurons_1, hidden_neurons_2, outputClasses):
        model = Sequential()
        model.add(Dense(hidden_neurons_1, input_dim=datapoint, activation='tanh'))
        model.add(Dense(hidden_neurons_2, input_dim=hidden_neurons_1, activation='tanh'))
        model.add(Dense(outputClasses, activation='softmax'))
        model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
        print(model.summary())
        return model

    def prepareData(self, data):
        emotion = []
        dimensions = []
        for face in data:
            faceData = []
            for _, value in face.iteritems():
                # value.replace('happy', 0).replace('sad', 1).replace('anger', 2).replace('surprised', 3)
                value = 0 if value == 'happy' else value
                value = 1 if value == 'sad' else value
                value = 2 if value == 'angry' else value
                value = 3 if value == 'surprised' else value
                faceData.append(value)
            emotion.append(faceData[0])
            dimensions.append(faceData[1:])
        oneHotOutput = np.eye(4)[emotion]
        input = np.asarray(dimensions)
        return input, oneHotOutput

    def loadDBData(self):
        db_data = []
        for entry in Emotion.select():
            db_data.append(entry.data)
        return db_data

    def testDatapoint(self, datapoint, model, input, output):
        prediction = model.predict(np.asarray([input[datapoint]]), verbose=0)[0]
        groundTruth = 'unknown'
        if output[datapoint][0] == 1:
            groundTruth = 'happy'

        if output[datapoint][1] == 1:
            groundTruth = 'sad'

        if output[datapoint][2] == 1:
            groundTruth = 'angry'

        if output[datapoint][3] == 1:
            groundTruth = 'surprised'

        print("")
        print("")
        print("")
        print("Model Prediction:")
        print("Happy Probability = " + str('{:f}'.format(prediction[0]*100)) + '%')
        print("Sad Probability = " + str('{:f}'.format(prediction[1]*100)) + '%')
        print("Angry Probability = " + str('{:f}'.format(prediction[2]*100)) + '%')
        print("Surprised Probability = " + str('{:f}'.format(prediction[3]*100)) + '%')
        print("")
        print("")
        print("#"*50)
        print("")
        print("")
        print("The person has really been " + groundTruth)
        print("")
        print("")
        print("")


if __name__ == '__main__':
    # Create new Object
    computation = Computation()

    # Connect to the database and retrieve the data
    dbData = computation.loadDBData()

    # Preprocess the data for the neural network
    input, output = computation.prepareData(dbData)

    # Generate the neural network topology
    model = computation.feedForwardNetwork(51,40, 30,4)

    # Train the model with the preprocessed data
    trainingResult = model.fit(input, output, batch_size=10, epochs=100)

    # Save the trained model
    model.save("./model.h5")

    # Define the test case
    computation.testDatapoint(6, model, input, output)

    # Comment in when running on the server
    # Save the neural network as a iPhone compatible ML model
    '''
    iphone_model = coremltools.converters.keras.convert("./model.h5")
    iphone_model.save('iPhoneModel.mlmodel')
    '''

