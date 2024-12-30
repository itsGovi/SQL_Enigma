WITH median_value AS (
    SELECT
        department,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY training_hours) AS median_hours
    FROM employees
    GROUP BY department
),
AboveMedian AS (
    SELECT
        e.employee_id,
        e.full_name,
        e.department,
        e.training_hours,
        m.median_hours,
        e.performance_score
    FROM employees e
    JOIN median_value m
        ON e.department = m.department
    WHERE e.training_hours > m.median_hours
)
SELECT
    employee_id,
    full_name,
    department,
    performance_score
FROM AboveMedian
ORDER BY performance_score DESC;