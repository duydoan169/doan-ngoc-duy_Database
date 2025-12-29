create database bai4;
use bai4;

create table student (
	student_id int auto_increment primary key,
    full_name varchar(255) not null,
    email varchar(255) not null unique,
    date_of_birth date not null
);

insert into student (full_name, email, date_of_birth) values 
("Nguyen Van A", "a@gmail.com", '2005-01-01'),
("Nguyen Van B", "b@gmail.com", '2005-02-02'),
("Nguyen Van C", "c@gmail.com", '2005-03-03');

create table subject (
	subject_id int auto_increment primary key,
    subject_name varchar(255) not null,
    credit int not null check (credit > 0)
);

insert into subject (subject_name, credit) values
("Database Systems", 3),
("Data Structures", 4),
("Operating Systems", 3);

update subject set credit = 5 where subject_id = 2;
update subject set subject_name = "Advanced Database Systems" where subject_id = 1;

create table enrollment (
	student_id int not null,
    subject_id int not null,
    enroll_date date not null,
    unique (student_id, subject_id),
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into enrollment (student_id, subject_id, enroll_date) values
(1, 1, '2025-09-01'),
(1, 2, '2025-09-01'),
(2, 1, '2025-09-02'),
(2, 3, '2025-09-02');

select * from student;
select * from subject;
select * from enrollment;

select * from enrollment where student_id = 1;
