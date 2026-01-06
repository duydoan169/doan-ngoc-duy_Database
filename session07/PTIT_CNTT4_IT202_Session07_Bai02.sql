create database bai2;
use bai2;

create table products (
    id int auto_increment primary key,
    name varchar(100),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int
);

insert into products (name, price) values
('product a', 100.00),
('product b', 200.00),
('product c', 150.00),
('product d', 300.00),
('product e', 250.00),
('product f', 180.00),
('product g', 220.00);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(1, 3, 1),
(2, 2, 5),
(3, 4, 1),
(3, 5, 2),
(4, 1, 1),
(5, 7, 3);

select *
from products
where id in (
    select product_id
    from order_items
);
