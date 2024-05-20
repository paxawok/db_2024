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
    new_product = request.json
    query = f"""
    CALL create_product('{new_product["name"]}', '{new_product["description"]}', {new_product["price"]}, {new_product["category_id"]});
    """
    execute_query(connection, query)
    return jsonify({"message": "Product added successfully"}), 201

@app.route('/products/<int:id>', methods=['PUT'])
def update_product(id):
    connection = connect()
    product = request.json
    query = f"""
    CALL update_product({id}, '{product["name"]}', '{product["description"]}', {product["price"]}, {product["category_id"]});
    """
    execute_query(connection, query)
    return jsonify({"message": "Product updated successfully"})

@app.route('/products/<int:id>', methods=['DELETE'])
def delete_product(id):
    connection = connect()
    query = f"CALL delete_product({id});"
    execute_query(connection, query)
    return jsonify({"message": "Product deleted successfully"})

@app.route('/transaction', methods=['POST'])
def perform_transaction():
    connection = connect()
    if connection is None:
        return jsonify({'error': 'Database connection failed'}), 500

    transaction_data = request.json
    try:
        with connection:
            with connection.cursor() as cursor:
                for operation in transaction_data["operations"]:
                    if operation["type"] == "insert":
                        cursor.execute("""
                            INSERT INTO Products (name, description, price, category_id) 
                            VALUES (%s, %s, %s, %s);
                        """, (
                            operation["name"], 
                            operation["description"], 
                            operation["price"], 
                            operation["category_id"]
                        ))
                    elif operation["type"] == "update":
                        cursor.execute("""
                            UPDATE Products 
                            SET 
                                name = %s,
                                description = %s,
                                price = %s,
                                category_id = %s
                            WHERE id = %s;
                        """, (
                            operation["name"], 
                            operation["description"], 
                            operation["price"], 
                            operation["category_id"], 
                            operation["id"]
                        ))
    except Exception as e:
        print("Error during transaction:", e)
        connection.rollback()
        return jsonify({'error': 'Failed to perform transaction', 'details': str(e)}), 500

    return jsonify({"message": "Transaction performed successfully"})

if __name__ == '__main__':
    app.run(debug=True)
