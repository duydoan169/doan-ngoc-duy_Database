create database mini_social_network;
use mini_social_network;

create table users (
	user_id int auto_increment primary key,
	username varchar(50) not null unique,
	password varchar(255) not null,
	email varchar(100) not null unique,
	created_at datetime default current_timestamp
);

create table posts (
	post_id int auto_increment primary key,
	user_id int,
	content text not null,
	like_count int default 0,
	created_at datetime default current_timestamp,
	foreign key (user_id) references users(user_id) on delete cascade
);

create table comments (
	comment_id int auto_increment primary key,
	post_id int,
	user_id int,
	content text not null,
	created_at datetime default current_timestamp,
	foreign key (post_id) references posts(post_id) on delete cascade,
	foreign key (user_id) references users(user_id) on delete cascade
);

create table likes (
	user_id int,
	post_id int,
	created_at datetime default current_timestamp,
	primary key (user_id, post_id),
	foreign key (user_id) references users(user_id) on delete cascade,
	foreign key (post_id) references posts(post_id) on delete cascade
);

create table friends (
	user_id int,
	friend_id int,
	status varchar(20) default 'pending',
	created_at datetime default current_timestamp,
	primary key (user_id, friend_id),
	foreign key (user_id) references users(user_id) on delete cascade,
	foreign key (friend_id) references users(user_id) on delete cascade
);

create table user_log (
	log_id int auto_increment primary key,
	user_id int,
	action varchar(100),
	log_time datetime default current_timestamp
);

create table post_log (
	log_id int auto_increment primary key,
	post_id int,
	action varchar(100),
	log_time datetime default current_timestamp
);

create table friend_log (
	log_id int auto_increment primary key,
	user_id int,
	friend_id int,
	action varchar(100),
	log_time datetime default current_timestamp
);

create table like_log (
	log_id int auto_increment primary key,
	user_id int,
	post_id int,
	action varchar(50),
	log_time datetime default current_timestamp
);

delimiter $$

-- Bài 1: Đăng Ký Thành Viên
create procedure sp_register_user(
	in p_username varchar(50),
	in p_password varchar(255),
	in p_email varchar(100)
)
begin
	if exists (select 1 from users where username = p_username) then
		signal sqlstate '45000' set message_text = 'username exists';
	end if;

	if exists (select 1 from users where email = p_email) then
		signal sqlstate '45000' set message_text = 'email exists';
	end if;

	insert into users(username, password, email)
	values (p_username, p_password, p_email);
end$$

create trigger trg_user_register
after insert on users
for each row
begin
	insert into user_log(user_id, action)
	values (new.user_id, 'register');
end$$

-- Bài 2: Đăng Bài Viết
create procedure sp_create_post(
	in p_user_id int,
	in p_content text
)
begin
	if p_content is null or p_content = '' then
		signal sqlstate '45000' set message_text = 'content empty';
	end if;

	insert into posts(user_id, content)
	values (p_user_id, p_content);
end$$

create trigger trg_post_create
after insert on posts
for each row
begin
	insert into post_log(post_id, action)
	values (new.post_id, 'create post');
end$$

-- Bài 3: Thích Bài Viết
create trigger trg_like_insert
after insert on likes
for each row
begin
	update posts
	set like_count = like_count + 1
	where post_id = new.post_id;

	insert into like_log(user_id, post_id, action)
	values (new.user_id, new.post_id, 'like');
end$$

create trigger trg_like_delete
after delete on likes
for each row
begin
	update posts
	set like_count = like_count - 1
	where post_id = old.post_id;

	insert into like_log(user_id, post_id, action)
	values (old.user_id, old.post_id, 'unlike');
end$$

-- Bài 4: Gửi Lời Mời Kết Bạn
create procedure sp_send_friend_request(
	in p_sender_id int,
	in p_receiver_id int
)
begin
	if p_sender_id = p_receiver_id then
		signal sqlstate '45000' set message_text = 'cannot add yourself';
	end if;

	if exists (
		select 1 from friends
		where user_id = p_sender_id
		  and friend_id = p_receiver_id
	) then
		signal sqlstate '45000' set message_text = 'request exists';
	end if;

	insert into friends(user_id, friend_id, status)
	values (p_sender_id, p_receiver_id, 'pending');
end$$

create trigger trg_friend_request
after insert on friends
for each row
begin
	insert into friend_log(user_id, friend_id, action)
	values (new.user_id, new.friend_id, 'send request');
end$$

-- Bài 5: Chấp Nhận Lời Mời Kết Bạn
create trigger trg_friend_accept
after update on friends
for each row
begin
	if old.status = 'pending' and new.status = 'accepted' then
		if not exists (
			select 1 from friends
			where user_id = new.friend_id
			  and friend_id = new.user_id
		) then
			insert into friends(user_id, friend_id, status)
			values (new.friend_id, new.user_id, 'accepted');
		end if;
	end if;
end$$

-- Bài 6: Quản Lý Mối Quan Hệ Bạn Bè
create procedure sp_delete_friend(
	in p_user_id int,
	in p_friend_id int
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
	end;

	start transaction;

	delete from friends
	where (user_id = p_user_id and friend_id = p_friend_id)
	   or (user_id = p_friend_id and friend_id = p_user_id);

	commit;
end$$

-- Bài 7: Quản Lý Xóa Bài Viết
create procedure sp_delete_post(
	in p_post_id int,
	in p_user_id int
)
begin
	declare v_owner int;

	select user_id into v_owner
	from posts
	where post_id = p_post_id;

	if v_owner != p_user_id then
		signal sqlstate '45000' set message_text = 'not owner';
	end if;

	start transaction;

	delete from posts where post_id = p_post_id;

	commit;
end$$

-- Bài 8: Quản Lý Xóa Tài Khoản Người Dùng
create procedure sp_delete_user(
	in p_user_id int
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
	end;

	start transaction;

	delete from users where user_id = p_user_id;

	commit;
end$$

delimiter ;
