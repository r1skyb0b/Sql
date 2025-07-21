-- 1. Select top 5 employees
SELECT TOP 5 * FROM Employees;

-- 2. Select unique categories from Products
SELECT DISTINCT Category FROM Products;

-- 3. Filter Products with Price > 100
SELECT * FROM Products WHERE Price > 100;

-- 4. Select Customers whose FirstName starts with 'A'
SELECT * FROM Customers WHERE FirstName LIKE 'A%';

-- 5. Order Products by Price in ascending order
SELECT * FROM Products ORDER BY Price ASC;

-- 6. Employees with Salary >= 60000 and Department = 'HR'
SELECT * FROM Employees
WHERE Salary >= 60000 AND DepartmentName = 'HR';

-- 7. Replace NULL Email with default text
SELECT ISNULL(Email, 'noemail@example.com') AS Email FROM Employees;

-- 8. Products with Price between 50 and 100
SELECT * FROM Products WHERE Price BETWEEN 50 AND 100;

-- 9. Select DISTINCT Category and ProductName
SELECT DISTINCT Category, ProductName FROM Products;

-- 10. DISTINCT Category and ProductName, ordered by ProductName DESC
SELECT DISTINCT Category, ProductName
FROM Products
ORDER BY ProductName DESC;

-- 11. Top 10 products ordered by Price DESC
SELECT TOP 10 * FROM Products ORDER BY Price DESC;

-- 12. First non-NULL from FirstName or LastName
SELECT COALESCE(FirstName, LastName) AS Name FROM Employees;

-- 13. DISTINCT Category and Price
SELECT DISTINCT Category, Price FROM Products;

-- 14. Employees with Age between 30–40 OR Department = 'Marketing'
SELECT * FROM Employees
WHERE (Age BETWEEN 30 AND 40) OR DepartmentName = 'Marketing';

-- 15. Employees rows 11 to 20 ordered by Salary DESC
SELECT * FROM Employees
ORDER BY Salary DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 16. Products with Price <= 1000 and Stock > 50, sorted by Stock ASC
SELECT * FROM Products
WHERE Price <= 1000 AND StockQuantity > 50
ORDER BY StockQuantity ASC;

-- 17. Products with 'e' in ProductName
SELECT * FROM Products WHERE ProductName LIKE '%e%';

-- 18. Employees in HR, IT, or Finance
SELECT * FROM Employees
WHERE DepartmentName IN ('HR', 'IT', 'Finance');

-- 19. Customers ordered by City ASC and PostalCode DESC
SELECT * FROM Customers
ORDER BY City ASC, PostalCode DESC;

-- 20. Top 5 products with highest sales (by total SaleAmount)
SELECT TOP 5 ProductID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY ProductID
ORDER BY TotalSales DESC;

-- 21. Combine FirstName and LastName into FullName
SELECT 
    FirstName + ' ' + LastName AS FullName
FROM Employees;

-- 22. DISTINCT Category, ProductName, Price where Price > 50
SELECT DISTINCT Category, ProductName, Price
FROM Products
WHERE Price > 50;

-- 23. Products where Price is less than 10% of average price
SELECT * FROM Products
WHERE Price < (SELECT AVG(Price) * 0.1 FROM Products);

-- 24. Employees younger than 30 AND in HR or IT
SELECT * FROM Employees
WHERE Age < 30 AND DepartmentName IN ('HR', 'IT');

-- 25. Customers with Gmail email domain
SELECT * FROM Customers
WHERE Email LIKE '%@gmail.com%';

-- 26. Employees whose salary is greater than ALL employees in Sales
SELECT * FROM Employees
WHERE Salary > ALL (
    SELECT Salary FROM Employees WHERE DepartmentName = 'Sales'
);

-- 27. Orders placed in the last 180 days from today
SELECT * FROM Orders
WHERE OrderDate BETWEEN DATEADD(DAY, -180, GETDATE()) AND GETDATE();
