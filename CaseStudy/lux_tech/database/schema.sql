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

-- 5. Thêm Đơn hàng mẫu
INSERT INTO orders (id, customer_id, order_date, total, status, source) VALUES
(1, 1, NOW(), 40980000.00, 'COMPLETED', 'STAFF'),
(2, 2, NOW(), 35500000.00, 'CONFIRMED', 'ONLINE'),
(3, 3, NOW(), 5990000.00, 'PENDING', 'ONLINE');

-- 6. Thêm Chi tiết đơn hàng
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 8, 1, 34990000.00),
(1, 23, 1, 5990000.00),
(2, 15, 1, 35500000.00),
(3, 23, 1, 5990000.00);

-- 7. Thêm Tùy chọn màu sắc cho 46 sản phẩm
INSERT INTO product_colors (product_id, name, hex_code, border_hex) VALUES
(1, 'Đen', '#1e293b', NULL),
(1, 'Xanh dương', '#1d4ed8', NULL),
(1, 'Xanh lá', '#6ee7b7', '#a7f3d0'),

(2, 'Xanh', '#3b82f6', NULL),
(2, 'Vàng', '#facc15', '#fef08a'),
(2, 'Đen', '#18181b', NULL),

(3, 'Xanh', '#0284c7', NULL),
(3, 'Đen', '#0f172a', NULL),
(3, 'Tím', '#c084fc', NULL),

(4, 'Xanh', '#99f6e4', '#ccfbf1'),
(4, 'Tím', '#a855f7', NULL),
(4, 'Xám', '#334155', NULL),

(5, 'Xanh', '#0f172a', NULL),
(5, 'Ánh Sao', '#f8fafc', '#cbd5e1'),
(5, 'Hồng', '#fbcfe8', '#fce7f3'),

(6, 'Xanh Dương', '#bfdbfe', '#dbeafe'),
(6, 'Hồng Nhạt', '#fce7f3', '#fbcfe8'),
(6, 'Đen Nhám', '#18181b', NULL),
(6, 'Xanh Lá', '#dcfce7', '#bbf7d0'),

(7, 'Xám Titan', '#6f7074', NULL),
(7, 'Đen Titan', '#2c2c2e', NULL),
(7, 'Tím Titan', '#595166', NULL),
(7, 'Vàng Titan', '#e4d9bc', NULL),

(8, 'Titan Sa Mạc', '#cda277', NULL),
(8, 'Titan Tự Nhiên', '#9e9b94', NULL),
(8, 'Titan Trắng', '#f4f3ed', '#d1d5db'),
(8, 'Titan Đen', '#393836', NULL),

(9, 'Bạc Ánh Kim', '#e2e8f0', '#cbd5e1'),
(10, 'Xám Tro', '#64748b', NULL),
(11, 'Bạc', '#f1f5f9', '#cbd5e1'),
(12, 'Đen', '#09090b', NULL),
(13, 'Xám', '#475569', NULL),
(14, 'Xanh Thẫm', '#1e293b', NULL),
(14, 'Ánh Vàng', '#fef08a', '#fef9c3'),
(14, 'Xám', '#64748b', NULL),
(15, 'Bạch Kim', '#dadbdc', '#cbd5e1'),
(15, 'Than Chì', '#424446', NULL),
(16, 'Đen', '#2e3033', NULL),
(16, 'Bạc', '#e2e4e6', '#cbd5e1'),

(17, 'Đen Nhám', '#18181b', NULL),
(18, 'Đen', '#27272a', NULL),
(19, 'Be Ánh Kim', '#fef3c7', '#fde68a'),
(19, 'Xanh Dương', '#2563eb', NULL),
(20, 'Trắng', '#ffffff', '#e2e8f0'),
(21, 'Đen', '#1c1917', NULL),
(21, 'Nâu', '#78350f', NULL),
(22, 'Đen', '#09090b', NULL),
(23, 'Trắng', '#ffffff', '#d1d5db'),
(24, 'Đen Nhám', '#1f2022', NULL),
(24, 'Bạc', '#dcd7ce', '#cbd5e1'),

(25, 'Trắng', '#ffffff', '#e2e8f0'),
(26, 'Đen', '#18181b', NULL),
(27, 'Xám', '#475569', NULL),
(28, 'Đen', '#262626', NULL),
(28, 'Trắng', '#ffffff', '#d1d5db'),
(29, 'Đen', '#181818', NULL),
(29, 'Trắng', '#f8f9fa', '#d1d5db'),
(30, 'Xanh', '#99f6e4', '#ccfbf1'),
(30, 'Trắng', '#f8fafc', '#e2e8f0'),
(31, 'Xám', '#334155', NULL),
(32, 'Đen', '#0f172a', NULL),

(33, 'Đen', '#1e293b', NULL),
(34, 'Hồng', '#fbcfe8', '#fce7f3'),
(34, 'Trắng', '#f8fafc', '#e2e8f0'),
(35, 'Đen', '#18181b', NULL),
(36, 'Xanh Tím', '#7c3aed', NULL),
(37, 'Xám Carbon', '#374151', NULL),
(38, 'Xanh', '#1e3a8a', NULL),
(39, 'Đen', '#09090b', NULL),

(40, 'Đen Nhám', '#18181b', NULL),
(41, 'Xám Chống Ồn', '#475569', NULL),
(42, 'Đen', '#09090b', NULL),
(42, 'Trắng', '#ffffff', '#cbd5e1'),
(43, 'Hồng', '#e9d5ff', '#f3e8ff'),
(43, 'Xanh', '#d9f99d', '#ecfccb'),
(44, 'Đen', '#09090b', NULL),
(45, 'Xám', '#374151', NULL),
(46, 'Trắng', '#ffffff', '#cbd5e1'),
(46, 'Đen', '#09090b', NULL);

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;
