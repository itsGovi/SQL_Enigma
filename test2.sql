WITH regional_avg AS (
    SELECT
        region,
        ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS avg_actual_utilization
    FROM employees
    WHERE region = 'Americas'
    GROUP BY region
)
SELECT
    e.employee_id,
    e.full_name,
    e.position,
    e.active_projects,
    e.actual_utilization, 
    ROUND(CAST((((e.actual_utilization - ra.avg_actual_utilization) / ra.avg_actual_utilization) * 100) AS NUMERIC), 2) AS difference
FROM employees e
JOIN regional_avg ra
    ON e.region = ra.region
WHERE e.active_projects > 2 
    AND ((e.actual_utilization - ra.avg_actual_utilization) / ra.avg_actual_utilization) * 100 > 10
    AND e.region = 'Americas';