/* =========================
   LESSON 16 – CTEs & Derived Tables
   ========================= */

/* === Easy Tasks === */

-- 1. Numbers table 1 to 1000
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 1000
)
SELECT * FROM Numbers
OPTION (MAXRECURSION 1000);

-- 2. Total sales per employee (derived table)
SELECT e.EmployeeID, e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID;

-- 3. Average salary of employees (CTE)
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT AvgSal FROM AvgSalary;

-- 4. Highest sales per product (derived table)
SELECT p.ProductID, p.ProductName, t.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) t ON p.ProductID = t.ProductID;

-- 5. Double numbers starting at 1 until < 1,000,000
WITH Doubles AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n * 2 FROM Doubles WHERE n * 2 < 1000000
)
SELECT * FROM Doubles
OPTION (MAXRECURSION 1000);

-- 6. Employees with more than 5 sales (CTE)
WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SaleCnt
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, e.FirstName, e.LastName
FROM Employees e
JOIN SalesCount s ON e.EmployeeID = s.EmployeeID
WHERE s.SaleCnt > 5;

-- 7. Products with sales > $500 (CTE)
WITH ProductSales AS (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
)
SELECT p.ProductName, ps.TotalSales
FROM Products p
JOIN ProductSales ps ON p.ProductID = ps.ProductID
WHERE ps.TotalSales > 500;

-- 8. Employees with salaries above average (CTE)
WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT *
FROM Employees
WHERE Salary > (SELECT AvgSal FROM AvgSalary);


/* === Medium Tasks === */

-- 9. Top 5 employees by number of orders (derived table)
SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, t.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.OrderCount DESC;

-- 10. Sales per product category (derived table)
SELECT p.CategoryID, SUM(s.SalesAmount) AS TotalSales
FROM Products p
JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.CategoryID;

-- 11. Factorial for each number (Numbers1)
WITH Factorial AS (
    SELECT Number, CAST(Number AS BIGINT) AS Fact, Number AS Step
    FROM Numbers1
    UNION ALL
    SELECT f.Number, f.Fact * f.Step, f.Step - 1
    FROM Factorial f
    WHERE f.Step > 1
)
SELECT Number, MAX(Fact) AS Factorial
FROM Factorial
GROUP BY Number;

-- 12. Split string into rows by character (Example)
WITH Split AS (
    SELECT Id, 1 AS Pos, SUBSTRING(String, 1, 1) AS Ch
    FROM Example
    UNION ALL
    SELECT Id, Pos + 1, SUBSTRING(String, Pos + 1, 1)
    FROM Split
    WHERE Pos < LEN((SELECT String FROM Example e WHERE e.Id = Split.Id))
)
SELECT Id, Ch FROM Split
ORDER BY Id, Pos
OPTION (MAXRECURSION 1000);

-- 13. Sales difference month vs previous month (CTE)
WITH MonthlySales AS (
    SELECT YEAR(SaleDate) AS Y, MONTH(SaleDate) AS M,
           SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT Y, M,
       TotalSales - LAG(TotalSales) OVER (ORDER BY Y, M) AS SalesDiff
FROM MonthlySales;

-- 14. Employees with sales over 45000 per quarter (derived table)
SELECT e.EmployeeID, e.FirstName, e.LastName, t.QuarterSales
FROM Employees e
JOIN (
    SELECT EmployeeID,
           DATEPART(QUARTER, SaleDate) AS Q,
           SUM(SalesAmount) AS QuarterSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) t ON e.EmployeeID = t.EmployeeID;


/* === Difficult Tasks === */

-- 15. Fibonacci numbers (recursion)
WITH Fib AS (
    SELECT 0 AS a, 1 AS b, 1 AS n
    UNION ALL
    SELECT b, a + b, n + 1
    FROM Fib WHERE n < 20
)
SELECT n, a AS Fibonacci FROM Fib
OPTION (MAXRECURSION 100);

-- 16. String where all chars are same and length > 1 (FindSameCharacters)
SELECT *
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(LTRIM(REPLACE(Vals, LEFT(Vals,1), ''))) = 0;

-- 17. Numbers with gradual sequence (n=5 => 1,12,123,1234,12345)
WITH Seq AS (
    SELECT 1 AS n, CAST('1' AS VARCHAR(20)) AS SeqStr
    UNION ALL
    SELECT n+1, SeqStr + CAST(n+1 AS VARCHAR(10))
    FROM Seq WHERE n < 5
)
SELECT * FROM Seq;

-- 18. Employee with most sales last 6 months (derived table)
SELECT TOP 1 e.EmployeeID, e.FirstName, e.LastName, t.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) t ON e.EmployeeID = t.EmployeeID
ORDER BY t.TotalSales DESC;

-- 19. Remove duplicate ints and single-digit ints (RemoveDuplicateIntsFromNames)
SELECT PawanName,
       Pawan_slug_name,
       REPLACE(
           STRING_AGG(val, '') WITHIN GROUP (ORDER BY val),
           '-', ''
       ) AS Cleaned
FROM (
    SELECT PawanName, Pawan_slug_name,
           value AS val
    FROM RemoveDuplicateIntsFromNames
    CROSS APPLY STRING_SPLIT(Pawan_slug_name, '-')
) t
GROUP BY PawanName, Pawan_slug_name;
