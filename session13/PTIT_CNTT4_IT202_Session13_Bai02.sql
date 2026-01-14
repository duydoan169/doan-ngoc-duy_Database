-- bai 2
use bai01;

create table likes (
	like_id int primary key auto_increment,
    user_id int,
    post_id int,
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade,
    liked_at datetime default current_timestamp
);

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
SELECT * FROM user_statistics;

delete from likes where like_id = 2;

select * from user_statistics;
