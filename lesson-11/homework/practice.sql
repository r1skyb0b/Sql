--🟢 Easy-Level Tasks (7)

--Return: OrderID, CustomerName, OrderDate
--Task: Show all orders placed after 2022 along with the names of the customers who placed them.
--Tables Used: Orders, Customers

SELECT Ord.OrderID, Cust.FirstName, Cust.LastName, Ord.OrderDate FROM Orders AS Ord
JOIN Customers AS Cust
ON Ord.CustomerID = Cust.CustomerID AND YEAR(Ord.OrderDate) > 2022
ORDER BY Ord.OrderDate


--Return: EmployeeName, DepartmentName
--Task: Display the names of employees who work in either the Sales or Marketing department.
--Tables Used: Employees, Departments

SELECT Emp.Name AS EmployeeName, Dept.DepartmentName FROM Employees AS Emp
JOIN Departments AS Dept
ON Emp.DepartmentID = Dept.DepartmentID AND Dept.DepartmentName IN ('Sales', 'Marketing')


--Return: DepartmentName, MaxSalary
--Task: Show the highest salary for each department.
--Tables Used: Departments, Employees

SELECT Dept.DepartmentName, MAX(Emp.Salary) AS MaxSalary FROM Departments AS Dept
JOIN Employees AS Emp
ON Dept.DepartmentID = Emp.DepartmentID
GROUP BY Dept.DepartmentName


--Return: CustomerName, OrderID, OrderDate
--Task: List all customers from the USA who placed orders in the year 2023.
--Tables Used: Customers, Orders

SELECT Cust.FirstName, Cust.LastName, Ord.OrderID, Ord.OrderDate FROM Customers AS Cust
JOIN Orders AS Ord
ON Cust.CustomerID = Ord.CustomerID AND Cust.Country = 'USA' AND YEAR(Ord.OrderDate) = '2023'


--Return: CustomerName, TotalOrders
--Task: Show how many orders each customer has placed.
--Tables Used: Orders , Customers

SELECT Cust.CustomerID, Cust.FirstName, Cust.LastName, COUNT(Ord.CustomerID) AS TotalOrders FROM Customers AS Cust
JOIN Orders AS Ord
ON Cust.CustomerID = Ord.CustomerID
GROUP BY Cust.CustomerID, Cust.FirstName, Cust.LastName


--Return: ProductName, SupplierName
--Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
--Tables Used: Products, Suppliers

SELECT Prod.ProductName, Sup.SupplierName FROM Products AS Prod
JOIN Suppliers AS Sup
ON Prod.SupplierID = Sup.SupplierID AND Sup.SupplierName IN ('Gadget Supplies', 'Clothing Mart')


--Return: CustomerName, MostRecentOrderDate
--Task: For each customer, show their most recent order. Include customers who haven't placed any orders.
--Tables Used: Customers, Orders

SELECT Cust.FirstName, Cust.LastName, MAX(Ord.OrderDate) AS MostRecentOrderDate FROM Customers AS Cust
LEFT JOIN Orders AS Ord
ON Cust.CustomerID = Ord.CustomerID
GROUP BY Cust.FirstName, Cust.LastName
ORDER BY MostRecentOrderDate



--🟠 Medium-Level Tasks (6)
--Return: CustomerName, OrderTotal
--Task: Show the customers who have placed an order where the total amount is greater than 500.
--Tables Used: Orders, Customers

SELECT Cust.FirstName, Cust.LastName, Ord.TotalAmount AS OrderTotal FROM Customers AS Cust
JOIN Orders AS Ord
ON Cust.CustomerID = Ord.CustomerID AND Ord.TotalAmount > 500


--Return: ProductName, SaleDate, SaleAmount
--Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400.
--Tables Used: Products, Sales

SELECT P.ProductName, S.SaleDate, S.SaleAmount FROM Products AS P
JOIN Sales AS S
ON P.ProductID = S.ProductID AND (YEAR(S.SaleDate) = 2022 OR S.SaleAmount > 400)


--Return: ProductName, TotalSalesAmount
--Task: Display each product along with the total amount it has been sold for.
--Tables Used: Sales, Products

SELECT P.ProductName, ISNULL(SUM(S.SaleAmount),0) AS TotalSalesAmount FROM Products AS P
LEFT JOIN Sales AS S
ON P.ProductID = S.ProductID
GROUP BY P.ProductName


