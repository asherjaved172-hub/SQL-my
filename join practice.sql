-- ==========================================================================
-- JOINS — INNER, LEFT, RIGHT, FULL OUTER, SELF, CROSS
-- Prerequisite: run SQL/00-sample-schema.sql first
-- ==========================================================================

-- Q1: INNER JOIN — only customers who have placed orders
SELECT c.customer_name, o.order_id, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- Q2: LEFT JOIN — all customers, including those with NO orders
-- (rows with no matching order will show NULL for order columns)
SELECT c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q3: LEFT JOIN + WHERE IS NULL — customers who have NEVER ordered
-- (a common pattern for finding "anti-joins")
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q4: RIGHT JOIN — all orders, even if (hypothetically) the customer record
-- were missing. Included for completeness (LEFT JOIN with tables swapped
-- achieves the same result and is more portable across engines)
SELECT c.customer_name, o.order_id
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- Q5: FULL OUTER JOIN — every customer AND every order, matched where possible
-- Note: MySQL does not support FULL OUTER JOIN natively; emulate with
-- LEFT JOIN UNION RIGHT JOIN. PostgreSQL/SQL Server support it directly.
SELECT c.customer_name, o.order_id
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- Q6: Multi-table JOIN — order details with customer name and product name
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    oi.quantity,
    p.unit_price,
    (oi.quantity * p.unit_price) AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Q7: SELF JOIN — pair employees who work in the same department
SELECT
    e1.first_name AS employee_1,
    e2.first_name AS employee_2,
    e1.department_id
FROM employees e1
JOIN employees e2
    ON e1.department_id = e2.department_id
    AND e1.employee_id < e2.employee_id  -- avoids duplicate/reverse pairs
ORDER BY e1.department_id;

-- Q8: CROSS JOIN — every possible product/customer combination
-- (useful for building a "coverage matrix", e.g. which customers have NOT
-- bought which products)
SELECT c.customer_name, p.product_name
FROM customers c
CROSS JOIN products p
ORDER BY c.customer_name, p.product_name;

-- Q9: JOIN + GROUP BY — total spend per customer, only showing customers
-- who spent more than $100
SELECT
    c.customer_name,
    ROUND(SUM(oi.quantity * p.unit_price), 2) AS total_spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_name
HAVING SUM(oi.quantity * p.unit_price) > 100;

-- Q10: Department + employee JOIN with a manager self-join combined
SELECT
    d.department_name,
    e.first_name AS employee_name,
    m.first_name AS manager_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON e.manager_id = m.employee_id;

-- ==========================================================================
-- 💡 Practice Tip: Draw the two tables on paper as circles (Venn-diagram
-- style) before writing a JOIN. It makes INNER vs LEFT vs FULL OUTER far
-- more intuitive than memorizing syntax.
-- ==========================================================================
