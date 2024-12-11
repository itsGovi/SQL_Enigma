SELECT
    DENSE_RANK() OVER (ORDER BY project_satisfaction DESC) AS rank,
  employee_id,
  full_name,
  department,
  project_satisfaction
FROM employees
WHERE level = 'senior'
ORDER BY project_satisfaction DESC