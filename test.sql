WITH sharing_score_bar AS (
    SELECT
        department,
            ROUND(CAST(AVG(knowledge_sharing_score) AS NUMERIC), 2) * 1.25 AS knowledge_sharing_bar
    FROM employees
    GROUP BY department
)
SELECT
    e.department,
    e.employee_id,
    e.full_name,
    e.knowledge_sharing_score,
    s.knowledge_sharing_bar
FROM employees e
JOIN sharing_score_bar s
    ON e.department = s.department
WHERE e.knowledge_sharing_score > s.knowledge_sharing_bar
ORDER BY e.knowledge_sharing_score DESC;
