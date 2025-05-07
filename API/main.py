from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config["MONGO_URI"] = "mongodb://localhost:27017/test" 
mongo = PyMongo(app)
users = mongo.db.test

# Registrasi pengguna
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    if users.find_one({'email': email}):
        return jsonify({'error': 'Email sudah digunakan'}), 400

    users.insert_one({'email': email, 'password': password})
    return jsonify({'message': 'Registrasi berhasil'}), 201

# Login pengguna
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    user = users.find_one({'email': email, 'password': password})
    if user:
        return jsonify({'message': 'Login berhasil'}), 200
    return jsonify({'error': 'Login gagal'}), 401

if __name__ == '__main__':
    app.run(debug=True)
