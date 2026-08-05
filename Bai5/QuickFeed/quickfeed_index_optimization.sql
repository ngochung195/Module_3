USE quickfeed_db;

-- BƯỚC 1: KIỂM TRA DUNG LƯỢNG KHI CHƯA DỌN DẸP
-- Ghi nhận lại giá trị tại cột `Index_length`
SHOW TABLE STATUS LIKE 'Posts';

SELECT 
    table_name AS 'Table',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data_Size_MB',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index_Size_MB'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

ALTER TABLE Posts 
    DROP INDEX idx_content,
    DROP INDEX idx_post_type,
    DROP INDEX idx_is_visible;

-- Quan sát cột `Index_length` giảm mạnh
SHOW TABLE STATUS LIKE 'Posts';

SELECT 
    table_name AS 'Table',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data_Size_MB',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index_Size_MB'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';