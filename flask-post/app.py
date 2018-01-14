import os
import json
import datetime

from flask import Flask, request, jsonify

from models import Emotion, db


app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return "Hello, world!"


@app.route('/post-emotion', methods=['POST'])
def post_emotion():
    data = request.get_json(silent=True)

    if data.get('emotion'):
        Emotion.create(data=data)
        print("{}: Recorded {} datapoint.".format(datetime.datetime.now(), data['emotion']))
        return jsonify(data)

    else:
        return jsonify({'error': 'invalid data'})


if __name__ == '__main__':
    db.connect()
    Emotion.create_table(fail_silently=True)

    port = int(os.environ.get('PORT', 5001))
    app.run(host='0.0.0.0', port=port)
