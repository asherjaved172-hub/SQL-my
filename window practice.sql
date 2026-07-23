-- ==========================================================================
-- WINDOW FUNCTIONS — ROW_NUMBER, RANK, LAG/LEAD, running totals, moving avg
-- Prerequisite: run SQL/00-sample-schema.sql first
-- ==========================================================================

-- Q1: ROW_NUMBER — assign a unique sequential number to employees ordered by salary
SELECT
    first_name, last_name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- Q2: RANK vs DENSE_RANK — see how ties are handled differently
SELECT
    first_name, last_name, department_id, salary,
    RANK()       OVER (PARTITION BY department_id ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dense_rnk
FROM employees;

-- Q3: Top earner PER department using ROW_NUMBER + PARTITION BY
SELECT * FROM (
    SELECT
        first_name, last_name, department_id, salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn = 1;

-- Q4: Running total of order revenue, ordered by date
SELECT
    o.order_id,
    o.order_date,
    (oi.quantity * p.unit_price) AS order_line_revenue,
    SUM(oi.quantity * p.unit_price) OVER (ORDER BY o.order_date) AS running_total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date;

-- Q5: LAG — compare each employee's salary to the previous employee's salary
-- (ordered by hire_date, useful for spotting salary progression over time)
SELECT
    first_name, last_name, hire_date, salary,
    LAG(salary) OVER (ORDER BY hire_date) AS previous_hire_salary
FROM employees;

-- Q6: LEAD — show the next employee hired after each person
SELECT
    first_name, last_name, hire_date,
    LEAD(first_name) OVER (ORDER BY hire_date) AS next_hired_employee
FROM employees;

-- Q7: Moving average of the last 3 orders' revenue (frame clause)
SELECT
    o.order_id,
    o.order_date,
    (oi.quantity * p.unit_price) AS revenue,
    ROUND(AVG(oi.quantity * p.unit_price) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date;

-- Q8: NTILE — split employees into 2 salary "buckets" (halves)
SELECT
    first_name, last_name, salary,
    NTILE(2) OVER (ORDER BY salary DESC) AS salary_half
FROM employees;

-- Q9: PERCENT_RANK — relative standing of each employee's salary (0 to 1)
SELECT
    first_name, last_name, salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 3) AS salary_percentile
FROM employees;

-- Q10: FIRST_VALUE / LAST_VALUE within each department
SELECT DISTINCT
    department_id,
    FIRST_VALUE(first_name) OVER (PARTITION BY department_id ORDER BY salary DESC) AS highest_paid_in_dept,
    LAST_VALUE(first_name) OVER (
        PARTITION BY department_id ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_paid_in_dept
FROM employees;

-- ==========================================================================
-- 💡 Practice Tip: Window functions are the #1 differentiator between junior
-- and mid-level SQL analysts. Master PARTITION BY (grouping without
-- collapsing rows) and you'll handle 80% of real-world ranking/comparison
-- tasks.
-- ==========================================================================
