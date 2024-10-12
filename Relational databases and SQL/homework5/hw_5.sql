DROP DATABASE IF EXISTS apple_store;
CREATE DATABASE apple_store;
USE apple_store;

DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS payments;

-- создаю таблицы
-- хранит информацию о категориях товаров 
CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL UNIQUE
);

-- хранит информацию о подкатегориях товаров
CREATE TABLE subcategories (
  subcategory_id INT AUTO_INCREMENT PRIMARY KEY,
  subcategory_name VARCHAR(100) NOT NULL,
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- хранит информацию о продуктах (идентификатор продукта, название продукта, идентификатор подкатегории, цена, количество на складе, описание)
CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  subcategory_id INT,
  price DECIMAL(10,2) NOT NULL,
  stock INT DEFAULT 0,
  description TEXT,
  FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id)
);

-- хранит информацию о городах
CREATE TABLE cities (
  city_id INT AUTO_INCREMENT PRIMARY KEY,
  city_name VARCHAR(100) NOT NULL UNIQUE
);

-- хранит информацию о клиентах
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  city_id INT,
  FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

-- хранит информацию о заказах (идентификатор заказа, идентификатор клиента, дата заказа, общая сумма заказа)
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATE NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- хранит информацию о позициях в заказах (идентификатор позиции заказа, идентификатор заказа, идентификатор продукта, количество, цена)
CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- хранит информацию об отзывах на продукты
CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT,
  customer_id INT,
  rating INT CHECK(rating BETWEEN 1 AND 5),
  comment TEXT,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- хранит информацию о поставщиках, которые поставляют товары в магазин (имя поставщика, контактное лицо, номер телефона) 
CREATE TABLE suppliers (
supplier_id INT AUTO_INCREMENT PRIMARY KEY,
supplier_name VARCHAR(50) NOT NULL,
contact_name VARCHAR(50),
phone VARCHAR (15)
);

