-- Active: 1712562691271@@127.0.0.1@5432@online_store

-- 1. взяти всі записи з таблиці clients
select * from clients;

-- 2. взяти всі записи в таблиці clients де ім'я = Véronique
select * from clients where name = 'Véronique';

-- імена клєнтів що починаються на М і мають 4 літери 
select * from clients where name like 'M___';

-- те саме але закінчується на а, 5 літер
select * from products where name like '____a';

-- замовлення від 2024 року і кількість замовлень на день
select to_char(order_date, 'MM-DD'), count(*) as ammount 
from orders
where order_date > '2024-01-01'
group by to_char
order by to_char asc;

-- 3. оновити адресу в таблиці clients де id = 12339532
update clients set address = 'Suite 36' where id = 12339532;

-- 4. виділити запиcи таблиці products де category = Drama
select products.name, products.price, categories.name as category
from products 
join categories on products.category_id = categories.id
where categories.name = 'Drama';

-- 5. додати в таблицю orders кілька замовлень з однаковим ід
/*insert into orders (client_id, status) 
values 
(12393958, 'pending'),
(12393958, 'pending'),
(12393958, 'pending'),
(12393958, 'pending'),
(12393958, 'pending'),
(12393958, 'pending'),
(12393958, 'pending');*/

-- 6. перевіряю наявність записів з однаковим ід з попереднього запиту
select orders.client_id, orders.status from orders where orders.client_id = '12393958';

-- 7. вибрати всі запити з таблиці orders де статус пендінг - в дорозі // ід - унікальні
select distinct client_id, status, order_date  from orders where status = 'pending';

-- 8. обрати всі категорії з products де ціна вища за 4900 + їхня кількість 
select categories.name as category, count(categories.name) as amount_of_films 
from categories 
join products on products.category_id = categories.id
where products.price > 4900
group by categories.name;

-- 9. вивести середній чек з таблиці з платежами
select avg(amount) as average_check from payments;

-- 10. вивести загальну суму платежів за дату та їхню кількість
select sum(amount) as sum_amount, count(amount) as count_payments from payments 
where payment_date between '2024-01-01 00:00:00' and '2024-04-08 00:00:00';

--  вивід унікальний айді категорій з таблиці продукти (має бути лише 15)
select distinct category_id from Products;

-- вибрати всі замовлення клієнта за певний період
select * from orders where client_id = 1 and order_date between '2024-01-01' and '2024-03-31';

-- вибрати всі замовлення з певним статусом
select * from orders where status = 'rejected';

-- вибрати всі платежі для певного замовлення
select * from payments where order_id = 1;

-- вибрати всі продукти, відсортовані за ціною у спадаючому порядку
select * from products order by price desc;

-- вибрати всі замовлення, які містять певний продукт
select * from orders where id in (select order_id from order_details where product_id = 1);

-- вибрати всі клієнти, у яких електронна пошта закінчується на '@gmail.com'
select * from clients where email like '%@youtu.be';

-- вибрати всі продукти, ціна яких більше середньої ціни продуктів
select * from products where price > (select avg(price) from products);

-- вибрати всі платежі, які були здійснені після певної дати
select * from payments where payment_date > '2024-01-01';

-- вибрати всі продукти, які мають унікальні категорії
select * from products where category_id in (select category_id from (select category_id, count(*) as cnt from products group by category_id) as temp where cnt = 1);

-- вибрати всі замовлення з певним статусом, відсортовані за датою у зростаючому порядку
select * from orders where status = 'pending' order by order_date asc;

-- вибрати всі клієнти, відсортовані за алфавітом за ім'ям
select * from clients order by name;

-- вибрати всі продукти, відсортовані за ціною у зростаючому порядку
select * from products order by price asc;

-- 12. вивести максимальну і мінімальну ціну продуктів
select max(price) as max_price, min(price) as min_price from products;

-- таблиця показує номер замовлення, клієнта, назву продукту і кількість
select orders.id as order_id, clients.name as client_name, products.name as product_name, order_details.quantity
from orders
inner join clients on orders.client_id = clients.id
inner join order_details on orders.id = order_details.order_id
inner join products on order_details.product_id = products.id;

--  виводимо інформацію, на яку суму скупився той чи інший клієнт
select orders.id as order_id, clients.name as client_name,
       sum(order_details.quantity * products.price) as total_cost
from orders
join clients on orders.client_id = clients.id
join order_details on orders.id = order_details.order_id
join products on order_details.product_id = products.id
group by  orders.id, clients.name;


select * from products;

select clients.name as client_name, count(clients.name) as count_clients from clients
join orders on clients.id = orders.client_id
join order_details on orders.id = order_details.order_id
where order_details.product_id = 1
group by client_name;
SELECT * FROM pg_trigger;

SELECT * FROM pg_trigger WHERE tgname = 'trigger_log_new_product_4';
