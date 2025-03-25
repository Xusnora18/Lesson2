DROP TABLE Products;
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50),
    ProductPrice INT,
	Category VARCHAR (50));

INSERT INTO Products(ProductName,ProductPrice)
VALUES 
     ('Laptop','5200'),
	 ('Phone','6000'),
	 ('tv','4500'),
	 ('Fridge','7000');


SELECT ProductID, ProductName, ProductPrice  
FROM Products  
ORDER BY ProductPrice DESC;

DROP TABLE Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
	Age INT 
);
DROP TABLE Departments;
CREATE TABLE Departments (
     DepartmentName INT);

INSERT INTO Departments (DepartmentName)
VALUES 
     ('Finance'),
	 ('Marketing'),
	 ('Seller'),
	 ('IT');

----------
INSERT INTO Employees (EmployeeID, FirstName, LastName) VALUES
(1, 'John', 'Doe'),
(2, NULL, 'Smith'),
(3, 'Alice', NULL),
(4, NULL, NULL);

-- CAOLESCE
SELECT COALESCE(FirstName, LastName, 'Unknown') AS EmployeeName  
FROM Employees;

SELECT DISTINCT Category, ProductPrice  
FROM Products;
SELECT *  
FROM Employees  
WHERE (Age BETWEEN 30 AND 40) OR (Department = 'Marketing');
SELECT *  
FROM Employees  
ORDER BY Salary DESC  
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
SELECT TOP 10 
FROM Employees  
ORDER BY Salary DESC; 
SELECT *  
FROM Products  
WHERE ProductPrice <= 1000 AND Stock > 50  
ORDER BY Stock ASC;
SELECT *  
FROM Products  
WHERE ProductName LIKE '%e%';
SELECT *  
FROM Employees  
WHERE Department IN ('HR', 'IT', 'Finance');
SELECT *  
FROM Employees  
WHERE Salary > ANY (SELECT AVG(Salary) FROM Employees);
SELECT *  
FROM Customers  
ORDER BY City ASC, PostalCode DESC;