--Return: EmployeeName, DepartmentName, Salary
--Task: Show the employees who work in the HR department and earn a salary greater than 60000.
--Tables Used: Employees, Departments

SELECT Emp.Name AS EmployeeName, Dept.DepartmentName, Emp.Salary FROM Employees AS Emp
JOIN Departments AS Dept
ON Emp.DepartmentID = Dept.DepartmentID AND Dept.DepartmentName = 'Human Resources' AND Emp.Salary > 60000


--Return: ProductName, SaleDate, StockQuantity
--Task: List the products that were sold in 2023 and had more than 100 units in stock at the time.
--Tables Used: Products, Sales

SELECT P.ProductName, S.SaleDate, P.StockQuantity FROM Products AS P
INNER JOIN Sales AS S
ON P.ProductID = S.ProductID AND YEAR(S.SaleDate) = '2023' AND P.StockQuantity > 100


--Return: EmployeeName, DepartmentName, HireDate
--Task: Show employees who either work in the Sales department or were hired after 2020.
--Tables Used: Employees, Departments

SELECT Emp.Name AS EmployeeName, Dept.DepartmentName, Emp.HireDate FROM Employees AS Emp
JOIN Departments AS Dept
ON Emp.DepartmentID = Dept.DepartmentID AND (Dept.DepartmentName = 'Sales' OR YEAR(Emp.HireDate) > 2020)



--🔴 Hard-Level Tasks (7)
--Return: CustomerName, OrderID, Address, OrderDate
--Task: List all orders made by customers in the USA whose address starts with 4 digits.
--Tables Used: Customers, Orders

SELECT Cust.CustomerID, Cust.FirstName, Cust.LastName, Ord.OrderID, Cust.Country, Cust.Address, Ord.OrderDate FROM Customers AS Cust
JOIN Orders AS Ord
ON Cust.CustomerID = Ord.CustomerID AND Cust.Country = 'USA' AND Cust.Address LIKE '[0-9][0-9][0-9][0-9]%'


--Return: ProductName, Category, SaleAmount
--Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350.
--Tables Used: Products, Sales

SELECT P.ProductName, C.CategoryName, S.SaleAmount FROM Products AS P
JOIN Sales AS S
ON P.ProductID = S.ProductID
JOIN Categories AS C
ON P.Category = C.CategoryID
WHERE C.CategoryName = 'Electronics' OR S.SaleAmount > 350


--Return: CategoryName, ProductCount
--Task: Show the number of products available in each category.
--Tables Used: Products, Categories

SELECT C.CategoryName, COUNT(P.ProductID) AS ProductCount FROM Categories AS C
LEFT JOIN Products AS P
ON C.CategoryID = P.Category
GROUP BY C.CategoryName


--Return: CustomerName, City, OrderID, Amount
--Task: List orders where the customer is from Los Angeles and the order amount is greater than 300.
--Tables Used: Customers, Orders


SELECT C.CustomerID, C.FirstName, C.LastName, C.City, O.OrderID, O.TotalAmount AS Amount FROM Orders AS O
JOIN Customers AS C
ON O.CustomerID = C.CustomerID AND C.City = 'Los Angeles' AND O.TotalAmount > 300


--Return: EmployeeName, DepartmentName
--Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
--Tables Used: Employees, Departments

SELECT 
    E.Name AS EmployeeName,
    D.DepartmentName
FROM 
    Employees E
JOIN 
    Departments D ON E.DepartmentID = D.DepartmentID
WHERE 
    D.DepartmentName IN ('HR', 'Finance')
    OR (
        -- Count vowels in the name
        (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'a', ''))) +
        (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'e', ''))) +
        (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'i', ''))) +
        (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'o', ''))) +
        (LEN(E.Name) - LEN(REPLACE(LOWER(E.Name), 'u', '')))
    ) >= 4;



--Return: EmployeeName, DepartmentName, Salary
--Task: Show employees who are in the Sales or Marketing department and have a salary above 60000.
--Tables Used: Employees, Departments

SELECT * FROM Employees AS E
JOIN Departments AS D
ON E.DepartmentID = D.DepartmentID AND (D.DepartmentName IN ('Sales', 'Marketing') AND E.Salary > 60000)
