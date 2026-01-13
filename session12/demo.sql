/* =====================================================
   MINI PROJECT: SOCIAL NETWORK
   LÀM ĐÚNG THEO YÊU CẦU ĐỀ BÀI
   SQL CƠ BẢN + HÀM + VIEW + INDEX + PROCEDURE
===================================================== */

DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

/* =====================================================
   BÀI 1. QUẢN LÝ NGƯỜI DÙNG
===================================================== */
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TEST
INSERT INTO Users(username, password, email) VALUES
('an','123','an@gmail.com'),
('binh','123','binh@gmail.com'),
('cuong','123','cuong@gmail.com');

SELECT * FROM Users;

/* =====================================================
   BÀI 2. VIEW THÔNG TIN CÔNG KHAI
===================================================== */
CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

-- TEST
SELECT * FROM vw_public_users;

/* =====================================================
   BÀI 3. INDEX TÌM KIẾM USER
===================================================== */
CREATE INDEX idx_username ON Users(username);

-- TEST
SELECT * FROM Users WHERE username = 'an';

/* =====================================================
   TẠO BẢNG POSTS
===================================================== */
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* =====================================================
   BÀI 4. STORED PROCEDURE ĐĂNG BÀI
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO Posts(user_id, content)
    VALUES (p_user_id, p_content);
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_create_post(1, 'Hoc SQL co ban');
CALL sp_create_post(2, 'Hoc VIEW va INDEX');

SELECT * FROM Posts;

/* =====================================================
   BÀI 5. VIEW NEWS FEED (7 NGÀY)
===================================================== */
CREATE VIEW vw_recent_posts AS
SELECT *
FROM Posts
WHERE created_at >= NOW() - INTERVAL 7 DAY;

-- TEST
SELECT * FROM vw_recent_posts;

/* =====================================================
   BÀI 6. INDEX TỐI ƯU BÀI VIẾT
===================================================== */
CREATE INDEX idx_post_user ON Posts(user_id);
CREATE INDEX idx_post_user_time ON Posts(user_id, created_at);

-- TEST
SELECT * FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC;

/* =====================================================
   BÀI 7. PROCEDURE THỐNG KÊ BÀI VIẾT
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT
)
BEGIN
    SELECT COUNT(*) AS total_posts
    FROM Posts
    WHERE user_id = p_user_id;
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_count_posts(1);

/* =====================================================
   BÀI 8. VIEW WITH CHECK OPTION
===================================================== */
CREATE VIEW vw_active_users AS
SELECT *
FROM Users
WHERE created_at IS NOT NULL
WITH CHECK OPTION;

-- TEST
INSERT INTO vw_active_users(username, password, email)
VALUES ('dung','123','dung@gmail.com');

/* =====================================================
   TẠO BẢNG FRIENDS
===================================================== */
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

/* =====================================================
   BÀI 9. PROCEDURE KẾT BẠN
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    INSERT INTO Friends(user_id, friend_id, status)
    VALUES (p_user_id, p_friend_id, 'pending');
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_add_friend(1, 2);
SELECT * FROM Friends;

/* =====================================================
   BÀI 10. PROCEDURE GỢI Ý BẠN BÈ
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT
)
BEGIN
    SELECT user_id, username
    FROM Users
    WHERE user_id <> p_user_id;
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_suggest_friends(1);

/* =====================================================
   TẠO BẢNG LIKES
===================================================== */
CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

/* =====================================================
   BÀI 11. VIEW TOP BÀI VIẾT
===================================================== */
INSERT INTO Likes VALUES
(1,1),(2,1),(3,1),(2,2);

CREATE VIEW vw_top_posts AS
SELECT p.post_id, p.content, COUNT(l.user_id) AS total_likes
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id
ORDER BY total_likes DESC
LIMIT 5;

-- TEST
SELECT * FROM vw_top_posts;

/* =====================================================
   TẠO BẢNG COMMENTS
===================================================== */
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

/* =====================================================
   BÀI 12. PROCEDURE THÊM BÌNH LUẬN
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    INSERT INTO Comments(user_id, post_id, content)
    VALUES (p_user_id, p_post_id, p_content);
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_add_comment(2, 1, 'Bai viet hay');
SELECT * FROM Comments;

/* =====================================================
   BÀI 13. PROCEDURE LIKE BÀI VIẾT
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    INSERT INTO Likes(user_id, post_id)
    VALUES (p_user_id, p_post_id);
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_like_post(3, 2);
SELECT * FROM Likes;

/* =====================================================
   BÀI 14. PROCEDURE TÌM KIẾM
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        SELECT * FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');
    ELSE
        SELECT * FROM Posts
        WHERE content LIKE CONCAT('%', p_keyword, '%');
    END IF;
END //

DELIMITER ;

-- TEST (CALL)
CALL sp_search_social(1, 'an');
CALL sp_search_social(2, 'SQL');