CREATE DATABASE HW
USE HW;
CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);

INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 150.00, 2, 101),
(2, 'Product B', '2023-01-02', 200.00, 3, 102),
(3, 'Product C', '2023-01-03', 250.00, 1, 103),
(4, 'Product A', '2023-01-04', 150.00, 4, 101),
(5, 'Product B', '2023-01-05', 200.00, 5, 104),
(6, 'Product C', '2023-01-06', 250.00, 2, 105),
(7, 'Product A', '2023-01-07', 150.00, 1, 101),
(8, 'Product B', '2023-01-08', 200.00, 8, 102),
(9, 'Product C', '2023-01-09', 250.00, 7, 106),
(10, 'Product A', '2023-01-10', 150.00, 2, 107),
(11, 'Product B', '2023-01-11', 200.00, 3, 108),
(12, 'Product C', '2023-01-12', 250.00, 1, 109),
(13, 'Product A', '2023-01-13', 150.00, 4, 110),
(14, 'Product B', '2023-01-14', 200.00, 5, 111),
(15, 'Product C', '2023-01-15', 250.00, 2, 112),
(16, 'Product A', '2023-01-16', 150.00, 1, 113),
(17, 'Product B', '2023-01-17', 200.00, 8, 114),
(18, 'Product C', '2023-01-18', 250.00, 7, 115),
(19, 'Product A', '2023-01-19', 150.00, 3, 116),
(20, 'Product B', '2023-01-20', 200.00, 4, 117),
(21, 'Product C', '2023-01-21', 250.00, 2, 118),
(22, 'Product A', '2023-01-22', 150.00, 5, 119),
(23, 'Product B', '2023-01-23', 200.00, 3, 120),
(24, 'Product C', '2023-01-24', 250.00, 1, 121),
(25, 'Product A', '2023-01-25', 150.00, 6, 122),
(26, 'Product B', '2023-01-26', 200.00, 7, 123),
(27, 'Product C', '2023-01-27', 250.00, 3, 124),
(28, 'Product A', '2023-01-28', 150.00, 4, 125),
(29, 'Product B', '2023-01-29', 200.00, 5, 126),
(30, 'Product C', '2023-01-30', 250.00, 2, 127);

-- 1. 
SELECT 
    SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate) as RowNum
FROM ProductSales;

-- 2.
SELECT 
    ProductName, SUM(Quantity) AS TotalQuantitySold,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS ProductRank
FROM ProductSales
GROUP BY ProductName;

-- 3. 
SELECT 
    CustomerID, MAX(SaleAmount) AS TopSaleAmount
FROM ProductSales
GROUP BY CustomerID;

-- 4.
SELECT 
    SaleID, SaleAmount, 
    LEAD(SaleAmount, 1, 0) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales;

-- 5.
SELECT 
    SaleID, SaleAmount,
    LAG(SaleAmount, 1, 0) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales;

-- 6. 
ALTER TABLE ProductSales ADD ProductCategory VARCHAR(50);
UPDATE ProductSales SET ProductCategory = 
CASE
    WHEN ProductName LIKE 'Product A%' THEN 'A'
    WHEN ProductName LIKE 'Product B%' THEN 'B'
    WHEN ProductName LIKE 'Product C%' THEN 'C'
    ELSE 'Other'
END;

SELECT 
    SaleID, ProductName, SaleAmount, ProductCategory,
    RANK() OVER (PARTITION BY ProductCategory ORDER BY SaleAmount DESC) AS SaleRank
FROM ProductSales;


-- 7.
SELECT 
    SaleID, SaleAmount
FROM (
    SELECT 
        SaleID, SaleAmount,
        LAG(SaleAmount, 1, 0) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
) AS SalesWithLag
WHERE SaleAmount > PreviousSaleAmount;

-- 8. 
SELECT 
    SaleID, ProductName, SaleAmount,
    SaleAmount - LAG(SaleAmount, 1, 0) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS SaleDifference
FROM ProductSales;

-- 9. 
SELECT 
    SaleID, SaleAmount,
    LEAD(SaleAmount, 1, 0) OVER (ORDER BY SaleDate) AS NextSaleAmount,
    (LEAD(SaleAmount, 1, 0) OVER (ORDER BY SaleDate) - SaleAmount) * 100.0 / SaleAmount AS PercentageChange
FROM ProductSales;

--10 Вычислить соотношение текущей суммы продажи к предыдущей сумме продажи в рамках того же продукта.
SELECT 
    SaleID, ProductName, SaleAmount,
    SaleAmount / LAG(SaleAmount, 1, SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS SaleRatio
FROM ProductSales;


--11
WITH FirstSales AS (
    SELECT ProductName, MIN(SaleDate) AS FirstSaleDate, MIN(SaleAmount) AS FirstSaleAmount
    FROM ProductSales
    GROUP BY ProductName
)
SELECT 
    ps.SaleID, ps.ProductName, ps.SaleAmount,
    ps.SaleAmount - fs.FirstSaleAmount AS SaleDifferenceFromFirst
FROM ProductSales ps
JOIN FirstSales fs ON ps.ProductName = fs.ProductName
ORDER BY ps.ProductName, ps.SaleDate;


-- 12
WITH SalesWithLag AS (
    SELECT 
        SaleID, ProductName, SaleAmount,
        LAG(SaleAmount, 1, 0) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID, ProductName, SaleAmount
FROM SalesWithLag
WHERE SaleAmount > PreviousSaleAmount;


--13
SELECT 
    SaleID, ProductName, SaleAmount,
    SUM(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS ClosingBalance
FROM ProductSales;


-- 14
SELECT 
    SaleID, ProductName, SaleAmount,
    AVG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM ProductSales;


-- 15
SELECT 
    SaleID, ProductName, SaleAmount,
    SaleAmount - (SELECT AVG(SaleAmount) FROM ProductSales) AS SaleDifferenceFromAverage
FROM ProductSales;

--16
WITH RankedSalaries AS (
    SELECT 
        EmployeeID, Name, Department, Salary,
        RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT 
    EmployeeID, Name, Department, Salary, SalaryRank
FROM RankedSalaries
GROUP BY SalaryRank, EmployeeID, Name, Department, Salary
HAVING COUNT(*) > 1;


-- 17
SELECT 
    Department, EmployeeID, Name, Salary,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
FROM Employees1
WHERE DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) <=2
ORDER BY Department, SalaryRank;


-- 18
SELECT 
    Department, EmployeeID, Name, MIN(Salary) AS LowestSalary
FROM Employees1
GROUP BY Department
;

-- 19
SELECT 
    EmployeeID, Name, Department, Salary,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate) AS RunningTotalSalary
FROM Employees1;


--20
SELECT 
    SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1;


--21
SELECT 
    AVG(Salary) OVER (PARTITION BY Department) AS AverageSalary
FROM Employees1;


-- 22
SELECT 
    EmployeeID, Name, Department, Salary,
    Salary - (SELECT AVG(Salary) FROM Employees1 WHERE Department = e.Department) AS SalaryDifference
FROM Employees1 e;


--23
SELECT 
    EmployeeID, Name, Department, Salary,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAverageSalary
FROM Employees1;


--24
SELECT 
    SUM(Salary) AS SumOfLast3Salaries
FROM (
    SELECT TOP 3 Salary
    FROM Employees1
    ORDER BY HireDate DESC
) AS Last3Employees;


