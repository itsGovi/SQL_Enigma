WITH region_avg_billing AS (
SELECT
        region,
        department,
        position,
        level,
        ROUND(CAST(AVG(billing_rate) AS NUMERIC), 2) AS avg_billing_rate
    FROM employees
    GROUP BY region, department, position, level
)
SELECT
    e.department,
    e.employee_id,
    e.full_name,
    e.position,
    e.level,
    e.primary_specialization,
    e.billing_rate,
    r.avg_billing_rate
FROM employees e
JOIN region_avg_billing r
    ON e.department = r.department
    AND e.region = r.region
    AND e.position = r.position
    AND e.level = r.level
WHERE e.billing_rate > r.avg_billing_rate