--Easy Tasks

--1.Create a numbers table using a recursive query.
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 100 -- Or whatever your desired upper limit is
)
SELECT n FROM Numbers;
--2.Beginning at 1, this script uses a recursive statement to double the number for each record
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2
    FROM Numbers
    WHERE n * 2 < 100 -- Or whatever upper limit you set
)
SELECT n FROM Numbers;
--3.Write a query to find the total sales per employee using a derived table.(Sales, Employees)
SELECT
    e.EmployeeID,
    SUM(s.SalesAmount) AS TotalSales
FROM
    Employees e
JOIN
    Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY
    e.EmployeeID;
--4.Create a CTE to find the average salary of employees.(Employees)
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary FROM Employees
)
SELECT * FROM AvgSalary;
--5.Write a query using a derived table to find the highest sales for each product.(Sales, Products)
SELECT
    p.ProductID,
    MAX(s.SalesAmount) AS HighestSales
FROM
    Products p
JOIN
    Sales s ON p.ProductID = s.ProductID
GROUP BY
    p.ProductID;
--6.Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
WITH SalesCounts AS (
    SELECT
        EmployeeID,
        COUNT(*) AS SaleCount
    FROM
        Sales
    GROUP BY
        EmployeeID
    HAVING
        COUNT(*) > 5
)
SELECT e.EmployeeID, e.EmployeeName -- Assuming EmployeeName column
FROM Employees e
JOIN SalesCounts sc ON e.EmployeeID = sc.EmployeeID;
--7.Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
WITH HighSalesProducts AS (
    SELECT ProductID
    FROM Sales
    WHERE SalesAmount > 500
)
SELECT p.* -- Assuming you want all product details
FROM Products p
JOIN HighSalesProducts hsp ON p.ProductID = hsp.ProductID;
--8.Create a CTE to find employees with salaries above the average salary.(Employees)
WITH AboveAvgSalary AS (
    SELECT EmployeeID
    FROM Employees
    WHERE Salary > (SELECT AVG(Salary) FROM Employees)
)
SELECT e.* -- Assuming you want all employee details
FROM Employees e
JOIN AboveAvgSalary aas ON e.EmployeeID = aas.EmployeeID;
--9.Write a query to find the total number of products sold using a derived table.(Sales, Products)
SELECT
    COUNT(DISTINCT s.ProductID) AS TotalProductsSold
FROM
    Sales s
JOIN
    Products p ON s.ProductID = p.ProductID;
--10.Use a CTE to find the names of employees who have not made any sales.(Sales, Employees)
WITH EmployeesWithSales AS (
    SELECT DISTINCT EmployeeID
    FROM Sales
)
SELECT e.*
FROM Employees e
WHERE e.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesWithSales);
--Medium Tasks

--1.This script uses recursion to calculate factorials
DECLARE @Number INT = 5; -- Example number

WITH Factorials AS (
    SELECT 1 AS n, 1 AS Factorial
    UNION ALL
    SELECT n + 1, (n + 1) * Factorial
    FROM Factorials
    WHERE n < @Number
)
SELECT Factorial FROM Factorials WHERE n = @Number;
--2.This script uses recursion to calculate Fibonacci numbers
DECLARE @Number INT = 10; -- Example number of Fibonacci numbers

WITH Fibonacci AS (
    SELECT 0 AS n, 0 AS value
    UNION ALL
    SELECT 1, 1
    UNION ALL
    SELECT n + 1,
           (SELECT value FROM Fibonacci WHERE n = F.n - 1) + (SELECT value FROM Fibonacci WHERE n = F.n - 2)
    FROM Fibonacci F
    WHERE n < @Number
)
SELECT value FROM Fibonacci WHERE n > 1 ORDER BY n;
--3.This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
DECLARE @String VARCHAR(30) = (SELECT String FROM Example WHERE Id = 1);
WITH RecursiveSplit AS (
    SELECT 1 AS Position, SUBSTRING(@String, 1, 1) AS Substring, LEN(@String) AS StringLength
    UNION ALL
    SELECT Position + 1, SUBSTRING(@String, Position + 1, 1), LEN(@String)
    FROM RecursiveSplit
    WHERE Position < StringLength
)
SELECT Position, Substring FROM RecursiveSplit ORDER BY Position;
--4.Create a CTE to rank employees based on their total sales.(Employees, Sales)
WITH EmployeeSales AS (
    SELECT
        e.EmployeeID,
        SUM(s.SalesAmount) AS TotalSales
    FROM
        Employees e
    JOIN
        Sales s ON e.EmployeeID = s.EmployeeID
    GROUP BY
        e.EmployeeID
)
SELECT
    EmployeeID,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM
    EmployeeSales;
