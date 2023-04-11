from flask import Flask, jsonify
from blockchain import Blockchain

app = Flask(__name__)

blockchain = Blockchain()

@app.route('/', methods=['GET'])
def get_blockchain():
    response = {'chain': blockchain.chain,'length': len(blockchain.chain),}
    return jsonify(response), 200
