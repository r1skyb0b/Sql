/* Level 1: Basic Subqueries */

-- 1. Employees with Minimum Salary
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- 2. Products Above Average Price
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);


/* Level 2: Nested Subqueries with Conditions */

-- 3. Employees in Sales Department
SELECT *
FROM employees
WHERE department_id = (
    SELECT id FROM departments WHERE department_name = 'Sales'
);

-- 4. Customers with No Orders
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id
);


/* Level 3: Aggregation and Grouping in Subqueries */

-- 5. Products with Max Price in Each Category
SELECT p.*
FROM products p
WHERE price = (
    SELECT MAX(price) 
    FROM products 
    WHERE category_id = p.category_id
);

-- 6. Employees in Department with Highest Average Salary
SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);


/* Level 4: Correlated Subqueries */

-- 7. Employees Earning Above Department Average
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- 8. Students with Highest Grade per Course
SELECT s.student_id, s.name, g.course_id, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE g.grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
);


/* Level 5: Subqueries with Ranking and Complex Conditions */

-- 9. Third-Highest Price per Category
SELECT *
FROM products p
WHERE 2 = (
    SELECT COUNT(DISTINCT price)
    FROM products
    WHERE category_id = p.category_id AND price > p.price
);

-- 10. Employees Salary Between Company Avg and Dept Max
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
      SELECT MAX(salary)
      FROM employees
      WHERE department_id = e.department_id
);
