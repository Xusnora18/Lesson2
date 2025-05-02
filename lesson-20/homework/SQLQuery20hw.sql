CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND s2.SaleDate BETWEEN '2024-03-01' AND '2024-03-31'
);

---------------------------------------------------------------------
--  Product with the highest total sales revenue
SELECT TOP 1 Product
FROM #Sales
GROUP BY Product
ORDER BY SUM(Quantity * Price) DESC;

--  Find the second highest sale amount using a subquery
SELECT MAX(Price * Quantity)
FROM #Sales
WHERE Price * Quantity < (SELECT MAX(Price * Quantity) FROM #Sales);

-- 3. Find the total quantity of products sold per month using a subquery
SELECT
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    SUM(Quantity) AS TotalQuantitySold
FROM
    #Sales
GROUP BY
    YEAR(SaleDate),
    MONTH(SaleDate)
ORDER BY
    SaleYear,
    SaleMonth;

-- 4. Find customers who bought same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName
      AND s1.Product = s2.Product
);

------------------------------------------
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

-- Создание таблицы
CREATE TABLE Fruits (
    Name VARCHAR(50),
    Fruit VARCHAR(50)
);

-- Вставка данных в таблицу
INSERT INTO Fruits VALUES
('Francesko', 'Apple'),
('Francesko', 'Apple'),
('Francesko', 'Apple'),
('Francesko', 'Orange'),
('Francesko', 'Orange'),
('Francesko', 'Banana'),
('Li', 'Orange'),
('Li', 'Apple'),
('Li', 'Apple'),
('Li', 'Banana'),
('Mario', 'Apple'),
('Mario', 'Apple'),
('Mario', 'Apple'),
('Mario', 'Banana'),
('Mario', 'Banana'),
('Mario', 'Orange');

SELECT
    Name,
    SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
    SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
    SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM
    Fruits
GROUP BY
    Name
ORDER BY
    Name;
---------------------------------------------------
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

SELECT
    f1.ParentID AS PID,
    f1.ChildID AS CHID
FROM
    Family f1
ORDER BY
    f1.ParentID, f1.ChildID;
------------------------------------------------------

CREATE TABLE #Orders (
    CustomerID INTEGER,
    OrderID INTEGER,
    DeliveryState VARCHAR(100) NOT NULL,
    Amount MONEY NOT NULL,
    PRIMARY KEY (CustomerID, OrderID)
);

INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);


SELECT CustomerID, OrderID, DeliveryState, Amount
FROM #Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (SELECT CustomerID FROM #Orders WHERE DeliveryState = 'CA');
--------------------------------------------------------------------

CREATE TABLE #residents (
    resid INT IDENTITY,
    fullname VARCHAR(50),
    address VARCHAR(100)
);

INSERT INTO #residents (fullname, address) VALUES
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22');

UPDATE #residents
SET fullname = CASE
    WHEN fullname IS NULL OR fullname = '' THEN
        CASE
            WHEN address LIKE '%name=%' THEN
                SUBSTRING(address, CHARINDEX('name=', address) + 5,
                          CHARINDEX(' age=', address) - (CHARINDEX('name=', address) + 5))
            ELSE
                fullname  -- Если name= не найдено, оставляем fullname как есть (NULL/пустая строка)
        END
    ELSE
        fullname  -- Если fullname не NULL и не пустое, не изменяем его
END;

SELECT * FROM #residents;

-------------------------------------------------------------------

CREATE TABLE #Routes (
    RouteID INTEGER NOT NULL,
    DepartureCity VARCHAR(30) NOT NULL,
    ArrivalCity VARCHAR(30) NOT NULL,
    Cost MONEY NOT NULL,
    PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1, 'Tashkent', 'Samarkand', 100),
(2, 'Samarkand', 'Bukhoro', 200),
(3, 'Bukhoro', 'Khorezm', 300),
(4, 'Samarkand', 'Khorezm', 400),
(5, 'Tashkent', 'Jizzakh', 100),
(6, 'Jizzakh', 'Samarkand', 50);

WITH  RoutePaths AS (
    SELECT
        RouteID,
        DepartureCity,
        ArrivalCity,
        Cost,
        DepartureCity || ' -> ' || ArrivalCity AS Path
    FROM
        #Routes
    WHERE
        DepartureCity = 'Tashkent'

    UNION ALL

    SELECT
        r.RouteID,
        r.DepartureCity,
        r.ArrivalCity,
        r.Cost + rp.Cost,
        rp.Path || ' -> ' || r.ArrivalCity AS Path
    FROM
        #Routes r
    JOIN
        RoutePaths rp ON r.DepartureCity = rp.ArrivalCity
    WHERE rp.Path NOT LIKE '%' || r.ArrivalCity || '%' --Предотвращает циклы
)

SELECT TOP 1 WITH TIES Path, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC;


SELECT TOP 1 WITH TIES Path, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost DESC;

----------------------------------------------------------------

CREATE TABLE #RankingPuzzle (
    ID INT,
    Vals VARCHAR(10)
);

