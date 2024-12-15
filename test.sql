WITH certified AS (
    SELECT
        COUNT(employee_id) AS emp_cnt,
        position,
        level,
        AVG(delivery_quality) as avg_with_aws
    FROM employees
    WHERE certifications LIKE '%AWS Solutions Architect%' AND department = 'Product Architecture'
    GROUP BY position, level
),
not_certified AS (
    SELECT
        position,
        level,
        AVG(delivery_quality) AS avg_without_aws
    FROM employees
    WHERE certifications NOT LIKE '%AWS Solutions Architect%' AND department = 'Product Architecture'
    GROUP BY position, level
)
SELECT
    c.position,
    c.level,
    c.emp_cnt,
    c.avg_with_aws,
    nc.avg_without_aws
FROM certified c
JOIN not_certified nc
    ON c.position = nc.position
    AND c.level = nc.level