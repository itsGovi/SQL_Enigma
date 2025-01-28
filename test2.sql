WITH exploded_certifications AS (
    SELECT
        UNNEST(STRING_TO_ARRAY(certifications, ',')) AS certificate_name,
        department,
        region
    FROM employees
),
certification_counts AS (
    SELECT
        certificate_name,
        department,
        region,
        COUNT(*) as total_count
    FROM exploded_certifications
    GROUP BY department, region, certificate_name
),
ranked_certifications AS (
    SELECT
        certificate_name,
        total_count,
        department,
        region,
        RANK() OVER (PARTITION BY region ORDER BY total_count) AS regional_rank
    FROM certification_counts
)

SELECT
    region,
    certificate_name,
    total_count,
    department
FROM ranked_certifications
WHERE regional_rank <= 3
ORDER BY region, regional_rank;