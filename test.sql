WITH department_delivery_quality AS (
  SELECT
    department,
    AVG(delivery_quality) AS dept_avg_delivery_quality
  FROM employees
  WHERE department = 'Product Architecture'
)
SELECT
  e.employee_id,
  e.full_name,
  e.position,
  e.delivery_quality,
  d.dept_avg_delivery_quality
FROM employees e
JOIN department_delivery_quality d
 ON e.department = d.department
WHERE certifications = '%AWS Solutions Architecture%' and department = 'Product Architecture'