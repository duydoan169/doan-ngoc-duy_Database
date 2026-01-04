create database bai3;
use bai3;

create table orders (
    order_id int,
    customer_id int,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending','completed','cancelled')
);

insert into orders values
(1, 1, 3000000, '2024-01-10', 'completed'),
(2, 2, 7000000, '2024-01-12', 'pending'),
(3, 3, 12000000, '2024-01-15', 'completed'),
(4, 1, 4500000, '2024-01-18', 'cancelled'),
(5, 4, 9000000, '2024-01-20', 'completed'),
(6, 2, 2000000, '2024-01-22', 'pending'),
(7, 5, 15000000, '2024-01-25', 'completed');

select * from orders
where status = 'completed';

select * from orders
where total_amount > 5000000;

select * from orders
order by order_date desc
limit 5;

select * from orders
where status = 'completed'
order by total_amount desc;
