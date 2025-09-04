/* ======================
   PUZZLE SECTION
   ====================== */

-- Puzzle 1: Extract month with leading zero
SELECT Id,
       Dt,
       RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;


-- Puzzle 2: Distinct Ids, SUM of Max Vals per Id & rID
SELECT COUNT(DISTINCT Id) AS Distinct_Ids,
       rID,
       SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) t
GROUP BY rID;


-- Puzzle 3: Records with length between 6 and 10
SELECT Id, Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;


-- Puzzle 4: Get max Vals per ID with Item
SELECT t.ID, t.Item, t.Vals
FROM TestMaximum t
JOIN (
    SELECT ID, MAX(Vals) AS MaxVals
    FROM TestMaximum
    GROUP BY ID
) m ON t.ID = m.ID AND t.Vals = m.MaxVals;


-- Puzzle 5: Max per DetailedNumber then sum per Id
SELECT Id, SUM(MaxVals) AS SumOfMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) t
GROUP BY Id;


-- Puzzle 6: Difference a-b, replace zero with blank
SELECT Id, a, b,
       CASE 
           WHEN a - b = 0 THEN ''
           ELSE CAST(a - b AS VARCHAR)
       END AS OUTPUT
FROM TheZeroPuzzle;


/* ======================
   SALES & CUSTOMERS QUERIES
   ====================== */

-- Q1: Total revenue (Quantity * UnitPrice)
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

-- Q2: Average unit price
SELECT AVG(UnitPrice) AS AvgUnitPrice
FROM Sales;

-- Q3: Number of sales transactions
SELECT COUNT(*) AS TotalTransactions
FROM Sales;

-- Q4: Highest number of units sold in single transaction
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

-- Q5: Products sold per category
SELECT Category, SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;

-- Q6: Total revenue per region
SELECT Region, SUM(QuantitySold * UnitPrice) AS Revenue
FROM Sales
GROUP BY Region;

-- Q7: Product with highest revenue
SELECT TOP 1 Product,
       SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- Q8: Running total revenue by date
SELECT SaleDate,
       SUM(QuantitySold * UnitPrice) AS DailyRevenue,
       SUM(SUM(QuantitySold * UnitPrice)) OVER (ORDER BY SaleDate) AS RunningTotal
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

-- Q9: Category contribution to total revenue
SELECT Category,
       SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
       CAST(SUM(QuantitySold * UnitPrice) * 100.0 /
            SUM(SUM(QuantitySold * UnitPrice)) OVER () AS DECIMAL(5,2)) AS PercentageContribution
FROM Sales
GROUP BY Category;


/* ======================
   CUSTOMERS & SALES
   ====================== */

-- Show all sales with customer names
SELECT s.SaleID, s.Product, s.QuantitySold, s.UnitPrice, s.SaleDate,
       c.CustomerName, c.Region
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID;

-- Customers with no purchases
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.SaleID IS NULL;

-- Total revenue per customer
SELECT c.CustomerID, c.CustomerName,
       SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

-- Customer with max revenue
SELECT TOP 1 c.CustomerID, c.CustomerName,
       SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- Total sales per customer (just units sold)
SELECT c.CustomerID, c.CustomerName,
       SUM(s.QuantitySold) AS TotalUnits
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName;


/* ======================
   PRODUCTS QUERIES
   ====================== */

-- Products sold at least once
SELECT DISTINCT p.ProductID, p.ProductName
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

-- Most expensive product (by SellingPrice)
SELECT TOP 1 ProductID, ProductName, SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- Products with selling price > category average
SELECT p.ProductID, p.ProductName, p.Category, p.SellingPrice
FROM Products p
JOIN (
    SELECT Category, AVG(SellingPrice) AS AvgPrice
    FROM Products
    GROUP BY Category
) c ON p.Category = c.Category
WHERE p.SellingPrice > c.AvgPrice;
