USE PRO;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

SELECT id, name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

DROP TABLE Products;
  CREATE TABLE productss (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO productss (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

SELECT id, product_name, price
FROM productss
WHERE price > (SELECT AVG(price) FROM productss);

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

DROP TABLE Employees 
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

SELECT e.id, e.name, e.department_id
FROM employees e
JOIN departments d ON e.department_id = d.id
WHERE d.department_name = 'Sales';


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

USE md;
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

WITH RankedProducts AS (
    SELECT
        id,
        product_name,
        price,
        category_id,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM
        products
)
SELECT id, product_name, price, category_id
FROM RankedProducts
WHERE rn = 1;

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

WITH DepartmentAvgSalaries AS (
    SELECT
        department_id,
        AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
    FROM
        employees
),
RankedDepartments AS (
    SELECT
        department_id,
        avg_salary,
        RANK() OVER (ORDER BY avg_salary DESC) AS salary_rank
    FROM
        DepartmentAvgSalaries
)
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
JOIN RankedDepartments rd ON e.department_id = rd.department_id
WHERE rd.salary_rank = 1;

DROP TABLE Employees;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

WITH DepartmentAvgSalaries AS (
    SELECT
        id,
        name,
        salary,
        department_id,
        AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
    FROM
        employees
)
SELECT id, name, salary, department_id
FROM DepartmentAvgSalaries
WHERE salary > avg_salary;


DROP TABLE Students;
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

WITH RankedGrades AS (
    SELECT
        student_id,
        course_id,
        grade,
        ROW_NUMBER() OVER (PARTITION BY course_id ORDER BY grade DESC) AS rank_num
    FROM
        grades
)
SELECT
    s.name,
    rg.course_id,
    rg.grade
FROM
    RankedGrades rg
JOIN
    students s ON rg.student_id = s.student_id
WHERE
    rg.rank_num = 1;

DROP TABLE products;
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);


WITH RankedProducts AS (
    SELECT
        id,
        product_name,
        price,
        category_id,
        RANK() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
    FROM
        products
)
SELECT id, product_name, price, category_id
FROM RankedProducts
WHERE price_rank = 3;

DROP TABLE employees;
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

WITH CompanyStats AS (
    SELECT AVG(salary) AS company_avg_salary, MAX(salary) as company_max_salary
    FROM employees
),
DepartmentMaxSalaries AS (
    SELECT department_id, MAX(salary) AS department_max_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.id, e.name, e.salary, e.department_id
FROM employees e
JOIN DepartmentMaxSalaries dms ON e.department_id = dms.department_id
JOIN CompanyStats cs ON 1=1
WHERE e.salary > cs.company_avg_salary AND e.salary < dms.department_max_salary;


