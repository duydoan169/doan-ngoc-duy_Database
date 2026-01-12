-- bai 3
USE social_network_pro;

explain select * from users
where hometown = 'Hà Nội';

create index idx_hometown on users(hometown);

explain select * from users
where hometown = 'Hà Nội';

drop index idx_hometown on users;