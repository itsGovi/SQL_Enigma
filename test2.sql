WITH grouped_data AS (
  SELECT
    department,
    position,
    level,
    direct_reports,
    is_manager,
    AVG(base_salary) AS avg_base_salary,
    AVG(total_comp) AS avg_total_comp
  FROM employees
  GROUP BY department, position, level, is_manager, direct_reports
)
SELECT
  g1.department,
  g1.position,
  g1.level,
  g1.direct_reports,
  ROUND(CAST(g1.avg_base_salary AS NUMERIC), 2) AS manager_base_comp,
  ROUND(CAST(g2.avg_base_salary AS NUMERIC), 2) AS non_manager_base_comp,
  ROUND(CAST((g1.avg_base_salary - g2.avg_base_salary) / g2.avg_base_salary * 100 AS NUMERIC), 2) AS base_diff_percentage,
  ROUND(CAST(g1.avg_total_comp AS NUMERIC), 2) AS manager_total_comp,
  ROUND(CAST(g2.avg_total_comp AS NUMERIC), 2) AS non_manager_total_comp,
  ROUND(CAST((g1.avg_total_comp - g2.avg_total_comp) / g2.avg_total_comp * 100 AS NUMERIC), 2) AS total_comp_diff_percentage
FROM grouped_data g1
JOIN grouped_data g2
  ON g1.department = g2.department
  AND g1.position = g2.position
  AND g1.is_manager = TRUE
  AND g2.is_manager = FALSE
WHERE (g1.avg_total_comp - g2.avg_total_comp) > 0 AND (g1.avg_base_salary - g2.avg_base_salary) > 0;