-- хранит информацию о платежах, связанных с заказами (идентификатор заказа, дата платежа и сумма платежа)
CREATE TABLE payments (
payment_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT,
payment_date DATE NOT NULL,
amount DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- добавляю новое поле phone_number в таблицу customers
ALTER TABLE customers ADD phone_number VARCHAR(15);

-- добавляю уникальное ограничение для email
ALTER TABLE customers ADD CONSTRAINT unique_email UNIQUE (email);

-- добавляю проверочное ограничение для phone_number
ALTER TABLE customers ADD CONSTRAINT chk_phone_number CHECK (LENGTH(phone_number) >= 10);

-- заполняю таблицу categories данными
INSERT INTO categories (category_name) VALUES
('Apple iPhone'), ('Apple Mac'), ('Apple iPad'), ('Apple Watch'), ('Apple AirPods'), ('Apple Vision'), ('Apple TV'); 

-- заполняю таблицу subcategories данными
INSERT INTO subcategories (subcategory_name, category_id) VALUES
('iPhone 16/Plus/Pro/Pro Max', 1), ('iPhone 15/Plus/Pro/Pro Max', 1), ('iPhone 14/Plus/Pro/Pro Max', 1), ('iPhone SE 2022', 1), ('iPhone 13/mini/Pro/Pro Max', 1), ('iPhone 12/mini/Pro/Pro Max', 1), ('iPhone 11/Pro/Pro Max', 1), ('iPhone SE 2020', 1),
('MacBook Air', 2), ('Apple MacBook Pro', 2), ('All-in-one iMac', 2), ('iMac Pro', 2), ('System unit Mac Pro', 2), ('Mac mini', 2), ('Mac Studio', 2),
('iPad Pro 2024', 3), ('iPad Air 2024', 3), ('iPad Pro', 3), ('iPad 10th generation', 3), ('iPad Air 2022', 3), ('¡Pad mini 2021', 3), ('iPad Air 2020', 3),
('Watch Series 10', 4), ('Watch Ultra 2', 4), ('Watch Series 9', 4), ('Watch Ultra', 4), ('Watch Series 8', 4), ('Watch SE 2022', 4), ('Watch SE 2020', 4),
('AirPods 4', 5), ('AirPods 3', 5), ('AirPods 2', 5), ('AirPods Pro 2', 5), ('AirPods Pro', 5), ('AirPods Max', 5), ('Accessories', 5), ('Cases', 5),
('Apple Vision Pro', 6),
('Apple TV 4K', 7);

-- заполняю таблицу products данными
INSERT INTO products (product_name, subcategory_id, price, stock, description) VALUES
('iPhone 16 Pro Max 256GB', 1, 2000, 50, 'Latest model of iPhone 16 Pro Max with 256GB storage'),
('iPhone 16 Pro Max 512GB', 1, 2200, 40, 'Latest model of iPhone 16 Pro Max with 512GB storage'),
('iPhone 16 Pro Max 1TB', 1, 2700, 30, 'Latest model of iPhone 16 Pro Max with 1TB storage'),
('MacBook Air 13", 8GB, 256GB, Apple M1, Space Gray', 9, 999.99, 20, 'Lightweight and portable laptop'),
('Apple Watch Series 10, 42 mm', 23, 399.99, 30, 'Newest Apple Watch with advanced features'),
('AirPods Pro 2 USB-C', 33, 249.99, 100, 'Wireless earbuds with noise cancellation'),
('Vision Pro 256GB', 38, 3499.99, 10, 'Advanced augmented reality headset'),
('Apple TV 4K 128GB', 39, 179.99, 50, 'High-definition streaming device');

-- заполняю таблицу suppliers данными
INSERT INTO suppliers (supplier_name, contact_name, phone) VALUES
('Supplier A', 'Timothy Donald Cook', '1234567890'),
('Supplier B', 'Jeff Williams', '0987654321'),
('Supplier C', 'Luca Maestri', '1234554321'),
('Supplier D', 'Katherine Leatherman Adams', '1236547890'),
('Supplier E', 'Greg "Joz" Jóswiak', '9874563210');

INSERT INTO cities (city_name) VALUES
('Minsk'),
('Moscow'),
('Saint Petersburg'),
('Kyiv'),
('Warsaw');

-- Добавляю клиентов в таблицу
INSERT INTO customers (customer_name, email, city_id) VALUES
('Customer 1', 'customer1@gmail.com', 1),
('Customer 2', 'customer2@gmail.com', 2),
('Customer 3', 'customer3@gmail.com', 3),
('Customer 4', 'customer4@gmail.com', 4),
('Customer 5', 'customer5@gmail.com', 5);

-- Добавляю клиентов в таблицу из города Minsk
INSERT INTO customers (customer_name, email, city_id, phone_number) VALUES
('Customer 8', 'customer8@gmail.com', 1, 7777777777),
('Customer 9', 'customer9@gmail.com', 1, 5566777999);

-- заказы для клиента
INSERT INTO orders (customer_id, order_date, total) VALUES
(1, '2024-09-01', 2100.00),
(2, '2024-09-02', 2200.00),
(3, '2024-09-03', 2300.00),
(4, '2024-09-04', 2400.00),
(5, '2024-09-05', 2500.00);

-- дополнительные заказы для клиентов чтобы было видно в SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id HAVING COUNT(*) > 1;
INSERT INTO orders (customer_id, order_date, total) VALUES
(3, '2024-09-06', 2600.00),
(3, '2024-09-07', 2700.00),
(5, '2024-09-05', 2550.00);

-- заполняю таблицу payments данными
INSERT INTO payments (order_id, payment_date, amount) VALUES
(1, '2024-10-01', 2100.00),
(2, '2024-10-02', 2200.00),
(3, '2024-10-03', 2300.00),
(4, '2024-10-04', 2400.00),
(5, '2024-10-05', 2500.00);


-- обновление записей  
UPDATE products SET price = 2100 WHERE product_name = 'iPhone 16 Pro Max 256GB';
UPDATE categories SET category_name = 'Apple Vision Pro' WHERE category_name = 'Apple Vision';

-- HW_3 1 выборка данных из одной таблицы с помощью оператора SELECT. Выбираю все столбцы и строки из таблицы products
SELECT * FROM products;

-- 2 выборка данных из одной таблицы базы данных с помощью оператора SELECT с использованием оператора WHERE. Выбираю название продуктов, которые начинаются с буквы 'A' 
SELECT product_name FROM products WHERE product_name LIKE 'A%';

-- 3 запрос с группировкой при помощи оператора GROUP BY. Тут группируются данные по subcategory_id и подсчитывается количество продуктов в каждой подкатегории
SELECT subcategory_id, COUNT(*) AS product_count FROM products GROUP BY subcategory_id;

-- 4 запрос с группировкой при помощи оператора GROUP BY с использованием HAVING. Данный запрос группирует заказы по клиентам и выбирает тех клиентов у которых больше одного заказа.
SELECT customer_id, COUNT(*) AS order_count FROM orders GROUP BY customer_id HAVING COUNT(*) > 1; 

-- 5 запрос с использованием ORDER BY. Выбираю название продуктов и их цены из табл. products сортируя по убыванию цены 
SELECT product_name, price FROM products ORDER BY price DESC;
 
-- 6 вычисляю среднюю цену продуктов в таблице products
 SELECT AVG(price) AS average_price FROM products;

-- 7 запрос выбирает названия продуктов и их цены, цена которых выше средней цены всех продуктов
SELECT product_name, price FROM products WHERE price > (SELECT AVG(price) FROM products);

-- 8 выбираю клиентов которые находятся в городе Минск
SELECT * FROM customers WHERE city_id IN (SELECT city_id FROM cities WHERE city_name = 'Minsk');
	
-- 9 выбирает все продукты с ценой в диапазоне от 399 до 2500
SELECT * FROM products WHERE price BETWEEN 399 AND 2500; 

-- 10 вычисляю общую сумму всех заказов в таблице orders
SELECT SUM(total) AS total_sales FROM orders;

-- HW_4 1 выборка данных из одной таблицы базы данных с помощью оператора SELECT с использованием LIKE. Этот запрос выбирает все продукты название которых содержит слово Pro
SELECT product_name
FROM products
WHERE product_name LIKE '%Pro%';

-- 2 выборка данных из одной таблицы базы данных с помощью оператора SELECT с использованием CASE. Этот запрос в таблице products выбирает название продуктов и их цены а затем классифицирует их по категориям цен. Также полям даются псевдонимы, а результату присваивается имя price_category
SELECT product_name AS product,
	price AS cost,
	CASE 
		WHEN price > 2500 THEN 'Expensive'
		WHEN price BETWEEN 990 AND 2500 THEN 'Average'
		ELSE 'Cheap'
	END AS price_category
FROM products; 

-- 3 запрос с использованием сравнения времени
-- 3.1 пример с форматированием даты. Этот запрос выберет все столбцы из таблицы orders где дата заказа больше чем 1 сентября 2024г. 
SELECT *
FROM orders
WHERE date_format(order_date, '%Y-%m-%d') > '2024-09-01'; 

-- 3.2 пример без форматирования даты 
SELECT * 
FROM orders
WHERE order_date > '2024-09-01';

-- 4 запрос с выводом всех нулевых и/или пустых значений в некоторых полях таблицы. Этот запрос выбирает всех клиентов у которых phone_number не заполнен (NULL) или является пустой строкой
SELECT *
FROM customers
WHERE phone_number IS NULL OR phone_number = '';

-- 5 запрос с несколькими условиями в WHERE группировкой GROUP BY и CASE
-- несколько условий в WHERE - WHERE stock > 0 AND price IS NOT NULL выбирает продукты которые есть в наличии, убирает продукты у которых нет цены
-- CASE классифицирует подкатегории по средней цене и присваевает результату пседоним
-- GROUP BY группирует строки по subcategory_id
-- HAVING фильтрует группы в которых более одного наименования товара
SELECT subcategory_id AS sub_id,
       COUNT(product_id) AS p_count,
       AVG(price) AS avg_price,
       CASE
           WHEN AVG(price) > 2000 THEN 'High Price'
           ELSE 'Low Price'
       END AS price_category
FROM products
WHERE stock > 0 AND price IS NOT NULL
GROUP BY subcategory_id
HAVING COUNT(product_id) > 1;


-- HW_5 
-- 1.1 CROSS JOIN возвращает все комбинации строк
SELECT *
FROM customers 
CROSS JOIN products;
-- 1.2 возвращает все комбинации строк
SELECT customers.customer_name AS c_name, products.product_name AS p_name
FROM customers 
CROSS JOIN products;

-- 2 INNER JOIN этот запрос соединяет таблицы orders и customers по PK и FK - customer_id и возвращает только те строки где есть совпадения в таблицах
SELECT orders.order_id, customers.customer_name, orders.total
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

-- 3 LEFT JOIN запрос возвращает все строки из таблицы customers и совпадающие строки из таблицы orders, если в табл orders нет совпадений, то возвращает NULL  
SELECT orders.order_id, customers.customer_name, orders.total 
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id;

-- 4 FULL JOIN не поддерживается в MySQL поэтому использую объединение LEFT JOIN и RIGHT JOIN. UNION объединяет результаты двух запросов и удаляет дубликаты. Если нет совпадений то возвращается NULL
SELECT * 
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
UNION
SELECT * 
FROM customers
RIGHT JOIN orders ON customers.customer_id = orders.customer_id;

-- 5.1 соединить две и более таблицы без помощи JOIN. Соединение описать в условии WHERE. Этот запрос везвращет имена клиентов, общую сумму заказа и ID заказа для всех заказов сделанных клиентами 
SELECT customers.customer_name, orders.total, orders.order_id
FROM customers, orders
WHERE customers.customer_id = orders.customer_id;

-- 5.2 фильтрация по дате, вернет только заказы сделанные после 3 сентября 2024
SELECT customers.customer_name, orders.total, orders.order_id
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
AND orders.order_date > '2024-09-03';

-- 6 написать 2 и более запросов с использованием WHERE/GROUP BY/HAVING для двух и более объединенных таблиц
-- выбираем название города из таблицы cities, подсчитываем количество заказов в каждом городе и присваиваем псевдоним 
-- соединяю таблицы customers и orders по полю customer_id а таблицы customers и cities по полю city_id
-- WHERE выбирает заказы сумма которых выше 2000
-- GROUP BY группирует разультаты по названию города чтобы получить данные по каждому городу 
-- HAVING фильтрует группы, оставляя только те где количество заказов больше 1
SELECT cities.city_name, COUNT(orders.order_id) AS order_count
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
INNER JOIN cities ON customers.city_id = cities.city_id
WHERE orders.total > 2000
GROUP BY cities.city_name
HAVING COUNT(orders.order_id) > 1;

-- заполняю таблицу order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 2100.00),
(2, 2, 3, 2200.00),
(3, 3, 1, 2700.00),
(4, 4, 2, 999.99),
(5, 5, 1, 399.99);

