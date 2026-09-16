USE electronic_store;

-- 1. Insert Users (Password default: '123456' hashed with BCrypt)
-- Hash chuẩn BCrypt cho '123456': $2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq
INSERT INTO users (username, password, role) VALUES
('admin', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'ADMIN'),
('staff', '$2a$10$vF/LyauKodYSHjUsOfnTfuHABiHZG6P54QnTgVy64MrYTkkXOhhuq', 'STAFF');

-- 2. Insert Categories (6 categories)
INSERT INTO categories (name) VALUES
('Điện thoại'),
('Laptop'),
('Tai nghe'),
('Sạc dự phòng'),
('Bàn phím'),
('Chuột');

-- 3. Insert Products (46 products across price tiers)
INSERT INTO products (name, price, quantity, category_id, image) VALUES
-- 1. Điện thoại (8 sản phẩm)
('Xiaomi Redmi 13C 128GB', 2990000.00, 35, 1, 'redmi-13c.png'),
('Samsung Galaxy A15 128GB', 4490000.00, 28, 1, 'galaxy-a15.png'),
('Xiaomi Redmi Note 13 Pro 5G', 8490000.00, 22, 1, 'redmi-note13pro.png'),
('Samsung Galaxy S23 FE 5G', 12990000.00, 18, 1, 'galaxy-s23fe.png'),
('iPhone 13 128GB Chính Hãng', 13490000.00, 20, 1, 'iphone-13.png'),
('iPhone 15 128GB Chính Hãng', 18990000.00, 15, 1, 'iphone-15.png'),
('Samsung Galaxy S24 Ultra', 29990000.00, 20, 1, 'galaxy-s24.png'),
('iPhone 17 Pro Max 256GB', 34990000.00, 15, 1, 'iphone-17.png'),

-- 2. Laptop (8 sản phẩm)
('Laptop Acer Aspire 3 A315 i3', 9990000.00, 16, 2, 'acer-aspire3.png'),
('Laptop Lenovo IdeaPad Slim 3 15IAH8 i5', 13490000.00, 25, 2, 'lenovo-ideapad3.png'),
('Laptop Asus Vivobook 15 OLED i5', 16990000.00, 14, 2, 'asus-vivobook15.png'),
('Laptop Gaming Acer Nitro 5 Tiger i5 RTX3050', 19490000.00, 12, 2, 'acer-nitro5.png'),
('Laptop Asus TUF Gaming A15 R7 RTX4050', 22990000.00, 10, 2, 'asus-tuf-a15.png'),
('MacBook Air M2 13.6 inch 256GB', 24490000.00, 15, 2, 'macbook-air-m2.png'),
('Dell XPS 13 9320', 35500000.00, 8, 2, 'dell-xps.png'),
('MacBook Pro M3 14 inch', 41990000.00, 10, 2, 'macbook-pro.png'),

-- 3. Tai nghe (8 sản phẩm)
('Tai nghe Gaming Havit H2002D', 450000.00, 50, 3, 'havit-h2002d.png'),
('Tai nghe Soundpeats Free2 Classic Bluetooth', 590000.00, 45, 3, 'soundpeats-free2.png'),
('Tai nghe chụp tai Sony WH-CH520', 1190000.00, 30, 3, 'sony-wh-ch520.png'),
('Tai nghe không dây JBL Wave Beam', 1290000.00, 35, 3, 'jbl-wave-beam.png'),
('Tai nghe Marshall Major IV Bluetooth', 3490000.00, 20, 3, 'marshall-major4.png'),
('Tai nghe Gaming Razer BlackShark V2 Pro', 4290000.00, 15, 3, 'razer-blackshark-v2.png'),
('AirPods Pro Gen 2', 5990000.00, 30, 3, 'airpods-pro.png'),
('Tai nghe Sony WH-1000XM5', 7990000.00, 12, 3, 'sony-wh1000xm5.png'),

