-- 🟢 EASY-LEVEL TASKS 🟢

-- 1. Definition of BULK INSERT
-- BULK INSERT is used to import large amounts of data from a file (like .txt or .csv) into a SQL Server table quickly.

-- 2. List four file formats that can be imported into SQL Server
-- Answer: .txt, .csv, .xml, .xls/.xlsx (Excel)

-- 3. Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4. Insert three records
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
(1, 'Laptop', 1200.00),
(2, 'Mouse', 25.50),
(3, 'Keyboard', 75.00);

-- 5. Difference between NULL and NOT NULL
-- NULL means a column can have no value (missing data), while NOT NULL ensures a value must be provided.

-- 6. Add UNIQUE constraint to ProductName
ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- 7. Example SQL comment
-- This query selects all products from the Products table
SELECT * FROM Products;

-- 8. Add CategoryID column to Products table
ALTER TABLE Products
ADD CategoryID INT;

-- 9. Create Categories table with PRIMARY KEY and UNIQUE on CategoryName
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 10. Purpose of IDENTITY column
-- An IDENTITY column automatically generates sequential numbers for new rows (e.g., 1, 2, 3...).


-- 🟠 MEDIUM-LEVEL TASKS 🟠

-- 1. Use BULK INSERT to import data from a text file (assumes file exists at this path)
-- Replace with actual file path on your system
-- BULK INSERT Products
-- FROM 'C:\Data\products_data.txt'
-- WITH (
--     FIELDTERMINATOR = ',',
--     ROWTERMINATOR = '\n',
--     FIRSTROW = 2
-- );

-- 2. Create FOREIGN KEY from Products.CategoryID to Categories.CategoryID
ALTER TABLE Products
ADD CONSTRAINT FK_Category FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);

-- 3. Difference between PRIMARY KEY and UNIQUE KEY
-- PRIMARY KEY: Uniquely identifies each row and does not allow NULLs.
-- UNIQUE KEY: Also enforces uniqueness but allows one NULL value.

-- 4. Add CHECK constraint: Price must be > 0
ALTER TABLE Products
ADD CONSTRAINT CHK_Price_Positive CHECK (Price > 0);

-- 5. Add Stock column as NOT NULL
ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

-- 6. Use ISNULL to replace NULL Price with 0 in SELECT
SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

-- 7. Purpose of FOREIGN KEY
-- A FOREIGN KEY maintains referential integrity between two tables by linking one column to a PRIMARY KEY in another table.


-- 🔴 HARD-LEVEL TASKS 🔴

-- 1. Create Customers table with CHECK constraint on Age
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Age INT CHECK (Age >= 18)
);

-- 2. Create table with IDENTITY column starting at 100, incrementing by 10
CREATE TABLE InventoryItems (
    ItemID INT IDENTITY(100, 10) PRIMARY KEY,
    ItemName VARCHAR(50)
);

-- 3. Create composite PRIMARY KEY in OrderDetails table
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

-- 4. Use of COALESCE and ISNULL
-- COALESCE returns the first non-null value from a list.
-- ISNULL replaces NULL with a specific value.
-- Example:
SELECT 
    COALESCE(NULL, NULL, 'Default') AS CoalesceResult,
    ISNULL(NULL, 'Default') AS IsNullResult;

-- 5. Employees table with PRIMARY KEY and UNIQUE KEY
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100) UNIQUE
);

-- 6. FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
