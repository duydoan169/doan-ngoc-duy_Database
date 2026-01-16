/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File

-- Câu 1 (TrTrigger - 2đ): 
-- Nhà trường yêu cầu điểm số (Score) nhập vào hệ thống phải luôn hợplệ (từ 0 đến 10). 
-- Hãy viết một TrTrigger có tên tg_CheckScore chạy trước khi thêm(BEFORE INSERTRT) dữ liệu vào bảng Grades.
-- ● Nếu người dùng nhập Score < 0 thì tự động gán về 0.
-- ● Nếu người dùng nhập Score > 10 thì tự động gán về 10.

delimiter $$

create trigger tg_CheckScore
before insert on Grades
for each row
begin
	if new.Score < 0 then
    set new.Score = 0;
    elseif new.Score > 10 then
    set new.Score = 10;
    end if;
end $$

delimiter ;

-- Câu 2 (TrTransaction - 2đ): ViViết một đoạn script sử dụng TrTransaction để thêm một sinh viênmới. 
-- Yêu cầu đảm bảo tính trọn vẹn or Nothing" của dữ liệu:
-- 1. Bắt đầu TrTransaction.
-- 2. Thêm sinh viên mới vào bảng Students: StudentID = FullName = BichNgoc'.
-- 3. Cập nhật nợ học phí (ToTotalDebt) cho sinh viên này là 5,000,000.
-- 4. Xác nhận (COMMIT) TrTransaction.

delimiter $$

create procedure create_student(
	in p_student_id CHAR(5),
    in p_fullname VARCHAR(50)
)
begin
	declare exit handler for sqlexception
    begin
		signal sqlstate '45000' set message_text = 'them sinh vien that bai';
		rollback;
	end;
    
    start transaction;
	insert into Students (StudentID, FullName) values
	("SV02", "Ha Bich Ngoc");
	update Students set TotalDebt = 5000000 where StudentID = "SV02";
	commit;
end $$
delimiter ;

call create_student("SV02", "Ha Bich Ngoc");

-- Câu 3 (TrTrigger - 1.5đ): Để chống tiêu cực trong thi cử, mọi hành động sửa đổi điểm số cầnđược ghi lại. 
-- Hãy viết TrTrigger tên tg_LogGradeUpdate chạy sau khi cập nhật (AFTERUPDATATE) trên bảng Grades.
-- ● Yêu cầu: Khi điểm số thay đổi, hãy tự động chèn một dòng vào bảng GradeLog vớicác thông tin: 
-- StudentID, OldScore (lấy từ OLD), NewScore (lấy từ NEW), vàChangeDate là thời gian hiện tại (NOW()).

delimiter $$

create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
	insert into GradeLog (StudentID, OldScore, NewScore, ChangeDate) values
    (old.StudentID, old.Score, new.Score, now());
end $$

delimiter ;

-- Câu 4 (TrTransaction & Procedure cơ bản - 1.5đ): ViViết một Stored Procedure đơngiản tên sp_PayTuTuition thực hiện việc đóng học phí cho sinh viên với số tiền2,000,000.
-- Bắt đầu TrTransaction.
-- TrTrừ 2,000,000 trong cột ToTotalDebt của bảng Students (StudentID = 
-- ● Kiểm tra logic: Nếu sau khi trừ, ToTotalDebt < 0, hãy ROLLBACK để hủy bỏ.Ngược lại, hãy COMMIT.

delimiter $$

create procedure sp_PayTuTuition(
	in p_student_id CHAR(5),
    in p_pay_amount DECIMAL(10,2)
)
begin
	start transaction;
    update Students set TotalDebt = TotalDebt - p_pay_amount where StudentID = p_student_id;
    
    if (select TotalDebt from Students where StudentID = p_student_id) < 0 then
		rollback;
	else
		commit;
	end if;
end $$

delimiter ;

call sp_PayTuTuition("SV01", 2000000);

-- Câu 5 (TrTrigger nâng cao - 1.5đ): ViViết TrTrigger tên tg_PreventPassUpdate.
-- ● Quy tắc nghiệp vụ: Sinh viên đã qua môn (Điểm cũ >= 4.0) thì không được phép sửađiểm nữa để đảm bảo tính minh bạch.
-- ● Yêu cầu: ViViết trigger BEFORE UPDATATE trên bảng Grades. 
-- Nếu OldScore(OLD.Score) >= 4.0, hãy hủy thao tác cập nhật bằng cách phát sinh lỗi (Sử dụngSIGNAL SQLSTATATATE với thông báo lỗi tùy ý).

delimiter $$

create trigger tg_PreventPassUpdate
before update on Grades
for each row
begin
	if old.Score >= 4.0 then
		signal sqlstate '45000' set message_text = "Sua diem that bai";
	end if;
end $$

delimiter ;

-- Câu 6 (Stored Procedure & TrTransaction - 1.5đ): ViViết một Stored Procedure tênsp_DeleteStudentGrade nhận vào p_StudentID và p_SubjectID. 
-- Thủ tục này thực hiện việcsinh viên xin hủy môn học nhưng phải đảm bảo an toàn dữ liệu:
-- 1. Bắt đầu TrTransaction.
-- 2. Lưu điểm hiện tại của sinh viên vào bảng GradeLog (Ghi chú: coi như điểm mớiNewScore là NULL) để lưu vết trước khi xóa.
-- 3. Thực hiện lệnh xóa (DELETE) dòng dữ liệu tương ứng trong bảng Grades.
-- 4. Kiểm tra: Nếu không tìm thấy dòng dữ liệu nào được xóa (dùng hàmROW_COUNT() trả về 0), hãy ROLLBACK.
-- 5. Nếu xóa thành công, hãy COMMIT.

delimiter $$

create procedure sp_DeleteStudentGrade(
	in p_student_id CHAR(5),
    in p_subject_id CHAR(5)
)
begin
	start transaction;
    insert into GradeLog 
end $$
delimiter ;