-- 4. Sạc dự phòng (8 sản phẩm)
('Sạc dự phòng Hoco J86 10000mAh', 220000.00, 60, 4, 'hoco-j86.png'),
('Sạc dự phòng Remax RPP-296 20000mAh', 390000.00, 55, 4, 'remax-rpp296.png'),
('Sạc dự phòng Ugreen 10000mAh PD 20W', 490000.00, 40, 4, 'ugreen-10000.png'),
('Sạc dự phòng Baseus 10000mAh', 650000.00, 40, 4, 'baseus-10000.png'),
('Sạc dự phòng Anker 20000mAh', 1290000.00, 50, 4, 'anker-20000.png'),
('Sạc dự phòng Anker MagGo 10000mAh Qi2', 1690000.00, 25, 4, 'anker-maggo.png'),
('Sạc dự phòng Cuktech 20 25000mAh 210W', 2190000.00, 18, 4, 'cuktech-20.png'),
('Sạc dự phòng Anker Prime 27650mAh 250W', 3490000.00, 12, 4, 'anker-prime-27k.png'),

-- 5. Bàn phím (7 sản phẩm)
('Bàn phím văn phòng có dây Logitech K120', 180000.00, 70, 5, 'logitech-k120.png'),
('Bàn phím không dây đa thiết bị Logitech K380', 590000.00, 40, 5, 'logitech-k380.png'),
('Bàn phím cơ DareU EK87 V2 Tenkeyless', 690000.00, 35, 5, 'dareu-ek87.png'),
('Bàn phím cơ Akko 3087 v2 Monet Cherry Switch', 1390000.00, 25, 5, 'akko-3087.png'),
('Bàn phím cơ Keychron K2 V2', 1990000.00, 25, 5, 'keychron-k2.png'),
('Bàn phím cơ Leopold FC900R PD High-End', 3290000.00, 15, 5, 'leopold-fc900r.png'),
('Bàn phím cơ Custom Asus ROG Azoth OLED', 5690000.00, 8, 5, 'asus-rog-azoth.png'),

-- 6. Chuột (7 sản phẩm)
('Chuột không dây văn phòng Fuhlen A09G', 150000.00, 80, 6, 'fuhlen-a09g.png'),
('Chuột không dây Logitech M220 Silent Chống Ồn', 290000.00, 65, 6, 'logitech-m220.png'),
('Chuột Gaming Logitech G102 Gen 2 Lightsync', 420000.00, 50, 6, 'logitech-g102.png'),
('Chuột không dây mỏng nhẹ Logitech Pebble M350', 450000.00, 45, 6, 'logitech-pebble.png'),
('Chuột Gaming chuyên nghiệp Razer DeathAdder V2', 1190000.00, 25, 6, 'razer-deathadder.png'),
('Chuột Logitech MX Master 3S', 2490000.00, 18, 6, 'logitech-mx3s.png'),
('Chuột Gaming không dây Logitech G Pro X Superlight', 2990000.00, 16, 6, 'logitech-gprox.png');

-- 4. Insert Customers (5 customers)
INSERT INTO customers (name, phone, email, address) VALUES
('Nguyễn Văn An', '0901234567', 'an.nguyen@gmail.com', '123 Lê Lợi, Quận 1, TP.HCM'),
('Trần Thị Bích', '0912345678', 'bich.tran@gmail.com', '456 Nguyễn Huệ, Quận 1, TP.HCM'),
('Lê Hoàng Nam', '0923456789', 'nam.le@gmail.com', '789 Cầu Giấy, Hà Nội'),
('Phạm Minh Tuấn', '0934567890', 'tuan.pham@gmail.com', '101 Trần Phú, Đà Nẵng'),
('Đỗ Thúy Hằng', '0945678901', 'hang.do@gmail.com', '202 Hùng Vương, Cần Thơ');

-- 5. Insert Sample Orders
INSERT INTO orders (customer_id, order_date, total, status, source) VALUES
(1, NOW(), 40980000.00, 'COMPLETED', 'STAFF'),
(2, NOW(), 35500000.00, 'CONFIRMED', 'ONLINE'),
(3, NOW(), 5990000.00, 'PENDING', 'ONLINE');

-- 6. Insert Order Details
INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
(1, 8, 1, 34990000.00),
(1, 23, 1, 5990000.00),
(2, 15, 1, 35500000.00),
(3, 23, 1, 5990000.00);

-- 7. Insert Product Colors
INSERT INTO product_colors (product_id, name, hex_code, border_hex)
SELECT id, 'Đen', '#1e293b', NULL FROM products WHERE name = 'Xiaomi Redmi 13C 128GB' UNION ALL
SELECT id, 'Xanh dương', '#1d4ed8', NULL FROM products WHERE name = 'Xiaomi Redmi 13C 128GB' UNION ALL
SELECT id, 'Xanh lá', '#6ee7b7', '#a7f3d0' FROM products WHERE name = 'Xiaomi Redmi 13C 128GB' UNION ALL

