SELECT
  employee_id,
  full_name,
  department,
  position,
  promotion_readiness
FROM employees
WHERE region = 'APAC' AND promotion_readiness > 75