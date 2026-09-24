-- =========================================================================
-- LUXTECH STORE - TOÀN BỘ CƠ SỞ DỮ LIỆU & DỮ LIỆU MẪU (ALL-IN-ONE)
-- Hệ thống quản trị và bán hàng thiết bị công nghệ LuxTech
-- =========================================================================

-- Tắt kiểm tra khóa ngoại tạm thời để xóa và tạo bảng an toàn tuyệt đối
SET FOREIGN_KEY_CHECKS = 0;

-- 2. Xóa bảng cũ (nếu tồn tại)
DROP TABLE IF EXISTS product_colors;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS customers;

-- =========================================================================
-- CẤU TRÚC BẢNG (SCHEMA DEFINITIONS)
-- =========================================================================

-- 1. Bảng Khách hàng
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng Tài khoản người dùng (Hỗ trợ ADMIN, STAFF, CUSTOMER)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER')),
    customer_id INT NULL DEFAULT NULL,
    CONSTRAINT fk_users_customers FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng Danh mục sản phẩm
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng Sản phẩm
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(15, 2) NOT NULL CHECK (price > 0),
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    category_id INT NOT NULL,
    image VARCHAR(255) NULL,
    CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng Đơn hàng
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(15, 2) NOT NULL DEFAULT 0.00 CHECK (total >= 0),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PAID', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    payment_method VARCHAR(20) NOT NULL DEFAULT 'COD',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'UNPAID',
    source VARCHAR(20) NOT NULL DEFAULT 'ONLINE',
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng Chi tiết đơn hàng
CREATE TABLE IF NOT EXISTS order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(15, 2) NOT NULL CHECK (price >= 0),
    CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_details_products FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bảng Tùy chọn màu sắc sản phẩm
CREATE TABLE IF NOT EXISTS product_colors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    hex_code VARCHAR(20) NOT NULL,
    border_hex VARCHAR(20) NULL,
    CONSTRAINT fk_product_colors_products FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =========================================================================
-- DỮ LIỆU KHỞI TẠO (INITIAL SEED DATA)
-- =========================================================================

-- 1. Thêm Khách hàng mẫu
INSERT INTO customers (id, name, phone, email, address) VALUES
(1, 'Nguyễn Văn An', '0901234567', 'an.nguyen@gmail.com', '123 Lê Lợi, Quận 1, TP.HCM'),
(2, 'Trần Thị Bích', '0912345678', 'bich.tran@gmail.com', '456 Nguyễn Huệ, Quận 1, TP.HCM'),
(3, 'Lê Hoàng Nam', '0923456789', 'nam.le@gmail.com', '789 Cầu Giấy, Hà Nội'),
(4, 'Phạm Minh Tuấn', '0934567890', 'tuan.pham@gmail.com', '101 Trần Phú, Đà Nẵng'),
(5, 'Đỗ Thúy Hằng', '0945678901', 'hang.do@gmail.com', '202 Hùng Vương, Cần Thơ');

-- 2. Thêm Tài khoản người dùng (Mật khẩu mặc định: '123456' mã hóa BCrypt)
-- Hash BCrypt chuẩn cho '123456': $2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq
INSERT INTO users (id, username, password, role, customer_id) VALUES
(1, 'admin', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'ADMIN', NULL),
(2, 'staff', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'STAFF', NULL),
(3, 'customer', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'CUSTOMER', 1);

-- 3. Thêm 6 Danh mục sản phẩm
INSERT INTO categories (id, name) VALUES
(1, 'Điện thoại'),
(2, 'Laptop'),
(3, 'Tai nghe'),
(4, 'Sạc dự phòng'),
(5, 'Bàn phím'),
(6, 'Chuột');

