from flask import Flask, request, jsonify
from flask_cors import CORS
from models import insert_transaction, get_transactions

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

@app.route('/', methods=['GET'])
def root():
    return jsonify({'message': 'API aktif dan bisa diakses!'})

@app.route('/transaksi', methods=['POST'])
def tambah_transaksi():
    data = request.json
    insert_transaction(
        data['title'],
        data['amount'],
        data['time'],
        data['type'],
        data['date'],
    )
    return jsonify({'message': 'Transaksi berhasil ditambahkan'}), 201

@app.route('/transaksi', methods=['GET'])
def ambil_transaksi():
    data = get_transactions()

    for item in data:
        if isinstance(item['date'], (str, type(None))):
            continue
        item['date'] = item['date'].isoformat()

    return jsonify(data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
