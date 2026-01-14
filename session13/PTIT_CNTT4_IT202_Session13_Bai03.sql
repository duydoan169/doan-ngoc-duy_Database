use bai01;

delimiter $$

create trigger prevent_like_self
before insert on likes
for each row
begin
	if new.user_id = (select user_id from posts where posts.post_id = new.post_id) then
    signal sqlstate '45000' set message_text = "khong duoc like bai dang cua chinh minh";
    end if;
end $$

delimiter ;

insert into likes(user_id, post_id, liked_at) values
(1, 1, '2025-01-10 10:00:00');
