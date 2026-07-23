-- ==========================================================================
-- BASIC SQL — SELECT, WHERE, ORDER BY, LIMIT, basic filtering
-- Prerequisite: run SQL/00-sample-schema.sql first
-- ==========================================================================

-- Q1: Select all columns from the customers table
SELECT * FROM customers;

-- Q2: Select only customer_name and city (column selection)
SELECT customer_name, city FROM customers;

-- Q3: Find all customers based in Pakistan
SELECT customer_name, city
FROM customers
WHERE country = 'Pakistan';

-- Q4: Find all products priced above $50
SELECT product_name, unit_price
FROM products
WHERE unit_price > 50;

-- Q5: Find all products in the 'Electronics' OR 'Furniture' category
SELECT product_name, category, unit_price
FROM products
WHERE category IN ('Electronics', 'Furniture');

-- Q6: Find all orders that are NOT cancelled
SELECT order_id, order_date, status
FROM orders
WHERE status <> 'Cancelled';

-- Q7: Find employees hired after Jan 1, 2020
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2020-01-01';

-- Q8: Find employees whose salary is between 60,000 and 100,000
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 60000 AND 100000;

-- Q9: Find customers whose name starts with the letter 'L' (pattern matching)
SELECT customer_name
FROM customers
WHERE customer_name LIKE 'L%';

-- Q10: Sort products by price, highest first
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC;

-- Q11: Get the 3 cheapest products
SELECT product_name, unit_price
FROM products
ORDER BY unit_price ASC
LIMIT 3;

-- Q12: Find employees with no manager (top of the org chart) using IS NULL
SELECT first_name, last_name
FROM employees
WHERE manager_id IS NULL;

-- Q13: Count how many customers exist in total
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q14: Select distinct countries our customers come from
SELECT DISTINCT country
FROM customers;

-- Q15: Combine first and last name into a single "full_name" column (string concatenation)
-- Note: MySQL uses CONCAT(); PostgreSQL supports both CONCAT() and the || operator
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

-- ==========================================================================
-- 💡 Practice Tip: Try changing the WHERE conditions above (different price
-- thresholds, different countries, different date ranges) and predict the
-- result before running the query. This builds real query-writing intuition.
-- ==========================================================================
