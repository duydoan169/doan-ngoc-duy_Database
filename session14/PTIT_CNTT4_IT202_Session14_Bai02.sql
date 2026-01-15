-- bai 2
use social_network;

create table likes (
	like_id int primary key auto_increment,
    post_id int not null,
    foreign key (post_id) references posts(post_id),
    user_id int not null,
    foreign key (user_id) references users(user_id),
    unique key unique_like (post_id, user_id)
);

alter table posts
add column likes_count int default 0;

delimiter $$

create procedure like_post(
	in p_post_id int,
    in p_user_id int
)
begin
	declare exit handler for sqlexception
    begin
		signal sqlstate '45000' set message_text = 'Thich bai viet that bai';
		rollback;
    end ;
    
    start transaction;
    insert into likes (post_id, user_id) values
    (p_post_id, p_user_id);
    update posts set likes_count = likes_count + 1 where post_id = p_post_id;
    select "Thich bai viet thanh cong" as result;
    commit;
end $$

delimiter ;

call like_post(1, 1);
call like_post(1, 1);