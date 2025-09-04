---------------------------------------------------
-- LESSON 22: AGGREGATED WINDOW FUNCTIONS
---------------------------------------------------

-- Drop tables if exist
IF OBJECT_ID('sales_data') IS NOT NULL DROP TABLE sales_data;
IF OBJECT_ID('OneColumn') IS NOT NULL DROP TABLE OneColumn;
IF OBJECT_ID('MyData') IS NOT NULL DROP TABLE MyData;
IF OBJECT_ID('TheSumPuzzle') IS NOT NULL DROP TABLE TheSumPuzzle;
IF OBJECT_ID('Seats') IS NOT NULL DROP TABLE Seats;

---------------------------------------------------
-- Create and Insert sales_data
---------------------------------------------------
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
(1,101,'Alice','Electronics','Laptop',1,1200,1200,'2024-01-01','North'),
(2,102,'Bob','Electronics','Phone',2,600,1200,'2024-01-02','South'),
(3,103,'Charlie','Clothing','T-Shirt',5,20,100,'2024-01-03','East'),
(4,104,'David','Furniture','Table',1,250,250,'2024-01-04','West'),
(5,105,'Eve','Electronics','Tablet',1,300,300,'2024-01-05','North'),
(6,106,'Frank','Clothing','Jacket',2,80,160,'2024-01-06','South'),
(7,107,'Grace','Electronics','Headphones',3,50,150,'2024-01-07','East'),
(8,108,'Hank','Furniture','Chair',4,75,300,'2024-01-08','West'),
(9,109,'Ivy','Clothing','Jeans',1,40,40,'2024-01-09','North'),
(10,110,'Jack','Electronics','Laptop',2,1200,2400,'2024-01-10','South'),
(11,101,'Alice','Electronics','Phone',1,600,600,'2024-01-11','North'),
(12,102,'Bob','Furniture','Sofa',1,500,500,'2024-01-12','South'),
(13,103,'Charlie','Electronics','Camera',1,400,400,'2024-01-13','East'),
(14,104,'David','Clothing','Sweater',2,60,120,'2024-01-14','West'),
(15,105,'Eve','Furniture','Bed',1,800,800,'2024-01-15','North'),
(16,106,'Frank','Electronics','Monitor',1,200,200,'2024-01-16','South'),
(17,107,'Grace','Clothing','Scarf',3,25,75,'2024-01-17','East'),
(18,108,'Hank','Furniture','Desk',1,350,350,'2024-01-18','West'),
(19,109,'Ivy','Electronics','Speaker',2,100,200,'2024-01-19','North'),
(20,110,'Jack','Clothing','Shoes',1,90,90,'2024-01-20','South'),
(21,111,'Kevin','Electronics','Mouse',3,25,75,'2024-01-21','East'),
(22,112,'Laura','Furniture','Couch',1,700,700,'2024-01-22','West'),
(23,113,'Mike','Clothing','Hat',4,15,60,'2024-01-23','North'),
(24,114,'Nancy','Electronics','Smartwatch',1,250,250,'2024-01-24','South'),
(25,115,'Oscar','Furniture','Wardrobe',1,1000,1000,'2024-01-25','East');

---------------------------------------------------
-- EASY QUERIES
---------------------------------------------------

-- 1. Running Total Sales per Customer
SELECT sale_id, customer_id, total_amount,
       SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data;

-- 2. Count Orders per Product Category
SELECT product_category,
       COUNT(*) OVER(PARTITION BY product_category) AS order_count
FROM sales_data;

-- 3. Max Total Amount per Product Category
SELECT sale_id, product_category, total_amount,
       MAX(total_amount) OVER(PARTITION BY product_category) AS max_amount
FROM sales_data;

-- 4. Min Price of Products per Category
SELECT sale_id, product_category, unit_price,
       MIN(unit_price) OVER(PARTITION BY product_category) AS min_price
FROM sales_data;

