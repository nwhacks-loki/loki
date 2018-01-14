import numpy as np
import random
import json
from keras.models import Sequential
from keras.layers import Dense
import peewee
import psycopg2

def feedForwardNetwork(datapoint, hidden_neurons, outputClasses):
	model = Sequential()
	model.add(Dense(hidden_neurons, input_dim=datapoint, activation='tanh'))
	model.add(Dense(outputClasses, activation='softmax'))
	model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
	print model.summary() 
	return model

def prepareData(filePath):
	data = json.load(open(filePath))
	emotion = []
	dimensions = []
	for face in data:
		faceData = []
		for _, value in face.iteritems():
			# value.replace('happy', 0).replace('sad', 1).replace('anger', 2).replace('surprised', 3)
			value = 0 if value == 'happy' else value
			value = 1 if value == 'sad' else value
			value = 2 if value == 'anger' else value
			value = 3 if value == 'surprised' else value
			faceData.append(value)
		emotion.append(faceData[0])
		dimensions.append(faceData[1:])
	return emotion, dimensions

emotion, dimensions = prepareData("./data.json")

oneHotOutput = np.eye(4)[emotion]
input = np.asarray(dimensions)

# Prepare the data
model = feedForwardNetwork(51,50,4)

# Train
trainingResult = model.fit(input, oneHotOutput, batch_size=10, epochs=20)

# Save the model at the end of the iteration
model.save("./model.h5")

# Predict
prediction = model.predict(np.asarray([input[0]]), verbose=0)[0]

print "Prediction:"
print prediction
print "#"*50
print "Original:"
print oneHotOutput[0]