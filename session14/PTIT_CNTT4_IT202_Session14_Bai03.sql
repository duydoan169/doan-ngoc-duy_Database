-- bai 3
use social_network;

create table followers (
	follower_id int not null,
	followed_id int not null,
	primary key (follower_id, followed_id)
);

alter table users
add column following_count int default 0,
add column followers_count int default 0;

delimiter $$

create procedure follow_user(
	in p_follower_id int,
	in p_followed_id int
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
		signal sqlstate '45000' set message_text = 'follow that bai';
	end;

	start transaction;

	if not exists (select user_id from users where user_id = p_follower_id) then
		rollback;
		signal sqlstate '45000' set message_text = 'follow that bai';
	end if;

	if not exists (select user_id from users where user_id = p_followed_id) then
		rollback;
		signal sqlstate '45000' set message_text = 'follow that bai';
	end if;

	if p_follower_id = p_followed_id then
		rollback;
		signal sqlstate '45000' set message_text = 'follow that bai';
	end if;

	insert into followers values (p_follower_id, p_followed_id);
	update users set following_count = following_count + 1 where user_id = p_follower_id;
	update users set followers_count = followers_count + 1 where user_id = p_followed_id;

	commit;
	select 'follow thanh cong' as result;
end $$

delimiter ;

call follow_user(1, 2);
call follow_user(1, 1);
call follow_user(1, 2);
call follow_user(5, 2);
