create database hw11;
drop table Employees;
CREATE TABLE Employees ( 
EmployeeID INT PRIMARY KEY,
[Name] VARCHAR(50), 
DepartmentID INT );

DROP TABLE Departments;
CREATE TABLE Departments (
DepartmentID INT PRIMARY KEY, 
DepartmentName VARCHAR(50) );

INSERT INTO Employees VALUES (1, 'Alice', 101), (2, 'Bob', 102), (3, 'Charlie', NULL);
INSERT INTO Departments VALUES (101, 'HR'), (102, 'IT'), (103, 'Finance');

SELECT e.[Name], d.DepartmentName
FROM Employees e
INNER JOIN Departments d on
e.DepartmentID = d.DepartmentID;

-------------

--Table Schema:
DROP TABLE Students;
CREATE TABLE Students ( StudentID INT PRIMARY KEY, StudentName VARCHAR(50), ClassID INT );

CREATE TABLE Classes ( ClassID INT PRIMARY KEY, ClassName VARCHAR(50) );

--Sample Data:
INSERT INTO Students VALUES (1, 'John', 201), (2, 'Emma', NULL), (3, 'Liam', 202);

INSERT INTO Classes VALUES (201, 'Math'), (202, 'Science');

SELECT s.StudentName, c.ClassName
FROM Students s
LEFT JOIN Classes c on
s.ClassID=c.ClassID;

--RIGHT JOIN

--Table Schema:
DROP TABLE Orders;
CREATE TABLE Orders ( 
OrderID INT PRIMARY KEY,
CustomerID INT, 
OrderDate DATE );

DROP TABLE Customers;
CREATE TABLE Customers ( 
CustomerID INT PRIMARY KEY, 
CustomerName VARCHAR(50) );

--Sample Data:
INSERT INTO Orders VALUES (1, 301, '2024-11-01'), (2, 302, '2024-11-05');

INSERT INTO Customers VALUES (301, 'Alice'), (302, 'Bob'), (303, 'Charlie');

SELECT c.CustomerName, o.OrderDate,c.CustomerID
FROM Customers c
RIGHT JOIN Orders o on
c.CustomerID=o.CustomerID;
--------
--Task 4: FULL OUTER JOIN
--Question: Retrieve a list of all products and their sales, including products with no sales and sales with invalid product references.

--Table Schema:
DROP TABLE Products;
CREATE TABLE Products ( ProductID INT PRIMARY KEY, ProductName VARCHAR(50) );
DROP TABLE Sales;
CREATE TABLE Sales ( SaleID INT PRIMARY KEY, ProductID INT, Quantity INT );

--Sample Data:
INSERT INTO Products VALUES (1, 'Laptop'), (2, 'Tablet'), (3, 'Phone');

INSERT INTO Sales VALUES (100, 1, 10), (101, 2, 5), (102, NULL, 8);

SELECT p.ProductName, s.SaleID, s.Quantity 
FROM Products p
FULL OUTER JOIN Sales s on
s.ProductID=p.ProductID;

--Task 5: SELF JOIN
--Question: Find the names of employees along with the names of their managers.

--Table Schema:
DROP TABLE Employees;
CREATE TABLE Employees ( EmployeeID INT PRIMARY KEY, [Name] VARCHAR(50), ManagerID INT );

--Sample Data:
INSERT INTO Employees VALUES (1, 'Alice', NULL), (2, 'Bob', 1), (3, 'Charlie', 1), (4, 'Diana', 2);

SELECT e.EmployeeID, e.[Name] AS 
EmployeeName, m.[Name] as ManagerName
FROM Employees e
INNER JOIN Employees m on
e.ManagerID = m.employeeID; 

--Task 6: CROSS JOIN
--Question: Generate all possible combinations of colors and sizes.

--Table Schema:
CREATE TABLE Colors ( ColorID INT PRIMARY KEY, ColorName VARCHAR(50) );

CREATE TABLE Sizes ( SizeID INT PRIMARY KEY, SizeName VARCHAR(50) );

--Sample Data:
INSERT INTO Colors VALUES (1, 'Red'), (2, 'Blue');

INSERT INTO Sizes VALUES (1, 'Small'), (2, 'Medium');

SELECT c.ColorID,c.ColorName ,s.SizeName
FROM Colors c
CROSS JOIN Sizes s ;

--Task 7: Join with WHERE Clause
--Question: Find all movies released after 2015 and their associated actors.

--Table Schema:
CREATE TABLE Movies ( MovieID INT PRIMARY KEY, Title VARCHAR(50), ReleaseYear INT );

CREATE TABLE Actors ( ActorID INT PRIMARY KEY, [Name] VARCHAR(50), MovieID INT );

--Sample Data:
INSERT INTO Movies VALUES (1, 'Inception', 2010), (2, 'Interstellar', 2014), (3, 'Dune', 2021);

INSERT INTO Actors VALUES (101, 'Leonardo DiCaprio', 1), (102, 'Matthew McConaughey', 2), (103, 'Timothée Chalamet', 3);

SELECT m.MovieID, m.Title, m.ReleaseYear , a.[Name]
FROM Movies m
Inner Join Actors a on m.MovieID=a.MovieID
WHERE(m.ReleaseYear) >2015 ;

--Task 8: MULTIPLE JOINS
--Question: Retrieve the order date, customer name, and the product ID for all orders.

--Table Schema:
DROP TABLE Orders;
CREATE TABLE Orders ( OrderID INT PRIMARY KEY, CustomerID INT, OrderDate DATE );
DROP TABLE Customers;
CREATE TABLE Customers ( CustomerID INT PRIMARY KEY, CustomerName VARCHAR(50) );

CREATE TABLE OrderDetails ( OrderDetailID INT PRIMARY KEY, OrderID INT, ProductID INT );

--Sample Data:
INSERT INTO Orders VALUES (1, 401, '2024-11-01'), (2, 402, '2024-11-05');

INSERT INTO Customers VALUES (401, 'Alice'), (402, 'Bob');

INSERT INTO OrderDetails VALUES (1001, 1, 501), (1002, 2, 502);
SELECT o.OrderDate, c.CustomerID, c.CustomerName, od.ProductID, od.OrderDetailID
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID;

--Task 9: JOIN with Aggregation
--Question: Calculate the total revenue generated for each product.

--Table Schema:
DROP TABLE Sales;
CREATE TABLE Sales ( SaleID INT PRIMARY KEY, ProductID INT, Quantity INT );
DROP TABLE Products;
CREATE TABLE Products ( ProductID INT PRIMARY KEY, ProductName VARCHAR(50), Price DECIMAL(10, 2) );

--Sample Data:
INSERT INTO Sales VALUES (1, 601, 3), (2, 602, 5), (3, 601, 2);

INSERT INTO Products VALUES (601, 'TV', 500.00), (602, 'Speaker', 150.00);
SELECT 
    p.ProductID, 
    p.ProductName, 
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
INNER JOIN Products p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;