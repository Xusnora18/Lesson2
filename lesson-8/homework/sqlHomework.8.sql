
--1. INNER JOIN 

SELECT Customers.CustomerName, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


---2. One-to-One

SELECT Employees.EmployeeID, Employees.EmployeeName, EmployeeDetails.Address, EmployeeDetails.PhoneNumber
FROM Employees
INNER JOIN EmployeeDetails ON Employees.EmployeeID = EmployeeDetails.EmployeeID;


---3. INNER JOIN 
SELECT Products.ProductName, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID;


---4. LEFT JOIN 
SELECT Customers.CustomerName, Orders.OrderDate
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


---5. Many-to-Many

SELECT Orders.OrderID, Customers.CustomerName, Products.ProductName, OrderDetails.Quantity
FROM Orders
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;


---6. CROSS JOIN Products 
SELECT Products.ProductName, Categories.CategoryName
FROM Products
CROSS JOIN Categories;


---7. One-to-Many
SELECT Customers.CustomerName, Orders.OrderID, Orders.OrderDate
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


---8. CROSS JOIN + WHERE 
SELECT Products.ProductName, Orders.OrderID, Orders.OrderAmount
FROM Products
CROSS JOIN Orders
WHERE Orders.OrderAmount > 500;


---

---9. INNER JOIN

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;


---

--10. INNER JOIN 
SELECT A.Column1, B.Column2
FROM TableA A
INNER JOIN TableB B ON A.SomeColumn <> B.SomeColumn;

--

--11. One-to-Many
SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName;


---

--12. Many-to-Many

SELECT Students.StudentName, Courses.CourseName
FROM Students
INNER JOIN StudentCourses ON Students.StudentID = StudentCourses.StudentID
INNER JOIN Courses ON StudentCourses.CourseID = Courses.CourseID;


---

--13. CROSS JOIN Employees
SELECT Employees.EmployeeName, Departments.DepartmentName, Employees.Salary
FROM Employees
CROSS JOIN Departments
WHERE Employees.Salary > 5000;


---

--14. One-to-One: Employees 

SELECT Employees.EmployeeName, EmployeeDetails.Address, EmployeeDetails.PhoneNumber
FROM Employees
INNER JOIN EmployeeDetails ON Employees.EmployeeID = EmployeeDetails.EmployeeID;


---

--15. INNER JOIN Products 

SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Suppliers.SupplierName = 'Supplier A';


---

--16. LEFT JOIN Products 
SELECT Products.ProductName, COALESCE(Sales.Quantity, 0) AS SalesQuantity
FROM Products
LEFT JOIN Sales ON Products.ProductID = Sales.ProductID;


---

--17. INNER JOIN Employees 

SELECT Employees.EmployeeName, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Employees.Salary > 4000 AND Departments.DepartmentName = 'HR';


---

--18. JOIN

SELECT A.Column1, B.Column2
FROM TableA A
INNER JOIN TableB B ON A.SomeValue >= B.SomeValue;




---

--19. INNER JOIN 
SELECT Products.ProductName, Products.Price, Suppliers.SupplierName
FROM Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Products.Price >= 50;


---

--20. CROSS JOIN Sales 
SELECT Sales.SalesAmount, Regions.RegionName
FROM Sales
CROSS JOIN Regions
WHERE Sales.SalesAmount > 1000;

--21. Many-to-Many: Authors и Books 

SELECT Authors.AuthorName, Books.BookTitle
FROM Authors
INNER JOIN AuthorBooks ON Authors.AuthorID = AuthorBooks.AuthorID
INNER JOIN Books ON AuthorBooks.BookID = Books.BookID;


--22. INNER JOIN Products и Categories 

SELECT Products.ProductName, Categories.CategoryName
FROM Products
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName <> 'Electronics';


---23. CROSS JOIN Orders и Products + фильтр (количество > 100)

SELECT Orders.OrderID, Products.ProductName, Orders.Quantity
FROM Orders
CROSS JOIN Products
WHERE Orders.Quantity > 100;


---24. INNER JOIN Employees и Departments 

SELECT Employees.EmployeeName, Employees.YearsOfService, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
AND Employees.YearsOfService > 5;


---25. 
SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
INNER JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;

-- LEFT JOIN (все сотрудники, включая тех, у кого нет отдела)
SELECT Employees.EmployeeName, COALESCE(Departments.DepartmentName, 'No Department') AS DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID;


---26. 

SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
CROSS JOIN Suppliers
WHERE Products.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName = 'Category A');


---27.

SELECT Customers.CustomerName, COUNT(Orders.OrderID) AS TotalOrders
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerName
HAVING COUNT(Orders.OrderID) >= 10;


---28.
SELECT Courses.CourseName, COUNT(StudentCourses.StudentID) AS EnrolledStudents
FROM Courses
LEFT JOIN StudentCourses ON Courses.CourseID = StudentCourses.CourseID
GROUP BY Courses.CourseName;


---29.

SELECT Employees.EmployeeName, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'Marketing';


---30. JOIN <= в ON

SELECT A.Column1, B.Column2
FROM TableA A
INNER JOIN TableB B ON A.SomeValue <= B.SomeValue;