WITH entry_level AS (
    SELECT
        department,
        ROUND(CAST(AVG(knowledge_sharing_score) AS NUMERIC), 2) AS avg_entry_level_score
    FROM employees
    WHERE level = 'entry'
    GROUP BY department
),
senior_level AS (
    SELECT
        department,
        ROUND(CAST(AVG(knowledge_sharing_score) AS NUMERIC),2) AS avg_senior_level_score
    FROM employees
    WHERE level = 'senior'
    GROUP BY department
)
SELECT
    e.department,
    e.avg_entry_level_score,
    s.avg_senior_level_score,
    ROUND(CAST(s.avg_senior_level_score - e.avg_entry_level_score AS NUMERIC), 2) AS difference
FROM entry_level e
JOIN senior_level s
    ON e.department = s.department;
