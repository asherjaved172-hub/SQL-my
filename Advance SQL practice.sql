-- ==========================================================================
-- ADVANCED SQL — Multi-step logic, correlated subqueries, set operations
-- Prerequisite: run SQL/00-sample-schema.sql first
-- ==========================================================================

-- Q1: Correlated subquery — customers whose total spend is above the
-- average total spend across all customers
SELECT c.customer_name, SUM(oi.quantity * p.unit_price) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name
HAVING SUM(oi.quantity * p.unit_price) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(oi2.quantity * p2.unit_price) AS customer_total
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        JOIN products p2 ON oi2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) AS customer_totals
);

-- Q2: EXISTS — find customers who have placed at least one 'Completed' order
SELECT customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id AND o.status = 'Completed'
);

-- Q3: UNION — combine a list of high earners and long-tenured employees
-- (UNION removes duplicates; UNION ALL keeps them)
SELECT first_name, last_name, 'High Earner' AS reason FROM employees WHERE salary > 90000
UNION
SELECT first_name, last_name, 'Long Tenured' AS reason FROM employees WHERE hire_date < '2019-01-01';

-- Q4: CASE expression — categorize products into price tiers
SELECT
    product_name,
    unit_price,
    CASE
        WHEN unit_price < 10 THEN 'Low'
        WHEN unit_price BETWEEN 10 AND 100 THEN 'Medium'
        ELSE 'High'
    END AS price_tier
FROM products;

-- Q5: Self-join — list each employee alongside their manager's name
SELECT
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    m.first_name AS manager_first_name,
    m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- Q6: Pivot-style aggregation using CASE + SUM (conditional aggregation)
SELECT
    p.category,
    SUM(CASE WHEN o.status = 'Completed' THEN oi.quantity ELSE 0 END) AS completed_qty,
    SUM(CASE WHEN o.status = 'Cancelled' THEN oi.quantity ELSE 0 END) AS cancelled_qty
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;

-- Q7: Find the second-highest salary WITHOUT using LIMIT/OFFSET
-- (classic interview question — works across all SQL dialects)
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Q8: Running percentage of total revenue contributed by each product
SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * p.unit_price), 2) AS product_revenue,
    ROUND(
        100.0 * SUM(oi.quantity * p.unit_price) /
        (SELECT SUM(oi2.quantity * p2.unit_price)
         FROM order_items oi2 JOIN products p2 ON oi2.product_id = p2.product_id),
        2
    ) AS pct_of_total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC;

-- ==========================================================================
-- 💡 Practice Tip: Advanced SQL interview questions almost always test
-- whether you can decompose a big problem into smaller subqueries. Practice
-- explaining each subquery's purpose out loud before writing the outer query.
-- ==========================================================================
