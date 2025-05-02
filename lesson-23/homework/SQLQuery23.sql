CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');

SELECT
    Id,
    Dt,
    CASE
        WHEN MONTH(Dt) < 10 THEN '0' + CAST(MONTH(Dt) AS VARCHAR(2))
        ELSE CAST(MONTH(Dt) AS VARCHAR(2))
    END AS MonthPrefixedWithZero
FROM
    Dates;
-----------------------------------------------------------------
CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

SELECT
    COUNT(DISTINCT Id) AS Distinct_Ids,
    9 AS rID,
    SUM(max_val) AS TotalOfMaxVals
FROM (
    SELECT
        Id,
        MAX(Vals) AS max_val
    FROM
        MyTabel
    WHERE
        rID = 9
    GROUP BY
        Id
) AS subquery;

--------------------------------------------------
CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');

SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) >= 6 AND LEN(Vals) <= 10;
------------------------------------------------------------
CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);

WITH RankedData AS (
    SELECT
        ID,
        Item,
        Vals,
        ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Vals DESC) as rn
    FROM
        TestMaximum
)
SELECT
    ID,
    Item,
    Vals
FROM
    RankedData
WHERE
    rn = 1
ORDER BY
    ID;

------------------------------------------------------------------------
CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);

SELECT
    Id,
    SUM(max_DetailedNumber) AS SumofMax
FROM (
    SELECT DISTINCT
        Id,
        MAX(DetailedNumber) AS max_DetailedNumber
    FROM
        SumOfMax
    GROUP BY
        Id
) AS subquery
GROUP BY
    Id;
---------------------------------------------------------
CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1, 10000000), (4,15,15);

SELECT
    Id,
    a,
    b,
    CASE
        WHEN a - b = 0 THEN NULL  
        ELSE CAST(a - b AS VARCHAR(50)) 
    END AS OUTPUT
FROM
    TheZeroPuzzle;


------------------------------------------------------
DROP TABLE Sales;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    Product VARCHAR(50),
    Category VARCHAR(50),
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    Region VARCHAR(50)
);
INSERT INTO Sales (Product, Category, QuantitySold, UnitPrice, SaleDate, Region)
VALUES
('Laptop', 'Electronics', 10, 800.00, '2024-01-01', 'North'),
('Smartphone', 'Electronics', 15, 500.00, '2024-01-02', 'North'),
('Tablet', 'Electronics', 8, 300.00, '2024-01-03', 'East'),
('Headphones', 'Electronics', 25, 100.00, '2024-01-04', 'West'),
('TV', 'Electronics', 5, 1200.00, '2024-01-05', 'South'),
('Refrigerator', 'Appliances', 3, 1500.00, '2024-01-06', 'South'),
('Microwave', 'Appliances', 7, 200.00, '2024-01-07', 'East'),
('Washing Machine', 'Appliances', 4, 1000.00, '2024-01-08', 'North'),
('Oven', 'Appliances', 6, 700.00, '2024-01-09', 'West'),
('Smartwatch', 'Electronics', 12, 250.00, '2024-01-10', 'East'),
('Vacuum Cleaner', 'Appliances', 5, 400.00, '2024-01-11', 'South'),
('Gaming Console', 'Electronics', 9, 450.00, '2024-01-12', 'North'),
('Monitor', 'Electronics', 14, 300.00, '2024-01-13', 'West'),
('Keyboard', 'Electronics', 20, 50.00, '2024-01-14', 'South'),
('Mouse', 'Electronics', 30, 25.00, '2024-01-15', 'East'),
('Blender', 'Appliances', 10, 150.00, '2024-01-16', 'North'),
('Fan', 'Appliances', 12, 75.00, '2024-01-17', 'South'),
('Heater', 'Appliances', 8, 120.00, '2024-01-18', 'East'),
('Air Conditioner', 'Appliances', 2, 2000.00, '2024-01-19', 'West'),
('Camera', 'Electronics', 7, 900.00, '2024-01-20', 'North');

SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

---------------------------------------------
SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

---------------------------------------
SELECT COUNT(*) AS TotalTransactions
FROM Sales;
--------------------------------------------------
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

--------------------------------------------
SELECT Category, SUM(QuantitySold) AS TotalProductsSold
FROM Sales
GROUP BY Category;

