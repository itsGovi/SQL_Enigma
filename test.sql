WITH emp_count AS (
    SELECT
        region,
        position,
        COUNT(employee_id) AS employee_count
    FROM employees
    WHERE level = 'mid'
    GROUP BY region, position
)
SELECT
    e.position,
    ec.employee_count,
    ROUND(CAST(AVG(billing_rate) AS NUMERIC), 2) AS avg_billing_rate,
    ROUND(CAST(AVG(engagement_score) AS NUMERIC), 2) AS avg_engagement_score
FROM employees e
JOIN emp_count ec
    ON e.position = ec.position
WHERE e.region = 'EMEA' /* change as you want - Americas, EPAC, EMEA */
GROUP BY e.region, e.position, ec.employee_count