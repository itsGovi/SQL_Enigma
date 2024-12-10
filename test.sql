SELECT
  employee_id,
  full_name,
  department,
  utilization_target,
  actual_utilization,
  CASE WHEN utilization_target > AVG(utilization_target) THEN 1 ELSE 0 END
FROM employees
GROUP BY department, employee_id