-- 1. Temporary table: MonthlySales
SELECT p.ProductID,
       SUM(s.Quantity) AS TotalQuantity,
       SUM(s.Quantity * p.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE MONTH(s.SaleDate) = MONTH(GETDATE())
  AND YEAR(s.SaleDate) = YEAR(GETDATE())
GROUP BY p.ProductID;

SELECT * FROM #MonthlySales;


-- 2. View: vw_ProductSalesSummary
CREATE VIEW vw_ProductSalesSummary AS
SELECT p.ProductID, p.ProductName, p.Category,
       SUM(s.Quantity) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category;


-- 3. Function: fn_GetTotalRevenueForProduct
CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);
    SELECT @Revenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    JOIN Products p ON s.ProductID = p.ProductID
    WHERE p.ProductID = @ProductID;
    RETURN @Revenue;
END;


-- 4. Function: fn_GetSalesByCategory
CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
    SELECT p.ProductName,
           SUM(s.Quantity) AS TotalQuantity,
           SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName;


-- 5. Function: fn_IsPrime
CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    IF @Number < 2 RETURN 'No';
    DECLARE @i INT = 2;
    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0 RETURN 'No';
        SET @i += 1;
    END
    RETURN 'Yes';
END;


-- 6. Function: fn_GetNumbersBetween
CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Nums TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Nums VALUES (@i);
        SET @i += 1;
    END
    RETURN;
END;


-- 7. Nth Highest Salary
-- Replace N with desired number
SELECT DISTINCT salary AS HighestNSalary
FROM Employee
ORDER BY salary DESC
OFFSET (N-1) ROWS FETCH NEXT 1 ROWS ONLY;


-- 8. Person with most friends
SELECT TOP 1 id, COUNT(*) AS num
FROM (
    SELECT requester_id AS id, accepter_id AS friend FROM RequestAccepted
    UNION ALL
    SELECT accepter_id, requester_id FROM RequestAccepted
) f
GROUP BY id
ORDER BY num DESC;


-- 9. View: vw_CustomerOrderSummary
CREATE VIEW vw_CustomerOrderSummary AS
SELECT c.customer_id, c.name,
       COUNT(o.order_id) AS total_orders,
       SUM(o.amount) AS total_amount,
       MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;


-- 10. Fill Missing Gaps
SELECT RowNumber,
       MAX(TestCase) OVER (ORDER BY RowNumber
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Workflow
FROM Gaps
ORDER BY RowNumber;
