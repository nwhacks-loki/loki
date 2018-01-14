import os

from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/', methods=['GET'])
def index():
    return "Hello, world!"


@app.route('/post-emotion', methods=['POST'])
def post_emotion():
    data = request.get_json(silent=True)
    print(data)
    return jsonify(data)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5001))
    app.run(host='0.0.0.0', port=port)
