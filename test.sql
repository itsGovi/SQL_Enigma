WITH DeptUtilization AS (
    SELECT
        department,
        AVG(utilization_target) * 1.1 AS utilization_threshold
    FROM employees
    GROUP BY department
),
ExceedingEmployees AS (
    SELECT
        e.employee_id,
        e.full_name,
        e.department,
        e.actual_utilization,
        d.utilization_threshold,
        e.active_projects,
        e.level,
        e.performance_score
    FROM employees e
    JOIN DeptUtilization d
        ON e.department = d.department
    WHERE e.actual_utilization > d.utilization_threshold
      AND e.active_projects > 2
)
SELECT
    department,
    level,
    employee_id,
    full_name,
    performance_score
FROM ExceedingEmployees;