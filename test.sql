SELECT
  region,
  is_manager,
  employee_id,
  department,
  position,
  level,
  AVG(base_salary),
  AVG(total_comp)
FROM employees


/*
SELECT
  employee_id,
  full_name,
  region,
  position,
  level,
  is_manager
FROM employees
WHERE is_manager = 'False'
GROUP BY 
*/