-- 5. Moving Average of Sales (3 days: prev, curr, next)
SELECT sale_id, order_date, total_amount,
       AVG(total_amount) OVER(ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg
FROM sales_data;

-- 6. Total Sales per Region
SELECT region, SUM(total_amount) OVER(PARTITION BY region) AS total_sales
FROM sales_data;

-- 7. Rank Customers by Total Purchase
SELECT customer_id, customer_name,
       SUM(total_amount) AS total_purchase,
       RANK() OVER(ORDER BY SUM(total_amount) DESC) AS rank_
FROM sales_data
GROUP BY customer_id, customer_name;

-- 8. Difference Between Current and Previous Sale per Customer
SELECT sale_id, customer_id, total_amount,
       total_amount - LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS diff_prev
FROM sales_data;

-- 9. Top 3 Most Expensive Products in Each Category
SELECT *
FROM (
  SELECT *, 
         DENSE_RANK() OVER(PARTITION BY product_category ORDER BY unit_price DESC) AS rnk
  FROM sales_data
) t
WHERE rnk <= 3;

-- 10. Cumulative Sum of Sales Per Region by Order Date
SELECT region, order_date, total_amount,
       SUM(total_amount) OVER(PARTITION BY region ORDER BY order_date) AS cumulative_sum
FROM sales_data;

---------------------------------------------------
-- MEDIUM QUERIES
---------------------------------------------------

-- 1. Cumulative Revenue per Product Category
SELECT product_category, order_date, total_amount,
       SUM(total_amount) OVER(PARTITION BY product_category ORDER BY order_date) AS cumulative_revenue
FROM sales_data;

-- 2. Sum of Previous Values (OneColumn)
CREATE TABLE OneColumn (Value SMALLINT);
INSERT INTO OneColumn VALUES (10),(20),(30),(40),(100);

SELECT Value,
       SUM(Value) OVER(ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [Sum of Previous]
FROM OneColumn;

-- 3. Customers who purchased from more than one category
SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

-- 4. Customers with Above-Average Spending in Their Region
SELECT DISTINCT customer_id, customer_name, region
FROM (
  SELECT customer_id, customer_name, region, SUM(total_amount) AS cust_total,
         AVG(SUM(total_amount)) OVER(PARTITION BY region) AS avg_regional
  FROM sales_data
  GROUP BY customer_id, customer_name, region
) t
WHERE cust_total > avg_regional;

-- 5. Rank customers by spending within region
SELECT customer_id, customer_name, region, SUM(total_amount) AS total_spent,
       RANK() OVER(PARTITION BY region ORDER BY SUM(total_amount) DESC) AS region_rank
FROM sales_data
GROUP BY customer_id, customer_name, region;

-- 6. Running total (cumulative sales) per customer
SELECT sale_id, customer_id, total_amount,
       SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data;

-- 7. Sales growth rate (month to month)
SELECT YEAR(order_date) AS yr, MONTH(order_date) AS mn, SUM(total_amount) AS monthly_sales,
       (SUM(total_amount) - LAG(SUM(total_amount)) OVER(ORDER BY YEAR(order_date), MONTH(order_date)))
        * 100.0 / LAG(SUM(total_amount)) OVER(ORDER BY YEAR(order_date), MONTH(order_date)) AS growth_rate
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date);

-- 8. Customers with order > their last order
SELECT sale_id, customer_id, total_amount,
       LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS prev_amount
FROM sales_data
WHERE total_amount > LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date);

---------------------------------------------------
-- HARD QUERIES
---------------------------------------------------

-- 1. Products above average price
SELECT DISTINCT product_name, unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

-- 2. Puzzle: Group Totals at First Row (MyData)
CREATE TABLE MyData (Id INT, Grp INT, Val1 INT, Val2 INT);
INSERT INTO MyData VALUES
(1,1,30,29),(2,1,19,0),(3,1,11,45),(4,2,0,0),(5,2,100,17);

SELECT Id, Grp, Val1, Val2,
       CASE WHEN ROW_NUMBER() OVER(PARTITION BY Grp ORDER BY Id)=1
            THEN SUM(Val1+Val2) OVER(PARTITION BY Grp)
       END AS Tot
FROM MyData;

-- 3. TheSumPuzzle
CREATE TABLE TheSumPuzzle (ID INT, Cost INT, Quantity INT);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164),(1234,13,164),(1235,100,130),(1235,100,135),(1236,12,136);

SELECT ID, SUM(Cost) AS Cost, SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-- 4. Find Gaps in Seats
CREATE TABLE Seats (SeatNumber INT);
INSERT INTO Seats VALUES
(7),(13),(14),(15),(27),(28),(29),(30),(31),(32),(33),(34),(35),(52),(53),(54);

SELECT (LAG(SeatNumber) OVER(ORDER BY SeatNumber)+1) AS GapStart,
       (SeatNumber-1) AS GapEnd
FROM Seats
WHERE SeatNumber - LAG(SeatNumber) OVER(ORDER BY SeatNumber) > 1
UNION ALL
SELECT 1, MIN(SeatNumber)-1 FROM Seats
UNION ALL
SELECT MAX(SeatNumber)+1, NULL FROM Seats;
