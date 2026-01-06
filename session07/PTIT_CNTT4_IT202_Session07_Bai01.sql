create database bai1;
use bai1;

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
('nguyen van e', 'e@gmail.com'),
('nguyen van f', 'f@gmail.com'),
('nguyen van g', 'g@gmail.com');

insert into orders (customer_id, order_date, total_amount) values
(1, '2025-01-01', 150),
(1, '2025-01-05', 200),
(2, '2025-01-03', 300),
(3, '2025-01-04', 120),
(5, '2025-01-06', 500),
(5, '2025-01-07', 250),
(7, '2025-01-08', 180);

select *
from customers
where id in (
    select customer_id
    from orders
);
