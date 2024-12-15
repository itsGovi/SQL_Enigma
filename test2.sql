WITH certified AS (
    SELECT
        position,
        level,
        AVG(delivery_quality) as avg_with_aws
    FROM employees
    WHERE certifications LIKE '%AWS Solutions Architect%' AND department = 'Product Architecture'
    GROUP BY position, level, employee_id
),
not_certified AS (
    SELECT
        position,
        level,
        AVG(delivery_quality) AS avg_without_aws
    FROM employees
    WHERE certifications NOT LIKE '%AWS Solutions Architect%' AND department = 'Product Architecture'
    GROUP BY position, level, employee_id
),
with_name
SELECT
    wn.employee_id,
    wn.full_name,
    c.position,
    c.level,
    c.avg_with_aws,
    nc.avg_without_aws
FROM certified c
JOIN not_certified nc
    ON c.position = nc.position
    AND c.level = nc.level