SELECT
    employee_id,
    full_name,
    department,
    billing_rate
FROM employees
WHERE region = 'APAC'
ORDER BY billing_rate DESC LIMIT 5;