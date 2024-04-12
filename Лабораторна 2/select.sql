-- Active: 1712562691271@@127.0.0.1@5432@online_store
SELECT * FROM Clients WHERE name = 'Véronique';
SELECT * FROM Payments;
UPDATE Clients SET address = 'Suite 36' WHERE id = 12339532;
SELECT * FROM Products WHERE category = 'Drama';
SELECT * FROM Orders WHERE status = 'pending';
SELECT category FROM Products WHERE price > 3900;

SELECT AVG(amount) AS average_check FROM payments;

SELECT Orders.id AS order_id, Clients.name AS client_name, Products.name AS product_name, Order_Details.quantity
FROM Orders
JOIN Clients ON Orders.client_id = Clients.id
JOIN Order_Details ON Orders.id = Order_Details.order_id
JOIN Products ON Order_Details.product_id = Products.id;

SELECT Orders.id AS order_id, Clients.name AS client_name, 
       SUM(Order_Details.quantity * Products.price) AS total_cost
FROM Orders
JOIN Clients ON Orders.client_id = Clients.id
JOIN Order_Details ON Orders.id = Order_Details.order_id
JOIN Products ON Order_Details.product_id = Products.id
GROUP BY Orders.id, Clients.name;


