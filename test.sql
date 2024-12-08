SELECT
  department,
  position,
  employee_id,
  full_name
FROM employees
WHERE flight_risk > 50 AND engagement_score < 5
GROUP BY department, position, employee_id;