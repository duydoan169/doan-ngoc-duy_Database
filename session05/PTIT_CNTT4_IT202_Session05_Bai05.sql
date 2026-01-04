create database bai5;
use bai5;

create table orders (
    order_id int,
    customer_id int,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending','completed','cancelled')
);

insert into orders values
(1, 1, 3000000, '2024-01-01', 'completed'),
(2, 2, 7000000, '2024-01-02', 'pending'),
(3, 3, 12000000, '2024-01-03', 'completed'),
(4, 4, 4500000, '2024-01-04', 'cancelled'),
(5, 5, 9000000, '2024-01-05', 'completed'),
(6, 1, 2000000, '2024-01-06', 'pending'),
(7, 2, 15000000, '2024-01-07', 'completed'),
(8, 3, 6000000, '2024-01-08', 'pending'),
(9, 4, 8000000, '2024-01-09', 'completed'),
(10, 5, 1000000, '2024-01-10', 'pending'),
(11, 1, 5000000, '2024-01-11', 'completed'),
(12, 2, 4000000, '2024-01-12', 'pending'),
(13, 3, 11000000, '2024-01-13', 'completed'),
(14, 4, 2500000, '2024-01-14', 'pending'),
(15, 5, 9500000, '2024-01-15', 'completed'),
(16, 1, 3000000, '2024-01-16', 'cancelled');

select * from orders
where status != 'cancelled'
order by order_date desc
limit 5;

select * from orders
where status != 'cancelled'
order by order_date desc
limit 5 offset 5;

select * from orders
where status != 'cancelled'
order by order_date desc
limit 5 offset 10;