-- 4. Thêm 46 Sản phẩm đầy đủ các phân khúc giá
INSERT INTO products (id, name, price, quantity, category_id, image) VALUES
-- 1. Điện thoại (8 sản phẩm)
(1, 'Xiaomi Redmi 13C 128GB', 2990000.00, 35, 1, 'redmi-13c.jpg'),
(2, 'Samsung Galaxy A15 128GB', 4490000.00, 28, 1, 'galaxy-a15.jpg'),
(3, 'Xiaomi Redmi Note 13 Pro 5G', 8490000.00, 22, 1, 'redmi-note13pro.jpg'),
(4, 'Samsung Galaxy S23 FE 5G', 12990000.00, 18, 1, 'galaxy-s23fe.png'),
(5, 'iPhone 13 128GB Chính Hãng', 13490000.00, 20, 1, 'iphone-13.jpg'),
(6, 'iPhone 15 128GB Chính Hãng', 18990000.00, 15, 1, 'iphone-15.jpg'),
(7, 'Samsung Galaxy S24 Ultra', 29990000.00, 20, 1, 'galaxy-s24.png'),
(8, 'iPhone 17 Pro Max 256GB', 34990000.00, 15, 1, 'iphone-17.png'),

-- 2. Laptop (8 sản phẩm)
(9, 'Laptop Acer Aspire 3 A315 i3', 9990000.00, 16, 2, 'acer-aspire3.jpg'),
(10, 'Laptop Lenovo IdeaPad Slim 3 15IAH8 i5', 13490000.00, 25, 2, 'lenovo-ideapad3.jpg'),
(11, 'Laptop Asus Vivobook 15 OLED i5', 16990000.00, 14, 2, 'asus-vivobook15.jpg'),
(12, 'Laptop Gaming Acer Nitro 5 Tiger i5 RTX3050', 19490000.00, 12, 2, 'acer-nitro5.png'),
(13, 'Laptop Asus TUF Gaming A15 R7 RTX4050', 22990000.00, 10, 2, 'asus-tuf-a15.jpg'),
(14, 'MacBook Air M2 13.6 inch 256GB', 24490000.00, 15, 2, 'macbook-air-m2.png'),
(15, 'Dell XPS 13 9320', 35500000.00, 8, 2, 'dell-xps.png'),
(16, 'MacBook Pro M3 14 inch', 41990000.00, 10, 2, 'macbook-pro.png'),

-- 3. Tai nghe (8 sản phẩm)
(17, 'Tai nghe Gaming Havit H2002D', 450000.00, 50, 3, 'havit-h2002d.jpg'),
(18, 'Tai nghe Soundpeats Free2 Classic Bluetooth', 590000.00, 45, 3, 'soundpeats-free2.jpg'),
(19, 'Tai nghe chụp tai Sony WH-CH520', 1190000.00, 30, 3, 'sony-wh-ch520.jpg'),
(20, 'Tai nghe không dây JBL Wave Beam', 1290000.00, 35, 3, 'jbl-wave-beam.jpg'),
(21, 'Tai nghe Marshall Major IV Bluetooth', 3490000.00, 20, 3, 'marshall-major4.jpg'),
(22, 'Tai nghe Gaming Razer BlackShark V2 Pro', 4290000.00, 15, 3, 'razer-blackshark-v2.jpg'),
(23, 'AirPods Pro Gen 2', 5990000.00, 30, 3, 'airpods-pro.png'),
(24, 'Tai nghe Sony WH-1000XM5', 7990000.00, 12, 3, 'sony-wh1000xm5.png'),

-- 4. Sạc dự phòng (8 sản phẩm)
(25, 'Sạc dự phòng Hoco J86 10000mAh', 220000.00, 60, 4, 'hoco-j86.jpg'),
(26, 'Sạc dự phòng Remax RPP-296 20000mAh', 390000.00, 55, 4, 'remax-rpp296.png'),
(27, 'Sạc dự phòng Ugreen 10000mAh PD 20W', 490000.00, 40, 4, 'ugreen-10000.jpg'),
(28, 'Sạc dự phòng Baseus 10000mAh', 650000.00, 40, 4, 'baseus-10000.png'),
(29, 'Sạc dự phòng Anker 20000mAh', 1290000.00, 50, 4, 'anker-20000.png'),
(30, 'Sạc dự phòng Anker MagGo 10000mAh Qi2', 1690000.00, 25, 4, 'anker-maggo.jpg'),
(31, 'Sạc dự phòng Cuktech 20 25000mAh 210W', 2190000.00, 18, 4, 'cuktech-20.jpg'),
(32, 'Sạc dự phòng Anker Prime 27650mAh 250W', 3490000.00, 12, 4, 'anker-prime-27k.png'),

