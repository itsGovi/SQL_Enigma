SELECT 
    m.employee_id AS manager_emp_id,
    m.full_name,
    COUNT(e.employee_id) AS emp_managed,
    ROUND(CAST(AVG(e.project_satisfaction) AS NUMERIC), 2) AS avg_project_satisfaction
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE m.is_manager = TRUE
GROUP BY m.employee_id, m.full_name;