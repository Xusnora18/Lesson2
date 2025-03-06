1. Define and Explain the Purpose of BULK INSERT in SQL Server

BULK INSERT is used to quickly load large amounts of data from an external file into a SQL Server table. It is faster than using INSERT INTO and is useful for importing large datasets.

Example:

BULK INSERT Products  
FROM 'C:\data\products.csv'  
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');


---

2. Four File Formats That Can Be Imported into SQL Server

1. CSV (Comma-Separated Values)


2. JSON (JavaScript Object Notation)


3. XML (Extensible Markup Language)


4. Excel (XLSX/XLS)




---

3. Create a Table "Products"

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);


---

4. Insert Three Records into the Products Table

INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
    (1, 'Laptop', 1200.50),
    (2, 'Mouse', 25.99),
    (3, 'Keyboard', 45.75);


---

5. Explain the Difference Between NULL and NOT NULL with Examples

NULL means the value is missing or unknown.

NOT NULL ensures that a column cannot have NULL values, meaning it must always have a valid entry.


Example:

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,  -- This column cannot be NULL
    Email VARCHAR(100) NULL             -- This column can have NULL values
);


---

6. Add a UNIQUE Constraint to the ProductName Column in Products Table

ALTER TABLE Products  
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);


---

7. Write a Comment in a SQL Query Explaining Its Purpose

-- Insert a new product into the Products table
INSERT INTO Products (ProductID, ProductName, Price)  
VALUES (4, 'Monitor', 150.99);


---

8. Create a Table "Categories" with a Primary Key on CategoryID and a Unique Constraint on CategoryName

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);


---

9. Export Data from the Products Table to a CSV File Using SSMS

You can use bcp (Bulk Copy Program) in SQL Server:

EXEC xp_cmdshell 'bcp "SELECT * FROM MyDatabase.dbo.Products" queryout "C:\data\products_export.csv" -c -t, -T -S YOUR_SERVER_NAME';

Alternatively, use SQL Server Management Studio (SSMS):

1. Right-click the database → Tasks → Export Data.


2. Choose Flat File Destination.


3. Specify the file path (.csv).


4. Select Products table and export.




---

10. Explain the Purpose of the IDENTITY Column in SQL Server

The IDENTITY column in SQL Server automatically generates unique values for each new row. It is commonly used for primary keys.

Example:

CREATE TABLE Orders (
    OrderID INT IDENTITY(100,10) PRIMARY KEY,  -- Starts at 100, increments by 10
    OrderDate DATETIME DEFAULT GETDATE()
);

In this example:

The first record will have OrderID = 100,

The second record will have OrderID = 110,

The third record will have OrderID = 120, and so on.