create database social_network;
use social_network;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    status varchar(20) default 'active',
    created_at datetime default current_timestamp
);

create table posts (
    post_id int primary key auto_increment,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
);

create table comments (
    comment_id int primary key auto_increment,
    post_id int,
    user_id int,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id),
    foreign key (user_id) references users(user_id)
);

create table friends (
    user_id int,
    friend_id int,
    status varchar(20) check (status in ('pending','accepted')),
    foreign key (user_id) references users(user_id),
    foreign key (friend_id) references users(user_id)
);

create table likes (
    user_id int,
    post_id int,
    foreign key (user_id) references users(user_id),
    foreign key (post_id) references posts(post_id)
);

-- Bài 1. Quản lý người dùng
insert into users (username, password, email) 
values ('ngocduy', '123456', 'duy@example.com');
insert into users (username, password, email) 
values ('lananh', 'abcdef', 'lananh@example.com');
select * from users;

-- Bài 2. Hiển thị thông tin công khai bằng VIEW
create view vw_public_users as
select user_id, username, created_at
from users;
select * from vw_public_users;
select user_id, username, created_at from users;

-- Bài 3. Tối ưu tìm kiếm người dùng bằng INDEX
create index idx_username on users(username);
select * from users where username = 'ngocduy';

-- Bài 4. Quản lý bài viết bằng Stored Procedure
delimiter $$
create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if exists (select 1 from users where user_id = p_user_id) then
        insert into posts(user_id, content) values(p_user_id, p_content);
    end if;
end $$
delimiter ;
call sp_create_post(1, 'abcdefg');
select * from posts;

-- Bài 5. Hiển thị News Feed bằng VIEW
create view vw_recent_posts as
select post_id, user_id, content, created_at
from posts
where created_at >= current_date - interval 7 day;
select * from vw_recent_posts;

-- Bài 6. Tối ưu truy vấn bài viết
create index idx_posts_user_id on posts(user_id);
create index idx_posts_user_created on posts(user_id, created_at);
select * from posts
where user_id = 1
order by created_at desc;

-- Bài 7. Thống kê hoạt động bằng Stored Procedure
delimiter $$
create procedure sp_count_posts(
    in p_user_id int,
    out p_total int
)
begin
    select count(*) into p_total
    from posts
    where user_id = p_user_id;
end $$
delimiter ;
call sp_count_posts(1, @total);
select @total;

-- Bài 8. Kiểm soát dữ liệu bằng View WITH CHECK OPTION
create view vw_active_users as
select user_id, username, password, email, status, created_at
from users
where status = 'active'
with check option;
insert into vw_active_users(username, password, email, status)
values ('phuong', '123456', 'phuong@example.com', 'active');
update vw_active_users
set username = 'phuongupdated'
where username = 'phuong';

-- Bài 9. Quản lý kết bạn bằng Stored Procedure
delimiter $$
create procedure sp_add_friend(
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id = p_friend_id then
        select 'khong the ket ban voi chinh minh';
    else
        insert into friends(user_id, friend_id, status)
        values(p_user_id, p_friend_id, 'pending');
    end if;
end $$
delimiter ;
call sp_add_friend(1, 2);

-- Bài 10. Gợi ý bạn bè bằng Procedure nâng cao
delimiter $$
create procedure sp_suggest_friends(
    in p_user_id int,
    inout p_limit int
)
begin
    declare counter int default 0;
    declare suggested_id int;
    while counter < p_limit do
        select user_id into suggested_id
        from users
        where user_id <> p_user_id
        limit counter, 1;
        select suggested_id;
        set counter = counter + 1;
    end while;
end $$
delimiter ;
set @limit = 3;
call sp_suggest_friends(1, @limit);

-- Bài 11. Thống kê tương tác nâng cao
create index idx_likes_post_id on likes(post_id);
create view vw_top_posts as
select post_id, count(*) as total_likes
from likes
group by post_id
order by total_likes desc
limit 5;
select * from vw_top_posts;

-- Bài 12. Quản lý bình luận
delimiter $$
create procedure sp_add_comment(
    in p_user_id int,
    in p_post_id int,
    in p_content text
)
begin
    declare user_exist int;
    declare post_exist int;
    select count(*) into user_exist from users where user_id = p_user_id;
    select count(*) into post_exist from posts where post_id = p_post_id;
    if user_exist = 1 and post_exist = 1 then
        insert into comments(user_id, post_id, content) values(p_user_id, p_post_id, p_content);
    else
        select 'user hoac post khong ton tai';
    end if;
end $$
delimiter ;
call sp_add_comment(1, 1, 'binh luan moi');
create view vw_post_comments as
select c.content, u.username, c.created_at
from comments c
join users u on c.user_id = u.user_id;
select * from vw_post_comments;

-- Bài 13. Quản lý lượt thích
delimiter $$
create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    if not exists (select 1 from likes where user_id = p_user_id and post_id = p_post_id) then
        insert into likes(user_id, post_id) values(p_user_id, p_post_id);
    else
        select 'da thich bai viet nay';
    end if;
end $$
delimiter ;
call sp_like_post(1, 1);
create view vw_post_likes as
select post_id, count(*) as total_likes
from likes
group by post_id;
select * from vw_post_likes;

-- Bài 14. Tìm kiếm người dùng & bài viết
delimiter $$
create procedure sp_search_social(
    in p_option int,
    in p_keyword varchar(100)
)
begin
    if p_option = 1 then
        select * from users where username like concat('%', p_keyword, '%');
    elseif p_option = 2 then
        select * from posts where content like concat('%', p_keyword, '%');
    else
        select 'option khong hop le';
    end if;
end $$
delimiter ;
call sp_search_social(1, 'an');
call sp_search_social(2, 'database');
