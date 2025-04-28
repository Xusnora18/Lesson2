DROP TABLE Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);
DROP TABLE Sales;
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

WITH MonthlySales AS (
    SELECT
        s.ProductID,
        SUM(s.Quantity) AS TotalQuantity,
		COUNT(s.Quantity) as Countquantity
    FROM
        Sales s
    JOIN
        Products p ON s.ProductID = p.ProductID
     
    GROUP BY
        s.ProductID
)
SELECT ProductID, TotalQuantity, Countquantity 
FROM MonthlySales;
---------------------------------------------------------
GO
CREATE VIEW vw_ProductSalesSummary AS
SELECT
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.Quantity) AS TotalQuantitySold
FROM
    Products p
JOIN
    Sales s ON p.ProductID = s.ProductID
GROUP BY
    p.ProductID, p.ProductName, p.Category; -- Group by all non-aggregated columns
GO
-- To query the view:
SELECT *
FROM vw_ProductSalesSummary;

-----------------------------------------------------
GO
CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18, 2)  -- Choose appropriate data type and precision for currency
AS
BEGIN
    
    DECLARE @TotalRevenue DECIMAL(18, 2);


    SELECT @TotalRevenue = SUM(s.Quantity)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

   
    IF @TotalRevenue IS NULL
    BEGIN
        SET @TotalRevenue = 0;
    END

    RETURN @TotalRevenue;
END;
GO
-- Example Usage:
SELECT dbo.fn_GetTotalRevenueForProduct(123);  
-----------------------------------------------------------------
GO
CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS @SalesSummary TABLE (
    ProductName VARCHAR(255), 
    TotalQuantity INT,
    TotalRevenue DECIMAL(18, 2)  
)
AS
BEGIN
    INSERT INTO @SalesSummary
    SELECT
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity) AS TotalRevenue
    FROM
        Products p
    JOIN
        Sales s ON p.ProductID = s.ProductID
    WHERE
        p.Category = @Category
    GROUP BY
        p.ProductName;  

    RETURN;
END;
GO
-- Example Usage:
SELECT * FROM dbo.fn_GetSalesByCategory('Electronics'); 
-------------------------------------------------------------------------------------------------------
GO
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)  
AS
BEGIN
    IF @Number <= 1
    BEGIN
        RETURN 'No';
    END;

    IF @Number = 2
    BEGIN
        RETURN 'Yes';
    END;


    IF @Number % 2 = 0
    BEGIN
        RETURN 'No';
    END;

    
    DECLARE @i INT = 3;
    WHILE @i * @i <= @Number
    BEGIN
      
        IF @Number % @i = 0
        BEGIN
            RETURN 'No';
        END;

      
        SET @i = @i + 2;
    END;

    RETURN 'Yes';
END;
GO

SELECT dbo.fn_IsPrime(7);  -- Returns 'Yes'
SELECT dbo.fn_IsPrime(10); -- Returns 'No'
SELECT dbo.fn_IsPrime(29); -- Returns 'Yes'

------------------------------------------------------------------------
GO
    CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
    RETURNS TABLE
    AS
    RETURN
    SELECT value AS Number
    FROM GENERATE_SERIES(@Start, @End);
GO
----------------------------------------------------------------------
GO
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        SELECT CASE
            WHEN (SELECT COUNT(DISTINCT salary) FROM Employee) < @N THEN NULL
            ELSE (
                SELECT salary
                FROM (
                    SELECT
                        salary,
                        DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
                    FROM
                        Employee
                ) AS ranked_salaries
                WHERE salary_rank = @N
            )
        END
    );
END;
GO
SELECT dbo.getNthHighestSalary(2);
SELECT dbo.getNthHighestSalary(1);
-----------------------------------------------------------------
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |

SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id FROM RequestAccepted
) AS all_friends
GROUP BY id
ORDER BY num DESC;

-------------------------------------------------------------
CREATE DATABASE CUSTOMK;
USE CUSTOMK;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);



CREATE VIEW vw_CustomerOrderSummary AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM
    Customers c
LEFT JOIN
    Orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.name;
---------------------------------------------------------

	DROP TABLE IF EXISTS Gaps;

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,'Charlie'),(8,NULL),(9,NULL);

SELECT
    g.RowNumber,
    COALESCE(g.TestCase, LAG(g.TestCase, 1, '') IGNORE NULLS OVER (ORDER BY g.RowNumber), '') AS Workflow,
    CASE
        WHEN g.RowNumber IN (1, 5, 8, 9) THEN 'Pass'
        ELSE 'Fail'
    END AS Status
FROM
    Gaps g
LEFT JOIN (
    SELECT RowNumber
    FROM Gaps
    WHERE TestCase IS NOT NULL
) AS t ON g.RowNumber = t.RowNumber
ORDER BY
    g.RowNumber;