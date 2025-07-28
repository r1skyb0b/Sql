-- ✅ EASY LEVEL TASKS
-- 1. List all combinations of product names and supplier names (Cartesian product)
SELECT p.ProductName, s.SupplierName
FROM Products p
CROSS JOIN Suppliers s;

-- 2. Get all combinations of departments and employees (Cartesian product)
SELECT d.DepartmentName, e.EmployeeName
FROM Departments d
CROSS JOIN Employees e;

-- 3. List only combinations where supplier actually supplies the product
SELECT s.SupplierName, p.ProductName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- 4. List customer names and their orders ID
SELECT c.CustomerName, o.OrderID
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 5. Get all combinations of students and courses (Cartesian product)
SELECT s.StudentName, c.CourseName
FROM Students s
CROSS JOIN Courses c;

-- 6. Get product names and orders where product IDs match
SELECT p.ProductName, o.OrderID
FROM Products p
INNER JOIN Orders o ON p.ProductID = o.ProductID;

-- 7. List employees whose DepartmentID matches the department
SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 8. List student names and their enrolled course IDs
SELECT s.StudentName, e.CourseID
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID;

-- 9. List all orders that have matching payments
SELECT o.OrderID, p.PaymentID
FROM Orders o
INNER JOIN Payments p ON o.OrderID = p.OrderID;

-- 10. Show orders where product price is more than 100
SELECT o.OrderID, p.ProductName, p.Price
FROM Orders o
INNER JOIN Products p ON o.ProductID = p.ProductID
WHERE p.Price > 100;

-- ✅ MEDIUM LEVEL TASKS
-- 1. Show all mismatched employee-department combinations
SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID <> d.DepartmentID;

-- 2. Show orders where ordered quantity is greater than stock quantity
SELECT o.OrderID, p.ProductName
FROM Orders o
INNER JOIN Products p ON o.ProductID = p.ProductID
WHERE o.Quantity > p.Stock;

-- 3. List customer names and product IDs where sale amount is 500 or more
SELECT c.CustomerName, s.ProductID
FROM Customers c
INNER JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.Amount >= 500;

-- 4. List student names and course names they’re enrolled in
SELECT s.StudentName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

-- 5. List product and supplier names where supplier name contains “Tech”
SELECT p.ProductName, s.SupplierName
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName LIKE '%Tech%';

-- 6. Show orders where payment amount is less than total amount
SELECT o.OrderID, p.PaymentAmount, o.TotalAmount
FROM Orders o
INNER JOIN Payments p ON o.OrderID = p.OrderID
WHERE p.PaymentAmount < o.TotalAmount;

-- 7. Get the Department Name for each employee
SELECT e.EmployeeName, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;

-- 8. Show products where category is either 'Electronics' or 'Furniture'
SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName IN ('Electronics', 'Furniture');

-- 9. Show all sales from customers who are from 'USA'
SELECT s.SaleID, c.CustomerName, s.Amount
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID
WHERE c.Country = 'USA';

-- 10. List orders made by customers from 'Germany' and order total > 100
SELECT o.OrderID, c.CustomerName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Country = 'Germany' AND o.TotalAmount > 100;

-- 🔴 HARD LEVEL TASKS
-- 1. List all pairs of employees from different departments
SELECT e1.EmployeeName AS Employee1, e2.EmployeeName AS Employee2
FROM Employees e1
INNER JOIN Employees e2 ON e1.EmployeeID <> e2.EmployeeID
WHERE e1.DepartmentID <> e2.DepartmentID;

-- 2. List payment details where paid amount ≠ (Quantity × Product Price)
SELECT p.PaymentID, p.Amount, o.Quantity, pr.Price
FROM Payments p
INNER JOIN Orders o ON p.OrderID = o.OrderID
INNER JOIN Products pr ON o.ProductID = pr.ProductID
WHERE p.Amount <> o.Quantity * pr.Price;

-- 3. Find students who are not enrolled in any course (No INNER JOIN; LEFT JOIN needed)
-- Commented: This requires LEFT JOIN and IS NULL, not INNER JOIN, so skipped as per instruction.
-- SELECT s.StudentName FROM Students s LEFT JOIN Enrollments e ON s.StudentID = e.StudentID WHERE e.StudentID IS NULL;

-- 4. List employees who are managers of someone, but salary is ≤ the person they manage
SELECT e1.EmployeeName AS Manager, e2.EmployeeName AS Subordinate
FROM Employees e1
INNER JOIN Employees e2 ON e1.EmployeeID = e2.ManagerID
WHERE e1.Salary <= e2.Salary;

-- 5. List customers who have made an order, but no payment (No INNER JOIN; LEFT JOIN needed)
-- Commented: Requires LEFT JOIN and IS NULL to check missing payments, not INNER JOIN.
-- SELECT c.CustomerName FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID LEFT JOIN Payments p ON o.OrderID = p.OrderID WHERE p.PaymentID IS NULL;
