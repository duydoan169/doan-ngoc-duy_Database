use bai01;

delimiter $$

create trigger prevent_like_self_update
before update on likes
for each row
begin
	if new.user_id = (select user_id from posts where post_id = new.post_id) then
		signal sqlstate '45000'
		set message_text = 'khong duoc like bai dang cua chinh minh';
	end if;
end $$

delimiter ;

delimiter $$

create trigger update_like_count_on_update
after update on likes
for each row
begin
	if old.post_id <> new.post_id then
		update posts
		set like_count = like_count - 1
		where post_id = old.post_id;

		update posts
		set like_count = like_count + 1
		where post_id = new.post_id;
	end if;
end $$

delimiter ;

insert into likes (user_id, post_id, liked_at) values
(2, 1, '2025-01-10 11:00:00');

update likes set post_id = 3 where like_id = 1;

delete from likes where like_id = 1;

select post_id, like_count from posts;

select * from user_statistics;
