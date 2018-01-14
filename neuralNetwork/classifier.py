import numpy as np
import random
import json
import sys
from keras.models import Sequential
from keras.layers import Dense
import peewee
import psycopg2
sys.path.insert(0,'../flask-post')
from models import Emotion
 
def feedForwardNetwork(datapoint, hidden_neurons_1, hidden_neurons_2, outputClasses):
	model = Sequential()
	model.add(Dense(hidden_neurons_1, input_dim=datapoint, activation='tanh'))
	model.add(Dense(hidden_neurons_2, input_dim=hidden_neurons_1, activation='tanh'))
	model.add(Dense(outputClasses, activation='softmax'))
	model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
	print model.summary() 
	return model

def prepareData(data):
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
	return emotion, dimensions

db_data = []
for entry in Emotion.select():
	db_data.append(entry.data)
	
emotion, dimensions = prepareData(db_data)


oneHotOutput = np.eye(4)[emotion[:-1]]
input = np.asarray(dimensions[:-1])

# Prepare the data
model = feedForwardNetwork(51,40, 30,4)

# Train
trainingResult = model.fit(input, oneHotOutput, batch_size=10, epochs=100)

# Save the model at the end of the iteration
model.save("./model.h5")

# Predict
prediction = model.predict(np.asarray([input[9]]), verbose=0)[0]

print ""
print ""
print ""
print "Model Prediction:"
print prediction
print ""
print ""
print "#"*50
print ""
print ""
print "Ground Truth Data:"
print oneHotOutput[9]
print emotion[9]
print ""
print ""
print ""

import coremltools 

coreml_model = coremltools.converters.keras.convert("./model.h5")

