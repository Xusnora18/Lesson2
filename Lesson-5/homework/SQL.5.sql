--Easy-Level Tasks (10)
SELECT
    ProductName AS Name  -- Rename the ProductName column to Name
FROM
    Products;
-------
	SELECT *
FROM (SELECT * FROM Customers) AS Client;
-------
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discontinued;
--------
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discontinued;

------
SELECT * FROM Products
UNION ALL
SELECT * FROM Orders;

------
SELECT DISTINCT CustomerName, Country
FROM Customers;  -- Assuming the table is named 'Customers'
------
SELECT
    ProductName,
    Price,
    CASE
        WHEN Price > 100 THEN 'High'
        ELSE 'Low'
    END AS PriceCategory  -- Conditional Column
FROM
    Products;
-------
SELECT
    Department,
    Country,
    COUNT(*) AS NumberOfEmployees
FROM
    Employees
WHERE
    Department = 'Sales'  -- Replace 'Sales' with the desired Department
GROUP BY
    Department,
    Country
ORDER BY
    Country;
---------
SELECT
    CategoryID,
    COUNT(ProductID) AS NumberOfProducts
FROM
    Products
GROUP BY
    CategoryID;
---------
SELECT
    ProductName,
    Stock,
    IIF(Stock > 100, 'Yes', 'No') AS StockStatus
FROM
    Products;
--------
 ---Medium-Level Tasks (10)
 SELECT
    Orders.*,
    Customers.CustomerID,
    Customers.ContactName,
    Customers.Country,
    Customers.City,
    Customers.Address,
    Customers.PostalCode,
    Customers.CompanyName AS ClientName  -- Alias the CustomerName
FROM
    Orders
INNER JOIN
    Customers ON Orders.CustomerID = Customers.CustomerID;
	-------------
	SELECT ProductName FROM Products
UNION
SELECT ProductName FROM OutOfStockProducts;
---------
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM DiscontinuedProducts;
----------
SELECT
    CustomerID,
    CompanyName,
    (
        CASE
            WHEN (SELECT COUNT(*) FROM Orders WHERE Orders.CustomerID = Customers.CustomerID) > 5 THEN 'Eligible'
            ELSE 'Not Eligible'
        END
    ) AS EligibilityStatus
FROM
    Customers;
	----------
WITH CustomerOrderCounts AS (
    SELECT
        CustomerID,
        COUNT(*) AS OrderCount
    FROM
        Orders
    GROUP BY
        CustomerID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    CASE
        WHEN coc.OrderCount > 5 THEN 'Eligible'
        ELSE 'Not Eligible'
    END AS EligibilityStatus
FROM
    Customers c
LEFT JOIN
    CustomerOrderCounts coc ON c.CustomerID = coc.CustomerID;
-----
SELECT
    ProductName,  -- Or other relevant columns
    Price,
    IIF(Price > 100, 'Expensive', 'Affordable') AS PriceCategory
FROM
    Products;  -- Replace 'Products' with your actual table name
	----------
	SELECT
    CustomerID,
    COUNT(*) AS NumberOfOrders
FROM
    Orders
GROUP BY
    CustomerID;
------
SELECT
    *  -- Or specify the columns you want to retrieve (e.g., EmployeeID, FirstName, LastName)
FROM
    Employees
WHERE
    Age < 25 OR Salary > 6000;
-------
SELECT
    Region,
    SUM(SalesAmount) AS TotalSales
FROM
    Sales
GROUP BY
    Region;
------
SELECT
    Customers.*,  -- Select all columns from the Customers table
    Orders.*,
    Orders.OrderDate AS DateOfOrder
FROM
    Customers
LEFT JOIN
    Orders ON Customers.CustomerID = Orders.CustomerID;
------
UPDATE Employees
SET Salary = IF(Department = 'HR', Salary * 1.10, Salary)
WHERE Department = 'HR';
--------
UPDATE Employees
SET Salary = CASE
                WHEN Department = 'HR' THEN Salary * 1.10
                ELSE Salary
             END
WHERE Department = 'HR';
----------
-- Hard-Level Tasks (10)
-- Sample Tables (if you don't already have them)

CREATE TABLE Sales (
    ProductID INT,
    SaleDate DATE,
    SaleAmount DECIMAL(10, 2)
);

CREATE TABLE Returns (
    ProductID INT,
    ReturnDate DATE,
    ReturnAmount DECIMAL(10, 2)
);

-- Sample Data
INSERT INTO Sales (ProductID, SaleDate, SaleAmount) VALUES
(1, '2023-01-01', 100.00),
(2, '2023-01-02', 200.00),
(1, '2023-01-03', 150.00),
(3, '2023-01-04', 300.00);

INSERT INTO Returns (ProductID, ReturnDate, ReturnAmount) VALUES
(1, '2023-01-05', 25.00),
(2, '2023-01-06', 10.00),
(1, '2023-01-07', 15.00);


-- The Query
SELECT
    ProductID,
    SUM(TotalAmount) AS NetTotal
FROM
    (
        SELECT ProductID, SaleAmount AS TotalAmount FROM Sales
        UNION ALL
        SELECT ProductID, -ReturnAmount AS TotalAmount FROM Returns  -- Negative for Returns
    ) AS CombinedData
GROUP BY
    ProductID
ORDER BY
    ProductID;
-------
-- Sample Tables
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255)
);

