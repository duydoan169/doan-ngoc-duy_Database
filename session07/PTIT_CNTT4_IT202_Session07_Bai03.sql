create database bai3;
use bai3;

create table orders (
    id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2)
);

insert into orders (customer_id, order_date, total_amount) values
(1, '2025-01-01', 100.00),
(2, '2025-01-02', 250.00),
(3, '2025-01-03', 150.00),
(4, '2025-01-04', 400.00),
(5, '2025-01-05', 300.00);

select *
from orders
where total_amount > (
    select avg(total_amount)
    from orders
);
