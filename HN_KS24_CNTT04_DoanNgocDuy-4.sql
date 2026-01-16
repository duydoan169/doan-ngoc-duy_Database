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
    insert into GradeLog (StudentID, OldScore, NewScore) values
    (p_student_id, (select Score from Grades where StudentID = p_student_id and SubjectID = p_subject_id), null);
end $$
delimiter ;