--5.Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
SELECT TOP 5
    e.EmployeeID,
    COUNT(*) AS OrderCount
FROM
    Employees e
JOIN
    Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY
    e.EmployeeID
ORDER BY
    OrderCount DESC;
--6.Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
WITH MonthlySales AS (
    SELECT
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM
        Sales
    GROUP BY
        YEAR(SaleDate),
        MONTH(SaleDate)
)
SELECT
    ms.SaleYear,
    ms.SaleMonth,
    ms.TotalSales,
    LAG(ms.TotalSales, 1, 0) OVER (ORDER BY ms.SaleYear, ms.SaleMonth) AS PreviousMonthSales,
    ms.TotalSales - LAG(ms.TotalSales, 1, 0) OVER (ORDER BY ms.SaleYear, ms.SaleMonth) AS SalesDifference
FROM
    MonthlySales ms
ORDER BY
    ms.SaleYear,
    ms.SaleMonth;
--7.Write a query using a derived table to find the sales per product category.(Sales, Products)
SELECT
    p.CategoryID,
    SUM(s.SalesAmount) AS TotalSales
FROM
    Products p
JOIN
    Sales s ON p.ProductID = s.ProductID
GROUP BY
    p.CategoryID;
--8.Use a CTE to rank products based on total sales in the last year.(Sales, Products)
WITH LastYearSales AS (
    SELECT
        p.ProductID,
        SUM(s.SalesAmount) AS TotalSales
    FROM
        Products p
    JOIN
        Sales s ON p.ProductID = s.ProductID
    WHERE
        s.SaleDate >= DATEADD(year, -1, GETDATE())
    GROUP BY
        p.ProductID
)
SELECT
    ProductID,
    TotalSales,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM
    LastYearSales;
--9.Create a derived table to find employees with sales over $5000 in each quarter.(Sales, Employees)
SELECT
    e.EmployeeID
FROM
    Employees e
JOIN
    (SELECT EmployeeID, DATEPART(quarter, SaleDate) AS SaleQuarter, SUM(SalesAmount) AS TotalQuarterSales FROM Sales GROUP BY EmployeeID, DATEPART(quarter, SaleDate) HAVING SUM(SalesAmount) > 5000) AS QuarterlySales ON e.EmployeeID = QuarterlySales.EmployeeID
GROUP BY e.EmployeeID
--10.Use a derived table to find the top 3 employees by total sales amount in the last month.(Sales, Employees)
SELECT TOP 3
    e.EmployeeID,
    SUM(s.SalesAmount) AS TotalSales
FROM
    Employees e
JOIN
    Sales s ON e.EmployeeID = s.EmployeeID
WHERE
    s.SaleDate >= DATEADD(month, -1, GETDATE()) AND s.SaleDate < GETDATE()
GROUP BY
    e.EmployeeID
ORDER BY
    TotalSales DESC;
--Difficult Tasks

--1.Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)
DECLARE @n INT = 5;

WITH RECURSIVE Numbers AS (
  SELECT 1 AS n, CAST(1 AS VARCHAR(MAX)) AS seq
  UNION ALL
  SELECT n + 1, seq + CAST((n + 1) AS VARCHAR(MAX))
  FROM Numbers
  WHERE n < @n
)

SELECT seq FROM Numbers
ORDER BY n;
--2.Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)
WITH EmployeeLastSixMonths AS (
    SELECT
        EmployeeID,
        SUM(SalesAmount) AS TotalSales
    FROM
        Sales
    WHERE
        SaleDate >= DATEADD(month, -6, GETDATE())
    GROUP BY
        EmployeeID
)
SELECT TOP 1 WITH TIES
    e.*
FROM
    Employees e
JOIN
    EmployeeLastSixMonths esm ON e.EmployeeID = esm.EmployeeID
ORDER BY
    esm.TotalSales DESC;
--3.This script uses recursion to display a running total where the sum cannot go higher than 10 or lower than 0.(Numbers)

-- Create a sample table and insert statement (replace with your actual table)
CREATE TABLE #Numbers (
    Id INT,
    StepNumber INT,
    [Count] INT
);
INSERT INTO #Numbers VALUES
    (1, 1, 1),
    (1, 2, -2),
    (1, 3, -1),
    (1, 4, 12),
    (1, 5, -2),
    (2, 1, 7),
    (2, 2, -3);

