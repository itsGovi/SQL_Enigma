SELECT
    DISTINCT department
FROM employees
WHERE region = 'EMEA' AND active_projects > 2 AND actual_utilization > 85
GROUP BY employee_id

    employee_id,
    department,
    AVG(project_satisfaction) AS avg_project_satifaction