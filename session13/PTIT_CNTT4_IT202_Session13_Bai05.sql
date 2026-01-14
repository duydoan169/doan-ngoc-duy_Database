use bai01;

delimiter $$

create trigger validate_user_before_insert
before insert on users
for each row
begin
	if new.email not like '%@%.%' then
		signal sqlstate '45000'
		set message_text = 'email khong hop le';
	end if;

	if new.username regexp '[^a-zA-Z0-9_]' then
		signal sqlstate '45000'
		set message_text = 'username khong hop le';
	end if;
end $$

delimiter ;

delimiter $$

create procedure add_user(
	in p_username varchar(50),
	in p_email varchar(100),
	in p_created_at date
)
begin
	insert into users(username, email, created_at)
	values (p_username, p_email, p_created_at);
end $$

delimiter ;

call add_user('nguyen_van_a', 'a@gmail.com', '2025-01-15');
call add_user('nguyen van !@#$%^&*()', '!@#$%^&*()@gmailcom', '2025-01-15');
call add_user('nguyenvanb', 'email', '2025-01-15');

select * from users;
