USE social_network_pro;

create or replace view view_users_firstname as
select user_id, username, full_name, email, created_at from users 
where full_name like 'Nguyễn%';

select * from view_users_firstname;

insert into users(username, full_name, gender, email, password, birthdate, hometown) values
('tumi', 'Nguyễn Tuấn Minh', 'Nam', 'tumi@gmail.com', '123', '1994-02-28', 'Hà Nội');

select * from view_users_firstname;

delete from users where username = 'tumi';

select * from view_users_firstname;