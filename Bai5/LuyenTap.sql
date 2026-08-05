CREATE DATABASE IF NOT EXISTS demo_db;
USE demo_db;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10, 2) NOT NULL,
    productAmount INT DEFAULT 0,
    productDescription TEXT,
    productStatus VARCHAR(20) DEFAULT 'Active'
);

INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) 
VALUES
('P001', 'iPhone 15 Pro', 999.99, 50, 'Apple Smartphone 128GB', 'Active'),
('P002', 'Samsung Galaxy S24', 899.99, 40, 'Samsung Flagship 256GB', 'Active'),
('P003', 'MacBook Air M2', 1199.00, 20, 'Apple Laptop 8GB/256GB', 'Active'),
('P004', 'Dell XPS 13', 1050.50, 15, 'Dell Ultrabook 16GB RAM', 'Inactive'),
('P005', 'Sony WH-1000XM5', 349.99, 100, 'Wireless Noise Canceling Headphones', 'Active');

CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

CREATE INDEX idx_name_price ON Products(productName, productPrice);

EXPLAIN SELECT * FROM Products WHERE productCode = 'P003';

EXPLAIN SELECT * FROM Products WHERE productName = 'MacBook Air M2' AND productPrice = 1199.00;

CREATE VIEW v_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

SELECT * FROM v_product_info;

CREATE OR REPLACE VIEW v_product_info AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productStatus = 'Active';

DROP VIEW IF EXISTS w_product_info;

DELIMITER //

-- 1. SP: Lấy tất cả thông tin sản phẩm
CREATE PROCEDURE sp_get_all_products()
BEGIN
    SELECT * FROM Products;
END //

-- 2. SP: Thêm một sản phẩm mới
CREATE PROCEDURE sp_add_product(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //

-- 3. SP: Sửa thông tin sản phẩm theo Id
CREATE PROCEDURE sp_update_product_by_id(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Products 
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //

-- 4. SP: Xóa sản phẩm theo Id
CREATE PROCEDURE sp_delete_product_by_id(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //

DELIMITER ;