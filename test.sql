WITH high_risk_emps AS (
    SELECT
        department,
        employee_id,
        full_name,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) AS emp_yrs_in_cmpny,
        engagement_score
    FROM employees
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 5
        AND retention_risk = 'High'
),
department_engagement_stats AS (
    SELECT
        department,
        AVG(engagement_score) AS avg_engagement_score,
        STDDEV(engagement_score) AS engagement_score_variance
    FROM high_risk_emps
    GROUP BY department
)
SELECT
    h.department,
    h.employee_id,
    h.full_name,
    h.engagement_score,
    d.avg_engagement_score,
    d.engagement_score_variance,
    CASE
        WHEN h.engagement_score > d.avg_engagement_score THEN 'Above Average'
        WHEN h.engagement_score < d.avg_engagement_score THEN 'Below Average'
        ELSE 'Average'
    END AS is_average 
FROM high_risk_emps h
JOIN department_engagement_stats d ON h.department = d.department
ORDER BY d.engagement_score_variance DESC;