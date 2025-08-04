-- 🟢 Easy-Level Tasks (10)

-- 1. Employees with salary > 50000 and their department names
SELECT Emp.Name AS EmployeeName, Emp.Salary, Dept.DepartmentName
FROM Employees AS Emp
JOIN Departments AS Dept ON Emp.DepartmentID = Dept.DepartmentID
WHERE Emp.Salary > 50000;

-- 2. Customer names and order dates for orders in 2023
SELECT C.FirstName, C.LastName, O.OrderDate
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE YEAR(O.OrderDate) = 2023;

-- 3. All employees and their departments, including those without a department
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees AS E
LEFT JOIN Departments AS D ON E.DepartmentID = D.DepartmentID;

-- 4. All suppliers and the products they supply, including suppliers with no products
SELECT S.SupplierName, P.ProductName
FROM Suppliers AS S
LEFT JOIN Products AS P ON S.SupplierID = P.SupplierID;

-- 5. All orders and their corresponding payments (even unmatched ones)
SELECT O.OrderID, O.OrderDate, P.PaymentDate, P.Amount
FROM Orders AS O
FULL OUTER JOIN Payments AS P ON O.OrderID = P.OrderID;

-- 6. Each employee and their manager's name
SELECT E.Name AS EmployeeName, M.Name AS ManagerName
FROM Employees AS E
LEFT JOIN Employees AS M ON E.ManagerID = M.EmployeeID;

-- 7. Students enrolled in 'Math 101'
SELECT S.StudentName, C.CourseName
FROM Students AS S
JOIN Enrollments AS E ON S.StudentID = E.StudentID
JOIN Courses AS C ON E.CourseID = C.CourseID
WHERE C.CourseName = 'Math 101';

-- 8. Customers who placed an order with more than 3 items
SELECT C.FirstName, C.LastName, O.Quantity
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
WHERE O.Quantity > 3;

-- 9. Employees working in 'Human Resources' department
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Human Resources';


-- 🟠 Medium-Level Tasks (9)


-- 1. Departments with more than 5 employees
SELECT D.DepartmentName, COUNT(E.EmployeeID) AS EmployeeCount
FROM Departments AS D
JOIN Employees AS E ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(E.EmployeeID) > 5;

-- 2. Products that have never been sold
SELECT P.ProductID, P.ProductName
FROM Products AS P
LEFT JOIN Sales AS S ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL;

-- 3. Customers who placed at least one order
SELECT C.FirstName, C.LastName, COUNT(O.OrderID) AS TotalOrders
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName;

-- 4. Only records where both employee and department exist (no NULLs)
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees AS E
INNER JOIN Departments AS D ON E.DepartmentID = D.DepartmentID;

-- 5. Pairs of employees who report to the same manager
SELECT E1.Name AS Employee1, E2.Name AS Employee2, E1.ManagerID
FROM Employees AS E1
JOIN Employees AS E2 ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID < E2.EmployeeID
WHERE E1.ManagerID IS NOT NULL;

-- 6. Orders placed in 2022 with customer name
SELECT O.OrderID, O.OrderDate, C.FirstName, C.LastName
FROM Orders AS O
JOIN Customers AS C ON O.CustomerID = C.CustomerID
WHERE YEAR(O.OrderDate) = 2022;

-- 7. Employees in 'Sales' department with salary > 60000
SELECT E.Name AS EmployeeName, E.Salary, D.DepartmentName
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' AND E.Salary > 60000;

-- 8. Only orders that have a payment
SELECT O.OrderID, O.OrderDate, P.PaymentDate, P.Amount
FROM Orders AS O
JOIN Payments AS P ON O.OrderID = P.OrderID;

-- 9. Products never ordered
SELECT P.ProductID, P.ProductName
FROM Products AS P
LEFT JOIN Orders AS O ON P.ProductID = O.ProductID
WHERE O.ProductID IS NULL;


-- 🔴 Hard-Level Tasks (9)


-- 1. Employees with salary greater than department average
SELECT E.Name AS EmployeeName, E.Salary
FROM Employees AS E
JOIN (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
) AS DeptAvg ON E.DepartmentID = DeptAvg.DepartmentID
WHERE E.Salary > DeptAvg.AvgSalary;

-- 2. Orders before 2020 with no payment
SELECT O.OrderID, O.OrderDate
FROM Orders AS O
LEFT JOIN Payments AS P ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL AND O.OrderDate < '2020-01-01';

-- 3. Products with no matching category
SELECT P.ProductID, P.ProductName
FROM Products AS P
LEFT JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE C.CategoryID IS NULL;

-- 4. Employees with same manager and salary > 60000
SELECT E1.Name AS Employee1, E2.Name AS Employee2, E1.ManagerID, E1.Salary
FROM Employees AS E1
JOIN Employees AS E2 ON E1.ManagerID = E2.ManagerID AND E1.EmployeeID < E2.EmployeeID
WHERE E1.Salary > 60000 AND E2.Salary > 60000;

-- 5. Employees in departments starting with 'M'
SELECT E.Name AS EmployeeName, D.DepartmentName
FROM Employees AS E
JOIN Departments AS D ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName LIKE 'M%';

-- 6. Sales with amount > 500, including product names
SELECT S.SaleID, P.ProductName, S.SaleAmount
FROM Sales AS S
JOIN Products AS P ON S.ProductID = P.ProductID
WHERE S.SaleAmount > 500;

-- 7. Students not enrolled in 'Math 101'
SELECT S.StudentID, S.StudentName
FROM Students AS S
WHERE S.StudentID NOT IN (
    SELECT E.StudentID
    FROM Enrollments AS E
    JOIN Courses AS C ON E.CourseID = C.CourseID
    WHERE C.CourseName = 'Math 101'
);

-- 8. Orders missing payment details
SELECT O.OrderID, O.OrderDate, P.PaymentID
FROM Orders AS O
LEFT JOIN Payments AS P ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL;

-- 9. Products in 'Electronics' or 'Furniture' category
SELECT P.ProductID, P.ProductName, C.CategoryName
FROM Products AS P
JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE C.CategoryName IN ('Electronics', 'Furniture');
