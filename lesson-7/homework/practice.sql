-- EASY-LEVEL TASKS

-- 1. Minimum price of a product
SELECT MIN(Price) AS MinPrice FROM Products;

-- 2. Maximum salary
SELECT MAX(Salary) AS MaxSalary FROM Employees;

-- 3. Count of customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 4. Count of unique product categories
SELECT COUNT(DISTINCT Category) AS UniqueCategories FROM Products;

-- 5. Total sales amount for product ID 7
SELECT SUM(SaleAmount) AS TotalSales FROM Sales WHERE ProductID = 7;

-- 6. Average age of employees
SELECT AVG(Age) AS AverageAge FROM Employees;

-- 7. Number of employees in each department
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 8. Min and Max product price by category
SELECT Category, MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice
FROM Products
GROUP BY Category;

-- 9. Total sales per customer
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

-- 10. Departments with more than 5 employees
SELECT DepartmentName, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName
HAVING COUNT(*) > 5;


-- MEDIUM-LEVEL TASKS


-- 1. Total and average sales by product category
SELECT P.Category, SUM(S.SaleAmount) AS TotalSales, AVG(S.SaleAmount) AS AvgSales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category;

-- 2. Count of employees in HR
SELECT COUNT(*) AS HRCount
FROM Employees
WHERE DepartmentName = 'HR';

-- 3. Highest and lowest salary by department
SELECT DepartmentName, MAX(Salary) AS MaxSalary, MIN(Salary) AS MinSalary
FROM Employees
GROUP BY DepartmentName;

-- 4. Average salary per department
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName;

-- 5. Avg salary and employee count per department
SELECT DepartmentName, AVG(Salary) AS AvgSalary, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentName;

-- 6. Product categories with avg price > 400
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400;

-- 7. Total sales per year
SELECT YEAR(SaleDate) AS SaleYear, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate);

-- 8. Customers who placed at least 3 orders
SELECT CustomerID, COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- 9. Departments with average salary > 60000
SELECT DepartmentName, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 60000;


-- HARD-LEVEL TASKS


-- 1. Avg price per category, filter if > 150
SELECT Category, AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
HAVING AVG(Price) > 150;

-- 2. Customers with total sales > 1500
SELECT CustomerID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(SaleAmount) > 1500;

-- 3. Total and average salary per department, filter if avg > 65000
SELECT DepartmentName, SUM(Salary) AS TotalSalary, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000;

-- 4. [NO TABLE tsql2012.sales.orders in current DB]
-- Placeholder for TSQL2012.orders query with freight column
-- Uncomment and use only if that table is present
/*
SELECT CustomerID,
       SUM(TotalAmount) AS TotalAbove50,
       MIN(TotalAmount) AS LeastPurchase
FROM Orders
WHERE TotalAmount > 50
GROUP BY CustomerID;
*/

-- 5. Total sales and unique products sold each month of each year (from Orders)
SELECT YEAR(OrderDate) AS Year,
       MONTH(OrderDate) AS Month,
       SUM(TotalAmount) AS TotalSales,
       COUNT(DISTINCT ProductID) AS UniqueProducts
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
HAVING COUNT(DISTINCT ProductID) >= 2;

-- 6. MIN and MAX quantity per year from Orders
SELECT YEAR(OrderDate) AS Year,
       MIN(Quantity) AS MinQty,
       MAX(Quantity) AS MaxQty
FROM Orders
GROUP BY YEAR(OrderDate);
