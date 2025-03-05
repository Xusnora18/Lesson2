# Lesson2 Homework
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Employees';
DROP TABLE IF EXISTS Employees;
-----
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary DECIMAL(10,2)
);
USE [master]; 

INSERT INTO Employees (EmpID, EmpName, Salary) VALUES (1, 'Alice Johnson', 50000.00);
INSERT INTO Employees (EmpID, EmpName, Salary) VALUES (2, 'Bob Smith', 60000.00);
INSERT INTO Employees (EmpID, EmpName, Salary) VALUES (3, 'Charlie Brown', 55000.00);
SELECT * FROM Employees;
