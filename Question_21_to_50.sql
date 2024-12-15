-- Question 21: Analyze the `base_salary` distribution across regions, and compare it with the average `total_comp` of managers and non-managers in each region.
"""
I've better aligned the question with data at hand (a bit harder too):
Analyze compensation differences among employees at the same level (mid, senior,
entry) across departments and positions. Incorporate team size (direct_reports)
and management responsibilities (is_manager) to identify how average total_comp
varies within each department and position. Highlight departments or roles where
the compensation gaps are significant.
"""
WITH grouped_data AS (
  SELECT
    is_manager,
    department,
    position,
    level,
    direct_reports,
    ROUND(CAST(AVG(base_salary) AS NUMERIC), 2) AS avg_base_salary,
    ROUND(CAST(AVG(total_comp) AS NUMERIC), 2) AS avg_total_comp
  FROM employees
  GROUP BY is_manager, department, position, level, direct_reports
)
SELECT
  g1.department,
  g1.position,
  g1.level,
  g1.direct_reports,
  g1.avg_base_salary AS manager_base_comp,
  g2.avg_base_salary AS non_manager_base_comp,
  ROUND(CAST((g1.avg_base_salary - g2.avg_base_salary)/ g2.avg_base_salary * 100 AS NUMERIC), 2) AS base_diff_percentage,
  g1.avg_total_comp AS manager_total_comp,
  g2.avg_total_comp AS non_manager_total_comp,
  ROUND(CAST((g1.avg_total_comp - g2.avg_total_comp)/ g2.avg_total_comp * 100 AS NUMERIC), 2) AS total_comp_diff_percentage
FROM grouped_data g1
JOIN grouped_data g2
  ON g1.department = g2.department
  AND g1.position = g2.position
  AND g1.level = g2.level
  AND g1.is_manager = TRUE
  AND g2.is_manager = FALSE
WHERE (g1.avg_base_salary - g2.avg_base_salary) > 0 AND (g1.avg_total_comp - g2.avg_total_comp) > 0;
