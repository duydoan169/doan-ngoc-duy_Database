create database quanlybanhang ;
use quanlybanhang ;

-- Câu 2 - Tạo bảng
create table Customers (
	customer_id int auto_increment primary key,
    customer_name varchar(100) not null ,
    phone varchar(20) not null unique,
    address varchar(255) 
);

create table Products (
	product_id int auto_increment primary key,
    product_name varchar (100) ,
    price decimal(10,2) not null,
    quantity int not null check(quantity > 0),
    category varchar(50) not null
);

create table Employees (
	employee_id int auto_increment primary key,
    employee_name varchar(100) not null,
    birthday date not null,
    position varchar(50) not null,
    salary decimal(10,2) not null,
    revenue decimal(10,2) default 0
);

create table Orders (
	order_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    order_date datetime default(current_timestamp()),
    total_amount decimal(10,2) default 0,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (employee_id ) references Employees(employee_id )
);

create table OrderDetails (
	order_detail_id int auto_increment primary key,
    order_id  int ,
    product_id int,
    quantity int not null check(quantity > 0),
    unit_price decimal(10,2) not null,
    foreign key (order_id ) references Orders(order_id),
    foreign key (product_id  ) references Products(product_id )
);

-- Câu 3 - Chỉnh sửa cấu trúc bảng
	-- 3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng Customers

alter table Customers add email varchar(100) not null unique;

	-- 3.2 Xóa cột ngày sinh ra khỏi bảng Employees

alter table Employees drop birthday ;

-- PHẦN 2 : TRUY VẤN DỮ LIỆU
	-- Câu 4 - Chèn dữ liệu Viết câu lệnh chèn dữ liệu vào bảng (mỗi bảng ít nhất 5 bản ghi phù hợp)

insert into customers (customer_name, phone, address, email) values
('nguyen van a', '0901111111', 'ha noi', 'a@gmail.com'),
('tran thi b', '0902222222', 'hai phong', 'b@gmail.com'),
('le van c', '0903333333', 'da nang', 'c@gmail.com'),
('pham thi d', '0904444444', 'tp hcm', 'd@gmail.com'),
('hoang van e', '0905555555', 'can tho', 'e@gmail.com');


insert into products (product_name, price, quantity, category) values
('iphone 15', 25000000, 10, 'dien thoai'),
('samsung s23', 22000000, 8, 'dien thoai'),
('macbook air m2', 30000000, 5, 'laptop'),
('chuot logitech', 500000, 50, 'phu kien'),
('ban phim co', 1500000, 20, 'phu kien');

insert into employees (employee_name, position, salary, revenue) values
('nguyen van nam', 'ban hang', 8000000, 0),
('tran thi lan', 'ban hang', 8500000, 0),
('le hoang long', 'quan ly', 15000000, 0),
('pham minh duc', 'ke toan', 10000000, 0),
('do thi mai', 'ban hang', 8200000, 0);

insert into orders (customer_id, employee_id, order_date, total_amount) values
(1, 1, now(), 25500000),
(2, 2, now(), 22000000),
(3, 1, now(), 30000000),
(4, 5, now(), 2000000),
(5, 3, now(), 1500000);

insert into orderdetails (order_id, product_id, quantity, unit_price) values
(1, 1, 1, 25000000),
(1, 4, 1, 500000),
(2, 2, 1, 22000000),
(3, 3, 1, 30000000),
(4, 5, 1, 1500000);

	-- Câu 5 - Truy vấn cơ bản
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách hàng, tên khách hàng, email, số điện thoại và địa chỉ

select * from Customers;

-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name= “Laptop Dell XPS” và price = 99.99

update Products 
set product_name ='Laptop Dell XP' , price = 99.99
where product_id = 1;

-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt hàng.

select o.order_id , c.customer_name, e.employee_name , o.total_amount , o.order_date  
from Orders o
join Customers c on o.customer_id = c.customer_id
join Employees e on o.employee_id = e.employee_id;

	-- Câu 6 - Truy vấn đầy đủ
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn

select c.customer_id  , c.customer_name  , count(o.order_id ) as 'tong so don hang'  from Customers c 
join Orders o on c.customer_id = o.customer_id
group by c.customer_id;

--  6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm : mã nhân viên, tên nhân viên, doanh thu

select e.employee_id ,e.employee_name, sum(o.total_amount) as doanh_thu
from employees e
join orders o on e.employee_id = o.employee_id
where year(o.order_date) = year(now())
group by e.employee_id ;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại. Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần

select p.product_id, p.product_name, sum(od.quantity) as so_luong_dat
from products p
join orderdetails od on p.product_id = od.product_id
join orders o on od.order_id = o.order_id
where month(o.order_date) = month(now()) and year(o.order_date) = year(now())
group by p.product_id
having sum(od.quantity) > 100
order by so_luong_dat desc;

	--  Câu 7 - Truy vấn nâng cao
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng
select customer_id , customer_name from Customers
where  customer_id not in (select customer_id from Orders );

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
select product_id , product_name from Products
where price > (select avg(price) from Products);

-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)

select c.customer_id, c.customer_name, sum(o.total_amount) as tong_chi_tieu
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_amount) = (select max(tong_chi_tieu) from (
								select sum(total_amount) as tong_chi_tieu
								from orders
								group by customer_id
								) t
);


-- Câu 8 - Tạo view
	-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng, tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự ngày đặt mới nhất

create or replace view view_order_list as
select o.order_id, c.customer_name, e.employee_name, o.total_amount, o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
order by o.order_date desc;

	-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp theo số lượng giảm dần

create or replace view view_order_detail_product 
as
select od.order_detail_id ,p.product_name ,od.quantity, od.unit_price from OrderDetails od
join Products p on od.product_id = p.product_id
order by od.quantity  desc;

-- Câu 9 - Tạo thủ tục lưu trữ

-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả về mã nhân viên vừa mới thêm.
delimiter //
 create procedure proc_insert_employee (
	 employee_name_in varchar(100),
	 position_in varchar(50),
	 salary_in decimal(10,2),
     out employee_id_out int )
begin
	
    insert into Employees (employee_name,position ,salary ) values (
    employee_name_in ,position_in,salary_in  );
    set employee_id_out = last_insert_id();
end //
delimiter ;

call proc_insert_employee( 'huy', 'bảo vệ' , 1 , @new_employee_id);
select @new_employee_id;
   
-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo mã đặt hàng.
delimiter //

create procedure proc_get_orderdetails (in order_id_in int)
begin
    select od.order_detail_id, p.product_name, od.quantity, od.unit_price
    from orderdetails od
    join products p on od.product_id = p.product_id
    where od.order_id = order_id_in;
end //

delimiter ;


call proc_get_orderdetails(1);


-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.

delimiter //

create procedure proc_cal_total_amount_by_order ( in order_id_in int, out total_product_types int)
begin
    select count(distinct product_id) into total_product_types
    from orderdetails
    where order_id = order_id_in;
end //

delimiter ;

call proc_cal_total_amount_by_order(1, @total_types);
select @total_types;

-- Câu 10 - Tạo trigger
   -- Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng
	-- sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho
	-- không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy
	-- thao tác chèn.

delimiter //

create trigger trigger_after_insert_order_details
before insert on orderdetails
for each row
begin
    declare current_quantity int;

    select quantity into current_quantity
    from products
    where product_id = new.product_id
    for update;

    if current_quantity < new.quantity then
        signal sqlstate '45000'
        set message_text = 'so luong san pham trong kho khong du';
    else
        update products
        set quantity = quantity - new.quantity
        where product_id = new.product_id;
    end if;
end //

delimiter ;

   
-- Câu 11 - Quản lý transaction
	-- Tạo một thủ tục có tên proc_insert_order_details nhận vào tham số là mã đơn hàng, mã sản phẩm, số lượng và giá sản phẩm. Sử dụng transaction thực hiện các yêu cầu sau :

	-- Kiểm tra nếu mã hóa đơn không tồn tại trong bảng order thì ném ra thông báo
	-- lỗi “không tồn tại mã hóa đơn”.
	-- Chèn dữ liệu vào bảng order_details
	-- Cập nhật tổng tiền của đơn hàng ở bảng Orders
	-- Nếu như có bất cứ lỗi nào sinh ra, rollback lại Transaction
delimiter //

create procedure proc_insert_order_details (
    in order_id_in int,
    in product_id_in int,
    in quantity_in int,
    in unit_price_in decimal(10,2)
)
begin
    declare order_count int;
    declare total_money decimal(10,2);

    declare exit handler for sqlexception
    begin
        rollback;
        signal sqlstate '45000'
        set message_text = 'co loi xay ra, rollback transaction';
    end;

    start transaction;

    -- kiem tra ma hoa don
    select count(*) into order_count
    from orders
    where order_id = order_id_in;

    if order_count = 0 then
        signal sqlstate '45000'
        set message_text = 'khong ton tai ma hoa don';
    end if;

    -- them chi tiet don hang
    insert into orderdetails (order_id, product_id, quantity, unit_price)
    values (order_id_in, product_id_in, quantity_in, unit_price_in);

    -- cap nhat tong tien don hang
    select sum(quantity * unit_price) into total_money
    from orderdetails
    where order_id = order_id_in;

    update orders
    set total_amount = total_money
    where order_id = order_id_in;

    commit;
end //

delimiter ;