-- 5. Bàn phím (7 sản phẩm)
(33, 'Bàn phím văn phòng có dây Logitech K120', 180000.00, 70, 5, 'logitech-k120.jpg'),
(34, 'Bàn phím không dây đa thiết bị Logitech K380', 590000.00, 40, 5, 'logitech-k380.jpg'),
(35, 'Bàn phím cơ DareU EK87 V2 Tenkeyless', 690000.00, 35, 5, 'dareu-ek87.jpg'),
(36, 'Bàn phím cơ Akko 3087 v2 Monet Cherry Switch', 1390000.00, 25, 5, 'akko-3087.jpg'),
(37, 'Bàn phím cơ Keychron K2 V2', 1990000.00, 25, 5, 'keychron-k2.png'),
(38, 'Bàn phím cơ Leopold FC900R PD High-End', 3290000.00, 15, 5, 'leopold-fc900r.png'),
(39, 'Bàn phím cơ Custom Asus ROG Azoth OLED', 5690000.00, 8, 5, 'asus-rog-azoth.jpg'),

-- 6. Chuột (7 sản phẩm)
(40, 'Chuột không dây văn phòng Fuhlen A09G', 150000.00, 80, 6, 'fuhlen-a09g.jpg'),
(41, 'Chuột không dây Logitech M220 Silent Chống Ồn', 290000.00, 65, 6, 'logitech-m220.png'),
(42, 'Chuột Gaming Logitech G102 Gen 2 Lightsync', 420000.00, 50, 6, 'logitech-g102.jpg'),
(43, 'Chuột không dây mỏng nhẹ Logitech Pebble M350', 450000.00, 45, 6, 'logitech-pebble.png'),
(44, 'Chuột Gaming chuyên nghiệp Razer DeathAdder V2', 1190000.00, 25, 6, 'razer-deathadder.jpg'),
(45, 'Chuột Logitech MX Master 3S', 2490000.00, 18, 6, 'logitech-mx3s.png'),
(46, 'Chuột Gaming không dây Logitech G Pro X Superlight', 2990000.00, 16, 6, 'logitech-gprox.jpg');

-- 5. Thêm Đơn hàng mẫu (Tổng cộng 23 đơn hàng đa dạng trạng thái, khách hàng, phương thức thanh toán)
INSERT INTO orders (id, customer_id, order_date, total, status, payment_method, payment_status, source) VALUES
(1, 1, '2026-03-01 10:15:00', 40980000.00, 'COMPLETED', 'VNPAY', 'PAID', 'STAFF'),
(2, 2, '2026-03-02 14:30:00', 35500000.00, 'CONFIRMED', 'COD', 'UNPAID', 'ONLINE'),
(3, 3, '2026-03-05 09:00:00', 5990000.00, 'PENDING', 'COD', 'UNPAID', 'ONLINE'),
(4, 1, '2026-03-10 09:15:00', 26270000.00, 'COMPLETED', 'VNPAY', 'PAID', 'ONLINE'),
(5, 2, '2026-03-11 14:20:00', 26980000.00, 'COMPLETED', 'BANKING', 'PAID', 'ONLINE'),
(6, 3, '2026-03-12 16:45:00', 26770000.00, 'CONFIRMED', 'COD', 'UNPAID', 'ONLINE'),
(7, 4, '2026-03-13 11:30:00', 9570000.00, 'PAID', 'VNPAY', 'PAID', 'ONLINE'),
(8, 5, '2026-03-14 08:50:00', 9420000.00, 'COMPLETED', 'COD', 'PAID', 'STAFF'),
(9, 1, '2026-03-15 10:05:00', 2440000.00, 'PENDING', 'COD', 'UNPAID', 'ONLINE'),
(10, 2, '2026-03-16 13:10:00', 39670000.00, 'CONFIRMED', 'VNPAY', 'PAID', 'ONLINE'),
(11, 3, '2026-03-17 15:25:00', 14370000.00, 'COMPLETED', 'BANKING', 'PAID', 'ONLINE'),
(12, 4, '2026-03-18 09:40:00', 3440000.00, 'CANCELLED', 'COD', 'UNPAID', 'ONLINE'),
(13, 5, '2026-03-18 17:15:00', 41990000.00, 'CONFIRMED', 'VNPAY', 'PAID', 'ONLINE'),
(14, 1, '2026-03-19 11:00:00', 6880000.00, 'COMPLETED', 'VNPAY', 'PAID', 'ONLINE'),
(15, 2, '2026-03-19 14:35:00', 14930000.00, 'COMPLETED', 'COD', 'PAID', 'ONLINE'),
(16, 3, '2026-03-20 10:20:00', 24100000.00, 'PAID', 'VNPAY', 'PAID', 'ONLINE'),
(17, 4, '2026-03-21 08:30:00', 16980000.00, 'CONFIRMED', 'BANKING', 'PAID', 'ONLINE'),
(18, 5, '2026-03-21 16:00:00', 18670000.00, 'COMPLETED', 'COD', 'PAID', 'STAFF'),
(19, 1, '2026-03-22 13:45:00', 6780000.00, 'PENDING', 'COD', 'UNPAID', 'ONLINE'),
(20, 2, '2026-03-22 18:10:00', 2770000.00, 'COMPLETED', 'COD', 'PAID', 'ONLINE'),
(21, 3, '2026-03-23 09:15:00', 10320000.00, 'COMPLETED', 'BANKING', 'PAID', 'STAFF'),
(22, 4, '2026-03-23 15:50:00', 8180000.00, 'PAID', 'VNPAY', 'PAID', 'ONLINE'),
(23, 5, '2026-03-24 08:00:00', 39670000.00, 'CONFIRMED', 'VNPAY', 'PAID', 'ONLINE');

