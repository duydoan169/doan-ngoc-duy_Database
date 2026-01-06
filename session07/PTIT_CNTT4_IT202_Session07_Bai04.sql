create database bai4;
use bai4;

create table customers (
    id int auto_increment primary key,
    name varchar(100),
    email varchar(100)
);

create table orders (
    id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2)
);

insert into customers (name, email) values
('nguyen van a', 'a@gmail.com'),
('nguyen van b', 'b@gmail.com'),
('nguyen van c', 'c@gmail.com'),
('nguyen van d', 'd@gmail.com'),
('nguyen van e', 'e@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(1, '2025-01-01', 100),
(1, '2025-01-03', 200),
(2, '2025-01-02', 150),
(3, '2025-01-04', 300),
(3, '2025-01-06', 120),
(5, '2025-01-05', 250);

select name, (select count(*) from orders where orders.customer_id = customers.id )
as order_count
from customers;
