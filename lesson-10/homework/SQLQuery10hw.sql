CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Location VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Rating DECIMAL(3,2),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    EmployeeID INT,
    Amount DECIMAL(10,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    Status VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10,2),
    JobTitle VARCHAR(50),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Temp_Employees (
    EmployeeID INT PRIMARY KEY,
    Salary DECIMAL(10,2),
    DepartmentName VARCHAR(50)
);
-- Insert Customers
INSERT INTO Customers (CustomerID, Name, Location) VALUES
(1, 'Alice', 'New York'),
(2, 'Bob', 'California'),
(3, 'Charlie', 'Texas');

-- Insert Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(101, 1, '2024-03-01', 6000),
(102, 2, '2024-03-05', 4500),
(103, 3, '2024-03-10', 3000);

-- Insert Categories
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

-- Insert Products
INSERT INTO Products (ProductID, Name, CategoryID, Price, Discount, Rating) VALUES
(201, 'Laptop', 1, 1200, 10, 4.5),
(202, 'Sofa', 2, 800, 5, 4.0),
(203, 'T-Shirt', 3, 20, 15, 4.2);

-- Insert Sales
INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate, EmployeeID, Amount) VALUES
(301, 201, 2, '2024-03-02', 1, 2400),
(302, 202, 1, '2024-03-06', 800),
(303, 203, 5, '2024-03-11', 2, 100);

-- Insert Payments
INSERT INTO Payments (PaymentID, OrderID, Status) VALUES
(401, 101, 'Paid'),
(402, 102, 'Pending'),
(403, 103, 'Partially Paid');

-- Insert Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Sales');

-- Insert Employees
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, JobTitle) VALUES
(501, 'David', 1, 7000, 'HR Manager'),
(502, 'Emma', 2, 6500, 'Finance Analyst'),
(503, 'Frank', 3, 5500, 'Sales Executive');

-- Insert Temp Employees



--1. INNER JOIN между Orders и Customers, фильтр по году

SELECT Orders.*, Customers.*  
FROM Orders  
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID  
AND YEAR(Orders.OrderDate) > 2022;

--2. JOIN Employees и Departments с OR

--SELECT Employees.*, Departments.*  
FROM Employees  
JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID  
AND (Departments.Name = 'Sales' OR Departments.Name = 'Marketing');

--3. JOIN с Derived Table (Products > 100)

SELECT p.*, o.*  
FROM (SELECT * FROM Products WHERE Price > 100) AS p  
JOIN Orders o ON p.ProductID = o.ProductID;

--4. JOIN с Temp Table (Temp_Orders)

SELECT t.*, o.*  
FROM Temp_Orders t  
JOIN Orders o ON t.OrderID = o.OrderID;

--5. CROSS APPLY (топ-5 продаж сотрудников)

SELECT e.*, s.*  
FROM Employees e  
CROSS APPLY (  
    SELECT TOP 5 * FROM Sales s  
    WHERE s.EmployeeID = e.EmployeeID  
    ORDER BY s.TotalAmount DESC  
) AS TopSales;

--6. INNER JOIN Customers и Orders с фильтром по году и статусу

SELECT c.*, o.*  
FROM Customers c  
JOIN Orders o ON c.CustomerID = o.CustomerID  
AND YEAR(o.OrderDate) = 2023  
AND c.LoyaltyStatus = 'Gold';

--7. JOIN с Derived Table (количество заказов на клиента)

SELECT c.*, order_counts.OrderCount  
FROM Customers c  
JOIN (  
    SELECT CustomerID, COUNT(*) AS OrderCount  
    FROM Orders  
    GROUP BY CustomerID  
) AS order_counts ON c.CustomerID = order_counts.CustomerID;

--8. JOIN Products и Suppliers с OR

SELECT p.*, s.*  
FROM Products p  
JOIN Suppliers s ON p.SupplierID = s.SupplierID  
AND (s.Name = 'Supplier A' OR s.Name = 'Supplier B');
--
--9. OUTER APPLY (последний заказ каждого сотрудника)

SELECT e.*, last_order.*  
FROM Employees e  
OUTER APPLY (  
    SELECT TOP 1 * FROM Orders o  
    WHERE o.EmployeeID = e.EmployeeID  
    ORDER BY o.OrderDate DESC  
) AS last_order;

--10. CROSS APPLY Departments и TVF (список сотрудников в отделе)

SELECT d.*, emp_list.*  
FROM Departments d  
CROSS APPLY dbo.GetEmployeesInDepartment(d.DepartmentID) AS emp_list

--11. JOIN Orders и Customers с фильтром по сумме заказа

SELECT o.*, c.*  
FROM Orders o  
JOIN Customers c ON o.CustomerID = c.CustomerID  
AND o.TotalAmount > 5000;

--12. JOIN Products и Sales с OR (фильтр по году или скидке)

SELECT p.*, s.*  
FROM Products p  
JOIN Sales s ON p.ProductID = s.ProductID  
AND (YEAR(s.SaleDate) = 2022 OR s.Discount > 20);

