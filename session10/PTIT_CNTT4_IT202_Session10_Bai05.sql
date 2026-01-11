-- bai 5
use social_network_pro;

explain analyze
select u.user_id, u.username, u.hometown, p.post_id, p.content
from users u
join posts p on u.user_id = p.user_id
where u.hometown = 'Hà Nội'
order by u.username desc
limit 10;

create index idx_hometown
on users(hometown);

explain analyze
select u.user_id, u.username, u.hometown, p.post_id, p.content
from users u
join posts p on u.user_id = p.user_id
where u.hometown = 'Hà Nội'
order by u.username desc
limit 10;

drop index idx_hometown on users;
