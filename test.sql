SELECT
    certificate_name,
    COUNT(*) AS total_count
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(certifications, ',')) AS certificate_name
    FROM employees
)
GROUP BY certificate_name