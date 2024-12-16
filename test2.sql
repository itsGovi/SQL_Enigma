SELECT
    unnest(string_to_array(certifications, ',')) AS certification,
    COUNT(*) AS employee_count
FROM employees
GROUP BY certification;