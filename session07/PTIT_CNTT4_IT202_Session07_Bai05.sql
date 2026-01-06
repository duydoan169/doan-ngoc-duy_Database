create database bai5;
use bai5;

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
(1, '2025-01-01', 100.00),
(1, '2025-01-02', 200.00),
(2, '2025-01-03', 150.00),
(3, '2025-01-04', 300.00),
(3, '2025-01-05', 250.00),
(4, '2025-01-06', 180.00),
(5, '2025-01-07', 400.00);

select * from customers where id in (
	select customer_id
    from orders 
    group by customer_id
    having sum(total_amount) = (
		select max(total) from
        (
			select sum(total_amount) as total
            from orders
            group by customer_id
        ) as temp
    )
)