--1. INNER JOIN Employees и Departments 
SELECT Employees.EmployeeName, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.Salary > 5000;


---2. INNER JOIN Customers и Orders

SELECT Customers.CustomerName, Orders.OrderID, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE YEAR(Orders.OrderDate) = 2023;


---3. LEFT OUTER JOIN Employees и Departments 

SELECT Employees.EmployeeName, COALESCE(Departments.DepartmentName, 'No Department') AS DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;


---4. RIGHT OUTER JOIN Products и Suppliers 
SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
RIGHT JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;


---5. FULL OUTER JOIN Orders и Payments 
SELECT Orders.OrderID, Payments.PaymentID, Orders.OrderAmount, Payments.PaymentAmount
FROM Orders
FULL OUTER JOIN Payments ON Orders.OrderID = Payments.OrderID;


---6. SELF JOIN Employees 

SELECT E1.EmployeeName AS Employee, E2.EmployeeName AS Manager
FROM Employees E1
LEFT JOIN Employees E2 ON E1.ManagerID = E2.EmployeeID;


---7 JOIN + WHERE 

SELECT Products.ProductName, Sales.SalesAmount
FROM Products
INNER JOIN Sales ON Products.ProductID = Sales.ProductID
WHERE Sales.SalesAmount > 100;


---8. INNER JOIN Students и Courses 

SELECT Students.StudentName, Courses.CourseName
FROM Students
INNER JOIN StudentCourses ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses ON StudentCourses.CourseID = Courses.CourseID
WHERE Courses.CourseName = 'Math 101';


---9. INNER JOIN Customers и Orders 
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName
HAVING COUNT(Orders.OrderID) > 3;


---10. LEFT OUTER JOIN Employees  Departments 
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'HR';

--11. INNER JOIN Employees и Departments (фильтр: отделы с >10 сотрудниками)

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.DepartmentID IN (
    SELECT DepartmentID
    FROM Employees
    GROUP BY DepartmentID
    HAVING COUNT(EmployeeID) > 10
);


---12. LEFT OUTER JOIN Products и Sales 

SELECT Products.ProductName
FROM Products
LEFT JOIN Sales ON Products.ProductID = Sales.ProductID
WHERE Sales.ProductID IS NULL;


---13. RIGHT OUTER JOIN Customers и Orders 

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NOT NULL;


---14. FULL OUTER JOIN Employees и Departments 

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
FULL OUTER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName IS NOT NULL;


---15. SELF JOIN Employees 
SELECT E1.EmployeeName AS Employee1, E2.EmployeeName AS Employee2, E1.ManagerID
FROM Employees E1
JOIN Employees E2 ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID <> E2.EmployeeID;


---16. LEFT OUTER JOIN Orders и Customers 

SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
LEFT JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(Orders.OrderDate) = 2022;


---17. INNER JOIN Employees и Departments

SELECT Employees.EmployeeName, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Sales' AND Employees.Salary > 5000;


---18. INNER JOIN Employees и Departments 

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'IT';


---19. FULL OUTER JOIN Orders и Payments 

SELECT Orders.OrderID, Payments.PaymentID, Orders.OrderAmount, Payments.PaymentAmount
FROM Orders
FULL OUTER JOIN Payments ON Orders.OrderID = Payments.OrderID
WHERE Payments.PaymentID IS NOT NULL;


---20. LEFT OUTER JOIN Products и Orders 
SELECT Products.ProductName
FROM Products
LEFT JOIN Orders ON Products.ProductID = Orders.ProductID
WHERE Orders.ProductID IS NULL;

--21. INNER JOIN Employees и Departments 
SELECT Employees.EmployeeName, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.Salary > (
    SELECT AVG(Salary)
    FROM Employees AS e2
    WHERE e2.DepartmentID = Employees.DepartmentID
);


---22. LEFT OUTER JOIN Orders и Payments 

SELECT Orders.OrderID, Orders.OrderDate, Payments.PaymentID
FROM Orders
LEFT JOIN Payments ON Orders.OrderID = Payments.OrderID
WHERE Orders.OrderDate < '2020-01-01' AND Payments.PaymentID IS NULL;


---23. FULL OUTER JOIN Products и Categories 
SELECT Products.ProductName, Categories.CategoryName
FROM Products
FULL OUTER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryID IS NULL;


---24. SELF JOIN Employees 

SELECT E1.EmployeeName AS Employee1, E2.EmployeeName AS Employee2, E1.ManagerID, E1.Salary
FROM Employees E1
JOIN Employees E2 ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID <> E2.EmployeeID
WHERE E1.Salary > 5000;


---25. RIGHT OUTER JOIN Employees и Departments 

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName LIKE 'M%';


---26. Разница между ON и WHERE при JOIN (Sales > 1000)


SELECT Products.ProductName, Sales.SalesAmount
FROM Products
INNER JOIN Sales ON Products.ProductID = Sales.ProductID AND Sales.SalesAmount > 1000;


SELECT Products.ProductName, Sales.SalesAmount
FROM Products
INNER JOIN Sales ON Products.ProductID = Sales.ProductID
WHERE Sales.SalesAmount > 1000;


---27. LEFT OUTER JOIN Students и Courses 
SELECT Students.StudentName
FROM Students
LEFT JOIN StudentCourses ON Students.StudentID = StudentCourses.StudentID
LEFT JOIN Courses ON StudentCourses.CourseID = Courses.CourseID
WHERE Courses.CourseName IS NULL OR Courses.CourseName <> 'Math 101';


---28. FULL OUTER JOIN Orders и Payments 
SELECT Orders.OrderID, Orders.OrderAmount, Payments.PaymentID
FROM Orders
FULL OUTER JOIN Payments ON Orders.OrderID = Payments.OrderID
WHERE Payments.PaymentID IS NOT NULL;


---29. INNER JOIN Products и Categories 

SELECT Products.ProductName, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName IN ('Electronics', 'Furniture');


---30. CROSS JOIN Customers и Orders 

SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS OrderCount
FROM Customers
CROSS JOIN Orders
WHERE YEAR(Orders.OrderDate) = 2023
GROUP BY Customers.CustomerName
HAVING COUNT(Orders.OrderID) > 2;

