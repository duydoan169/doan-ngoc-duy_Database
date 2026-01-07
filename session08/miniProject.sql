create database online_sales;
use online_sales;

create table customers (
    customer_id int auto_increment primary key,
    customer_name varchar(100) not null,
    email varchar(100) not null unique,
    phone varchar(10) not null unique
);

insert into customers (customer_name, email, phone) values
('nguyen van a', 'a@gmail.com', '0912345678'),
('tran thi b', 'b@gmail.com', '0923456789'),
('le van c', 'c@gmail.com', '0934567890'),
('pham thi d', 'd@gmail.com', '0945678901'),
('hoang van e', 'e@gmail.com', '0956789012');

create table categories (
    category_id int auto_increment primary key,
    category_name varchar(255) not null unique
);

insert into categories (category_name) values
('electronics'),
('books'),
('clothing'),
('home appliances'),
('stationery');

create table products (
    product_id int auto_increment primary key,
    product_name varchar(255) not null unique,
    price decimal(10,2) not null check (price > 0),
    category_id int not null,
    foreign key (category_id) references categories(category_id)
);

insert into products (product_name, price, category_id) values
('laptop', 1500.00, 1),
('smartphone', 900.00, 1),
('novel book', 120.00, 2),
('t-shirt', 200.00, 3),
('notebook', 25.00, 5);

create table orders (
    order_id int auto_increment primary key,
    customer_id int not null,
    order_date datetime default current_timestamp,
    status enum('pending', 'completed', 'cancel') default 'pending',
    foreign key (customer_id) references customers(customer_id)
);

insert into orders (customer_id, status) values
(1, 'pending'),
(2, 'completed'),
(3, 'pending'),
(4, 'cancel'),
(5, 'completed');

create table order_items (
    order_item_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 1),
(1, 5, 3),
(2, 2, 1),
(3, 4, 2),
(5, 3, 1);

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN:

-- lấy danh sách tất cả danh mục sản phẩm trong hệ thống
select * from categories;

-- lấy danh sách đơn hàng có trạng thái completed
select * from orders
where status = 'completed';

-- lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
select * from products
order by price desc;

-- lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
select * from products
order by price desc
limit 5 offset 2;

-- PHẦN B – TRUY VẤN NÂNG CAO:

-- Lấy danh sách sản phẩm kèm tên danh mục
select p.product_id, p.product_name, p.price, c.category_name
from products p 
join categories c 
on p.category_id = c.category_id; 

-- Lấy danh sách đơn hàng gồm: order_id, order_date, customer_name, status
select o.order_id, o.order_date, c.customer_name, o.status 
from orders o
join customers c
on o.customer_id = c.customer_id;

-- Tính tổng số lượng sản phẩm trong từng đơn hàng
select o.order_id, sum(oi.quantity)
from orders o
join order_items oi
on o.order_id = oi.order_id 
group by o.order_id;

-- Thống kê số đơn hàng của mỗi khách hàng
select c.customer_id, c.customer_name, count(o.customer_id)
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_id;

-- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
select c.customer_id, c.customer_name, count(o.customer_id)
from customers c
join orders o 
on c.customer_id = o.customer_id
group by c.customer_id
having count(o.customer_id) >= 2;

-- Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
select c.category_id, c.category_name, avg(p.price) as average, min(p.price) as min, max(p.price) as max
from categories c
join products p on p.category_id = c.category_id
group by c.category_id, c.category_name;

-- lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select *
from products
where price > (
    select avg(price)
    from products
);

-- lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
select *
from customers
where customer_id in (
    select customer_id
    from orders
);

-- lấy đơn hàng có tổng số lượng sản phẩm lớn nhất
select order_id
from order_items
group by order_id
having sum(quantity) = (
    select max(total_quantity)
    from (
        select sum(quantity) as total_quantity
        from order_items
        group by order_id
    ) t
);

-- lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
select distinct c.customer_name
from customers c
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
join products p on p.product_id = oi.product_id
where p.category_id = (
    select category_id
    from products
    group by category_id
    having avg(price) = (
        select max(avg_price)
        from (
            select avg(price) as avg_price
            from products
            group by category_id
        ) t
    )
);

-- từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
select customer_id, sum(total_quantity) as total_quantity
from (
    select o.customer_id, sum(oi.quantity) as total_quantity
    from orders o
    join order_items oi on oi.order_id = o.order_id
    group by o.customer_id
) t
group by customer_id;

-- viết lại truy vấn lấy sản phẩm có giá cao nhất
select *
from products
where price = (
    select max(price)
    from products
);
