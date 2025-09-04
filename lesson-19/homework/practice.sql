/* --------------------------
   PART 1: STORED PROCEDURES
   -------------------------- */

-- Task 1: Employee Bonus
CREATE PROCEDURE GetEmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus
    SELECT e.EmployeeID,
           e.FirstName + ' ' + e.LastName,
           e.Department,
           e.Salary,
           e.Salary * db.BonusPercentage / 100
    FROM Employees e
    JOIN DepartmentBonus db ON e.Department = db.Department;

    SELECT * FROM #EmployeeBonus;
END;
GO


-- Task 2: Increase salary by department
CREATE PROCEDURE UpdateDepartmentSalary
    @Dept NVARCHAR(50),
    @IncreasePercent DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + Salary * @IncreasePercent / 100
    WHERE Department = @Dept;

    SELECT * FROM Employees WHERE Department = @Dept;
END;
GO


/* --------------------------
   PART 2: MERGE TASKS
   -------------------------- */

-- Task 3: MERGE Products
MERGE Products_Current AS tgt
USING Products_New AS src
ON tgt.ProductID = src.ProductID
WHEN MATCHED THEN
    UPDATE SET tgt.ProductName = src.ProductName,
               tgt.Price = src.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (src.ProductID, src.ProductName, src.Price)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;


-- Task 4: Tree Node
SELECT id,
       CASE 
            WHEN p_id IS NULL THEN 'Root'
            WHEN id IN (SELECT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
            ELSE 'Leaf'
       END AS type
FROM Tree;


-- Task 5: Confirmation Rate
SELECT s.user_id,
       ISNULL(CAST(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 /
                   NULLIF(COUNT(c.user_id),0) AS DECIMAL(3,2)), 0) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id;


-- Task 6: Employees with lowest salary
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);


-- Task 7: Get Product Sales Summary
CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT p.ProductName,
           SUM(s.Quantity) AS TotalQuantity,
           SUM(s.Quantity * p.Price) AS TotalSalesAmount,
           MIN(s.SaleDate) AS FirstSaleDate,
           MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
GO
