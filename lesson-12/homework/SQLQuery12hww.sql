--Easy level questions(20)

--What is the result of Ascii('A') in SQL?
SELECT ASCII('A');
--Write a SQL query to get the length of the string 'Hello World' using Len().
SELECT LEN('Hello World');
--How do you reverse a string 'OpenAI' using SQL?
SELECT REVERSE('OpenAI');
--What function would you use to add 5 spaces before a string in SQL?
SELECT CONCAT(SPACE(5), 'HELLO');
--How can you remove leading spaces from the string ' SQL Server'?
SELECT TRIM('SQL Server');
--Write a query that converts the string 'sql' to uppercase.
SELECT UPPER('sql');
--What function would you use to extract the first 3 characters of the string 'Database'?
SELECT LEFT ('Database',3);
--How can you get the last 4 characters from the string 'Technology'?
SELECT RIGHT('Technology',4);
--Use Substring() to get characters from position 3 to position 6 in the string 'Programming'.
SELECT SUBSTRING('Programming',3,4);
--Write a query to concatenate the strings 'SQL' and 'Server' using Concat().
SELECT CONCAT('SQL',' ', 'Server');
--How can you replace all occurrences of 'apple' with 'orange' in the string 'apple pie'?
SELECT REPLACE('apple pie','apple','orange');
--Write a query to find the position of the first occurrence of the word 'learn' in the string 'Learn SQL with LearnSQL'.
SELECT CHARINDEX('learn', LOWER('Learn SQL with LearnSQL'));
--What function can you use to check if the string 'Server' contains 'er' using SQL?
SELECT CASE 
WHEN CHARINDEX('er','Server')>0
then 'Yes'
else 'No'
end as ContainsSubstring;
--How can you split the string 'apple,orange,banana' into individual words using String_split()?
SELECT value 
FROM String_split('apple,orange,banana',',');
--What is the result of the expression Power(2, 3)?
SELECT POWER(2,3);
--Write a query that calculates the square root of 16 using SQL.
SELECT SQRT(16);
--How do you get the current date and time in SQL?
SELECT CURRENT_TIMESTAMP;
--What SQL function would you use to get the current UTC date and time?
SELECT GETUTCDATE();
--How can you get the day of the month from the date '2025-02-03'?
SELECT DAY ('2025-02-03');
--Write a query to add 10 days to the date '2025-02-03' using Dateadd().
SELECT DATEADD(DAY,10,'2025-03-02');

--Medium level questions(20)

--Use Char() to convert the ASCII value 65 to a character.
SELECT CHAR(65);
--What is the difference between Ltrim() and Rtrim() in SQL?
--LTRIM(string) removes leading (left) spaces.

--RTRIM(string) removes trailing (right) spaces.


--Example:

SELECT 
    LTRIM('   SQL  ') AS LeftTrimmed,  
    RTRIM('   SQL  ') AS RightTrimmed;

--Write a query to find the position of the substring 'SQL' in the string 'Learn SQL basics'.
SELECT CHARINDEX('SQL','Learn SQL basics');
--Use Concat_ws() to join 'SQL' and 'Server' with a comma between them.
SELECT CONCAT_WS(' ','SQL','Server');
--How would you replace the substring 'test' with 'exam' using Stuff()?
SELECT STUFF('This is a test', CHARINDEX('test', 'This is a test'), 4, 'exam') AS Result;
 --Write a SQL query to get the square of 7 using Square().
 SELECT SQUARE(7);
 --How do you get the first 5 characters from the string 'International'?
 SELECT LEFT('International',5);
 --Write a query to get the last 2 characters of the string 'Database'.
 SELECT RIGHT('Database',2);
 --What is the result of Patindex('%n%', 'Learn SQL')?
 SELECT Patindex('%n%', 'Learn SQL') AS Result;
 --How do you calculate the difference in days between '2025-01-01' and '2025-02-03' using Datediff()?
