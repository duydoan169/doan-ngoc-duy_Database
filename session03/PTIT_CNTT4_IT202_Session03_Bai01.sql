create database bai1;
use bai1;

create table student (
	student_id int auto_increment primary key,
    full_name varchar(255) not null,
    email varchar(255) not null unique,
    date_of_birth date not null
);

insert into student (full_name, email, date_of_birth) values 
("Nguyen Van A", "a@gmail.com", '2025-12-27'),
("Nguyen Van B", "b@gmail.com", '2025-12-27'),
("Nguyen Van C", "c@gmail.com", '2025-12-27');

select * from student;