---------------------------------------------------
SELECT Region, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

------------------------------------------------------

SELECT
    FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
    SUM(QuantitySold) AS TotalQuantitySold
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM');





---------------------------------------------------
SELECT TOP 1 Product, SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC; 

--------------------------------------------------------

SELECT
    SaleDate,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales;

SELECT
    s1.SaleDate,
    (SELECT SUM(QuantitySold * UnitPrice) FROM Sales s2 WHERE s2.SaleDate <= s1.SaleDate) AS RunningTotalRevenue
FROM Sales s1
ORDER BY s1.SaleDate;

----------------------------------------------------------------
SELECT
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    (SUM(QuantitySold * UnitPrice) * 100.0 / (SELECT SUM(QuantitySold * UnitPrice) FROM Sales)) AS PercentageOfTotalRevenue
FROM Sales
GROUP BY Category;
----------------------------------------------------------------
use practice2
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    JoinDate DATE
);
INSERT INTO Customers (CustomerName, Region, JoinDate)
VALUES
('John Doe', 'North', '2022-03-01'),
('Jane Smith', 'West', '2023-06-15'),
('Emily Davis', 'East', '2021-11-20'),
('Michael Brown', 'South', '2023-01-10'),
('Sarah Wilson', 'North', '2022-07-25'),
('David Martinez', 'East', '2023-04-30'),
('Laura Johnson', 'West', '2022-09-14'),
('Kevin Anderson', 'South', '2021-12-05'),
('Sophia Moore', 'North', '2023-02-17'),
('Daniel Garcia', 'East', '2022-08-22');


SELECT
    s.SaleID,
    s.Product,
    s.Category,
    s.QuantitySold,
    s.UnitPrice,
    s.SaleDate,
    s.Region,
    c.CustomerName
FROM
    Sales s
JOIN
    Customers c ON s.CustomerID = c.CustomerID;
------------------------------------------------------------------
SELECT
    c.CustomerName
FROM
    Customers c
LEFT JOIN
    Sales s ON c.CustomerID = s.CustomerID
WHERE
    s.CustomerID IS NULL;
------------------------------------------------------------

SELECT
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM
    Customers c
JOIN
    Sales s ON c.CustomerID = s.CustomerID
GROUP BY
    c.CustomerName;
--------------------------------------------------------------

SELECT top 1
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM
    Customers c
JOIN
    Sales s ON c.CustomerID = s.CustomerID
GROUP BY
    c.CustomerName
ORDER BY
    TotalRevenue DESC;
--------------
SELECT
    c.CustomerName,
    STRFTIME('%Y-%m', s.SaleDate) AS SaleMonth,  -- For SQLite
    SUM(s.QuantitySold * s.UnitPrice) AS MonthlyRevenue
FROM
    Customers c
JOIN
    Sales s ON c.CustomerID = s.CustomerID
GROUP BY
    c.CustomerName,
    SaleMonth
ORDER BY
    c.CustomerName,
    SaleMonth;

------------------------------------------------------------------
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2)
);
INSERT INTO Products (ProductName, Category, CostPrice, SellingPrice)
VALUES
('Laptop', 'Electronics', 600.00, 800.00),
('Smartphone', 'Electronics', 350.00, 500.00),
('Tablet', 'Electronics', 200.00, 300.00),
('Headphones', 'Electronics', 50.00, 100.00),
('TV', 'Electronics', 900.00, 1200.00),
('Refrigerator', 'Appliances', 1100.00, 1500.00),
('Microwave', 'Appliances', 120.00, 200.00),
('Washing Machine', 'Appliances', 700.00, 1000.00),
('Oven', 'Appliances', 500.00, 700.00),
('Gaming Console', 'Electronics', 320.00, 450.00);

SELECT DISTINCT p.ProductName
FROM Products p
INNER JOIN Sales s ON p.ProductID = s.ProductID;
---------------------------------------------------------
SELECT TOP 1 ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;
-----------------------------------------------
SELECT
    s.*,
    p.CostPrice
FROM
    Sales s
JOIN
    Products p ON s.SaleID = p.ProductID;

--------------------------------------------
SELECT p.ProductName, p.SellingPrice, p.Category
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = p.Category
);
