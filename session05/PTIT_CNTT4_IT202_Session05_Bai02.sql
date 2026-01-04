create database bai2;
use bai2;

create table customers (
    customer_id int,
    full_name varchar(255),
    email varchar(255),
    city varchar(255),
    status enum('active','inactive')
);

insert into customers values
(1, 'nguyen van a', 'a@gmail.com', 'tp.hcm', 'active'),
(2, 'tran thi b', 'b@gmail.com', 'ha noi', 'active'),
(3, 'le van c', 'c@gmail.com', 'tp.hcm', 'inactive'),
(4, 'pham thi d', 'd@gmail.com', 'ha noi', 'inactive'),
(5, 'hoang van e', 'e@gmail.com', 'da nang', 'active');

select * from customers;

select * from customers
where city = 'tp.hcm';

select * from customers
where status = 'active'
and city = 'ha noi';

select * from customers
order by full_name;
