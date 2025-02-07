/*
For each region, identify the top 3 departments (with at least 10 employees)
where the average training hours of entry‑level employees have not only
exceeded the overall median training hours (computed over the past 3 years)
but have also shown a consistent upward trend.
*/
WITH emp_count AS (
SELECT
    region,
    department,
    AVG(training_hours) AS avg_emp_training_hours
FROM employees
WHERE level = 'entry'
GROUP BY region, employee_id
),
rank_by_dept AS (
    SELECT
        RANK() OVER (PARTITION BY department ORDER BY avg_emp_training_hours DESC) AS rnk,
        region,
        COUNT(*) AS total_count,
        avg_emp_training_hours
    FROM emp_count
    GROUP BY region, avg_emp_training_hours, department
)
SELECT
    rnk,
    region,
    total_count,
    avg_emp_training_hours
FROM rank_by_dept
    WHERE rnk <= 10
    ORDER BY region, rnk