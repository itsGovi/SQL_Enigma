SELECT
  employee_id,
  full_name,
  department,
  travel_percentage
FROM employees e
WHERE travel_percentage > (
  SELECT AVG(travel_percentage)
  FROM employees
  WHERE department = e.department
)
ORDER BY travel_percentage DESC;