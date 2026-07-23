-- ==========================================================================
-- INTERMEDIATE SQL — Aggregations, GROUP BY, HAVING, Subqueries
-- Prerequisite: run SQL/00-sample-schema.sql first
-- ==========================================================================

-- Q1: Total number of orders per customer
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- Q2: Average salary per department
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id;

-- Q3: Total quantity sold per product
SELECT product_id, SUM(quantity) AS total_quantity_sold
FROM order_items
GROUP BY product_id
ORDER BY total_quantity_sold DESC;

-- Q4: Departments with more than 2 employees (GROUP BY + HAVING)
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Q5: Products with an average order quantity greater than 5
SELECT product_id, AVG(quantity) AS avg_qty
FROM order_items
GROUP BY product_id
HAVING AVG(quantity) > 5;

-- Q6: Find employees who earn more than the company average salary (subquery)
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q7: Find customers who have never placed an order (subquery with NOT IN)
SELECT customer_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- Q8: Find the most expensive product per category (subquery in WHERE)
SELECT product_name, category, unit_price
FROM products p
WHERE unit_price = (
    SELECT MAX(unit_price)
    FROM products
    WHERE category = p.category
);

-- Q9: Count orders by status
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- Q10: Find the highest-paid employee in each department (subquery + join)
SELECT e.first_name, e.last_name, e.department_id, e.salary
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- Q11: Total revenue generated (quantity * unit_price) across all orders
SELECT ROUND(SUM(oi.quantity * p.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- Q12: Monthly order counts (date functions)
-- Note: MySQL uses DATE_FORMAT(); PostgreSQL uses TO_CHAR()
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month, COUNT(*) AS orders_count
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- ==========================================================================
-- 💡 Practice Tip: HAVING filters groups AFTER aggregation; WHERE filters
-- rows BEFORE aggregation. Mixing these up is one of the most common SQL
-- interview mistakes — make sure you can explain the difference out loud.
-- ==========================================================================
