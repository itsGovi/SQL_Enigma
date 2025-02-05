WITH regional_and_dept_avg_util AS (
    SELECT
        region,
        department,
        ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS reg_and_dept_avg_util
    FROM employees
    GROUP BY region, department
),
median_team_size AS (
    SELECT
    region,
    department,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_team_size) AS medain_team_size
    FROM employees
    GROUP BY region, department
)
SELECT
    e.employee_id,
    e.full_name,
    e.region,
    e.department,
    ROUND(CAST(e.avg_team_size AS NUMERIC), 0) AS employee_team_size,
    md.medain_team_size,
    e.actual_utilization,
    rd.reg_and_dept_avg_util
FROM employees e
JOIN regional_and_dept_avg_util rd
    ON e.region = rd.region AND e.department = rd.department
JOIN median_team_size md
    ON e.region = md.region AND e.department = md.department
WHERE e.avg_team_size > md.medain_team_size
    AND e.active_projects >= 3
    AND e.actual_utilization > rd.reg_and_dept_avg_util;