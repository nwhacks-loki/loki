import sys

import coremltools
import numpy as np
from keras.models import Sequential
from keras.layers import Dense

sys.path.insert(0, '../data-backend')
from models import Emotion


EMOTIONS = {
    'happy': 0,
    'sad': 1,
    'angry': 2,
    'surprised': 3,
}


class Computation:
    def feedForwardNetwork(self, datapoint, hidden_neurons_1, hidden_neurons_2, outputClasses):
        model = Sequential()
        model.add(Dense(hidden_neurons_1, input_dim=datapoint, activation='tanh'))
        model.add(Dense(hidden_neurons_2, input_dim=hidden_neurons_1, activation='tanh'))
        model.add(Dense(outputClasses, activation='softmax'))
        model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
        print(model.summary())
        return model

    def prepareData(self, data, test_data):
        emotion = []
        dimensions = []
        for face in data:
            faceData = []
            for key, value in sorted(face.items()):
                if key == 'emotion':
                    emotion.append(EMOTIONS[value])
                else:
                    faceData.append(value)

            dimensions.append(faceData)

        # Separate the test datapoint
        test_X = dimensions[test_data]
        test_y = emotion[test_data]

        dimensions.pop(test_data)
        emotion.pop(test_data)

        oneHotOutput = np.eye(4)[emotion]
        input = np.asarray(dimensions)

        return input, oneHotOutput, test_X, test_y

    def loadDBData(self):
        db_data = []
        for entry in Emotion.select():
            db_data.append(entry.data)
        return db_data

    def testDatapoint(self, model, X, y):
        prediction = model.predict(np.asarray([X]), verbose=0)[0]
        groundTruth = 'unknown'
        if y == 0:
            groundTruth = 'happy'

        if y == 1:
            groundTruth = 'sad'

        if y == 2:
            groundTruth = 'angry'

        if y == 3:
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


def train_model(output_mlmodel=False):

    test_datapoint = 9

    # Create new Object
    computation = Computation()

    # Connect to the database and retrieve the data
    dbData = computation.loadDBData()

    # Preprocess the data for the neural network
    X, y, test_X, test_y = computation.prepareData(dbData, test_datapoint)

    # Generate the neural network topology
    model = computation.feedForwardNetwork(51,40, 30,4)

    # Train the model with the preprocessed data
    hist = model.fit(X, y, batch_size=10, epochs=100)

    # Save the trained model
    model.save("model.h5")
    print("Saved trained Keras model to `model.h5`.")

    # Define the test case
    computation.testDatapoint(model, test_X, test_y)

    # Comment in when running on the server
    # Save the neural network as a iPhone compatible ML model
    if output_mlmodel:
        iphone_model = coremltools.converters.keras.convert("./model.h5")
        iphone_model.save('model.mlmodel')
        print("Saved CoreML model to `model.mlmodel`.")

    # Return dictionary with history of accuracy and loss
    return hist.history


if __name__ == '__main__':
    train_model()
