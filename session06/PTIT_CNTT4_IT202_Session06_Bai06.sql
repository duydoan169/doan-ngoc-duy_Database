create database bai6;
use bai6;

create table products (
    product_id int auto_increment primary key,
    product_name varchar(255) not null,
    price decimal(10,2) not null
);

create table order_items (
    order_id int not null,
    product_id int not null,
    quantity int not null,
    foreign key (product_id) references products(product_id)
);

insert into products (product_name, price) values
('ban hoc', 1500000),
('ghe xoay', 1200000),
('laptop', 18000000),
('chuot khong day', 350000),
('ban phim co', 950000),
('man hinh', 5000000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 4),
(1, 1, 6),
(2, 2, 5),
(2, 2, 6),
(3, 3, 3),
(3, 3, 4),
(3, 3, 5),
(4, 4, 10),
(5, 5, 7),
(5, 5, 5),
(6, 6, 6),
(6, 6, 5);

select
    p.product_name,
    sum(oi.quantity) as total_sold,
    sum(oi.quantity * p.price) as total_revenue,
    avg(p.price) as avg_price
from products p
join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by total_revenue desc
limit 5;
