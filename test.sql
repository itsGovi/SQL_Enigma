SELECT
  COUNT(employee_id) AS total_employees,
  primary_specialization,
  AVG(experie)
FROM employees
GROUP BY primary_specialization;