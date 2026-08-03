-- HỆ THỐNG FLASHMART (LEGACY SCRIPT)
CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- 1. Tạo bảng và chèn dữ liệu mẫu
CREATE TABLE Customers (customer_id INT PRIMARY KEY, name VARCHAR(50));
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(50));
CREATE TABLE Orders (order_id INT PRIMARY KEY, customer_id INT, product_id INT);

INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie'); 
-- Chú ý: Charlie chưa từng mua hàng

INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard'); 
-- Chú ý: Keyboard chưa từng được ai mua

INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- ========================================================
-- LỖI 1: Báo cáo cho Marketing (Mất tích Charlie)
-- ========================================================
SELECT c.customer_id, c.name, COUNT(o.order_id) as total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- LỖI 2: Báo cáo cho Kho vận (Không tìm thấy Keyboard)
-- ========================================================
SELECT p.product_id, p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id 
WHERE o.order_id IS NULL; 