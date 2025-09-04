/* ======================
   LESSON 17 – Practice
   ====================== */

/* === 1. Distributors and their sales by region (fill missing with 0) === */
SELECT r.Region, d.Distributor, ISNULL(rs.Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) r
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) d
LEFT JOIN #RegionSales rs
    ON r.Region = rs.Region AND d.Distributor = rs.Distributor
ORDER BY d.Distributor, r.Region;


/* === 2. Managers with at least five direct reports === */
SELECT m.name
FROM Employee m
JOIN Employee e ON m.id = e.managerId
GROUP BY m.id, m.name
HAVING COUNT(*) >= 5;


/* === 3. Products with at least 100 units ordered in Feb 2020 === */
SELECT p.product_name, SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_date >= '2020-02-01' AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100;


/* === 4. Vendor from which each customer placed the most orders === */
WITH VendorCount AS (
    SELECT CustomerID, Vendor, COUNT(*) AS OrderCount,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM Orders
    GROUP BY CustomerID, Vendor
)
SELECT CustomerID, Vendor
FROM VendorCount
WHERE rn = 1;


/* === 5. Prime number check === */
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2, @isPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @i += 1;
END

IF @isPrime = 1 AND @Check_Prime > 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';


/* === 6. Device signals analysis === */
WITH CountSignals AS (
    SELECT Device_id, Locations, COUNT(*) AS SignalCnt
    FROM Device
    GROUP BY Device_id, Locations
),
MaxLoc AS (
    SELECT Device_id, Locations,
           ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC) AS rn
    FROM Device
    GROUP BY Device_id, Locations
)
SELECT c.Device_id,
       COUNT(DISTINCT c.Locations) AS no_of_location,
       m.Locations AS max_signal_location,
       SUM(c.SignalCnt) AS no_of_signals
FROM CountSignals c
JOIN MaxLoc m ON c.Device_id = m.Device_id AND m.rn = 1
GROUP BY c.Device_id, m.Locations;


/* === 7. Employees earning more than average in their department === */
WITH DeptAvg AS (
    SELECT DeptID, AVG(Salary) AS AvgSal
    FROM Employee
    GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN DeptAvg d ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSal;


/* === 8. Lottery winnings === */
WITH TicketMatch AS (
    SELECT t.TicketID, COUNT(DISTINCT t.Number) AS Matches
    FROM Tickets t
    JOIN Numbers n ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT SUM(CASE WHEN Matches = (SELECT COUNT(*) FROM Numbers) THEN 100
                WHEN Matches > 0 THEN 10
                ELSE 0 END) AS TotalWinnings
FROM TicketMatch;


/* === 9. Spending analysis === */
WITH Base AS (
    SELECT Spend_date, User_id,
           SUM(CASE WHEN Platform = 'Mobile' THEN Amount ELSE 0 END) AS Mobile,
           SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS Desktop
    FROM Spending
    GROUP BY Spend_date, User_id
)
SELECT Spend_date, 'Mobile' AS Platform, SUM(Mobile) AS Total_Amount, COUNT(*) AS Total_users
FROM Base WHERE Mobile > 0 AND Desktop = 0
GROUP BY Spend_date
UNION ALL
SELECT Spend_date, 'Desktop', SUM(Desktop), COUNT(*)
FROM Base WHERE Desktop > 0 AND Mobile = 0
GROUP BY Spend_date
UNION ALL
SELECT Spend_date, 'Both', SUM(Mobile + Desktop), COUNT(*)
FROM Base WHERE Mobile > 0 AND Desktop > 0
GROUP BY Spend_date
ORDER BY Spend_date, Platform;


/* === 10. De-group data === */
WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n < 100
)
SELECT g.Product, 1 AS Quantity
FROM Grouped g
JOIN Numbers n ON n.n <= g.Quantity
ORDER BY g.Product
OPTION (MAXRECURSION 1000);
