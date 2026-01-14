create database bai01;
use bai01;

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

drop database bai01;
