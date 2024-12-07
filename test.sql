SELECT
    employee_id,
    full_name,
    department,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_in_role
FROM (  
    SELECT
        employee_id,
        full_name,
        department,
        hire_date,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date ASC) AS rank
    FROM employees
) AS ranked_employees
WHERE rank <= 5;