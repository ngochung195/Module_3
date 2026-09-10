CREATE DATABASE IF NOT EXISTS demo;
USE demo;

CREATE TABLE users (
    id INT(3) NOT NULL AUTO_INCREMENT,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(220) NOT NULL,
    country VARCHAR(120),
    PRIMARY KEY (id)
);

-- Thêm một số dữ liệu mẫu ban đầu
INSERT INTO users(name, email, country) VALUES('Minh','minh@codegym.vn','Viet Nam');
INSERT INTO users(name, email, country) VALUES('Kante','kante@che.uk','Kenia');

DELIMITER //

DROP PROCEDURE IF EXISTS get_user_by_id //
CREATE PROCEDURE get_user_by_id(IN user_id INT)
BEGIN
    SELECT users.name, users.email, users.country
    FROM users
    WHERE users.id = user_id;
END //

DROP PROCEDURE IF EXISTS insert_user //
CREATE PROCEDURE insert_user(
    IN user_name VARCHAR(120),
    IN user_email VARCHAR(220),
    IN user_country VARCHAR(120)
)
BEGIN
    INSERT INTO users(name, email, country) VALUES(user_name, user_email, user_country);
END //

DROP PROCEDURE IF EXISTS get_all_users //
CREATE PROCEDURE get_all_users()
BEGIN
    SELECT * FROM users;
END //

DROP PROCEDURE IF EXISTS update_user //
CREATE PROCEDURE update_user(
    IN user_id INT,
    IN user_name VARCHAR(120),
    IN user_email VARCHAR(220),
    IN user_country VARCHAR(120)
)
BEGIN
    UPDATE users
    SET name = user_name, email = user_email, country = user_country
    WHERE id = user_id;
END //

DROP PROCEDURE IF EXISTS delete_user //
CREATE PROCEDURE delete_user(IN user_id INT)
BEGIN
    DELETE FROM users WHERE id = user_id;
END //

DELIMITER ;