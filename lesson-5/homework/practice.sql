-- ✅ EASY LEVEL TASKS ✅

-- 1. Rename the ProductName column as Name using an alias
SELECT ProductName AS Name
FROM Products;

-- 2. Use an alias to rename the Customers table as Client
SELECT Client.CustomerName, Client.City
FROM Customers AS Client;

-- 3. Use UNION to combine ProductName from Products and Products_Discounted
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 4. Find intersection of Products and Products_Discounted using INTERSECT
SELECT ProductName FROM Products
INTERSECT
SELECT ProductName FROM Products_Discounted;

-- 5. Select distinct customer names and their Country
SELECT DISTINCT CustomerName, Country
FROM Customers;

-- 6. Use CASE to create a conditional column for Price (High or Low)
SELECT ProductName,
       Price,
       CASE 
           WHEN Price > 1000 THEN 'High'
           ELSE 'Low'
       END AS PriceCategory
FROM Products;

-- 7. Use IIF to show 'Yes' if StockQuantity > 100, 'No' otherwise
SELECT ProductName,
       StockQuantity,
       IIF(StockQuantity > 100, 'Yes', 'No') AS InStockOver100
FROM Products_Discounted;

-- ✅ MEDIUM LEVEL TASKS ✅

-- 8. Use UNION again to combine ProductName from Products and Products_Discounted
SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted;

-- 9. Return difference using EXCEPT (Products not in Products_Discounted)
SELECT ProductName FROM Products
EXCEPT
SELECT ProductName FROM Products_Discounted;

-- 10. Conditional column with IIF: 'Expensive' or 'Affordable'
SELECT ProductName,
       Price,
       IIF(Price > 1000, 'Expensive', 'Affordable') AS PriceLabel
FROM Products;

-- 11. Find employees with Age < 25 or Salary > 60000
SELECT * FROM Employees
WHERE Age < 25 OR Salary > 60000;

-- 12. Update salary: increase by 10% if HR or EmployeeID = 5
UPDATE Employees
SET Salary = Salary * 1.10
WHERE Department = 'HR' OR EmployeeID = 5;

-- ✅ HARD LEVEL TASKS ✅

-- 13. Use CASE to assign SaleAmount tiers
SELECT SaleID,
       SaleAmount,
       CASE
           WHEN SaleAmount > 500 THEN 'Top Tier'
           WHEN SaleAmount BETWEEN 200 AND 500 THEN 'Mid Tier'
           ELSE 'Low Tier'
       END AS Tier
FROM Sales;

-- 14. Use EXCEPT to find customers who placed orders but are not in Sales
SELECT CustomerID FROM Orders
EXCEPT
SELECT CustomerID FROM Sales;

-- 15. CASE for discount percentage based on quantity (Orders table)
SELECT CustomerID,
       Quantity,
       CASE
           WHEN Quantity = 1 THEN '3%'
           WHEN Quantity BETWEEN 2 AND 3 THEN '5%'
           ELSE '7%'
       END AS DiscountPercentage
FROM Orders;