-- 7 написать 2 и более запросов с использованием WHERE/GROUP BY/HAVING для двух и более объединенных таблиц
-- в SELECT выбирается ID подкатегории и вычисляется средняя цена продуктов в каждой подкатегории, присваивается псевдоним
-- products и order_items соединяются по полю product_id
-- WHERE фильтрует выбирая количество товаров больше 1
-- GROUP BY группирует результаты по subcategory_id
-- HAVING фильтрует группы оставляя только те, где средняя цена продуктов avg_price больше 1000
SELECT products.subcategory_id, AVG(products.price) AS avg_price
FROM products
INNER JOIN order_items ON products.product_id = order_items.product_id
WHERE order_items.quantity > 1
GROUP BY products.subcategory_id
HAVING AVG(products.price) > 1000;

-- 8 Для одной из таблиц вывести все значения, которые не соединены первичным и внешним ключом с другой таблицей
-- выбирается название продукта и цена. Выполняется левое соединение по полю product_id. Если в таблице order_items нет совпадений то возвращаются NULL
-- условие WHERE выбирает только те строки где product_id из таблицы order_items равно NULL
SELECT products.product_name, products.price
FROM products
LEFT JOIN order_items ON products.product_id = order_items.product_id
WHERE order_items.product_id IS NULL;