SELECT id, 'Xanh', '#3b82f6', NULL FROM products WHERE name = 'Samsung Galaxy A15 128GB' UNION ALL
SELECT id, 'Vàng', '#facc15', '#fef08a' FROM products WHERE name = 'Samsung Galaxy A15 128GB' UNION ALL
SELECT id, 'Đen', '#18181b', NULL FROM products WHERE name = 'Samsung Galaxy A15 128GB' UNION ALL

SELECT id, 'Xanh', '#0284c7', NULL FROM products WHERE name = 'Xiaomi Redmi Note 13 Pro 5G' UNION ALL
SELECT id, 'Đen', '#0f172a', NULL FROM products WHERE name = 'Xiaomi Redmi Note 13 Pro 5G' UNION ALL
SELECT id, 'Tím', '#c084fc', NULL FROM products WHERE name = 'Xiaomi Redmi Note 13 Pro 5G' UNION ALL

SELECT id, 'Xanh', '#99f6e4', '#ccfbf1' FROM products WHERE name = 'Samsung Galaxy S23 FE 5G' UNION ALL
SELECT id, 'Tím', '#a855f7', NULL FROM products WHERE name = 'Samsung Galaxy S23 FE 5G' UNION ALL
SELECT id, 'Xám', '#334155', NULL FROM products WHERE name = 'Samsung Galaxy S23 FE 5G' UNION ALL

SELECT id, 'Xanh', '#0f172a', NULL FROM products WHERE name = 'iPhone 13 128GB Chính Hãng' UNION ALL
SELECT id, 'Ánh Sao', '#f8fafc', '#cbd5e1' FROM products WHERE name = 'iPhone 13 128GB Chính Hãng' UNION ALL
SELECT id, 'Hồng', '#fbcfe8', '#fce7f3' FROM products WHERE name = 'iPhone 13 128GB Chính Hãng' UNION ALL

SELECT id, 'Xanh Dương', '#bfdbfe', '#dbeafe' FROM products WHERE name = 'iPhone 15 128GB Chính Hãng' UNION ALL
SELECT id, 'Hồng Nhạt', '#fce7f3', '#fbcfe8' FROM products WHERE name = 'iPhone 15 128GB Chính Hãng' UNION ALL
SELECT id, 'Đen Nhám', '#18181b', NULL FROM products WHERE name = 'iPhone 15 128GB Chính Hãng' UNION ALL
SELECT id, 'Xanh Lá Nhạt', '#dcfce7', '#bbf7d0' FROM products WHERE name = 'iPhone 15 128GB Chính Hãng' UNION ALL

SELECT id, 'Xám Titan', '#6f7074', NULL FROM products WHERE name = 'Samsung Galaxy S24 Ultra' UNION ALL
SELECT id, 'Đen Titan', '#2c2c2e', NULL FROM products WHERE name = 'Samsung Galaxy S24 Ultra' UNION ALL
SELECT id, 'Tím Titan', '#595166', NULL FROM products WHERE name = 'Samsung Galaxy S24 Ultra' UNION ALL
SELECT id, 'Vàng Titan', '#e4d9bc', NULL FROM products WHERE name = 'Samsung Galaxy S24 Ultra' UNION ALL

SELECT id, 'Titan Sa Mạc', '#cda277', NULL FROM products WHERE name = 'iPhone 17 Pro Max 256GB' UNION ALL
SELECT id, 'Titan Tự Nhiên', '#9e9b94', NULL FROM products WHERE name = 'iPhone 17 Pro Max 256GB' UNION ALL
SELECT id, 'Titan Trắng', '#f4f3ed', '#d1d5db' FROM products WHERE name = 'iPhone 17 Pro Max 256GB' UNION ALL
SELECT id, 'Titan Đen', '#393836', NULL FROM products WHERE name = 'iPhone 17 Pro Max 256GB' UNION ALL

