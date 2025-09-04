----------------------------------------------------
-- LESSON 14: DATE AND TIME FUNCTIONS - PRACTICE
----------------------------------------------------

----------------------------------------------------
-- EASY TASKS
----------------------------------------------------

-- 1. Split Name by comma into Name and Surname
SELECT 
  LEFT(Name, CHARINDEX(',', Name) - 1) AS Name,
  LTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name))) AS Surname
FROM TestMultipleColumns;

-- 2. Find strings containing '%' character
SELECT *
FROM TestPercent
WHERE colname LIKE '%[%]%';

-- 3. Split string based on dot (.)
SELECT value AS part
FROM STRING_SPLIT((SELECT stringcol FROM Splitter), '.');

-- 4. Replace all digits with 'X'
SELECT TRANSLATE('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') AS result;

-- 5. Rows where Vals contains more than two dots
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

-- 6. Count spaces in string
SELECT LEN(stringcol) - LEN(REPLACE(stringcol, ' ', '')) AS space_count
FROM CountSpaces;

-- 7. Employees earning more than their managers
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Salary
FROM Employee e
JOIN Employee m ON e.ManagerID = m.EmployeeID
WHERE e.Salary > m.Salary;

-- 8. Employees with 10–15 years of service
SELECT EmployeeID, FirstName, LastName, HireDate,
       DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 10 AND 14;


----------------------------------------------------
-- MEDIUM TASKS
----------------------------------------------------

-- 1. Separate integers and characters
SELECT 
  STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Numbers,
  STRING_AGG(CASE WHEN ch LIKE '[^0-9]' THEN ch END, '') AS Letters
FROM STRING_SPLIT('rtcfvty34redt', '') AS s(ch);

-- 2. Weather: higher temp than yesterday
SELECT w1.id
FROM weather w1
JOIN weather w2 ON w1.recordDate = DATEADD(DAY, 1, w2.recordDate)
WHERE w1.temperature > w2.temperature;

-- 3. First login date per player
SELECT player_id, MIN(login_date) AS first_login
FROM Activity
GROUP BY player_id;

-- 4. Return the third item from list
SELECT value AS third_item
FROM STRING_SPLIT((SELECT fruits FROM fruits), ',')
ORDER BY (SELECT NULL)
OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY;

-- 5. Each character becomes a row
SELECT value AS ch
FROM STRING_SPLIT('sdgfhsdgfhs@121313131', '');

-- 6. Join p1 and p2, replacing 0 code with p2.code
SELECT p1.id, 
       CASE WHEN p1.code = 0 THEN p2.code ELSE p1.code END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

-- 7. Employment Stage based on hire_date
SELECT EmployeeID, FirstName, LastName, HireDate,
       CASE 
         WHEN DATEDIFF(YEAR, HireDate, GETDATE()) < 1 THEN 'New Hire'
         WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
         WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
         WHEN DATEDIFF(YEAR, HireDate, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
         ELSE 'Veteran'
       END AS EmploymentStage
FROM Employees;

-- 8. Extract integer at start of string
SELECT LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) AS starting_number
FROM GetIntegers;


----------------------------------------------------
-- DIFFICULT TASKS
----------------------------------------------------

-- 1. Swap the first two letters of comma-separated string
SELECT STRING_AGG(
         STUFF(val, 1, 2, RIGHT(LEFT(val, 2), 1) + LEFT(LEFT(val, 2), 1)), ','
       ) AS swapped
FROM STRING_SPLIT((SELECT vals FROM MultipleVals), ',') s(val);

-- 2. Device first logged in per player
SELECT player_id, device_id
FROM Activity a
WHERE login_date = (
    SELECT MIN(login_date) FROM Activity WHERE player_id = a.player_id
);

-- 3. Week-on-week percentage of sales per area
SELECT Area, Week, Day,
       100.0 * SUM(Sales) / SUM(SUM(Sales)) OVER (PARTITION BY Area, Week) AS pct_sales
FROM WeekPercentagePuzzle
GROUP BY Area, Week, Day;
