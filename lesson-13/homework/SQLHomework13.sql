--🔰 Beginner Level (10 Puzzles)
--1️⃣ Extract a Substring → Extract the first 4 characters from 'DATABASE'.
SELECT SUBSTRING('DATABASE',0,5);
--2️⃣ Find Position of a Word → Find position of 'SQL' in 'I love SQL Server'.
SELECT CHARINDEX('SQL','I love SQL Server');
--3️⃣ Replace a Word → Replace 'World' with 'SQL' in 'Hello World'.
SELECT REPLACE('Hello World','World', 'SQL');
--4️⃣ Find String Length → Find length of 'Microsoft SQL Server'.
SELECT LEN('Microsoft SQL Server');
--5️⃣ Extract Last 3 Characters → Get last 3 characters from 'Database'.
SELECT SUBSTRING('Database',6,3);
--6️⃣ Count a Character → Count occurrences of 'a' in 'apple', 'banana', 'grape'.
SELECT
    (LEN('apple') - LEN(REPLACE('apple', 'a', ''))) AS apple_count,
    (LEN('banana') - LEN(REPLACE('banana', 'a', ''))) AS banana_count,
    (LEN('grape') - LEN(REPLACE('grape', 'a', ''))) AS grape_count;
--7️⃣ Remove Part of a String → Remove first 5 characters from 'abcdefg'.
SELECT SUBSTRING('abcdefg',1,5);
--8️⃣ Extract a Word → Extract second word from 'SQL is powerful', 'I love databases'.
DECLARE @String VARCHAR(255) = 'SQL is powerful';
SELECT  LEFT(SUBSTRING(@String, CHARINDEX(' ', @String) + 1, 255), CHARINDEX(' ', SUBSTRING(@String, CHARINDEX(' ', @String) + 1, 255) + ' ', 1)-1)
--9️⃣ Round a Number → Round 15.6789 to 2 decimal places.
SELECT ROUND(15.6789,2);

--🔟 Absolute Value → Find absolute value of -345.67.
SELECT ABS(-345.67);

--🏆 Intermediate Level (10 Puzzles)

--1️⃣1️⃣ Find Middle Characters → Extract middle 3 characters from 'ABCDEFGHI'.
DECLARE @String VARCHAR(20) = 'ABCDEFGHI';
DECLARE @Length INT = LEN(@String);
SELECT SUBSTRING(@String, (@Length / 2) - 1, 3);
--1️⃣2️⃣ Replace Part of String → Replace first 3 chars of 'Microsoft' with 'XXX'.
SELECT STUFF('Microsoft', 1, 3, 'XXX');
--1️⃣3️⃣ Find First Space → Find position of first space in 'SQL Server 2025'.
SELECT CHARINDEX(' ', 'SQL Server 2025');
--1️⃣4️⃣ Concatenate Names → Join FirstName & LastName with ', '.
SELECT CONCAT('FirstName', ', ', 'LastName');
--1️⃣5️⃣ Find Nth Word → Extract third word from 'The database is very efficient'.
DECLARE @String VARCHAR(255) = 'The database is very efficient';

SELECT PARSENAME(REPLACE(@String, ' ', '.'), 2)

--1️⃣6️⃣ Extract Only Numbers → Get numeric part from 'INV1234', 'ORD5678'.
DECLARE @String VARCHAR(20) = 'INV1234';

SELECT RIGHT(@String, LEN(@String) - PATINDEX('%[0-9]%', @String) + 1);
--1️⃣7️⃣ Round to Nearest Integer → Round 99.5 to the nearest integer.
SELECT ROUND(99.5, 0);
SELECT FLOOR(99.5);
SELECT CEILING(99.5);
--1️⃣8️⃣ Find Day Difference → Days between '2025-01-01' & '2025-03-15'.
SELECT DATEDIFF(day, '2025-01-01', '2025-03-15');