SELECT id, 'Bạc Ánh Kim', '#e2e8f0', '#cbd5e1' FROM products WHERE name = 'Laptop Acer Aspire 3 A315 i3' UNION ALL
SELECT id, 'Xám Tro', '#64748b', NULL FROM products WHERE name = 'Laptop Lenovo IdeaPad Slim 3 15IAH8 i5' UNION ALL
SELECT id, 'Bạc Ánh Trăng', '#f1f5f9', '#cbd5e1' FROM products WHERE name = 'Laptop Asus Vivobook 15 OLED i5' UNION ALL
SELECT id, 'Đen', '#09090b', NULL FROM products WHERE name = 'Laptop Gaming Acer Nitro 5 Tiger i5 RTX3050' UNION ALL
SELECT id, 'Xám', '#475569', NULL FROM products WHERE name = 'Laptop Asus TUF Gaming A15 R7 RTX4050' UNION ALL
SELECT id, 'Xanh Thẫm', '#1e293b', NULL FROM products WHERE name = 'MacBook Air M2 13.6 inch 256GB' UNION ALL
SELECT id, 'Ánh Vàng', '#fef08a', '#fef9c3' FROM products WHERE name = 'MacBook Air M2 13.6 inch 256GB' UNION ALL
SELECT id, 'Xám', '#64748b', NULL FROM products WHERE name = 'MacBook Air M2 13.6 inch 256GB' UNION ALL
SELECT id, 'Bạch Kim (Platinum)', '#dadbdc', '#cbd5e1' FROM products WHERE name = 'Dell XPS 13 9320' UNION ALL
SELECT id, 'Than Chì (Graphite)', '#424446', NULL FROM products WHERE name = 'Dell XPS 13 9320' UNION ALL
SELECT id, 'Đen Không Gian', '#2e3033', NULL FROM products WHERE name = 'MacBook Pro M3 14 inch' UNION ALL
SELECT id, 'Bạc Ánh Kim', '#e2e4e6', '#cbd5e1' FROM products WHERE name = 'MacBook Pro M3 14 inch' UNION ALL

SELECT id, 'Đen Nhám', '#18181b', NULL FROM products WHERE name = 'Tai nghe Gaming Havit H2002D' UNION ALL
SELECT id, 'Đen', '#27272a', NULL FROM products WHERE name = 'Tai nghe Soundpeats Free2 Classic Bluetooth' UNION ALL
SELECT id, 'Be Ánh Kim', '#fef3c7', '#fde68a' FROM products WHERE name = 'Tai nghe chụp tai Sony WH-CH520' UNION ALL
SELECT id, 'Xanh Dương', '#2563eb', NULL FROM products WHERE name = 'Tai nghe chụp tai Sony WH-CH520' UNION ALL
SELECT id, 'Trắng', '#ffffff', '#e2e8f0' FROM products WHERE name = 'Tai nghe không dây JBL Wave Beam' UNION ALL
SELECT id, 'Đen', '#1c1917', NULL FROM products WHERE name = 'Tai nghe Marshall Major IV Bluetooth' UNION ALL
SELECT id, 'Nâu', '#78350f', NULL FROM products WHERE name = 'Tai nghe Marshall Major IV Bluetooth' UNION ALL
SELECT id, 'Đen', '#09090b', NULL FROM products WHERE name = 'Tai nghe Gaming Razer BlackShark V2 Pro' UNION ALL
SELECT id, 'Trắng Tinh Khôi', '#ffffff', '#d1d5db' FROM products WHERE name = 'AirPods Pro Gen 2' UNION ALL
SELECT id, 'Đen Nhám', '#1f2022', NULL FROM products WHERE name = 'Tai nghe Sony WH-1000XM5' UNION ALL
SELECT id, 'Bạc Ánh Kim', '#dcd7ce', '#cbd5e1' FROM products WHERE name = 'Tai nghe Sony WH-1000XM5' UNION ALL

