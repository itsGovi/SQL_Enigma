/*
For each department in the EMCA region, calculate the average project
satisfaction of employees who have more than three active projects and
actual utilization above 90%. Then, compare this department-level average
with the overall company-wide average project satisfaction. Return only the
departments where the average project satisfaction is below the company-wide
average.*/

/*SELECT
    ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) AS avg_project_satisfaction
FROM employees
WHERE active_projects > 2 AND actual_utilization > 85 AND region = 'Client Services' AND region = 'Engineering Delivery'
GROUP BY department,region*/

SELECT
    department,
    ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) AS avg_project_satisfaction
FROM employees
WHERE active_projects > 2 AND actual_utilization > 85
GROUP BY department