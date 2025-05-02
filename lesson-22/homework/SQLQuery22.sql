CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

	-- 1. Накопительная сумма продаж по каждому клиенту.
SELECT 
    customer_name, order_date, total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS RunningTotalSales
FROM sales_data;

-- 2. Количество заказов по каждой категории продукта.
SELECT 
    product_category, COUNT(*) AS OrderCount
FROM sales_data
GROUP BY product_category;

-- 3. Максимальная общая сумма по каждой категории продукта.
SELECT 
    product_category, MAX(total_amount) AS MaxTotalAmount
FROM sales_data
GROUP BY product_category;

-- 4. Минимальная цена продуктов по каждой категории продукта.
SELECT 
    product_category, MIN(unit_price) AS MinPrice
FROM sales_data
GROUP BY product_category;

-- 5. Скользящее среднее продаж за 3 дня (предыдущий день, текущий день, следующий день).
SELECT 
    order_date, total_amount,
    AVG(total_amount) OVER (ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAverageSales
FROM sales_data;


-- 6. Общая сумма продаж по каждому региону.
SELECT 
    region, SUM(total_amount) AS TotalSales
FROM sales_data
GROUP BY region;

-- 7. Ранг клиентов на основе их общей суммы покупок.
SELECT 
    customer_name, SUM(total_amount) AS TotalPurchaseAmount,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS CustomerRank
FROM sales_data
GROUP BY customer_name;

-- 8. Разница между текущей и предыдущей суммой продажи для каждого клиента.
SELECT 
    customer_name, order_date, total_amount,
    total_amount - LAG(total_amount, 1, 0) OVER (PARTITION BY customer_name ORDER BY order_date) AS SaleDifference
FROM sales_data;

-- 9. Топ 3 самых дорогих продуктов в каждой категории.
SELECT 
    product_category, [Name], unit_price,
    DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS PriceRank
FROM sales_data
WHERE DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) <= 3
ORDER BY product_category, PriceRank;


-- 10. Накопительная сумма продаж по регионам по дате заказа.
SELECT 
    region, order_date, total_amount,
    SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS CumulativeSales
FROM sales_data;

SELECT 
    category, 
    revenue,
    SUM(revenue) OVER (PARTITION BY product_category ORDER BY product_category) AS CumulativeRevenue
FROM Sales;
-------------------------------------------------

CREATE TABLE SampleData (
    ID INT,
    Value INT
);


INSERT INTO SampleData (ID, Value) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1);


SELECT 
    ID, 
    Value,
    SUM(Value) OVER (ORDER BY ID) AS SumPrevValues
FROM SampleData;

------------------------------------------------------------

CREATE TABLE OneColumn (
    Value SMALLINT
);


INSERT INTO OneColumn (Value) VALUES (10), (20), (30), (40), (100);


SELECT 
    Value,
    SUM(Value) OVER (ORDER BY (SELECT NULL)) - Value AS SumOfPrevious
FROM OneColumn;
-------------------------------------------------------------------
CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);

INSERT INTO Row_Nums VALUES
(101, 'a'), (102, 'b'), (102, 'c'), (103, 'f'), (103, 'e'), (103, 'q'), (104, 'r'), (105, 'p');


WITH RowNumbers AS (
    SELECT 
        Id, 
        Vals,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY (SELECT NULL)) as rn
    FROM Row_Nums
),
AdjustedRowNumbers AS (
  SELECT 
        Id, 
        Vals,
        rn,
        CASE 
            WHEN rn = 1 THEN 2 * (rn) -1
            ELSE rn + (2 * (rn) - 2) -1
        END as RowNumber
    FROM RowNumbers
)
SELECT Id, Vals, RowNumber
FROM AdjustedRowNumbers
ORDER BY RowNumber;

--------------------------------------------------------------------
-- 15. 
SELECT customer_name
FROM sales_data
GROUP BY customer_name
HAVING COUNT(DISTINCT product_category) > 1;


-- 16. 
SELECT customer_name, region, total_amount
FROM sales_data sd
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM sales_data sd2
    WHERE sd2.region = sd.region
);


