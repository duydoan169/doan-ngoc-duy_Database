create database bai2;
use bai2;

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
(2, '2025-12-02', 'pending', 800000),
(3, '2025-12-03', 'completed', 1500000),
(1, '2025-12-04', 'cancelled', 500000),
(3, '2025-12-05', 'pending', 900000);

select c.customer_id, c.full_name, sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
order by total_spent desc;

select c.customer_id, c.full_name, max(o.total_amount) as max_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;
