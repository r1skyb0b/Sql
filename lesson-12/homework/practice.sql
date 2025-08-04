-- 1. Combine Two Tables
-- Return all persons, even if their address is missing
SELECT 
    P.firstName, 
    P.lastName, 
    A.city, 
    A.state
FROM Person AS P
LEFT JOIN Address AS A 
    ON P.personId = A.personId;

-- 2. Employees Earning More Than Their Managers
-- Join employee table with itself to compare salary with their manager
SELECT 
    E.name AS Employee
FROM Employee AS E
JOIN Employee AS M 
    ON E.managerId = M.id
WHERE E.salary > M.salary;

-- 3. Duplicate Emails
-- Group by email and count duplicates
SELECT 
    email AS Email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;

-- 4. Delete Duplicate Emails
-- Keep only the row with smallest id for each email
DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email
);

-- 5. Parents Who Have Only Girls
-- Select parents from girls table who do not appear in boys table
SELECT DISTINCT g.ParentName
FROM girls AS g
WHERE g.ParentName NOT IN (
    SELECT DISTINCT ParentName
    FROM boys
);

-- 6. Total over 50 and Least Weight per Customer
-- This query depends on the TSQL2012 database structure
-- Assuming there's a Sales.Orders table with columns: CustomerID, Weight, and TotalAmount
SELECT 
    CustomerID,
    SUM(TotalAmount) AS TotalAmountOver50,
    MIN(Weight) AS LeastWeight
FROM Sales.Orders
WHERE Weight > 50
GROUP BY CustomerID;

-- 7. Carts (Full Outer Join)
-- Combine both carts with FULL OUTER JOIN to show all items from both
SELECT 
    C1.Item AS [Item Cart 1], 
    C2.Item AS [Item Cart 2]
FROM Cart1 AS C1
FULL OUTER JOIN Cart2 AS C2 
    ON C1.Item = C2.Item;

-- 8. Customers Who Never Order
-- Select customers who don't appear in the Orders table
SELECT 
    C.name AS Customers
FROM Customers AS C
LEFT JOIN Orders AS O 
    ON C.id = O.customerId
WHERE O.customerId IS NULL;

-- 9. Students and Examinations
-- Use CROSS JOIN to get all combinations, then COUNT matches
SELECT 
    S.student_id,
    S.student_name,
    Sub.subject_name,
    COUNT(E.subject_name) AS attended_exams
FROM Students AS S
CROSS JOIN Subjects AS Sub
LEFT JOIN Examinations AS E 
    ON S.student_id = E.student_id 
    AND Sub.subject_name = E.subject_name
GROUP BY 
    S.student_id, 
    S.student_name, 
    Sub.subject_name
ORDER BY 
    S.student_id, 
    Sub.subject_name;
