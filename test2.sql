SELECT
    ROW_NUMBER() OVER (ORDER BY hire_date DESC) AS index_no,
    employee_id,
    full_name,
    department,
    hire_date
FROM employees
ORDER BY hire_date DESC
LIMIT 23