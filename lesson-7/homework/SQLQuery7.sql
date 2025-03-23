--Homework for Lesson 7: Aggregate Functions, Pivoting
--1. Create Sales Table
--sql
create database Hw7;
Drop table Sales;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    SaleDate DATE,
    SaleAmount DECIMAL(10, 2)
);
--2. Insert 40 Rows into Sales Table
--sql

INSERT INTO Sales (SaleID, ProductID, CustomerID, SaleDate, SaleAmount) VALUES
(1, 1, 1, '2023-01-01', 150.00),
(2, 2, 2, '2023-01-02', 200.00),
(3, 3, 3, '2023-01-03', 250.00),
(4, 4, 4, '2023-01-04', 300.00),
(5, 5, 5, '2023-01-05', 350.00),
(6, 6, 6, '2023-01-06', 400.00),
(7, 7, 7, '2023-01-07', 450.00),
(8, 8, 8, '2023-01-08', 500.00),
(9, 9, 9, '2023-01-09', 550.00),
(10, 10, 10, '2023-01-10', 600.00),
(11, 1, 1, '2023-01-11', 150.00),
(12, 2, 2, '2023-01-12', 200.00),
(13, 3, 3, '2023-01-13', 250.00),
(14, 4, 4, '2023-01-14', 300.00),
(15, 5, 5, '2023-01-15', 350.00),
(16, 6, 6, '2023-01-16', 400.00),
(17, 7, 7, '2023-01-17', 450.00),
(18, 8, 8, '2023-01-18', 500.00),
(19, 9, 9, '2023-01-19', 550.00),
(20, 10, 10, '2023-01-20', 600.00),
(21, 1, 2, '2023-01-21', 150.00),
(22, 2, 3, '2023-01-22', 200.00),
(23, 3, 4, '2023-01-23', 250.00),
(24, 4, 5, '2023-01-24', 300.00),
(25, 5, 6, '2023-01-25', 350.00),
(26, 6, 7, '2023-01-26', 400.00),
(27, 7, 8, '2023-01-27', 450.00),
(28, 8, 9, '2023-01-28', 500.00),
(29, 9, 10, '2023-01-29', 550.00),
(30, 10, 1, '2023-01-30', 600.00),
(31, 1, 2, '2023-02-01', 150.00),
(32, 2, 3, '2023-02-02', 200.00),
(33, 3, 4, '2023-02-03', 250.00),
(34, 4, 5, '2023-02-04', 300.00),
(35, 5, 6, '2023-02-05', 350.00),
(36, 6, 7, '2023-02-06', 400.00),
(37, 7, 8, '2023-02-07', 450.00),
(38, 8, 9, '2023-02-08', 500.00),
(39, 9, 10, '2023-02-09', 550.00),
(40, 10, 1, '2023-02-10', 600.00);

--3. Create EmployeePerformance Table
--sql

CREATE TABLE EmployeePerformance (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    Year INT,
    Quarter INT,
    PerformanceScore DECIMAL(5, 2)
);
--4. Insert 40 Rows into EmployeePerformance Table
--sql

INSERT INTO EmployeePerformance (EmployeeID, EmployeeName, [Year], [Quarter], PerformanceScore) VALUES
(1, 'John Doe', 2023, 1, 85.00),
(2, 'Jane Smith', 2023, 1, 90.00),
(3, 'Samuel Brown', 2023, 1, 80.00),
(4, 'Emily White', 2023, 1, 95.00),
(5, 'Michael Green', 2023, 1, 88.00),
(6, 'Sarah Black', 2023, 1, 92.00),
(7, 'David Blue', 2023, 1, 87.00),
(8, 'Linda Purple', 2023, 1, 89.00),
(9, 'Peter Orange', 2023, 1, 91.00),
(10, 'Maria Pink', 2023, 1, 84.00),
(11, 'John Doe', 2023, 2, 88.00),
(12, 'Jane Smith', 2023, 2, 92.00),
(13, 'Samuel Brown', 2023, 2, 81.00),
(14, 'Emily White', 2023, 2, 94.00),
(15, 'Michael Green', 2023, 2, 89.00),
(16, 'Sarah Black', 2023, 2, 93.00),
(17, 'David Blue', 2023, 2, 86.00),
(18, 'Linda Purple', 2023, 2, 90.00),
(19, 'Peter Orange', 2023, 2, 92.00),
(20, 'Maria Pink', 2023, 2, 85.00),
(21, 'John Doe', 2023, 3, 90.00),
(22, 'Jane Smith', 2023, 3, 95.00),
(23, 'Samuel Brown', 2023, 3, 82.00),
(24, 'Emily White', 2023, 3, 96.00),
(25, 'Michael Green', 2023, 3, 90.00),
(26, 'Sarah Black', 2023, 3, 94.00),
(27, 'David Blue', 2023, 3, 88.00),
(28, 'Linda Purple', 2023, 3, 92.00),
(29, 'Peter Orange', 2023, 3, 93.00),
(30, 'Maria Pink', 2023, 3, 86.00),
(31, 'John Doe', 2023, 4, 92.00),
(32, 'Jane Smith', 2023, 4, 96.00),
(33, 'Samuel Brown', 2023, 4, 84.00),
(34, 'Emily White', 2023, 4, 97.00),
(35, 'Michael Green', 2023, 4, 91.00),
(36, 'Sarah Black', 2023, 4, 95.00),
(37, 'David Blue', 2023, 4, 89.00),
(38, 'Linda Purple', 2023, 4, 93.00),
(39, 'Peter Orange', 2023, 4, 94.00),
(40, 'Maria Pink', 2023, 4, 87.00);


