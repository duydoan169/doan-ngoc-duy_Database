create database bai6;
use bai6;

create table orders (
    id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2)
);

insert into orders (customer_id, order_date, total_amount) values
(1, '2025-01-01', 100.00),
(1, '2025-01-02', 200.00),
(2, '2025-01-03', 150.00),
(3, '2025-01-04', 300.00),
(3, '2025-01-05', 250.00),
(4, '2025-01-06', 180.00),
(5, '2025-01-07', 400.00);

select customer_id
from orders
group by customer_id
having sum(total_amount) > (
    select avg(total_per_customer)
    from (
        select sum(total_amount) as total_per_customer
        from orders
        group by customer_id
    ) as totals
);
