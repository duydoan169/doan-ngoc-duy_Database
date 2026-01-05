create database bai1;
use bai1;

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
    foreign key (customer_id) references customers(customer_id)
);

insert into customers (full_name, city) values
('nguyen van an', 'ha noi'),
('tran thi binh', 'ho chi minh'),
('le quang minh', 'da nang'),
('pham ngoc hoa', 'can tho'),
('do thanh tung', 'hai phong');

insert into orders (customer_id, order_date, status) values
(1, '2025-12-01', 'completed'),
(2, '2025-12-02', 'pending'),
(3, '2025-12-03', 'completed'),
(1, '2025-12-04', 'cancelled'),
(3, '2025-12-05', 'pending');

-- hien thi don hang + ten khach hang
select o.order_id, o.customer_id, o.order_date, o.status, c.full_name as 'customer' from orders o join customers c on c.customer_id = o.customer_id;

-- hien thi so don hang moi khach (chi hien khach co it nhat 1 don)
select c.customer_id, c.full_name, count(o.order_id) as 'number of orders' from customers c join orders o on c.customer_id = o.customer_id group by c.customer_id, c.full_name having count(o.order_id) >= 1;