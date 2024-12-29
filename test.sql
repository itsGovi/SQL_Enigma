WITH high_deliveriables AS (
    SELECT
        employee_id,
        department,
        UNNEST(string_to_array(certifications, ',')) as certificate
    FROM employees
    WHERE delivery_quality >= 85
),
ranked_cert AS (
SELECT
    department,
    certificate,
    COUNT(*) AS certificate_count,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY COUNT(*) DESC) AS row_num
FROM high_deliveriables
GROUP BY certificate, department
)

SELECT department, certificate, certificate_count
FROM ranked_cert
WHERE row_num = 1;