INSERT INTO #RankingPuzzle VALUES
(1, 'Product'),
(2, 'a'),
(3, 'a'),
(4, 'a'),
(5, 'a'),
(6, 'Product'),
(7, 'b'),
(8, 'b'),
(9, 'Product'),
(10, 'c');

SELECT
    ID,
    Vals,
    RANK() OVER (ORDER BY ID) AS ProductRank
FROM
    #RankingPuzzle
WHERE
    Vals = 'Product';
---------------------------------------------------------------------

CREATE TABLE #Consecutives (
    Id VARCHAR(5),
    Vals INT /* Value can be 0 or 1 */
);

INSERT INTO #Consecutives VALUES
('a', 1),
('a', 0),
('a', 1),
('a', 1),
('a', 1),
('a', 1),
('a', 0),
('b', 1),
('b', 1),
('b', 1),
('b', 0),
('b', 1),
('b', 0);

WITH ConsecutiveLengths AS (
    SELECT
        Id,
        Vals,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY (SELECT NULL)) AS RowNum,
        Vals - LAG(Vals, 1, Vals) OVER (PARTITION BY Id ORDER BY (SELECT NULL)) AS ChangeIndicator
    FROM
        #Consecutives
),
Groups AS (
    SELECT
        Id,
        Vals,
        RowNum,
        SUM(CASE WHEN ChangeIndicator <> 0 THEN 1 ELSE 0 END) OVER (PARTITION BY Id ORDER BY RowNum) AS GroupId
    FROM
        ConsecutiveLengths
),
GroupLengths AS (
    SELECT
        Id,
        Vals,
        GroupId,
        COUNT(*) AS ConsecutiveLength
    FROM
        Groups
    GROUP BY
        Id,
        Vals,
        GroupId
)
SELECT
    Id,
    MAX(ConsecutiveLength) AS MaxConsecutiveLength,
    CASE
        WHEN EXISTS (SELECT 1 FROM #Consecutives t2 WHERE t2.Id = t1.Id ORDER BY (SELECT NULL) DESC TOP 1  AND Vals = 0 ) THEN 1
        ELSE 0
    END AS NextValue
FROM
    GroupLengths t1
GROUP BY
    Id
ORDER BY
    Id;
	-------------------------------------------------------------

CREATE TABLE #EmployeeSales (
    EmployeeId INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT
    es.EmployeeName,
    es.Department,
    es.SalesAmount
FROM
    #EmployeeSales es
WHERE
    es.SalesAmount > (
        SELECT
            AVG(SalesAmount)
        FROM
            #EmployeeSales
        WHERE
            Department = es.Department
    );
--------------------------------------------------------------

SELECT DISTINCT
    es.EmployeeName
FROM
    #EmployeeSales es
WHERE
    EXISTS (
        SELECT
            1
        FROM
            #EmployeeSales es2
        WHERE
            es2.SalesMonth = es.SalesMonth 
        GROUP BY
            es2.SalesMonth
        HAVING
            MAX(es2.SalesAmount) = es.SalesAmount 
    );
--------------------------------------------------------------------
DROP TABLE #EmployeeSales;
CREATE TABLE #EmployeeSales (
    EmployeeID INT,
    EmployeeName VARCHAR(100),
    ProductID INT,
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeID, EmployeeName, ProductID, SalesMonth, SalesYear) VALUES
(1, 'Alice', 1, 1, 2024),
(1, 'Alice', 2, 2, 2024),
(1, 'Alice', 3, 3, 2024),
(1, 'Alice', 4, 4, 2024),
(2, 'Bob', 1, 1, 2024),
(2, 'Bob', 2, 2, 2024),
(2, 'Bob', 3, 3, 2024),
(3, 'Charlie', 1, 1, 2024),
(3, 'Charlie', 2, 2, 2024),
(3, 'Charlie', 1, 3, 2024),
(3, 'Charlie', 2, 4, 2024);

DROP TABLE Products;
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);

SELECT DISTINCT
    es.EmployeeName
FROM
    #EmployeeSales es
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            (SELECT DISTINCT SalesMonth FROM #EmployeeSales) AS AllMonths
        WHERE
            NOT EXISTS (
                SELECT
                    1
                FROM
                    #EmployeeSales es2
                WHERE
                    es2.EmployeeName = es.EmployeeName
                    AND es2.SalesMonth = AllMonths.SalesMonth
            )
    );
	------------------------------------------------------------------
	
SELECT [Name]
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name = 'Laptop')
AND Name <> 'Laptop';

SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics');

-------------------------------------------------------------
DROP TABLE Orders;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 1, '2024-03-28'),
(12, 11, 2, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 2, '2024-04-05'),
(15, 13, 20, '2024-04-08');


SELECT p.ProductID
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
WHERE p.Price > (
    SELECT AVG(Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);
---------------------------------------------------------
-- 21. 
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID;

-- 22.
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders);

-- 23.
SELECT Name
FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Orders);

-- 24. 
SELECT TOP 1 p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;

-- 25. 
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.Name
HAVING COUNT(DISTINCT o.OrderID) > (SELECT COUNT(*) * 1.0 / COUNT(DISTINCT ProductID) FROM Orders);
