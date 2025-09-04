----------------------------------------------------
-- EASY TASKS
----------------------------------------------------

-- 1. emp_id + first_name + last_name
SELECT CAST(emp_id AS VARCHAR) + '-' + first_name + ' ' + last_name AS result
FROM employees;

-- 2. Replace '124' with '999' in phone_number
UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999');

-- 3. First name + its length, names A/J/M, sorted
SELECT first_name, LEN(first_name) AS name_length
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE 'J%' OR first_name LIKE 'M%'
ORDER BY first_name;

-- 4. Total salary by manager_id
SELECT manager_id, SUM(salary) AS total_salary
FROM employees
GROUP BY manager_id;

-- 5. Year + highest of Max1, Max2, Max3 (CASE method)
SELECT year,
       CASE 
         WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
         WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
         ELSE Max3
       END AS highest_value
FROM TestMax;

-- 6. Odd-numbered movies, not boring
SELECT *
FROM cinema
WHERE movie_id % 2 = 1 AND description <> 'boring';

-- 7. Sort by Id, but 0 last
SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

-- 8. First non-null value from several columns
SELECT COALESCE(col1, col2, col3, col4) AS first_non_null
FROM person;


----------------------------------------------------
-- MEDIUM TASKS
----------------------------------------------------

-- 1. Split FullName into 3 parts (works if exactly 3 parts)
SELECT 
  PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
  PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM Students;

-- 2. Customers with CA delivery → orders in TX
SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id FROM Orders WHERE state = 'California'
)
AND state = 'Texas';

-- 3. Group concatenate values (SQL Server 2017+)
SELECT STRING_AGG(value_col, ',') AS all_values
FROM DMLTable;

-- 4. Employees with ≥3 "a" in concatenated name
SELECT first_name, last_name
FROM employees
WHERE LEN(LOWER(first_name + last_name)) 
      - LEN(REPLACE(LOWER(first_name + last_name), 'a', '')) >= 3;

-- 5. Employee count + % >3 years in company
SELECT department_id,
       COUNT(*) AS total_employees,
       100.0 * SUM(CASE WHEN DATEDIFF(year, hire_date, GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*) AS percent_over_3_years
FROM employees
GROUP BY department_id;

-- 6. Most and least experienced spaceman by job description
SELECT job_description,
       MIN(spaceman_id) AS least_experienced,
       MAX(spaceman_id) AS most_experienced
FROM Personal
GROUP BY job_description;


----------------------------------------------------
-- DIFFICULT TASKS
----------------------------------------------------

-- 1. Separate uppercase, lowercase, numbers, others
WITH chars AS (
  SELECT value AS ch
  FROM STRING_SPLIT('tf56sd#%OqH', '')
)
SELECT 
  STRING_AGG(CASE WHEN ch LIKE '[A-Z]' THEN ch END, '') AS Uppercase,
  STRING_AGG(CASE WHEN ch LIKE '[a-z]' THEN ch END, '') AS Lowercase,
  STRING_AGG(CASE WHEN ch LIKE '[0-9]' THEN ch END, '') AS Numbers,
  STRING_AGG(CASE WHEN ch NOT LIKE '[A-Za-z0-9]' THEN ch END, '') AS Others
FROM chars;

-- 2. Running total (cumulative sum)
SELECT StudentID, 
       SUM(value) OVER (ORDER BY StudentID) AS running_sum
FROM Students;

-- 3. Equations table (⚠️ SQL Server cannot evaluate text math directly.
-- Needs dynamic SQL or parsing. This is just placeholder if numeric.)
SELECT equation,
       SUM(CAST(equation AS INT)) AS result
FROM Equations;

-- 4. Students with same birthday
SELECT s1.student_id, s2.student_id, s1.birthdate
FROM Student s1
JOIN Student s2
  ON s1.birthdate = s2.birthdate AND s1.student_id < s2.student_id;

-- 5. Total score for each unique player pair
SELECT 
  CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
  CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
  SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
         CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;
