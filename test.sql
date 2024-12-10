SELECT
  primary_specialization,
  COUNT(employee_id),
  AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date)) AS avg_years_of_experience,
  100*SUM((CASE WHEN performance_score > 7 THEN 1 ELSE 0 END) / COUNT(employee_id)) AS high_performance_score,
  RANK() OVER (ORDER BY count(employee_id) DESC) AS rank_of_specialization
FROM employees
GROUP BY primary_specialization