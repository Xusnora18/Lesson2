DROP TABLE IF EXISTS Grouped;
CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil',3),('Eraser',4),('Notebook',2);

WITH ExpandedData AS ( 
  SELECT
    [Product],
    1 AS QuantityLeft,  
    Quantity AS OriginalQuantity 
  FROM Grouped

  UNION ALL

  SELECT
    [Product],
    QuantityLeft + 1,
    OriginalQuantity
  FROM ExpandedData
  WHERE QuantityLeft < OriginalQuantity
)
SELECT [Product], 1 AS Quantity FROM ExpandedData ORDER BY [Product];

DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales
(
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10),
('South','ACE',67),
('East','ACE',54),
('North','ACME',65),
('South','ACME',9),
('East','ACME',1),
('West','ACME',7),
('North','Direct Parts',8),
('South','Direct Parts',7),
('West','Direct Parts',12);
GO

SELECT 'North' AS Region, 'ACE' AS Distributor, 10 AS Sales
UNION ALL
SELECT 'South', 'ACE', 67
UNION ALL
SELECT 'East', 'ACE', 54
UNION ALL
SELECT 'West', 'ACE', 0
UNION ALL
SELECT 'North', 'Direct Parts', 8
UNION ALL
SELECT 'South', 'Direct Parts', 7
UNION ALL
SELECT 'East', 'Direct Parts', 0
UNION ALL
SELECT 'West', 'Direct Parts', 12
UNION ALL
SELECT 'North', 'ACME', 65
UNION ALL
SELECT 'South', 'ACME', 9
UNION ALL
SELECT 'East', 'ACME', 1
UNION ALL
SELECT 'West', 'ACME', 7
ORDER BY Region, Distributor;  

DROP TABLE Employee;
CREATE TABLE Employee (
  id INT,
  name VARCHAR(255),
  department VARCHAR(255),
  managerId INT
);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL),
(102, 'Dan', 'A', 101),
(103, 'James', 'A', 101),
(104, 'Amy', 'A', 101),
(105, 'Anne', 'A', 101),
(106, 'Ron', 'B', 101);

SELECT
    e.name
FROM
    Employee e
WHERE
    e.id IN (SELECT managerId
             FROM Employee
             WHERE managerId IS NOT NULL
             GROUP BY managerId
             HAVING COUNT(*) >= 5);

DROP TABLE Products;
CREATE TABLE Products (
  product_id INT,
  product_name VARCHAR(40),
  product_category VARCHAR(40)
);
DROP TABLE Orders;
CREATE TABLE Orders (
  product_id INT,
  order_date DATE,
  unit INT
);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'),
(4, 'Lenovo', 'Laptop'),
(5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1, '2020-02-05', 60),
(1, '2020-02-10', 70),
(2, '2020-01-18', 30),
(2, '2020-02-11', 80),
(3, '2020-02-17', 2),
(3, '2020-02-24', 3),
(4, '2020-03-01', 20),
(4, '2020-03-04', 30),
(4, '2020-03-04', 60),
(5, '2020-02-25', 50),
(5, '2020-02-27', 50),
(5, '2020-03-01', 50);


SELECT
    p.product_name,
    SUM(o.unit) AS unit
FROM
    Products p
JOIN
    Orders o ON p.product_id = o.product_id
WHERE
    o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY
    p.product_name
HAVING
    SUM(o.unit) >= 100;


DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID     INT PRIMARY KEY,
  CustomerID  INT NOT NULL,
  [Count]     MONEY NOT NULL,
  Vendor      VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1, 1001, 12, 'Direct Parts'),
(2, 1001, 54, 'Direct Parts'),
(3, 1001, 32, 'ACME'),
(4, 2002, 7, 'ACME'),
(5, 2002, 16, 'ACME'),
(6, 2002, 5, 'Direct Parts');

