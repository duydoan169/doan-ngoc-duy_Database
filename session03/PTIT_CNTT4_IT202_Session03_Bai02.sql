create database bai2;
use bai2;

create table student (
	student_id int auto_increment primary key,
    full_name varchar(255) not null,
    email varchar(255) not null unique,
    date_of_birth date not null
);

insert into student (full_name, email, date_of_birth) values 
("Nguyen Van A", "a@gmail.com", '2025-12-27'),
("Nguyen Van B", "b@gmail.com", '2025-12-27'),
("Nguyen Van C", "c@gmail.com", '2025-12-27'),
("Nguyen Van E", "e@gmail.com", '2025-12-27'),
("Nguyen Van F", "f@gmail.com", '2025-12-27');

update student set email = "abc" where student_id = 3;
update student set date_of_birth = '2025-08-13' where student_id = 2;
delete from student where student_id = 5;

select * from student;