SELECT id, 'Trắng', '#ffffff', '#e2e8f0' FROM products WHERE name = 'Sạc dự phòng Hoco J86 10000mAh' UNION ALL
SELECT id, 'Đen Nhám', '#18181b', NULL FROM products WHERE name = 'Sạc dự phòng Remax RPP-296 20000mAh' UNION ALL
SELECT id, 'Xám', '#475569', NULL FROM products WHERE name = 'Sạc dự phòng Ugreen 10000mAh PD 20W' UNION ALL
SELECT id, 'Đen Nhám', '#262626', NULL FROM products WHERE name = 'Sạc dự phòng Baseus 10000mAh' UNION ALL
SELECT id, 'Trắng Ngọc', '#ffffff', '#d1d5db' FROM products WHERE name = 'Sạc dự phòng Baseus 10000mAh' UNION ALL
SELECT id, 'Đen Huyền Bí', '#181818', NULL FROM products WHERE name = 'Sạc dự phòng Anker 20000mAh' UNION ALL
SELECT id, 'Trắng Sứ', '#f8f9fa', '#d1d5db' FROM products WHERE name = 'Sạc dự phòng Anker 20000mAh' UNION ALL
SELECT id, 'Xanh Ngọc Trai', '#99f6e4', '#ccfbf1' FROM products WHERE name = 'Sạc dự phòng Anker MagGo 10000mAh Qi2' UNION ALL
SELECT id, 'Trắng', '#f8fafc', '#e2e8f0' FROM products WHERE name = 'Sạc dự phòng Anker MagGo 10000mAh Qi2' UNION ALL
SELECT id, 'Xám Kim Loại', '#334155', NULL FROM products WHERE name = 'Sạc dự phòng Cuktech 20 25000mAh 210W' UNION ALL
SELECT id, 'Đen', '#0f172a', NULL FROM products WHERE name = 'Sạc dự phòng Anker Prime 27650mAh 250W' UNION ALL

SELECT id, 'Đen', '#1e293b', NULL FROM products WHERE name = 'Bàn phím văn phòng có dây Logitech K120' UNION ALL
SELECT id, 'Hồng', '#fbcfe8', '#fce7f3' FROM products WHERE name = 'Bàn phím không dây đa thiết bị Logitech K380' UNION ALL
SELECT id, 'Trắng', '#f8fafc', '#e2e8f0' FROM products WHERE name = 'Bàn phím không dây đa thiết bị Logitech K380' UNION ALL
SELECT id, 'Đen Led Đỏ', '#18181b', NULL FROM products WHERE name = 'Bàn phím cơ DareU EK87 V2 Tenkeyless' UNION ALL
SELECT id, 'Xanh Tím', '#7c3aed', NULL FROM products WHERE name = 'Bàn phím cơ Akko 3087 v2 Monet Cherry Switch' UNION ALL
SELECT id, 'Xám Carbon', '#374151', NULL FROM products WHERE name = 'Bàn phím cơ Keychron K2 V2' UNION ALL
SELECT id, 'Xanh', '#1e3a8a', NULL FROM products WHERE name = 'Bàn phím cơ Leopold FC900R PD High-End' UNION ALL
SELECT id, 'Đen', '#09090b', NULL FROM products WHERE name = 'Bàn phím cơ Custom Asus ROG Azoth OLED' UNION ALL

SELECT id, 'Đen Nhám', '#18181b', NULL FROM products WHERE name = 'Chuột không dây văn phòng Fuhlen A09G' UNION ALL
SELECT id, 'Xám Chống Ồn', '#475569', NULL FROM products WHERE name = 'Chuột không dây Logitech M220 Silent Chống Ồn' UNION ALL
SELECT id, 'Đen', '#09090b', NULL FROM products WHERE name = 'Chuột Gaming Logitech G102 Gen 2 Lightsync' UNION ALL
SELECT id, 'Trắng', '#ffffff', '#cbd5e1' FROM products WHERE name = 'Chuột Gaming Logitech G102 Gen 2 Lightsync' UNION ALL
SELECT id, 'Hồng', '#e9d5ff', '#f3e8ff' FROM products WHERE name = 'Chuột không dây mỏng nhẹ Logitech Pebble M350' UNION ALL
SELECT id, 'Xanh', '#d9f99d', '#ecfccb' FROM products WHERE name = 'Chuột không dây mỏng nhẹ Logitech Pebble M350' UNION ALL
SELECT id, 'Đen', '#09090b', NULL FROM products WHERE name = 'Chuột Gaming chuyên nghiệp Razer DeathAdder V2' UNION ALL
SELECT id, 'Xám Graphite', '#374151', NULL FROM products WHERE name = 'Chuột Logitech MX Master 3S' UNION ALL
SELECT id, 'Trắng Siêu Nhẹ 63g', '#ffffff', '#cbd5e1' FROM products WHERE name = 'Chuột Gaming không dây Logitech G Pro X Superlight' UNION ALL
SELECT id, 'Đen Siêu Nhẹ 63g', '#09090b', NULL FROM products WHERE name = 'Chuột Gaming không dây Logitech G Pro X Superlight';
