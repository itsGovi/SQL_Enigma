SELECT
    employee_id,
    full_name,
    department,
    position,
    level,
    LENGTH(certifications) - LENGTH(REPLACE(certifications, ',', '')) + 1 AS certificate_count,
    flight_risk
FROM employees
WHERE flight_risk <20
    AND LENGTH(certifications) - LENGTH(REPLACE(certifications, ',', '')) + 1 >= 2
GROUP BY department, position, level, employee_id, full_name