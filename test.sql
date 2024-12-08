SELECT 
    SUM(billing_rate) AS total_billing_rate,
    department,
    AVG(billing_rate) AS department_avg_billing_rate
FROM employees
WHERE department = 'Engineering Delivery'
  AND actual_utilization > 80
  AND billing_rate > (
      SELECT AVG(billing_rate)
      FROM employees
      WHERE department = employees.department
  )
GROUP BY department;
