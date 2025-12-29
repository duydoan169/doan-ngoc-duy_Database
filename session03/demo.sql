create database school;
use school;

create table student (
	student_id int auto_increment primary key,
    student_name varchar(255) not null,
    dob date not null,
    academic_year char(9) not null
);

create table subject (
	subject_id int auto_increment primary key,
    subject_name varchar(255) not null,
    credit int not null check (credit > 0)
);

create table enrollment (
	enrollment_id int auto_increment primary key,
    student_id int not null,
    subject_id int not null,
	foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id),
	unique(student_id, subject_id)
);

create table score (
	score_id int auto_increment primary key, 
	student_id int not null,
    subject_id int not null,
	foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id),
	score decimal not null check (score >= 0)
);

insert into student (student_name, dob, academic_year) values ("Doan Ngoc Duy", '2025-12-27', "2025-2030");
insert into subject (subject_name, credit) values ("Lap trinh C", 3);
insert into enrollment (student_id, subject_id) values (1, 1);
insert into score (student_id, subject_id, score) values (1, 1, 8);
update score set score = 9 where score_id = 1;

-- xoa student co id = 1
delete from score where student_id = 1;
delete from enrollment where student_id = 1;
delete from student where student_id = 1;

select * from student;
select * from subject;
select * from enrollment;
select * from score;