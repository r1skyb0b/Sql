/* =====================================================
   LESSON 21 – WINDOW FUNCTIONS SOLUTIONS
   ===================================================== */

----------------------
-- PRODUCTSALES TABLE
----------------------

-- 1. Row number by SaleDate
SELECT SaleID, ProductName, SaleDate,
       ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales;

-- 2. Rank products by total quantity (DENSE_RANK = no gaps)
SELECT ProductName, SUM(Quantity) AS TotalQty,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankNo
FROM ProductSales
GROUP BY ProductName;

-- 3. Top sale per customer
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) t
WHERE rn=1;

-- 4. Current + next sale amount
SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale
FROM ProductSales;

-- 5. Current + previous sale amount
SELECT SaleID, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
FROM ProductSales;

-- 6. Sales greater than previous
SELECT SaleID, SaleAmount
FROM (
    SELECT SaleID, SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE SaleAmount > PrevSale;

-- 7. Diff from previous sale per product
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffPrev
FROM ProductSales;

-- 8. % change vs next sale
SELECT SaleID, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSale,
       CASE WHEN LEAD(SaleAmount) OVER (ORDER BY SaleDate) IS NULL THEN NULL
            ELSE (LEAD(SaleAmount) OVER (ORDER BY SaleDate)-SaleAmount)*100.0/SaleAmount END AS PctChange
FROM ProductSales;

-- 9. Ratio current/previous within product
SELECT SaleID, ProductName, SaleAmount,
       CAST(SaleAmount AS DECIMAL(10,2)) / 
       NULLIF(LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate),0) AS RatioPrev
FROM ProductSales;

-- 10. Diff from first sale of that product
SELECT SaleID, ProductName, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DiffFirst
FROM ProductSales;

-- 11. Continuously increasing sales
SELECT SaleID, ProductName, SaleAmount
FROM (
    SELECT SaleID, ProductName, SaleAmount,
           LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSale
    FROM ProductSales
) t
WHERE PrevSale IS NOT NULL AND SaleAmount > PrevSale;

-- 12. Running total of sales
SELECT SaleID, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM ProductSales;

-- 13. Moving average over last 3 sales
SELECT SaleID, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg3
FROM ProductSales;

-- 14. Difference vs overall avg
SELECT SaleID, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromAvg
FROM ProductSales;


----------------------
-- EMPLOYEES1 TABLE
----------------------

-- 15. Employees with same salary rank
SELECT EmployeeID, Name, Salary,
       DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees1;

-- 16. Top 2 highest salaries per department
SELECT *
FROM (
    SELECT *, DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS rnk
    FROM Employees1
) t
WHERE rnk <= 2;

-- 17. Lowest paid per department
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS rnk
    FROM Employees1
) t
WHERE rnk=1;

-- 18. Running total per department
SELECT EmployeeID, Name, Department, Salary,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Employees1;

-- 19. Total salary per department (no GROUP BY)
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalDeptSalary
FROM Employees1;

-- 20. Avg salary per department (no GROUP BY)
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgDeptSalary
FROM Employees1;

-- 21. Diff vs dept avg
SELECT EmployeeID, Name, Department, Salary,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1;

-- 22. Moving avg salary over 3 employees (current, prev, next)
SELECT EmployeeID, Name, Department, Salary,
       AVG(Salary) OVER (ORDER BY EmployeeID ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees1;

-- 23. Sum of salaries of last 3 hired employees
SELECT SUM(Salary) AS Last3HiredSalary
FROM (
    SELECT Salary,
           ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS rn
    FROM Employees1
) t
WHERE rn <= 3;
