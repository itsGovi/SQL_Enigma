WITH dept_satis AS (
    SELECT
        department,
        ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) as avg_dept_project_satis
    FROM employees
    GROUP BY department
)
SELECT
    e.department,
    e.active_projects,
    e.employee_id,
    e.full_name,
    e.position,
    e.level,
    e.project_satisfaction,
    d.avg_dept_project_satis
FROM employees e
JOIN dept_satis d
    ON e.department = d.department
WHERE active_projects >= 3 AND e.project_satisfaction > d.avg_dept_project_satis