CREATE TABLE DiscontinuedProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255)
);

-- Sample Data
INSERT INTO Products (ProductID, ProductName) VALUES
(1, 'Widget A'),
(2, 'Widget B'),
(3, 'Widget C');

INSERT INTO DiscontinuedProducts (ProductID, ProductName) VALUES
(2, 'Widget B'),
(4, 'Widget D'),
(5, 'Widget E');


-- The Query
SELECT ProductID
FROM Products
INTERSECT
SELECT ProductID
FROM DiscontinuedProducts;
------
-- Assuming you have a table with TotalSales for each product (e.g., from a previous query)

-- Sample Table (assuming this is the result of a query that calculated TotalSales)
CREATE TABLE ProductSales (
    ProductID INT PRIMARY KEY,
    TotalSales DECIMAL(10, 2)
);

-- Sample Data
INSERT INTO ProductSales (ProductID, TotalSales) VALUES
(1, 12000.00),
(2, 7500.00),
(3, 3000.00);


-- The Query
SELECT
    ProductID,
    TotalSales,
    CASE
        WHEN TotalSales > 10000 THEN 'Top Tier'
        WHEN TotalSales BETWEEN 5000 AND 10000 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS SalesTier
FROM
    ProductSales;
-----
-- Sample Table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Salary DECIMAL(10, 2),
    Department VARCHAR(255),
    PerformanceRating INT  -- Example criteria
);

-- Sample Data
INSERT INTO Employees (EmployeeID, Salary, Department, PerformanceRating) VALUES
(1, 50000.00, 'Sales', 4),
(2, 60000.00, 'Marketing', 3),
(3, 45000.00, 'IT', 5);

-- Stored Procedure
CREATE PROCEDURE UpdateEmployeeSalaries
AS
BEGIN
    -- Declare variables for the cursor
    DECLARE @EmployeeID INT, @Salary DECIMAL(10, 2), @Department VARCHAR(255), @PerformanceRating INT;

    -- Declare the cursor
    DECLARE EmployeeCursor CURSOR FOR
    SELECT EmployeeID, Salary, Department, PerformanceRating
    FROM Employees;

    -- Open the cursor
    OPEN EmployeeCursor;

    -- Fetch the first row
    FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @Salary, @Department, @PerformanceRating;

    -- Loop through the rows
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Your update logic here (example)
        IF @Department = 'Sales' AND @PerformanceRating > 3
        BEGIN
            SET @Salary = @Salary * 1.10;  -- 10% raise
            UPDATE Employees SET Salary = @Salary WHERE EmployeeID = @EmployeeID;
        END
        ELSE IF @Department = 'IT' AND @PerformanceRating = 5
        BEGIN
            SET @Salary = @Salary * 1.15;  -- 15% raise
            UPDATE Employees SET Salary = @Salary WHERE EmployeeID = @EmployeeID;
        END

        -- Fetch the next row
        FETCH NEXT FROM EmployeeCursor INTO @EmployeeID, @Salary, @Department, @PerformanceRating;
    END

    -- Close and deallocate the cursor
    CLOSE EmployeeCursor;
    DEALLOCATE EmployeeCursor;
END;

-- Execute the stored procedure
EXEC UpdateEmployeeSalaries;
--------------
-- Sample Table (same as SQL Server example)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Salary DECIMAL(10, 2),
    Department VARCHAR(255),
    PerformanceRating INT
);

