DROP DATABASE IF EXISTS apple_store;
CREATE DATABASE apple_store;
USE apple_store;

DROP TABLE IF EXISTS log_table;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS subcategories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;

-- HW_11
-- 1 Создайте таблицу для логов
-- эта таблица для логов будет отслеживать все действия пользователей в базе данных
CREATE TABLE log_table (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  log_type VARCHAR(50),  -- тип действия 
  table_name VARCHAR(50),  -- имя таблицы в которой было выполнено действие 
  user_id INT,  -- id пользователя который выполнил действие 
  action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- время выполнения действия
);

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

-- хранит информацию о поставщиках, которые поставляют товары в магазин (имя поставщика, контактное лицо, номер телефона) 
CREATE TABLE suppliers (
supplier_id INT AUTO_INCREMENT PRIMARY KEY,
supplier_name VARCHAR(50) NOT NULL,
contact_name VARCHAR(50),
phone VARCHAR (15)
);

-- хранит информацию о продуктах (идентификатор продукта, название продукта, идентификатор подкатегории, цена, количество на складе, описание)
CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  subcategory_id INT,
  price DECIMAL(10,2) NOT NULL,
  stock INT DEFAULT 0,
  description TEXT,
  supplier_id INT,
  FOREIGN KEY (subcategory_id) REFERENCES subcategories(subcategory_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
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
  title VARCHAR(255),
  content TEXT,
  issued DATETIME,
  FOREIGN KEY (product_id) REFERENCES products(product_id),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
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

-- заказы 
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

-- заполняю таблицу order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 2100.00),
(2, 2, 3, 2200.00),
(3, 3, 1, 2700.00),
(4, 4, 2, 999.99),
(5, 5, 1, 399.99);

-- добавил отзывы
INSERT INTO reviews (product_id, customer_id, rating, title, content, issued) VALUES
(1, 1, 5, 'Amazing Battery Life', 'I recently bought the iPhone 16 Pro Max 256GB, and I am amazed by its battery life. It lasts all day with heavy usage. Highly recommend!', '2024-08-30 10:00:00'),
(2, 2, 4, 'Beautiful Display', 'The display on the iPhone 16 Pro Max 512GB is stunning. Colors are vibrant, and the resolution is top-notch. Watching videos is a delight.', '2024-09-02 16:00:00'),
(3, 3, 5, 'Smooth Performance', 'I\'ve been using the iPhone 16 Pro Max 1TB for a few months now, and its performance is incredibly smooth. No lags or glitches. Very satisfied!', '2024-09-01 14:00:00'),
(4, 4, 5, 'User-Friendly Interface', 'The MacBook Air 13" with Apple M1 has a very user-friendly interface. It\'s easy to navigate, and the new features are intuitive. Great job, Apple!', '2024-09-03 18:00:00'),
(5, 5, 5, 'Excellent Fitness Tracking', 'The Apple Watch Series 10 is fantastic for fitness tracking. It accurately monitors my workouts and health metrics. Perfect for fitness enthusiasts.', '2024-08-31 12:00:00');

-- дополнительные заказы 
INSERT INTO orders (customer_id, order_date, total) VALUES
(1, '2024-09-08', 2100.00),
(2, '2024-09-09', 2200.00),
(3, '2024-09-10', 2300.00),
(4, '2024-09-11', 2400.00),
(5, '2024-09-12', 2500.00),
(1, '2024-09-13', 2100.00),
(2, '2024-09-14', 2200.00),
(3, '2024-09-15', 2300.00),
(4, '2024-09-16', 2400.00),
(5, '2024-09-17', 2500.00);

-- дополнительные элементы заказов
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(6, 1, 1, 2000.00),
(7, 1, 1, 2000.00),
(8, 1, 1, 2000.00),
(9, 1, 1, 2000.00),
(10, 1, 1, 2000.00),
(6, 2, 1, 2200.00),
(7, 2, 1, 2200.00),
(8, 2, 1, 2200.00),
(9, 2, 1, 2200.00),
(10, 2, 1, 2200.00),
(6, 3, 1, 2700.00),
(7, 3, 1, 2700.00),
(8, 3, 1, 2700.00),
(9, 3, 1, 2700.00),
(10, 3, 1, 2700.00),
(6, 4, 1, 999.99),
(7, 4, 1, 999.99),
(8, 4, 1, 999.99),
(9, 4, 1, 999.99),
(10, 4, 1, 999.99),
(6, 5, 1, 399.99),
(7, 5, 1, 399.99),
(8, 5, 1, 399.99),
(9, 5, 1, 399.99),
(10, 5, 1, 399.99);

SET SQL_SAFE_UPDATES = 0;

-- обновление записей  
UPDATE products SET price = 2100 WHERE product_name = 'iPhone 16 Pro Max 256GB';
UPDATE categories SET category_name = 'Apple Vision Pro' WHERE category_name = 'Apple Vision';

-- HW_11
-- 2 Создайте транзакцию на добавление информации в любую таблицу вашей БД. Одновременно с добавлением в таблицу с логами должна поступать информация о добавлении
START TRANSACTION;

-- добавление нового продукта
INSERT INTO products (product_name, subcategory_id, price, stock, description, supplier_id)
VALUES ('iPad Pro 2024 11" Wi-Fi 512GB Silver', 35, 3199.99, 15, 'description of new product', 1);

-- запись в лог
INSERT INTO log_table (log_type, table_name, user_id)
VALUES ('INSERT', 'products', 1);

COMMIT;

-- 3 Запустите транзакцию из предыдущего задания, посмотрите на изменения, а затем завершите выполнение транзакции ее откатом
START TRANSACTION;

-- добавление нового продукта
INSERT INTO products (product_name, subcategory_id, price, stock, description, supplier_id)
VALUES ('iPad Pro 2024 11" Wi-Fi 512GB Silver', 35, 3199.99, 15, 'description of new product', 1);

-- запись в лог
INSERT INTO log_table (log_type, table_name, user_id)
VALUES ('INSERT', 'products', 1);

-- откат транзакции
ROLLBACK;

-- 4 Запустите транзакцию еще раз, а потом подтвердите её выполнение. Изучите измененные данные.
START TRANSACTION;

-- добавление нового продукта
INSERT INTO products (product_name, subcategory_id, price, stock, description, supplier_id)
VALUES ('iPad Pro 2024 11" Wi-Fi 512GB Silver', 35, 3199.99, 15, 'description of new product', 1);

-- запись в лог
INSERT INTO log_table (log_type, table_name, user_id)
VALUES ('INSERT', 'products', 1);

-- подтверждение транзакции
COMMIT;
