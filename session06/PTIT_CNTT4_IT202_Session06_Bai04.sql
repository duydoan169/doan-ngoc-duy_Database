create database bai4;
use bai4;

create table products(
	product_id int auto_increment primary key,
    product_name varchar(255),
    price decimal(10,2) 
);

create table order_items (
	order_id int not null,
    product_id int not null,
    quantity int,
    foreign key (product_id) references products(product_id)
);

insert into products (product_id, product_name, price) values
(1, 'Bàn học', 1500000),
(2, 'Ghế xoay', 1200000),
(3, 'Laptop', 18000000),
(4, 'Chuột không dây', 350000),
(5, 'Bàn phím cơ', 950000);

insert into order_items (order_id, product_id, quantity) values
(1, 1, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 3),
(5, 5, 2);

select p.product_name , sum(o.quantity) as number_of_products_sold from products p
join order_items o on p.product_id = o.product_id
group by  p.product_name;

select  p.product_name , sum(p.price * o.quantity) as price_of_products_sold from products p
join order_items o on p.product_id = o.product_id
group by  p.product_name;

select  p.product_name , sum(p.price * o.quantity) as price_of_products_sold from products p
join order_items o on p.product_id = o.product_id
group by  p.product_name
having sum(p.price * o.quantity) > 5000000;