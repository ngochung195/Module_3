-- ============================================================
-- DATABASE SCRIPT: product_management
-- Module 3: Java Web Back-End Development Exam
-- ============================================================

DROP DATABASE IF EXISTS `product_management`;
CREATE DATABASE `product_management` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `product_management`;

-- 1. Bảng Danh mục sản phẩm (Category)
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `description` VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng Sản phẩm (Products)
CREATE TABLE `products` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `price` DOUBLE NOT NULL,
    `quantity` INT NOT NULL,
    `color` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `category_id` INT NOT NULL,
    CONSTRAINT `fk_products_categories` 
        FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) 
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- SEED DATA (Dữ liệu mẫu)
-- ============================================================

-- Thêm danh mục
INSERT INTO `categories` (`id`, `name`, `description`) VALUES
(1, 'Phone', 'Điện thoại di động thông minh'),
(2, 'Tivi', 'Tivi thông minh độ phân giải cao'),
(3, 'Tủ lạnh', 'Tủ lạnh tiết kiệm điện Inverter'),
(4, 'Máy giặt', 'Máy giặt cửa ngang và cửa trên');

-- Thêm sản phẩm mẫu (Giá > 10.000.000 VNĐ theo yêu cầu đề bài, 3 màu tiếng Việt)
INSERT INTO `products` (`name`, `price`, `quantity`, `color`, `description`, `category_id`) VALUES
('iPhone 11', 11500000, 12, 'Đen, Vàng, Xanh', 'Apple iPhone 11 64GB - Chính hãng VN/A', 1),
('iPhone 11 Pro', 14500000, 12, 'Đen, Vàng, Xanh', 'Apple iPhone 11 Pro 256GB - Bản Quốc tế', 1),
('iPhone X', 10500000, 12, 'Đen, Vàng, Xanh', 'Apple iPhone X 64GB Space Gray', 1),
('Smart Tivi 55 inch', 12900000, 12, 'Đen, Vàng, Xanh', 'Smart Tivi Sony 4K 55 inch KD-55X75K', 2),
('Tủ lạnh 2 cánh Toshiba', 13500000, 12, 'Đen, Vàng, Xanh', 'Tủ lạnh Inverter Toshiba 311 lít GR-RT395WE', 3),
('Máy giặt cửa ngang Samsung', 11200000, 12, 'Đen, Vàng, Xanh', 'Máy giặt thông minh Samsung AI 9kg WW90T634DLX', 4);