--13. JOIN с Derived Table (общие продажи по продукту)

SELECT p.*, sales_summary.TotalSales  
FROM Products p  
JOIN (  
    SELECT ProductID, SUM(Amount) AS TotalSales  
    FROM Sales  
    GROUP BY ProductID  
) AS sales_summary ON p.ProductID = sales_summary.ProductID;

--14. JOIN с Temp Table (Temp_Products)

SELECT t.*, p.*  
FROM Temp_Products t  
JOIN Products p ON t.ProductID = p.ProductID  
AND t.Discontinued = 1;

--15. CROSS APPLY (производительность продаж на сотрудника)

SELECT e.*, sales_perf.*  
FROM Employees e  
CROSS APPLY dbo.GetSalesPerformance(e.EmployeeID) AS sales_perf;

--16. JOIN Employees и Departments с фильтром по зарплате

SELECT e.*, d.*  
FROM Employees e  
JOIN Departments d ON e.DepartmentID = d.DepartmentID  
AND d.Name = 'HR'  
AND e.Salary > 5000;

--17. JOIN Orders и Payments с OR (оплаченные полностью или частично)

SELECT o.*, p.*  
FROM Orders o  
JOIN Payments p ON o.OrderID = p.OrderID  
AND (p.PaymentStatus = 'Paid' OR p.PaymentStatus = 'Partially Paid');

--18. OUTER APPLY (клиенты и их последние заказы)

SELECT c.*, last_order.*  
FROM Customers c  
OUTER APPLY (  
    SELECT TOP 1 * FROM Orders o  
    WHERE o.CustomerID = c.CustomerID  
    ORDER BY o.OrderDate DESC  
) AS last_order;

--19. JOIN Products и Sales с фильтром по рейтингу

SELECT p.*, s.*  
FROM Products p  
JOIN Sales s ON p.ProductID = s.ProductID  
AND YEAR(s.SaleDate) = 2023  
AND p.Rating > 4;

--20. JOIN Employees и Departments с OR (фильтр по отделу или должности)

SELECT e.*, d.*  
FROM Employees e  
JOIN Departments d ON e.DepartmentID = d.DepartmentID  
AND (d.Name = 'Sales' OR e.JobTitle LIKE '%Manager%');

-----21.
SELECT o.OrderID, c.Name, c.Location, c.OrdersCount
FROM Orders o
JOIN Customers c 
ON o.CustomerID = c.CustomerID 
AND c.Location = 'New York' 
AND c.OrdersCount > 10;


--22.
SELECT p.ProductID, p.Name, p.Category, p.Discount, s.TotalPrice
FROM Products p
JOIN Sales s 
ON p.ProductID = s.ProductID 
AND (p.Category = 'Electronics' OR p.Discount > 15);


---23. 
SELECT c.CategoryID, c.CategoryName, prod.ProductCount
FROM Categories c
JOIN (SELECT Category, COUNT(*) AS ProductCount 
      FROM Products 
      GROUP BY Category) prod
ON c.CategoryID = prod.Category;


---24. 
SELECT e.EmployeeID, e.Name, e.Salary, e.Department
FROM Employees e
JOIN Temp_Employees te
ON e.EmployeeID = te.EmployeeID 
AND e.Salary > 4000 
AND e.Department = 'IT';


---25
SELECT d.DepartmentID, d.DepartmentName, emp_count.EmployeeCount
FROM Departments d
CROSS APPLY (SELECT COUNT(*) AS EmployeeCount 
             FROM Employees e 
             WHERE e.Department = d.DepartmentName) emp_count;


---26. 

SELECT o.OrderID, c.Name, o.Amount
FROM Orders o
JOIN Customers c 
ON o.CustomerID = c.CustomerID 
AND c.Location = 'California' 
AND o.Amount > 1000;


---27

SELECT e.EmployeeID, e.Name, e.Department, e.JobTitle
FROM Employees e
JOIN Departments d 
ON e.Department = d.DepartmentName 
AND (e.Department = 'HR' OR e.Department = 'Finance' OR e.JobTitle LIKE '%Executive%');


---28. 
SELECT c.CustomerID, c.Name, COALESCE(o.TotalOrders, 0) AS TotalOrders
FROM Customers c
OUTER APPLY (SELECT COUNT(*) AS TotalOrders 
             FROM Orders o 
             WHERE o.CustomerID = c.CustomerID) o
WHERE o.TotalOrders = 0;


---29. 

SELECT s.SaleID, p.Name, s.Quantity, p.Price
FROM Sales s
JOIN Products p 
ON s.ProductID = p.ProductID 
AND s.Quantity > 100 
AND p.Price > 50;


---30. 

SELECT e.EmployeeID, e.Name, e.Department, e.Salary
FROM Employees e
JOIN Departments d 
ON e.Department = d.DepartmentName 
AND (e.Department = 'Sales' OR e.Department = 'Marketing') 
AND e.Salary > 6000;