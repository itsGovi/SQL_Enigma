WITH avg_satisfaction_by_attribute AS (
    -- Compute average project satisfaction by primary_specialization
    SELECT
        'primary_specialization' AS attribute_type,
        primary_specialization AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY primary_specialization

    UNION ALL

    -- Compute average project satisfaction by role
    SELECT
        'role' AS attribute_type,
        position AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY position

    UNION ALL

    -- Compute average project satisfaction by level
    SELECT
        'level' AS attribute_type,
        level AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY level
)
SELECT
    attribute_type,
    attribute_value,
    avg_satisfaction
FROM avg_satisfaction_by_attribute
ORDER BY avg_satisfaction DESC
LIMIT 3;
