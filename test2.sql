WITH matched_certifications AS (
    -- Join the employees table with the Specialization & Certifications table
    SELECT
        e.employee_id,
        e.primary_specialization,
        e.certifications,
        s.certifications AS required_certifications,
        e.performance_score
    FROM employees e
    JOIN "Specialization & Certifications" s
        ON e.primary_specialization = s.primary_specialization
    -- Check if employee certifications match the required certifications for their specialization
    WHERE e.certifications LIKE '%' || s.certifications || '%'
),
employee_counts AS (
    -- Group by specialization and calculate the count of matching employees and their average performance score
    SELECT
        primary_specialization,
        required_certifications,  -- Include required certifications in the grouped data
        COUNT(*) AS employee_cnt,
        AVG(performance_score) AS avg_performance_score
    FROM matched_certifications
    GROUP BY primary_specialization, required_certifications
)
SELECT
    primary_specialization,
    required_certifications,   -- Show the certifications required for the specialization
    employee_cnt,
    ROUND(CAST((avg_performance_score) AS NUMERIC), 2) AS avg_performance_score
FROM employee_counts
ORDER BY employee_cnt DESC;  -- You can adjust sorting as needed
