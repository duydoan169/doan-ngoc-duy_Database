create database bai5;
use bai5;

create table customers (
    customer_id int primary key auto_increment,
    full_name varchar(255) not null,
    city varchar(255)
);

create table orders (
    order_id int primary key auto_increment,
    customer_id int not null,
    order_date date not null,
    status enum('pending', 'completed', 'cancelled') not null,
    total_amount decimal(10,2),
    foreign key (customer_id) references customers(customer_id)
);

insert into customers (full_name, city) values
('nguyen van an', 'ha noi'),
('tran thi binh', 'ho chi minh'),
('le quang minh', 'da nang'),
('pham ngoc hoa', 'can tho'),
('do thanh tung', 'hai phong');

insert into orders (customer_id, order_date, status, total_amount) values
(1, '2025-12-01', 'completed', 1200000),
(1, '2025-12-02', 'completed', 4500000),
(1, '2025-12-03', 'completed', 5200000),
(2, '2025-12-02', 'pending', 800000),
(3, '2025-12-03', 'completed', 1500000),
(3, '2025-12-04', 'completed', 4000000),
(3, '2025-12-05', 'completed', 6000000),
(4, '2025-12-06', 'completed', 2000000);

select
    c.customer_id,
    c.full_name,
    count(o.order_id) as total_orders,
    sum(o.total_amount) as total_spent,
    avg(o.total_amount) as avg_order_value
from customers c
join orders o on c.customer_id = o.customer_id
where o.status = 'completed'
group by c.customer_id, c.full_name
having count(o.order_id) >= 3
   and sum(o.total_amount) > 10000000
order by total_spent desc;
