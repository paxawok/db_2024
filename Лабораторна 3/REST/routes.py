from flask import jsonify, request, Flask
import psycopg2
import sys
from db import connect, execute_query, execute_read_query

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Welcome to the Online Store API'

@app.route('/products', methods=['GET'])
def get_products():
    connection = connect()
    if connection is None:
        print("Failed to connect to the database", file=sys.stderr)
        return jsonify({'error': 'Database connection failed'}), 500

    query = "SELECT * FROM get_all_products();"
    products = execute_read_query(connection, query)
    if products is None:
        print("Failed to fetch products", file=sys.stderr)
        return jsonify({'error': 'Failed to fetch products'}), 500

    return jsonify(products)

@app.route('/products', methods=['POST'])
def create_product():
    connection = connect()
    if connection is None:
        print("Failed to connect to the database", file=sys.stderr)
        return jsonify({'error': 'Database connection failed'}), 500

    new_product = request.json
    try:
        with connection:
            with connection.cursor() as cursor:
                query = f"""
                CALL create_product(%s, %s, %s, %s);
                """
                cursor.execute(query, (new_product["name"], new_product["description"], new_product["price"], new_product["category_id"]))
    except Exception as e:
        connection.rollback()
        print("Failed to create product", file=sys.stderr)
        return jsonify({'error': 'Failed to create product', 'details': str(e)}), 500

    return jsonify({"message": "Product added successfully"}), 201

@app.route('/products/<int:id>', methods=['PUT'])
def update_product(id):
    connection = connect()
    if connection is None:
        print("Failed to connect to the database", file=sys.stderr)
        return jsonify({'error': 'Database connection failed'}), 500

    product = request.json
    try:
        with connection:
            with connection.cursor() as cursor:
                query = f"""
                CALL update_product(%s, %s, %s, %s, %s);
                """
                cursor.execute(query, (id, product["name"], product["description"], product["price"], product["category_id"]))
    except Exception as e:
        connection.rollback()
        print("Failed to update product", file=sys.stderr)
        return jsonify({'error': 'Failed to update product', 'details': str(e)}), 500

    return jsonify({"message": "Product updated successfully"})

@app.route('/products/<int:id>', methods=['DELETE'])
def delete_product(id):
    connection = connect()
    if connection is None:
        print("Failed to connect to the database", file=sys.stderr)
        return jsonify({'error': 'Database connection failed'}), 500

    try:
        with connection:
            with connection.cursor() as cursor:
                query = f"CALL delete_product(%s);"
                cursor.execute(query, (id,))
    except Exception as e:
        connection.rollback()
        print("Failed to delete product", file=sys.stderr)
        return jsonify({'error': 'Failed to delete product', 'details': str(e)}), 500

    return jsonify({"message": "Product deleted successfully"})

if __name__ == '__main__':
    app.run(debug=True)