SELECT DATEDIFF(DAY, '2025-01-01', '2025-02-03') AS DaysDifference;
--Write a query to return the month from the date '2025-02-03' using Month().
SELECT MONTH('2025-02-03');
--Use DatePart() to extract the year from the date '2025-02-03'.
SELECT DATEPART(YEAR,'2025-02-03');
--How can you get the current system time without the date part in SQL?
SELECT CURRENT_TIMESTAMP;
--What does the function Sysdatetime() return in SQL?
SELECT Sysdatetime() ;
--How would you find the next occurrence of 'Wednesday' from today's date using Dateadd()?
SELECT DATEADD(DAY, (4 - DATEPART(WEEKDAY, CAST('2025-03-29' AS DATE)) + 7) % 7, CAST('2025-03-29' AS DATE));
--What is the difference between Getdate() and Getutcdate()?
SELECT GETDATE() AS LocalTime, GETUTCDATE() AS UTCTime;
--Use Abs() to get the absolute value of -15 in SQL.
SELECT Abs(-15);
--How would you round the number 4.57 to the nearest whole number using Ceiling()?
SELECT Ceiling(4.15);
--Write a SQL query to get the current time using Current_Timestamp.
SELECT Current_Timestamp;
--Use DateName() to return the day name for the date '2025-02-03'.
SELECT DateName(DAY,'2025-02-03');

--Difficult Questions (20)

--Write a query to reverse the string 'SQL Server' and then remove the spaces
SELECT REPLACE(REVERSE('SQL Server'), ' ', '');
--Write a query that uses String_agg() to concatenate all the values in the 'City' column of a table into a single string, separated by commas.
CREATE TABLE Cities (
    ID INT PRIMARY KEY IDENTITY(1,1),
    City NVARCHAR(100)
);

INSERT INTO Cities(City)
VALUES 
    ('New York'),
    ('London'),
    ('Paris'),
    ('Tokyo'),
    ('Berlin'),
    ('Sydney'),
    ('Moscow');
	SELECT* FROM Cities;
SELECT STRING_AGG('City', ', ') AS Cities
FROM Cities;
--Check if a string contains both 'SQL' and 'Server':

SELECT CASE 
    WHEN CHARINDEX('SQL', 'SQL Server') > 0 AND CHARINDEX('Server', 'SQL Server') > 0 
    THEN 'Contains both' 
    ELSE 'Does not contain both' 
END AS Result;


-- Cube of 5 using POWER():

SELECT POWER(5, 3) AS CubeOfFive;


--Split a string by semicolon (;) and return each word as a row:

SELECT value 
FROM STRING_SPLIT('apple;orange;banana', ';');


--Remove leading and trailing spaces using TRIM():

SELECT TRIM(' SQL ') AS TrimmedString;


--Calculate difference in hours between two timestamps:

SELECT DATEDIFF(HOUR, '2025-03-01 08:00:00', '2025-03-01 18:00:00') AS HourDifference;


--Calculate number of months between two dates using DATEPART():

SELECT (DATEPART(YEAR, '2025-02-03') - DATEPART(YEAR, '2023-05-01')) * 12 + 
       (DATEPART(MONTH, '2025-02-03') - DATEPART(MONTH, '2023-05-01')) AS MonthDifference;


-- Find the position of 'SQL' from the end of 'Learn SQL Server':

SELECT LEN('Learn SQL Server') - CHARINDEX('SQL', REVERSE('Learn SQL Server')) + 1 AS PositionFromEnd;


-- Split a comma-separated string using STRING_SPLIT():

SELECT value 
FROM STRING_SPLIT('apple,orange,banana', ',');


--Find number of days from '2025-01-01' to the current date:

SELECT DATEDIFF(DAY, '2025-01-01', GETDATE()) AS DaysDifference;

--Get the first 4 characters of 'Data Science' using LEFT():

SELECT LEFT('Data Science', 4) AS FirstFourCharacters;

--Calculate the square root of 225 and round it up using SQRT() and CEILING():

SELECT CEILING(SQRT(225)) AS RoundedSquareRoot;


--Concatenate two strings with a pipe (|) separator using CONCAT_WS():

SELECT CONCAT_WS('|', 'Hello', 'World') AS ConcatenatedString;


--Find position of the first digit in 'abc123xyz' using PATINDEX():

SELECT PATINDEX('%[0-9]%', 'abc123xyz') AS FirstDigitPosition;


-- Find the second occurrence of 'SQL' in 'SQL Server SQL' using CHARINDEX():

SELECT CHARINDEX('SQL', 'SQL Server SQL', CHARINDEX('SQL', 'SQL Server SQL') + 1) AS SecondOccurrence;


-- Get the year from the current date using DATEPART():

SELECT DATEPART(YEAR, GETDATE()) AS CurrentYear;


--Subtract 100 days from the current date using DATEADD():

SELECT DATEADD(DAY, -100, GETDATE()) AS DateMinus100Days;

--Extract the day of the week from '2025-02-03' using DATENAME():

SELECT DATENAME(WEEKDAY, '2025-02-03') AS DayOfWeek;
-- Get the square of a number using POWER():

SELECT POWER(6, 2) AS SquareOfSix;