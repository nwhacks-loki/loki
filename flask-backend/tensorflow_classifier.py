
# Imports
##############################################
import tensorflow as tf
import numpy as np
import json
import os
from random import shuffle
from tensorflow.python.framework import dtypes
import nltk

from models import Emotion
##############################################

EMOTIONS = {
    'happy': 0,
    'sad': 1,
    'angry': 2,
    'surprised': 3,
}

def init_weights(shape):
    weights = tf.random_uniform(shape, maxval=.5, seed=1)
    return tf.Variable(weights)

def init_biases(amount):
    bias = tf.zeros(amount)
    return tf.Variable(bias)

def softmax(x):
	e_x = np.exp(x - np.max(x))
	return e_x / e_x.sum()

def forwardprop(inputs, w_1, w_2, w_3, b_1, b_2, b_3):
    h_1 = tf.nn.tanh(tf.matmul(inputs, w_1)+b_1)
    h_2 = tf.nn.tanh(tf.matmul(h_1, w_2)+b_2)
    y_pred = tf.matmul(h_2, w_3)+b_3
    return y_pred

def createBatch(listing, batchSize):
	length = len(listing)
	batchList = []
	for index in range(0, length, batchSize):
		if index + batchSize < length:
			batchList.append(listing[index:(index + batchSize)])
	return batchList

def prepareData(data, test_data):
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

def loadDBData():
	db_data = []
	for entry in Emotion.select():
		db_data.append(entry.data)
	return db_data

def FeedForwardNetwork(nb_datapoints, hidden_neurons_1, hidden_neurons_2, outputClasses):

	# Create placeholders
	inputs = tf.placeholder(dtypes.float32, shape=[None, nb_datapoints], name="inputs")
	outputs = tf.placeholder(dtypes.int32, shape=[None, outputClasses], name="outputs")

	# Weight initializations
	w_1 = init_weights((nb_datapoints, hidden_neurons_1))
	w_2 = init_weights((hidden_neurons_1, hidden_neurons_2))
	w_3 = init_weights((hidden_neurons_2, outputClasses))

	# Weight initializations
	b_1 = init_biases((hidden_neurons_1))
	b_2 = init_biases((hidden_neurons_2))
	b_3 = init_biases((outputClasses))

	# Forward propagation
	y_pred = forwardprop(inputs, w_1, w_2, w_3, b_1, b_2, b_3)

	# Backward propagation
	cost = tf.reduce_mean(tf.losses.softmax_cross_entropy(outputs, y_pred))
	updates = tf.train.AdamOptimizer().minimize(cost)

	return inputs, outputs, updates, y_pred


test_datapoint = 9

inputs, outputs, updates, y_pred = FeedForwardNetwork(51, 100, 100, 4)

dbData = loadDBData()

# Preprocess the data for the neural network
X, y, test_X, test_y = prepareData(dbData, test_datapoint)

labels = []
for element in y:
	if element[0] == 1:
		curr_label = 'happy'
	if element[1] == 1:
		curr_label = 'sad'
	if element[2] == 1:
		curr_label = 'angry'
	if element[3] == 1:
		curr_label = 'surprised'

	with open("./labels", 'a') as f:
		f.write('{}\n'.format(curr_label))

X_train = createBatch(X, 10)
y_train = createBatch(y, 10)

data = zip(X_train, y_train)

# Run SGD
sess = tf.Session()
init = tf.global_variables_initializer()
saver = tf.train.Saver(max_to_keep=None)
writer = tf.summary.FileWriter(".", graph=tf.get_default_graph())
sess.run(init)

for epoch in range(100):
	shuffle(data)
	for idx, batch in enumerate(data):
		sess.run(updates, feed_dict={inputs: data[0][0], outputs: data[0][1]})

saver.save(sess, "./tf_models/tf_model", global_step = epoch+1)
saver.save(sess, "./model.ckpt", epoch+1)


from tensorflow.contrib.tensorboard.plugins import projector
config = projector.ProjectorConfig()
embedding = config.embeddings.add()
embedding.metadata_path = './labels'
projector.visualize_embeddings(writer, config)

test_output = softmax(sess.run(y_pred, feed_dict={inputs: [test_X]})[0])
sess.close()

groundTruth = 'unknown'
if test_y == 0:
    groundTruth = 'happy'

if test_y == 1:
    groundTruth = 'sad'

if test_y == 2:
    groundTruth = 'angry'

if test_y == 3:
    groundTruth = 'surprised'


print("")
print("")
print("")
print("Model Prediction:")
print("Happy Probability = " + str('{:f}'.format(test_output[0]*100)) + '%')
print("Sad Probability = " + str('{:f}'.format(test_output[1]*100)) + '%')
print("Angry Probability = " + str('{:f}'.format(test_output[2]*100)) + '%')
print("Surprised Probability = " + str('{:f}'.format(test_output[3]*100)) + '%')
print("")
print("")
print("#"*50)
print("")
print("")
print("The person has really been " + groundTruth)
print("")
print("")
print("")


