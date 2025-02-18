WITH employee_experience AS (
  SELECT
    region,
    employee_id,
    full_name,
    date_part('year', age(hire_date)) AS experience_years,
    avg_project_duration,
    department,
    active_projects
  FROM employees
  WHERE region = 'APAC'
),
experience_tags AS (
  SELECT
    employee_id,
    full_name,
    CASE
      WHEN experience_years BETWEEN 0 AND 2 THEN 'Junior'
      WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level'
      WHEN experience_years >= 6 THEN 'Senior'
      ELSE 'Unknown'
    END AS experience_level
  FROM employee_experience
),
dept_avg AS (
  SELECT
    department,
    AVG(avg_project_duration) AS dept_avg_project_duration
  FROM employees
  GROUP BY department
),
apac_median AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_project_duration) AS apac_median_duration
  FROM employees
  WHERE region = 'APAC'
)
-- Final Query
SELECT
  ee.employee_id,
  ee.full_name,
  ee.department,
  ee.avg_project_duration,
  da.dept_avg_project_duration,
  am.apac_median_duration,
  et.experience_level
FROM employee_experience ee
JOIN dept_avg da ON ee.department = da.department
CROSS JOIN apac_median am
JOIN experience_tags et ON ee.employee_id = et.employee_id
WHERE ee.active_projects >= 3
  AND ee.avg_project_duration > da.dept_avg_project_duration
  AND ee.avg_project_duration > am.apac_median_duration;