-- bai 1
create database social_network;
use social_network;

create table users(
	user_id int auto_increment primary key,
    username varchar(50) not null, 
    posts_count int default 0
);

create table posts(
	post_id int primary key auto_increment,
    user_id int not null,
    foreign key (user_id) references users(user_id),
    content text not null,
    created_at datetime default current_timestamp
);

insert into users values 
(1, "nguyen van a", 0),
(2, "nguyen van b", 0),
(3, "nguyen van c", 0);

delimiter $$

create procedure create_post(
	in p_user_id int,
    in p_content text
)
begin
	declare exit handler for sqlexception
    begin
        signal sqlstate '45000' set message_text = 'Them bai viet that bai';
		rollback;
    end;
    
	start transaction;
    insert into posts (user_id, content) values (p_user_id, p_content);
    update users set posts_count = posts_count + 1 where user_id = p_user_id;
    commit;
    select "Them bai viet thanh cong" as result;
end $$

delimiter ;

call create_post(1, "bai viet nguoi dung #1");
call create_post(4, "bai viet nguoi dung khong ton tai");
