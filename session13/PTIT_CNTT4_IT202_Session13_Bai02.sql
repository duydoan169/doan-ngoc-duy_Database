create database bai02;
use bai02;

create table users (
	user_id int primary key auto_increment,
    username varchar(50) unique not null,
    email varchar(100) unique not null,
    created_at date default (current_date()),
    follower_count int default 0,
    post_count int default 0
);

create table posts (
	post_id int primary key auto_increment,
    user_id int,
    foreign key (user_id) references users(user_id) on delete cascade,
    content text,
    created_at date default (current_date()),
    like_count int default 0
);

create table likes (
	like_id int primary key auto_increment,
    user_id int,
    post_id int,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade,
    liked_at datetime default current_timestamp
);
INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

delimiter $$

create trigger after_insert_post
after insert on posts
for each row
begin
	update users
    set post_count = post_count + 1
    where user_id = new.user_id;
end $$

delimiter ;

delimiter $$

create trigger after_delete_post
after delete on posts
for each row
begin
	update users
    set post_count = post_count - 1
    where user_id = old.user_id;
end $$

delimiter ;

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');
SELECT * FROM users;
delete from posts where post_id = 2;
SELECT * FROM users;

-- 2
delimiter $$

create trigger after_insert_like
after insert on likes
for each row
begin
	update posts 
    set like_count = like_count + 1
    where post_id = new.post_id;
end $$

delimiter ;

delimiter $$

create trigger after_delete_like
after delete on likes
for each row
begin
	update posts 
    set like_count = like_count - 1
    where post_id = old.post_id;
end $$

delimiter ;

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

create view user_statistics as
select u.user_id, u.username, count(p.post_id) as post_count, sum(p.like_count) as total_likes
from users u join posts p on u.user_id = p.user_id
group by u.user_id, u.username;

INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());
SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

delete from likes where like_id = 2;

select * from user_statistics;

drop database bai02;