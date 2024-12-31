SELECT 
    department,
    primary_specialization,
    AVG(span_of_control) AS average_span_of_control
FROM 
    employees
WHERE 
    direct_reports > 5
    AND level IN ('mid', 'senior')
    AND base_salary > 150000
GROUP BY 
    department,
    primary_specialization
ORDER BY 
    department, primary_specialization;