-- Sample Data (same as SQL Server example)
INSERT INTO Employees (EmployeeID, Salary, Department, PerformanceRating) VALUES
(1, 50000.00, 'Sales', 4),
(2, 60000.00, 'Marketing', 3),
(3, 45000.00, 'IT', 5);

-- Stored Procedure
DELIMITER //  -- Change delimiter to allow semicolons within the procedure

CREATE PROCEDURE UpdateEmployeeSalaries()
BEGIN
  DECLARE emp_id INT;
  DECLARE sal DECIMAL(10,2);
  DECLARE dept VARCHAR(255);
  DECLARE perf_rating INT;
  DECLARE done BOOLEAN DEFAULT FALSE;  -- Flag to indicate end of data

  -- Declare the cursor
  DECLARE cur CURSOR FOR SELECT EmployeeID, Salary, Department, PerformanceRating FROM Employees;

  -- Declare handler for when the cursor reaches the end
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO emp_id, sal, dept, perf_rating;
    IF done THEN
      LEAVE read_loop;  -- Exit the loop if no more rows
    END IF;

    -- Your update logic here
    IF dept = 'Sales' AND perf_rating > 3 THEN
        SET sal = sal * 1.10;
        UPDATE Employees SET Salary = sal WHERE EmployeeID = emp_id;
    ELSEIF dept = 'IT' AND perf_rating = 5 THEN
        SET sal = sal * 1.15;
        UPDATE Employees SET Salary = sal WHERE EmployeeID = emp_id;
    END IF;

  END LOOP;

  CLOSE cur;
END //

DELIMITER ;  -- Reset delimiter back to semicolon

-- Call the stored procedure
CALL UpdateEmployeeSalaries();
-----------------
    -- Example of a set-based solution (SQL Server/MySQL - adjust as needed)
    UPDATE Employees
    SET Salary =
        CASE
            WHEN Department = 'Sales' AND PerformanceRating > 3 THEN Salary * 1.10
            WHEN Department = 'IT' AND PerformanceRating = 5 THEN Salary * 1.15
            ELSE Salary -- Keep the original salary
        END;
-------------
-- Sample Tables

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    OrderID INT,
    InvoiceDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


-- Sample Data
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Peter Jones');

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(101, 1, '2023-01-10'),
(102, 2, '2023-01-15'),
(103, 1, '2023-01-20'),
(104, 3, '2023-01-25');

INSERT INTO Invoices (InvoiceID, OrderID, InvoiceDate) VALUES
(201, 101, '2023-01-12'),
(202, 102, '2023-01-17');


-- The Query
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID NOT IN (SELECT OrderID FROM Invoices);
---------------
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
EXCEPT
SELECT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN Invoices i ON o.OrderID = i.OrderID;
---------
SELECT
    CustomerID,
    ProductID,
    Region,
    SUM(SalesAmount) AS TotalSales  -- Or whatever column represents sales
FROM
    Orders  -- Replace with your actual table name
GROUP BY
    CustomerID,
    ProductID,
    Region;
-----
SELECT
    OrderID,
    Quantity,
    CASE
        WHEN Quantity >= 100 THEN 0.15  -- 15% discount
        WHEN Quantity >= 50 THEN 0.10   -- 10% discount
        WHEN Quantity >= 20 THEN 0.05   -- 5% discount
        ELSE 0.00                      -- No discount
    END AS Discount
FROM
    OrderDetails; -- Replace with your actual table name containing quantity data
------
SELECT
    p.ProductID,
    p.ProductName,
    p.Stock,
    CASE WHEN p.Stock > 0 THEN 'In Stock' ELSE 'Out of Stock' END AS StockStatus
FROM
    Products p
INNER JOIN
    (SELECT ProductID FROM Products UNION SELECT ProductID FROM DiscontinuedProducts) AS allProducts
ON p.ProductID = allProducts.ProductID

UNION ALL

SELECT
    dp.ProductID,
    dp.ProductName,
    0 AS Stock,  -- Assuming discontinued products have 0 stock
    'Discontinued' AS StockStatus
FROM
    DiscontinuedProducts dp
WHERE NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = dp.ProductID);
--------
SELECT
    ProductID,
    ProductName,
    Stock,
    IIF(Stock > 0, 'Available', 'Out of Stock') AS StockStatus
FROM
    Products; -- Replace with your actual table name
------
SELECT CustomerID
FROM Customers

EXCEPT

SELECT CustomerID
FROM VIP_Customers;