-- 17. 
SELECT 
    customer_name, region, SUM(total_amount) AS total_spending,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM sales_data
GROUP BY customer_name, region
ORDER BY region, customer_rank;


-- 18.
SELECT 
    customer_id, order_date, total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;


-- 19.
WITH MonthlySales AS (
    SELECT 
        MONTH(order_date) AS sales_month, 
        SUM(total_amount) AS monthly_sales
    FROM sales_data
    GROUP BY MONTH(order_date)
)
SELECT 
    sales_month, monthly_sales,
    (monthly_sales - LAG(monthly_sales, 1, 0) OVER (ORDER BY sales_month)) * 100.0 , LAG(monthly_sales, 1, 1) OVER (ORDER BY sales_month) AS growth_rate
FROM MonthlySales;


-- 20. 
WITH LastOrders AS (
    SELECT customer_id, MAX(order_date) AS last_order_date
    FROM sales_data
    GROUP BY customer_id
)
SELECT sd.customer_name
FROM sales_data sd
JOIN LastOrders lo ON sd.customer_id = lo.customer_id
WHERE sd.total_amount > (
    SELECT total_amount
    FROM sales_data sd2
    WHERE sd2.customer_id = sd.customer_id AND sd2.order_date = lo.last_order_date
);
-----------------------------------------------------------------------------
CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

SELECT ProductID, ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);



WITH GroupSums AS (
    SELECT 
        Grp, 
        SUM(Val1 + Val2) AS GroupSum
    FROM MyData
    GROUP BY Grp
)
SELECT 
    md.Id, md.Grp, md.Val1, md.Val2,
    gs.GroupSum
FROM MyData md
JOIN GroupSums gs ON md.Grp = gs.Grp
ORDER BY md.Grp, md.Id;


-----------------------------------------------------------------
CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);


SELECT
    Id,
    SUM(Cost) AS Cost,
    CASE
        WHEN COUNT(DISTINCT Quantity) > 1 THEN SUM(Quantity)
        ELSE MAX(Quantity)
    END AS Quantity
FROM
    TheSumPuzzle
GROUP BY
    Id;
------------------------------------------------------------
CREATE TABLE testSuXVI (
    Level TINYINT, TyZe TINYINT, Result CHAR(1)
);
INSERT INTO testSuXVI VALUES
(0, 1 ,'X'), (1, 5 ,'X'), (2, 2 ,'X'), (3, 2 ,'Z'), (1, 8 ,'X'), (2, 6 ,'Z'),
(1, 20 ,'X'), (2, 9 ,'X'), (3, 32 ,'X'), (4, 91 ,'Z'), (2, 21 ,'Z'), (3, 30 ,'Z');

SELECT
    Level,
    TyZe,
    Result,
    CASE
        WHEN Result = 'Z' THEN (SELECT SUM(t2.TyZe) FROM testSuXVI t2 WHERE t2.Result = 'Z' AND t2.Level <= t1.Level)
        ELSE 0
    END AS Results
FROM
    testSuXVI t1;
---------------------------------------------------------------
SELECT
    Id,
    Vals,
    (ROW_NUMBER() OVER (ORDER BY Id) +
     CASE
         WHEN ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) = 1 THEN
             CASE WHEN (ROW_NUMBER() OVER (ORDER BY Id), 2) = 1 THEN 1 ELSE 0 END
         ELSE 0
     END + 1
    ) as Changed
FROM
    YourTable;

WITH RankedData AS (
    SELECT
        Id,
        Vals,
        ROW_NUMBER() OVER (ORDER BY Id) as rn,
        ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Id) as rn_partition
    FROM
        YourTable
),
AdjustedData AS (
    SELECT
        Id,
        Vals,
        rn,
        rn_partition,
        CASE
            WHEN rn_partition = 1 AND MOD(rn + 1, 2) = 1 THEN 1
            ELSE 0
        END as adjustment
    FROM
        RankedData
)
SELECT
    Id,
    Vals,
    rn + SUM(adjustment) OVER (ORDER BY rn) + 1 AS Changed
FROM
    AdjustedData
ORDER BY
    rn;
	-------------------------------------------------------------------------