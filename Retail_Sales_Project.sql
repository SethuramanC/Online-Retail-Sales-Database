create database Salesdb;
use Salesdb;
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    city VARCHAR(50),
    join_date timestamp DEFAULT current_timestamp
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date timestamp DEFAULT current_timestamp,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_date DATE,
    payment_method ENUM('Credit Card', 'Debit Card', 'UPI', 'Cash'),
    amount DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

INSERT INTO categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Books');
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Smartphone', 1, 20000, 50),
('Laptop', 1, 55000, 30),
('T-Shirt', 2, 800, 100),
('Cooker', 3, 2500, 40),
('Novel - Python Basics', 4, 600, 20);
INSERT INTO customers (first_name, last_name, email, phone, city) VALUES
('Sethuraman', 'P', 'sethu@gmail.com', '9876543210', 'Chennai'),
('Anitha', 'M', 'anitha@gmail.com', '9123456780', 'Coimbatore'),
('Rahul', 'S', 'rahul@gmail.com', '9988776655', 'Madurai');
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2025-10-20', 20800),
(2, '2025-10-21', 57000),
(3, '2025-10-22', 3400);
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 20000),
(1, 3, 1, 800),
(2, 2, 1, 55000),
(2, 5, 1, 2000),
(3, 4, 1, 2500),
(3, 5, 1, 900);
INSERT INTO payments (order_id, payment_date, payment_method, amount) VALUES
(1, '2025-10-20', 'UPI', 20800),
(2, '2025-10-21', 'Credit Card', 57000),
(3, '2025-10-22', 'Cash', 3400);

/*'1 Total Sales by Category'*/
SELECT 
    c.category_name,
    SUM(oi.quantity * oi.price) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

/*2 Total Orders and Amount per Customer*/
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Customer,
    COUNT(o.order_id) AS Total_Orders,
    SUM(o.total_amount) AS Total_Spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY Customer
ORDER BY Total_Spent DESC;

/*3 Most Sold Products*/
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

/*4 Payment Method Analysis*/
SELECT 
    payment_method,
    COUNT(payment_id) AS Total_Transactions,
    SUM(amount) AS Total_Paid
FROM payments
GROUP BY payment_method;

/*5 View for Sales Summary*/
CREATE OR REPLACE VIEW sales_summary AS
SELECT 
    o.order_id,
    CONCAT(c.first_name, ' ', c.last_name) AS Customer,
    o.order_date,
    o.total_amount,
    p.payment_method
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN payments p ON o.order_id = p.order_id;

/*To view the report:*/
SELECT * FROM sales_summary;


