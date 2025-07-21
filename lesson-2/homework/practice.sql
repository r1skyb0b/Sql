-- ✅ BASIC LEVEL TASKS ✅

-- 1. Create Employees table
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- 2. Insert three records using different INSERT INTO approaches

-- Single-row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Alice', 6000.00);

-- Another single-row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (2, 'Bob', 5000.00);

-- Multi-row insert
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(3, 'Charlie', 5500.00);

-- 3. Update salary to 7000 where EmpID = 1
UPDATE Employees
SET Salary = 7000.00
WHERE EmpID = 1;

-- 4. Delete a record where EmpID = 2
DELETE FROM Employees
WHERE EmpID = 2;

-- 5. Brief explanation for DELETE, TRUNCATE, and DROP
-- DELETE: Removes specific rows with WHERE clause, can be rolled back if in transaction.
-- TRUNCATE: Removes all rows quickly without logging individual deletions. Cannot filter with WHERE.
-- DROP: Deletes the entire table structure and data permanently.

-- 6. Modify Name column to VARCHAR(100)
ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);

-- 7. Add new column Department
ALTER TABLE Employees
ADD Department VARCHAR(50);

-- 8. Change data type of Salary to FLOAT
ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

-- 9. Create Departments table with a primary key
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- 10. Remove all records from Employees table (keep structure)
TRUNCATE TABLE Employees;


-- ✅ INTERMEDIATE LEVEL TASKS ✅

-- 1. Insert 5 records into Departments using INSERT INTO SELECT
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'HR' UNION ALL
SELECT 2, 'IT' UNION ALL
SELECT 3, 'Finance' UNION ALL
SELECT 4, 'Marketing' UNION ALL
SELECT 5, 'Logistics';

-- 2. Update Department of employees with Salary > 5000 to 'Management'
UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

-- 3. Remove all employees (keep table structure)
TRUNCATE TABLE Employees;

-- 4. Drop Department column from Employees table
ALTER TABLE Employees
DROP COLUMN Department;

-- 5. Rename Employees to StaffMembers
EXEC sp_rename 'Employees', 'StaffMembers';

-- 6. Drop the Departments table completely
DROP TABLE Departments;


-- ✅ ADVANCED LEVEL TASKS ✅

-- 1. Create Products table with 5 columns
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    Description VARCHAR(100)
);

-- 2. Add CHECK constraint to ensure Price > 0
ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);

-- 3. Add StockQuantity column with DEFAULT 50
ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

-- 4. Rename Category to ProductCategory
EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN';

-- 5. Insert 5 records into Products
INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Description)
VALUES 
(1, 'Laptop', 'Electronics', 1200.00, '15 inch screen'),
(2, 'Phone', 'Electronics', 800.00, '5G enabled'),
(3, 'Chair', 'Furniture', 150.00, 'Ergonomic design'),
(4, 'Table', 'Furniture', 200.00, 'Wooden finish'),
(5, 'Pen', 'Stationery', 2.50, 'Blue ink');

-- 6. Create backup table using SELECT INTO
SELECT * INTO Products_Backup
FROM Products;

-- 7. Rename Products to Inventory
EXEC sp_rename 'Products', 'Inventory';

-- 8. Change Price column to FLOAT
ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

-- 9. Add IDENTITY column ProductCode starting from 1000, increment by 5
ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000, 5);
