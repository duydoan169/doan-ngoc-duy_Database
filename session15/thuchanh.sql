      
CREATE DATABASE mini_social_network;
USE mini_social_network;

/* =========================================================
   BÀI 1 – ĐĂNG KÝ THÀNH VIÊN
   ========================================================= */

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username đã tồn tại';
    END IF;

    IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email đã tồn tại';
    END IF;

    INSERT INTO Users(username, password, email)
    VALUES (p_username, p_password, p_email);
END;
//

CREATE TRIGGER trg_user_register
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'REGISTER');
END;
//
DELIMITER ;

/* =========================================================
   BÀI 2 – ĐĂNG BÀI VIẾT
   ========================================================= */

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    action VARCHAR(100),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR LENGTH(TRIM(p_content)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nội dung không được rỗng';
    END IF;

    INSERT INTO Posts(user_id, content)
    VALUES (p_user_id, p_content);
END;
//

CREATE TRIGGER trg_post_insert
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, action)
    VALUES (NEW.post_id, 'CREATE_POST');
END;
//
DELIMITER ;

/* =========================================================
   BÀI 3 – THÍCH / BỎ THÍCH
   ========================================================= */

CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

DELIMITER //

CREATE TRIGGER trg_like_insert
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END;
//

CREATE TRIGGER trg_like_delete
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END;
//
DELIMITER ;

/* =========================================================
   BÀI 4 + 5 – KẾT BẠN
   ========================================================= */

CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) CHECK (status IN ('pending','accepted')) DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

DELIMITER //

CREATE PROCEDURE sp_send_friend_request(
    IN p_sender INT,
    IN p_receiver INT
)
BEGIN
    IF p_sender = p_receiver THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể tự kết bạn';
    END IF;

    IF EXISTS (
        SELECT 1 FROM Friends
        WHERE user_id = p_sender AND friend_id = p_receiver
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lời mời đã tồn tại';
    END IF;

    INSERT INTO Friends(user_id, friend_id)
    VALUES (p_sender, p_receiver);
END;
//

CREATE TRIGGER trg_accept_friend
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF OLD.status = 'pending' AND NEW.status = 'accepted' THEN
        INSERT IGNORE INTO Friends(user_id, friend_id, status)
        VALUES (NEW.friend_id, NEW.user_id, 'accepted');
    END IF;
END;
//
DELIMITER ;

/* =========================================================
   BÀI 6 – QUẢN LÝ BẠN BÈ (TRANSACTION)
   ========================================================= */

DELIMITER //
CREATE PROCEDURE sp_remove_friend(
    IN p_user1 INT,
    IN p_user2 INT
)
BEGIN
    START TRANSACTION;
    IF NOT EXISTS (
        SELECT 1 FROM Friends
        WHERE user_id = p_user1 AND friend_id = p_user2
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại mối quan hệ bạn bè';
    END IF;

    DELETE FROM Friends WHERE user_id = p_user1 AND friend_id = p_user2;
    DELETE FROM Friends WHERE user_id = p_user2 AND friend_id = p_user1;

    COMMIT;
END;
//
DELIMITER ;

/* =========================================================
   BÀI 7 – XÓA BÀI VIẾT
   ========================================================= */

DELIMITER //
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM Posts
        WHERE post_id = p_post_id AND user_id = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không có quyền xóa bài';
    END IF;

    DELETE FROM Posts WHERE post_id = p_post_id;
    COMMIT;
END;
//
DELIMITER ;

/* =========================================================
   BÀI 8 – XÓA TÀI KHOẢN
   ========================================================= */

DELIMITER //
CREATE PROCEDURE sp_delete_user(IN p_user_id INT)
BEGIN
    START TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM Users WHERE user_id = p_user_id
    ) THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Người dùng không tồn tại';
    END IF;

    DELETE FROM Users WHERE user_id = p_user_id;

    COMMIT;
END;
//
DELIMITER ;


/* =========================================================
   DEMO / TEST TẤT CẢ CÁC BÀI
   ========================================================= */

-- BÀI 1
CALL sp_register_user('alice','123','alice@mail.com');
CALL sp_register_user('bob','123','bob@mail.com');
CALL sp_register_user('charlie','123','charlie@mail.com');

-- BÀI 2
CALL sp_create_post(1,'Bài viết của Alice');
CALL sp_create_post(2,'Hello từ Bob');

-- BÀI 3
INSERT INTO Likes VALUES (2,1,NOW());
DELETE FROM Likes WHERE user_id=2 AND post_id=1;

-- BÀI 4 + 5
CALL sp_send_friend_request(1,2);
UPDATE Friends SET status='accepted' WHERE user_id=1 AND friend_id=2;

-- BÀI 6
CALL sp_remove_friend(1,2);

-- BÀI 7
CALL sp_delete_post(2,2);

-- BÀI 8
CALL sp_delete_user(3);

-- KIỂM TRA KẾT QUẢ
SELECT * FROM Users;
SELECT * FROM Posts;
SELECT * FROM Friends;
SELECT * FROM user_log;
SELECT * FROM post_log;

    