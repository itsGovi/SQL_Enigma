WITH grouped_data AS (
  SELECT
    is_manager,
    department,
    position,
    level,
    direct_reports,
    ROUND(CAST(avg_base_salary AS NUMERIC), 2) AS avg_base_salary,
    ROUND(CAST(avg_total_comp AS NUMERIC), 2) AS abg_total_comp
  FROM employees
  GROUP BY is_manager, department, position, level, direct_reports
)
SELECT
  g1.department,
  g1.position,
  g1.level,
  g1.avg_base_salary AS manager_base_comp,
  g2.avg_base_salary AS non_manager_base_comp,
  ROUND(CAST(g2.avg_base_salary - g1.avg_base_salary)/ g2.avg_base_salary * 100 AS NUMERIC), 2)
FROM