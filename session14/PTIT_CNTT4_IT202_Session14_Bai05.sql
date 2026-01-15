-- bai 5
use social_network;

create table delete_log (
	log_id int auto_increment primary key,
	post_id int,
	deleted_at datetime default current_timestamp,
	deleted_by int
);

delimiter $$

create procedure delete_post(
	in p_post_id int,
	in p_user_id int
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
	end;

	start transaction;

	if not exists (
		select post_id from posts
		where post_id = p_post_id
		and user_id = p_user_id
	) then
		rollback;
		signal sqlstate '45000';
	end if;

	delete from likes where post_id = p_post_id;
	delete from comments where post_id = p_post_id;
	delete from posts where post_id = p_post_id;

	update users
	set posts_count = posts_count - 1
	where user_id = p_user_id;

	insert into delete_log (post_id, deleted_by)
	values (p_post_id, p_user_id);

	commit;
end $$

delimiter ;

call delete_post(1, 1);
call delete_post(2, 1);
