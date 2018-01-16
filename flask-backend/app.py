import os
import datetime

from flask import Flask, request, jsonify, send_file

from models import Emotion, db


app = Flask(__name__)


@app.before_request
def _db_open():
    db.connect()


@app.teardown_request
def _db_close(exc):
    if not db.is_closed():
        db.close()


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


@app.route('/train-model')
def train_model_endpoint():
    import sys
    sys.path.insert(0, '../neuralNetwork')
    from classifier import train_model

    hist = train_model(output_mlmodel=True)
    return jsonify(hist)


@app.route('/model')
def serve_model():
    # if not os.path.isfile('model.mlmodel'):
    print("Training model to serve...")
    train_model_endpoint()

    return send_file(
        filename_or_fp='model.mlmodel',
        mimetype='application/octet-stream',
        as_attachment=True,
        attachment_filename='EmotionModel.mlmodel',
    )


@app.route('/data')
def get_data():
    return jsonify([e.data for e in Emotion.select()])


if __name__ == '__main__':
    db.connect()
    Emotion.create_table(fail_silently=True)
    db.close()

    port = int(os.environ.get('PORT', 5001))
    app.run(host='0.0.0.0', port=port)