SELECT MIN(Price) as MinPrice --1 Question
FROM Products;

SELECT MAX(Price) as MaxPrice--2 Question
FROM Products;

SELECT COUNT(*) FROM Customers ;--3 Question

SELECT COUNT(DISTINCT [ProductID]) FROM Products;--4 Question

SELECT SUM(ProductID) --5 Question
FROM Sales;

SELECT AVG( PerformanceScore) AS AveragePerformance --6 Question
FROM  EmployeePerformance;

SELECT EmployeeID, COUNT(*) AS employees_count--7 Question
FROM EmployeePerformance
GROUP BY EmployeeID;

SELECT SUM([SaleAmount]) as  --9 Question
TotalSum FROM Sales;
 
 --SELECT * FROM Sales--10 Question
 --COUNT(*) AS MaxSales,
 --GROUP BY [SaleAmount],
 --HAVING ([SaleDate] >5);

SELECT SaleAmount--10 Question
FROM Sales
WHERE SaleAmount>=150.00 
GROUP BY [SaleAmount]
HAVING COUNT(*) >150.00
ORDER BY SaleAmount;

SELECT Category, 
       SUM(SalesAmount) AS TotalSales, --11 Question
       AVG(SalesAmount) AS AverageSales
FROM Sales
GROUP BY Category;

SELECT JobTitle, COUNT(JobTitle) AS EmployeeCount--12 Question
FROM Employees
GROUP BY JobTitle;

SELECT Department, --13 Question
       MAX(Salary) AS MaxSalary, 
       MIN(Salary) AS MinSalary
FROM Employees
GROUP BY Department;

SELECT Department, AVG(Salary) AS AverageSalary--14 Question
FROM Employees
GROUP BY Department;

SELECT Department, --15 Question
       AVG(Salary) AS AverageSalary, 
       COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;

SELECT ProductName, AVG(Price) AS AveragePrice--16 Question
FROM Products
GROUP BY ProductName
HAVING AVG(Price) > 100;

SELECT COUNT(DISTINCT ProductID) AS ProductCount--17 Question
FROM Sales
WHERE QuantitySold > 100;

SELECT YEAR(SaleDate) AS SaleYear, --18 Question
       SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

SELECT Region, COUNT(DISTINCT CustomerID) AS CustomerCount--19 Question
FROM Orders
GROUP BY Region;

SELECT Department, SUM(Salary) AS TotalSalary--20 Question
FROM Employees
GROUP BY Department
HAVING SUM(Salary) > 100000;

--Hard Level Tasks

SELECT Category, AVG(SalesAmount) AS AvgSales--21 Question
FROM Sales
GROUP BY Category
HAVING AVG(SalesAmount) > 200;

SELECT EmployeeID, SUM(SalesAmount) AS TotalSales--22 Question
FROM Sales
GROUP BY EmployeeID
HAVING SUM(SalesAmount) > 5000;

SELECT Department, 
       SUM(Salary) AS TotalSalary, --23 Question
       AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 6000;

SELECT CustomerID, --24 Question
       MAX(OrderValue) AS MaxOrder, 
       MIN(OrderValue) AS MinOrder
FROM Orders
GROUP BY CustomerID
HAVING MIN(OrderValue) >= 50;

SELECT Region, --25 Question
       SUM(SalesAmount) AS TotalSales, 
       COUNT(DISTINCT ProductID) AS ProductCount
FROM Sales
GROUP BY Region
HAVING COUNT(DISTINCT ProductID) > 10;

SELECT ProductCategory, --26 Question
       MIN(OrderQuantity) AS MinOrderQty, 
       MAX(OrderQuantity) AS MaxOrderQty
FROM Orders
GROUP BY ProductCategory;

SELECT Region, --27 Question
       SUM(CASE WHEN YEAR(SaleDate) = 2021 THEN SalesAmount ELSE 0 END) AS Sales_2021,
       SUM(CASE WHEN YEAR(SaleDate) = 2022 THEN SalesAmount ELSE 0 END) AS Sales_2022,
       SUM(CASE WHEN YEAR(SaleDate) = 2023 THEN SalesAmount ELSE 0 END) AS Sales_2023
FROM Sales
GROUP BY Region;

SELECT Region, Quarter, SalesAmount--28 Question
FROM Sales
UNPIVOT (
    SalesAmount FOR Quarter IN (Q1, Q2, Q3, Q4)
) AS UnpivotedSales;

SELECT ProductCategory, ProductID, COUNT(OrderID) AS OrderCount--29 Question
FROM Orders
GROUP BY ProductCategory, ProductID
HAVING COUNT(OrderID) > 50;

SELECT EmployeeID, --30 Question
       SUM(CASE WHEN Quarter = 'Q1' THEN SalesAmount ELSE 0 END) AS Q1_Sales,
       SUM(CASE WHEN Quarter = 'Q2' THEN SalesAmount ELSE 0 END) AS Q2_Sales,
       SUM(CASE WHEN Quarter = 'Q3' THEN SalesAmount ELSE 0 END) AS Q3_Sales,
       SUM(CASE WHEN Quarter = 'Q4' THEN SalesAmount ELSE 0 END) AS Q4_Sales
FROM EmployeeSales
GROUP BY EmployeeID;