-- 6. Thêm Chi tiết đơn hàng
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 8, 1, 34990000.00),
(1, 23, 1, 5990000.00),
(2, 15, 1, 35500000.00),
(3, 23, 1, 5990000.00),
-- Đơn hàng 4
(4, 6, 1, 18990000.00),
(4, 23, 1, 5990000.00),
(4, 29, 1, 1290000.00),
-- Đơn hàng 5
(5, 14, 1, 24490000.00),
(5, 45, 1, 2490000.00),
-- Đơn hàng 6
(6, 12, 1, 19490000.00),
(6, 22, 1, 4290000.00),
(6, 46, 1, 2990000.00),
-- Đơn hàng 7
(7, 3, 1, 8490000.00),
(7, 27, 1, 490000.00),
(7, 18, 1, 590000.00),
-- Đơn hàng 8
(8, 2, 2, 4490000.00),
(8, 25, 2, 220000.00),
-- Đơn hàng 9
(9, 37, 1, 1990000.00),
(9, 43, 1, 450000.00),
-- Đơn hàng 10
(10, 7, 1, 29900000.00),
(10, 24, 1, 7990000.00),
(10, 30, 1, 1690000.00),
-- Đơn hàng 11
(11, 10, 1, 13490000.00),
(11, 34, 1, 590000.00),
(11, 41, 1, 290000.00),
-- Đơn hàng 12
(12, 1, 1, 2990000.00),
(12, 17, 1, 450000.00),
-- Đơn hàng 13
(13, 16, 1, 41990000.00),
-- Đơn hàng 14
(14, 39, 1, 5690000.00),
(14, 44, 1, 1190000.00),
-- Đơn hàng 15
(15, 4, 1, 12990000.00),
(15, 20, 1, 1290000.00),
(15, 28, 1, 650000.00),
-- Đơn hàng 16
(16, 13, 1, 22990000.00),
(16, 35, 1, 690000.00),
(16, 42, 1, 420000.00),
-- Đơn hàng 17
(17, 5, 1, 13490000.00),
(17, 21, 1, 3490000.00),
-- Đơn hàng 18
(18, 11, 1, 16990000.00),
(18, 36, 1, 1390000.00),
(18, 41, 1, 290000.00),
-- Đơn hàng 19
(19, 32, 1, 3490000.00),
(19, 38, 1, 3290000.00),
-- Đơn hàng 20
(20, 19, 2, 1190000.00),
(20, 26, 1, 390000.00),
-- Đơn hàng 21
(21, 9, 1, 9990000.00),
(21, 33, 1, 180000.00),
(21, 40, 1, 150000.00),
-- Đơn hàng 22
(22, 31, 1, 2190000.00),
(22, 23, 1, 5990000.00),
-- Đơn hàng 23
(23, 8, 1, 34990000.00),
(23, 30, 1, 1690000.00),
(23, 46, 1, 2990000.00);