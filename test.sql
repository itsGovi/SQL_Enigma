SELECT 
    COUNT(employee_id),
    department,
    level
FROM employees
WHERE remote_work_ratio > 30
GROUP BY department, level;
