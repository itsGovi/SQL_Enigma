SELECT
    CAST(string_to_array(certifications,',') AS NUMERIC) AS certification,
    COUNT(employee_id) AS employee_cnt
FROM employees