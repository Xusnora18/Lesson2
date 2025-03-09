drop table employee;
CREATE TABLE Employee (
EmployeeID INT IDENTITY (1,1) PRIMARY KEY,
Email VARCHAR (50));

DROP TABLE Salary;
CREATE TABLE Salary (
Salary INT,
Department VARCHAR (50));
INSERT INTO Salary (Salary)
VALUES 
     ('5000'),
	 ('5500'),
	 ('6000'),
	 ('5000');
	 INSERT INTO Salary(Department) 
VALUES 
    ('HR'),
    ('Seller'),
	('HR'),
	('Seller');

	 drop table Customers;
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(50)
);
INSERT INTO Customers (CustomerName) 
VALUES 
    ('Alice'),
    ('Andrew'),
    ('Bob'),
    ('Amanda');

drop table Products;
 
 CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(50),
    ProductPrice INT,
	Category VARCHAR (50)
);
INSERT INTO Products (ProductName, ProductPrice)
VALUES 
    ('Laptop', 500),
    ('Phone', 100),
    ('TV', 950);
	
SELECT TOP 5 * 
FROM Employee 
ORDER BY [EmployeeID] ASC;
SELECT * FROM Products
WHERE ProductPrice > 100;
SELECT * FROM Products
WHERE ProductPrice > 100;
SELECT DISTINCT ProductName 
FROM Products;
SELECT * FROM Customers 
WHERE CustomerName LIKE 'A%';
SELECT * FROM Products 
ORDER BY ProductPrice ASC;
SELECT * FROM Salary 
WHERE Salary >= 5000 AND Department = 'HR';
SELECT EmployeeID, ISNULL(Email, 'noemail@example.com') AS Email 
FROM Employee;
SELECT * FROM Products 
WHERE ProductPrice BETWEEN 50 AND 100;
SELECT DISTINCT Category, ProductName 
FROM Products 
ORDER BY ProductName DESC;



