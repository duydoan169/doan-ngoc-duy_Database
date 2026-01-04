create database bai4;
use bai4;

create table products (
    product_id int,
    product_name varchar(255),
    price decimal(10,2),
    stock int,
    sold_quantity int
);

insert into products values
(1, 'laptop', 15000000, 10, 250),
(2, 'mouse', 200000, 50, 600),
(3, 'keyboard', 800000, 30, 400),
(4, 'monitor', 3000000, 15, 180),
(5, 'usb cable', 100000, 100, 90),
(6, 'headphone', 1800000, 25, 320),
(7, 'webcam', 2200000, 20, 140),
(8, 'speaker', 2500000, 18, 210),
(9, 'ssd', 1200000, 40, 500),
(10, 'hdd', 1000000, 35, 360),
(11, 'router', 900000, 22, 160),
(12, 'keyboard pro', 2000000, 12, 410),
(13, 'mouse pro', 1500000, 14, 380),
(14, 'microphone', 2700000, 10, 130),
(15, 'tablet', 6000000, 8, 95);

select * from products
order by sold_quantity desc
limit 10;

select * from products
order by sold_quantity desc
limit 5 offset 10;

select * from products
where price < 2000000
order by sold_quantity desc;
