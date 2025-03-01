WITH avg_act_util AS (
    SELECT
        employee_id,
        full_name,
        department,
        level,
        AVG(actual_utilization) AS avg_actual_utilization,
        base_salary,
        total_comp
    FROM employees
    GROUP BY employee_id, department, level, base_salary, total_comp
),
max_util_table AS (
    SELECT
        MAX(avg_actual_utilization) AS max_util,
        department,
        level
    FROM avg_act_util
    GROUP BY department, level
)

SELECT *
FROM (
    SELECT
        a.employee_id,
        a.full_name,
        m.department,
        m.level AS job_level,
        a.avg_actual_utilization,
        DENSE_RANK() OVER (PARTITION BY a.department, a.level ORDER BY a.avg_actual_utilization DESC) AS rnk,
        ROUND(((m.max_util - a.avg_actual_utilization))::numeric, 2) AS utilization_gap,
        ROUND((((m.max_util - a.avg_actual_utilization) / m.max_util * 100))::numeric, 2) AS percentage_gap
    FROM avg_act_util a
    JOIN max_util_table m
        ON a.department = m.department 
        AND a.level = m.level
) sub
WHERE percentage_gap <= 10;