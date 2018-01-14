import json

data = json.load(open('./data.txt'))

outfile = []

for face in data:
	faceData = []
	for _, value in face.iteritems():
		# value.replace('happy', 0).replace('sad', 1).replace('anger', 2).replace('surprised', 3)
		value = 0 if value == 'happy' else value
		value = 1 if value == 'sad' else value
		value = 2 if value == 'anger' else value
		value = 3 if value == 'surprised' else value
		faceData.append(value)
	outfile.append(faceData)

print outfile

