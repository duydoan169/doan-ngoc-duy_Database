create database bai6;

use bai6;

create table products (
    product_id int,
    product_name varchar(255),
    price decimal(10,2),
    status enum('active','inactive')
);

insert into products values
(1, 'laptop', 15000000, 'active'),
(2, 'mouse', 200000, 'active'),
(3, 'keyboard', 1200000, 'active'),
(4, 'monitor', 3000000, 'active'),
(5, 'usb cable', 100000, 'inactive'),
(6, 'headphone', 1800000, 'active'),
(7, 'webcam', 2200000, 'active'),
(8, 'speaker', 2500000, 'inactive'),
(9, 'ssd', 1300000, 'active'),
(10, 'hdd', 1000000, 'active'),
(11, 'router', 1900000, 'active'),
(12, 'keyboard pro', 2000000, 'active'),
(13, 'mouse pro', 1500000, 'inactive'),
(14, 'microphone', 2700000, 'active'),
(15, 'tablet', 2800000, 'active'),
(16, 'camera', 1600000, 'active'),
(17, 'power bank', 1100000, 'active'),
(18, 'smart watch', 2900000, 'active'),
(19, 'charger', 900000, 'active'),
(20, 'earbuds', 1400000, 'active'),
(21, 'printer', 3000000, 'inactive'),
(22, 'scanner', 2500000, 'active');

select * from products
where status = 'active'
and price between 1000000 and 3000000
order by price
limit 10;

select * from products
where status = 'active'
and price between 1000000 and 3000000
order by price
limit 10 offset 10;