--1️⃣9️⃣ Find Month Name → Retrieve month name from '2025-06-10'.
SELECT DATENAME(month, '2025-06-10');

--2️⃣0️⃣ Calculate Week Number → Week number for '2025-04-22'.
SELECT DATEPART(week, '2025-04-22');

SELECT DATEPART(ISO_WEEK, '2025-04-22');

SELECT DATEPART(YEAR, '2025-04-22');

--🚀 Advanced Level (10 Puzzles)
--2️⃣1️⃣ Extract After '@' → Extract domain from 'user1@gmail.com', 'admin@company.org'.
DECLARE @Email VARCHAR(100) = 'user1@gmail.com';

SELECT SUBSTRING(@Email, CHARINDEX('@', @Email) + 1, LEN(@Email));

--2️⃣2️⃣ Find Last Occurrence → Last 'e' in 'experience'.
DECLARE @String VARCHAR(100) = 'experience';

SELECT  LEN(@String) - CHARINDEX('e',REVERSE(@String)) + 1
--2️⃣3️⃣ Generate Random Number → Random number between 100-500.
SELECT RAND() * (500 - 100) + 100;
SELECT FLOOR(RAND() * (500 - 100 + 1)) + 100;

--2️⃣4️⃣ Format with Commas → Format 9876543 as "9,876,543".
SELECT FORMAT(9876543, 'N0'); 


--2️⃣5️⃣ Extract First Name → Get first name from CREATE TABLE Customers (FullName VARCHAR(100)); INSERT INTO Customers VALUES ('John Doe'), ('Jane Smith').
SELECT
    CASE
        WHEN CHARINDEX(' ', FullName) > 0
        THEN SUBSTRING(FullName, 1, CHARINDEX(' ', FullName) - 1)
        ELSE FullName -- Return the whole name if there's no space
    END
FROM Customers;



--2️⃣6️⃣ Replace Spaces with Dashes → Change 'SQL Server is great' → 'SQL-Server-is-great'.
    SELECT REPLACE('SQL Server is great', ' ', '-'); 
    

--2️⃣7️⃣ Pad with Zeros → Convert 42 to '00042' (5-digit).
    SELECT RIGHT('00000' + CAST(42 AS VARCHAR(5)), 5);
    

--2️⃣8️⃣ Find Longest Word Length → Longest word in 'SQL is fast and efficient'.
DECLARE @String VARCHAR(200) = 'SQL is fast and efficient';

CREATE FUNCTION dbo.fn_SplitString (@String VARCHAR(MAX), @Delimiter VARCHAR(1))
RETURNS @Results TABLE (
  Position INT IDENTITY(1, 1),
  Value VARCHAR(MAX)
)
AS
BEGIN
  DECLARE @StartIndex INT, @EndIndex INT

  SET @StartIndex = 1
  IF SUBSTRING(@String, LEN(@String) - 1, LEN(@String)) <> @Delimiter
  BEGIN
    SET @String = @String + @Delimiter
  END

  WHILE CHARINDEX(@Delimiter, @String, @StartIndex) > 0
  BEGIN
    SET @EndIndex = CHARINDEX(@Delimiter, @String, @StartIndex)

    INSERT INTO @Results(Value)
    SELECT SUBSTRING(@String, @StartIndex, @EndIndex - @StartIndex)

    SET @StartIndex = @EndIndex + 1
  END

  RETURN
END
GO

SELECT MAX(LEN(value)) from dbo.fn_SplitString(@String, ' ')


--2️⃣9️⃣ Remove First Word → Remove first word from 'Error: Connection failed'. Output: : Connection failed'
DECLARE @String VARCHAR(200) = 'Error: Connection failed';

SELECT SUBSTRING(@String, CHARINDEX(' ', @String) + 1, LEN(@String));


--3️⃣0️⃣ Find Time Difference → Minutes between '08:15:00' & '09:45:00'.
    SELECT DATEDIFF(minute, '08:15:00', '09:45:00'); 
    
