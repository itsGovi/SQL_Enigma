SELECT
    ROW_NUMBER() OVER (ORDER BY hire_date DESC)
    employee_id,
    full_name,
    department,
    engagement_score
FROM employees
WHERE hire_date >= '2023-10-01'
ORDER BY hire_date DESC