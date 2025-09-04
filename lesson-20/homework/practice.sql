/* =====================================================
   LESSON 20 – PRACTICE SOLUTIONS
   ===================================================== */

----------------------
-- 1. March buyers (EXISTS)
----------------------
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND MONTH(s2.SaleDate) = 3
      AND YEAR(s2.SaleDate) = 2024
);

----------------------
-- 2. Product with highest revenue
----------------------
SELECT TOP 1 Product
FROM (
    SELECT Product, SUM(Quantity*Price) AS Revenue
    FROM #Sales
    GROUP BY Product
) t
ORDER BY Revenue DESC;

----------------------
-- 3. Second highest sale amount
----------------------
SELECT MAX(SaleAmount) AS SecondHighest
FROM (
    SELECT Quantity*Price AS SaleAmount
    FROM #Sales
) t
WHERE SaleAmount < (SELECT MAX(Quantity*Price) FROM #Sales);

----------------------
-- 4. Total qty per month (subquery)
----------------------
SELECT MONTH(SaleDate) AS MonthNo,
       (SELECT SUM(s2.Quantity) 
        FROM #Sales s2
        WHERE MONTH(s2.SaleDate)=MONTH(s1.SaleDate)) AS TotalQty
FROM #Sales s1
GROUP BY MONTH(SaleDate);

----------------------
-- 5. Customers who bought same products as others (EXISTS)
----------------------
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.CustomerName <> s2.CustomerName
      AND s1.Product = s2.Product
);

----------------------
-- 6. Fruit pivot
----------------------
SELECT Name,
       SUM(CASE WHEN Fruit='Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit='Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit='Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name;

----------------------
-- 7. Ancestor relationships (recursive)
----------------------
WITH cte AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentId, c.ChildID
    FROM Family f
    JOIN cte c ON f.ChildID = c.ParentId
)
SELECT * FROM cte;

----------------------
-- 8. Orders: TX if CA exists
----------------------
SELECT o.*
FROM #Orders o
WHERE DeliveryState='TX'
  AND EXISTS (
      SELECT 1 FROM #Orders c
      WHERE c.CustomerID=o.CustomerID AND c.DeliveryState='CA'
  );

----------------------
-- 9. Fill missing names
----------------------
UPDATE #residents
SET fullname = SUBSTRING(address, CHARINDEX('name=',address)+5,
               CHARINDEX(' ',address+' ',CHARINDEX('name=',address)+5) - (CHARINDEX('name=',address)+5))
WHERE fullname NOT LIKE '%[A-Za-z]%';

----------------------
-- 10. Routes cheapest & most expensive
----------------------
WITH paths AS (
    SELECT DepartureCity, ArrivalCity, Cost, CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(200)) AS Route
    FROM #Routes
    WHERE DepartureCity='Tashkent'
    UNION ALL
    SELECT p.DepartureCity, r.ArrivalCity, p.Cost+r.Cost, p.Route+' - '+r.ArrivalCity
    FROM paths p
    JOIN #Routes r ON p.ArrivalCity=r.DepartureCity
)
SELECT TOP 1 Route, Cost FROM paths WHERE ArrivalCity='Khorezm' ORDER BY Cost ASC
UNION ALL
SELECT TOP 1 Route, Cost FROM paths WHERE ArrivalCity='Khorezm' ORDER BY Cost DESC;

----------------------
-- 11. Ranking puzzle
----------------------
SELECT ID, Vals,
       ROW_NUMBER() OVER(PARTITION BY Vals ORDER BY ID) AS RankNo
FROM #RankingPuzzle;

----------------------
-- 12. Above dept avg
----------------------
SELECT e.*
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department=e.Department
);

----------------------
-- 13. Highest sales per month (EXISTS)
----------------------
SELECT e1.*
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e1.SalesMonth=e2.SalesMonth
      AND e1.SalesYear=e2.SalesYear
    GROUP BY e2.SalesMonth,e2.SalesYear
    HAVING e1.SalesAmount = MAX(e2.SalesAmount)
);

----------------------
-- 14. Sales in every month (NOT EXISTS)
----------------------
SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
    WHERE SalesYear=2024
    EXCEPT
    SELECT SalesMonth FROM #EmployeeSales e2
    WHERE e1.EmployeeName=e2.EmployeeName
);

----------------------
-- 15. Products > avg price
----------------------
SELECT Name
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

----------------------
-- 16. Products with stock < highest stock
----------------------
SELECT Name
FROM Products
WHERE Stock < (SELECT MAX(Stock) FROM Products);

----------------------
-- 17. Products in same category as Laptop
----------------------
SELECT Name
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE Name='Laptop');

----------------------
-- 18. Price > lowest in Electronics
----------------------
SELECT Name
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category='Electronics');

----------------------
-- 19. Higher than category avg
----------------------
SELECT p.Name
FROM Products p
WHERE Price > (SELECT AVG(Price) FROM Products WHERE Category=p.Category);

----------------------
-- 20. Ordered products
----------------------
SELECT DISTINCT p.Name
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID;

----------------------
-- 21. Ordered > avg qty
----------------------
SELECT p.Name
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID
GROUP BY p.Name
HAVING SUM(o.Quantity) > (SELECT AVG(Quantity) FROM Orders);

----------------------
-- 22. Never ordered
----------------------
SELECT p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o WHERE o.ProductID=p.ProductID
);

----------------------
-- 23. Product with highest total ordered qty
----------------------
SELECT TOP 1 p.Name
FROM Products p
JOIN Orders o ON p.ProductID=o.ProductID
GROUP BY p.Name
ORDER BY SUM(o.Quantity) DESC;