WITH CumulativeSums AS (
    SELECT
        Id,
        StepNumber,
        [Count],
        [Count] AS RunningTotal
    FROM
        #Numbers
    WHERE
        StepNumber = (SELECT MIN(StepNumber) FROM #Numbers AS N2 WHERE N2.Id = Numbers.Id)

    UNION ALL

    SELECT
        N.Id,
        N.StepNumber,
        N.[Count],
        CASE
            WHEN CumulativeSums.RunningTotal + N.[Count] > 10 THEN 10
            WHEN CumulativeSums.RunningTotal + N.[Count] < 0 THEN 0
            ELSE CumulativeSums.RunningTotal + N.[Count]
        END AS RunningTotal
    FROM
        #Numbers AS N
    INNER JOIN
        CumulativeSums ON N.Id = CumulativeSums.Id
        AND N.StepNumber = CumulativeSums.StepNumber + 1
    WHERE N.StepNumber IN (SELECT StepNumber from #Numbers AS N2 WHERE N2.Id = N.Id)
)
SELECT
    Id,
    StepNumber,
    [Count],
    RunningTotal
FROM
    CumulativeSums
ORDER BY
    Id,
    StepNumber;
--4.Given a table of employee shifts, and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and does not have an activity planned, label the time frame as “Work”. (Schedule,Activity)
SELECT
    s.ScheduleID,
    s.StartTime,
    s.EndTime,
    ISNULL(a.ActivityName, 'Work') AS Activity
FROM
    Schedule s
LEFT JOIN
    Activity a ON s.ScheduleID = a.ScheduleID
WHERE
    NOT EXISTS (
        SELECT 1
        FROM Activity a2
        WHERE a2.ScheduleID = s.ScheduleID AND a2.StartTime <= s.EndTime AND a2.EndTime >= s.StartTime
    )

UNION ALL

SELECT
    a.ScheduleID,
    a.StartTime,
    a.EndTime,
    a.ActivityName
FROM
    Activity a;
--5.Create a complex query that uses both a CTE and a derived table to calculate sales totals for each department and product.(Employees, Sales, Products, Departments)

WITH DepartmentSales AS (
    SELECT
        d.DepartmentID,
        d.DepartmentName,
        SUM(s.SalesAmount) AS TotalDepartmentSales
    FROM
        Departments d
    JOIN
        Products p ON d.DepartmentID = p.DepartmentID
    JOIN
        Sales s ON p.ProductID = s.ProductID
    GROUP BY
        d.DepartmentID,
        d.DepartmentName
),
ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        SUM(s.SalesAmount) AS TotalProductSales
    FROM
        Products p
    JOIN
        Sales s ON p.ProductID = s.ProductID
    GROUP BY
        p.ProductID,
        p.ProductName
)

SELECT
    ds.DepartmentName,
    ps.ProductName,
    ps.TotalProductSales,
    ds.TotalDepartmentSales
FROM
    DepartmentSales ds
JOIN
    ProductSales ps ON 1=1 -- You NEED the join keys from the table relation!!!
ORDER BY
    ds.DepartmentName,
    ps.ProductName;
CREATE TABLE Schedule ( ScheduleID CHAR(1) PRIMARY KEY, StartTime DATETIME NOT NULL, EndTime DATETIME NOT NULL ); 

CREATE TABLE Activity ( ScheduleID CHAR(1) REFERENCES Schedule (ScheduleID), ActivityName VARCHAR(100), StartTime DATETIME, EndTime DATETIME, PRIMARY KEY (ScheduleID, ActivityName, StartTime, EndTime) ); 

INSERT INTO Schedule (ScheduleID, StartTime, EndTime) VALUES ('A',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 15:00:00' AS DATETIME)), ('B',CAST('2021-10-01 10:15:00' AS DATETIME),CAST('2021-10-01 12:15:00' AS DATETIME)); 

INSERT INTO Activity (ScheduleID, ActivityName, StartTime, EndTime) VALUES ('A','Meeting',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 10:30:00' AS DATETIME)), ('A','Break',CAST('2021-10-01 12:00:00' AS DATETIME),CAST('2021-10-01 12:30:00' AS DATETIME)), ('A','Meeting',CAST('2021-10-01 13:00:00' AS DATETIME),CAST('2021-10-01 13:30:00' AS DATETIME)), ('B','Break',CAST('2021-10-01 11:00:00'AS DATETIME),CAST('2021-10-01 11:15:00' AS DATETIME));

CREATE TABLE Numbers ( Id INTEGER, StepNumber INTEGER, [Count] INTEGER ); 

INSERT INTO Numbers VALUES (1,1,1) ,(1,2,-2) ,(1,3,-1) ,(1,4,12) ,(1,5,-2) ,(2,1,7) ,(2,2,-3); 

CREATE TABLE Example ( Id INTEGER IDENTITY(1,1) PRIMARY KEY, String VARCHAR(30) NOT NULL ); 

INSERT INTO Example VALUES('123456789'),('abcdefghi'); 

CREATE TABLE Employeess ( EmployeeID INT PRIMARY KEY, DepartmentID INT, FirstName VARCHAR(50), LastName VARCHAR(50), Salary DECIMAL(10, 2) );

INSERT INTO Employeess (EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES (1, 1, 'John', 'Doe', 60000.00), (2, 1, 'Jane', 'Smith', 65000.00), (3, 2, 'James', 'Brown', 70000.00), (4, 3, 'Mary', 'Johnson', 75000.00), (5, 4, 'Linda', 'Williams', 80000.00), (6, 2, 'Michael', 'Jones', 85000.00), (7, 1, 'Robert', 'Miller', 55000.00), (8, 3, 'Patricia', 'Davis', 72000.00), (9, 4, 'Jennifer', 'García', 77000.00), (10, 1, 'William', 'Martínez', 69000.00);

CREATE TABLE Department ( DepartmentID INT PRIMARY KEY, DepartmentName VARCHAR(50) );

INSERT INTO Department (DepartmentID, DepartmentName) VALUES (1, 'HR'), (2, 'Sales'), (3, 'Marketing'), (4, 'Finance'), (5, 'IT'), (6, 'Operations'), (7, 'Customer Service'), (8, 'R&D'), (9, 'Legal'), (10, 'Logistics');

CREATE TABLE Saless ( SalesID INT PRIMARY KEY, EmployeeID INT, ProductID INT, SalesAmount DECIMAL(10, 2), SaleDate DATE );

INSERT INTO Saless(SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES (1, 1, 1, 1500.00, '2025-01-01'), (2, 2, 2, 2000.00, '2025-01-02'), (3, 3, 3, 1200.00, '2025-01-03'), (4, 4, 4, 1800.00, '2025-01-04'), (5, 5, 5, 2200.00, '2025-01-05'), (6, 6, 6, 1400.00, '2025-01-06'), (7, 7, 1, 2500.00, '2025-01-07'), (8, 8, 2, 1700.00, '2025-01-08'), (9, 9, 3, 1600.00, '2025-01-09'), (10, 10, 4, 1900.00, '2025-01-10'), (11, 1, 5, 2100.00, '2025-01-11'), (12, 2, 6, 1300.00, '2025-01-12'), (13, 3, 1, 2000.00, '2025-01-13'), (14, 4, 2, 1800.00, '2025-01-14'), (15, 5, 3, 1500.00, '2025-01-15'), (16, 6, 4, 2200.00, '2025-01-16'), (17, 7, 5, 1700.00, '2025-01-17'), (18, 8, 6, 1600.00, '2025-01-18'), (19, 9, 1, 2500.00, '2025-01-19'), (20, 10, 2, 1800.00, '2025-01-20'), (21, 1, 3, 1400.00, '2025-01-21'), (22, 2, 4, 1900.00, '2025-01-22'), (23, 3, 5, 2100.00, '2025-01-23'), (24, 4, 6, 1600.00, '2025-01-24'), (25, 5, 1, 1500.00, '2025-01-25'), (26, 6, 2, 2000.00, '2025-01-26'), (27, 7, 3, 2200.00, '2025-01-27'), (28, 8, 4, 1300.00, '2025-01-28'), (29, 9, 5, 2500.00, '2025-01-29'), (30, 10, 6, 1800.00, '2025-01-30'), (31, 1, 1, 2100.00, '2025-02-01'), (32, 2, 2, 1700.00, '2025-02-02'), (33, 3, 3, 1600.00, '2025-02-03'), (34, 4, 4, 1900.00, '2025-02-04'), (35, 5, 5, 2000.00, '2025-02-05'), (36, 6, 6, 2200.00, '2025-02-06'), (37, 7, 1, 2300.00, '2025-02-07'), (38, 8, 2, 1750.00, '2025-02-08'), (39, 9, 3, 1650.00, '2025-02-09'), (40, 10, 4, 1950.00, '2025-02-10');

CREATE TABLE Productss ( ProductID INT PRIMARY KEY, CategoryID INT, ProductName VARCHAR(100), Price DECIMAL(10, 2) );

INSERT INTO Productss (ProductID, CategoryID, ProductName, Price) VALUES (1, 1, 'Laptop', 1000.00), (2, 1, 'Smartphone', 800.00), (3, 2, 'Tablet', 500.00), (4, 2, 'Monitor', 300.00), (5, 3, 'Headphones', 150.00), (6, 3, 'Mouse', 25.00), (7, 4, 'Keyboard', 50.00), (8, 4, 'Speaker', 200.00), (9, 5, 'Smartwatch', 250.00), (10, 5, 'Camera', 700.00);
