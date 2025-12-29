create database bai3;
use bai3;

create table subject (
	subject_id int auto_increment primary key,
    subject_name varchar(255) not null,
    credit int not null check (credit > 0)
);

insert into subject (subject_name, credit) values
("Database Systems", 3),
("Data Structures", 4),
("Operating Systems", 3),
("Computer Networks", 3);

update subject set credit = 5 where subject_id = 2;
update subject set subject_name = "Advanced Database Systems" where subject_id = 1;

select * from subject;