WITH VendorCounts AS (
    SELECT
        CustomerID,
        Vendor,
        COUNT(*) AS VendorCount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM
        Orders
    GROUP BY
        CustomerID,
        Vendor
)
SELECT
    CustomerID,
    Vendor
FROM
    VendorCounts
WHERE
    rn = 1;

	DECLARE @Check_Prime INT = 91
-- Continue from here using a WHILE loop to check if it's a prime number
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1; 

WHILE @i * @i <= @Check_Prime
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;
        BREAK; 
    END

    SET @i = @i + 1;
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

CREATE TABLE Device (
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Hosur'),
(12, 'Hosur'),
(13, 'Hyderabad'),
(13, 'Hyderabad'),
(13, 'Secunderabad'),
(13, 'Secunderabad'),
(13, 'Secunderabad');

WITH LocationCounts AS (
    SELECT
        Device_id,
        Locations,
        COUNT(*) AS LocationCount,
        ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC) AS rn
    FROM
        Device
    GROUP BY
        Device_id,
        Locations
),
DeviceSummary AS (
    SELECT
        Device_id,
        COUNT(*) AS no_of_location,
        SUM(LocationCount) AS no_of_signals
    FROM
        LocationCounts
    GROUP BY
        Device_id
)
SELECT
    ds.Device_id,
    ds.no_of_location,
    lc.Locations AS max_signal_location,
    ds.no_of_signals
FROM
    DeviceSummary ds
JOIN
    LocationCounts lc ON ds.Device_id = lc.Device_id AND lc.rn = 1;

	DROP TABLE Employee;
	CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001, 'Mark', 60000, 2),
(1002, 'Antony', 40000, 2),
(1003, 'Andrew', 15000, 1),
(1004, 'Peter', 35000, 1),
(1005, 'John', 55000, 1),
(1006, 'Albert', 25000, 3),
(1007, 'Donald', 35000, 3);

WITH DepartmentAverages AS (
    SELECT
        DeptID,
        AVG(Salary) AS AverageSalary
    FROM
        Employee
    GROUP BY
        DeptID
)
SELECT
    e.EmpID,
    e.EmpName,
    e.Salary
FROM
    Employee e
JOIN
    DepartmentAverages da ON e.DeptID = da.DeptID
WHERE
    e.Salary > da.AverageSalary;


	-- Winning Numbers
CREATE TABLE WinningNumbers (Number INT);
INSERT INTO WinningNumbers VALUES (25), (45), (78);

-- Tickets
CREATE TABLE Tickets (TicketID VARCHAR(10), Number INT);
INSERT INTO Tickets VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

WITH WinningNumbersCount AS (
    SELECT COUNT(DISTINCT Number) AS TotalWinningNumbers FROM WinningNumbers
),
TicketMatches AS (
    SELECT
        t.TicketId,
        SUM(CASE WHEN t.Number = wn.Number THEN 1 ELSE 0 END) AS MatchingNumbers
    FROM
        Tickets t
    CROSS JOIN
        WinningNumbers wn
    GROUP BY
        t.TicketId
)
SELECT
    SUM(
        CASE
            WHEN tm.MatchingNumbers = wnc.TotalWinningNumbers AND wnc.TotalWinningNumbers = 3 THEN 100 
            WHEN tm.MatchingNumbers > 0 AND tm.MatchingNumbers < wnc.TotalWinningNumbers THEN 10 
            ELSE 0  
        END
    ) AS TotalWinning
FROM
    TicketMatches tm
CROSS JOIN
 WinningNumbersCount wnc;

 CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

WITH CombinedSpending AS (
    SELECT
        us.Spend_date,
        'Both' AS Platform,
        SUM(ps.Total_Amount) AS Total_Amount,  
        COUNT(DISTINCT us.User_id) AS Total_users  
    FROM
        (SELECT DISTINCT Spend_date, User_id FROM Spending) AS us
    JOIN
        PlatformSpending ps ON us.Spend_date = ps.Spend_date  
    GROUP BY
        us.Spend_date  
    HAVING
        COUNT(*) > 1
)
