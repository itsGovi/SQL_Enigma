WITH department_delivery_quality AS (
  SELECT
    department,
    AVG(delivery_quality) AS dept_avg_delivery_quality
  FROM employees
  GROUP BY department
),
aws_certified_employees AS (
  SELECT
    department,
    AVG(delivery_quality) AS aws_cert_avg_delivery_quality
  FROM employees
  WHERE certifications LIKE '%AWS Solutions Architect%' -- Adjust based on how certifications are stored
  GROUP BY department
)
SELECT
  d.department,
  d.dept_avg_delivery_quality,
  a.aws_cert_avg_delivery_quality,
  CASE 
    WHEN a.aws_cert_avg_delivery_quality > 85 THEN 'Above 85%'
    ELSE 'Below 85%'
  END AS aws_cert_delivery_quality_status
FROM department_delivery_quality d
JOIN aws_certified_employees a
  ON d.department = a.department
WHERE a.aws_cert_avg_delivery_quality > d.dept_avg_delivery_quality;
