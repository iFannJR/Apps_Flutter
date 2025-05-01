from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config["MONGO_URI"] = "mongodb://localhost:27017/flutter_auth"
mongo = PyMongo(app)
users = mongo.db.users

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if users.find_one({'email': data['email']}):
        return jsonify({'error': 'Email sudah digunakan'}), 400
    users.insert_one({'email': data['email'], 'password': data['password']})
    return jsonify({'message': 'Registrasi berhasil'}), 201

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = users.find_one({'email': data['email'], 'password': data['password']})
    if user:
        return jsonify({'message': 'Login berhasil'}), 200
    return jsonify({'error': 'Login gagal'}), 401

if __name__ == '__main__':
    app.run(debug=True)

