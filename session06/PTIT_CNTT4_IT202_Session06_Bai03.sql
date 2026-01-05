create database bai3;
use bai3;

create table orders (
    order_id int primary key auto_increment,
    order_date date not null,
    status enum('pending', 'completed', 'cancelled') not null,
    total_amount decimal(10,2) not null
);

insert into orders (order_date, status, total_amount) values
('2025-12-01', 'completed', 6000000),
('2025-12-01', 'completed', 5000000),
('2025-12-01', 'pending', 3000000),
('2025-12-02', 'completed', 12000000),
('2025-12-02', 'completed', 2000000),
('2025-12-03', 'completed', 8000000),
('2025-12-03', 'cancelled', 4000000);

select order_date, sum(total_amount) as total_revenue, count(order_id) as order_count
from orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;
