create database bai1;
use bai1;

create table products (
    product_id int,
    product_name varchar(255),
    price decimal(10,2),
    stock int,
    status enum('active','inactive')
);

insert into products values
(1, 'laptop', 15000000, 10, 'active'),
(2, 'mouse', 200000, 50, 'active'),
(3, 'keyboard', 800000, 30, 'inactive'),
(4, 'monitor', 3000000, 15, 'active'),
(5, 'usb cable', 100000, 100, 'inactive');

select * from products;

select * from products
where status = 'active';

select * from products
where price > 1000000;

select * from products
where status = 'active'
order by price asc;
