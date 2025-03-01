"Q1:"
WITH latest_hired_emps AS (
    -- Retrieve employees hired in the last 90 days
    SELECT
        employee_id,
        full_name,
        department,
        position,
        level,
        engagement_score
    FROM employees
    WHERE hire_date >= '2023-10-01'
),
latest_emp_avg AS (
    -- Calculate department-level average engagement score for recent hires
    SELECT
        department,
        AVG(engagement_score) AS recent_engt_avg
    FROM latest_hired_emps
    GROUP BY department
),
overall_emp_avg AS (
    -- Calculate department-level average engagement score for all employees
    SELECT
        department,
        AVG(engagement_score) AS overall_engt_avg
    FROM employees
    GROUP BY department
)
SELECT
    ROW_NUMBER() OVER (ORDER BY l.department, l.engagement_score DESC) AS index_no,
    l.employee_id,
    l.full_name,
    l.department,
    l.position,
    l.engagement_score AS emp_engagement_score,
    dept_avg.recent_engt_avg,
    dept_avg.overall_engt_avg
FROM latest_hired_emps l
JOIN (
    SELECT
        la.department,
        la.recent_engt_avg,
        oa.overall_engt_avg
    FROM latest_emp_avg la
    JOIN overall_emp_avg oa
        ON la.department = oa.department
) dept_avg
ON l.department = dept_avg.department
WHERE (l.engagement_score - dept_avg.overall_engt_avg) / dept_avg.overall_engt_avg > 0.1
ORDER BY l.department, l.engagement_score DESC;


---


"Q2:"
WITH exploded_certifications AS (
    SELECT
        UNNEST(STRING_TO_ARRAY(certifications, ',')) AS certificate_name,
        department,
        region
    FROM employees
),
certification_counts AS (
    SELECT
        certificate_name,
        department,
        region,
        COUNT(*) as total_count
    FROM exploded_certifications
    GROUP BY department, region, certificate_name
),
ranked_certifications AS (
    SELECT
        certificate_name,
        total_count,
        department,
        region,
        RANK() OVER (PARTITION BY region ORDER BY total_count) AS regional_rank
    FROM certification_counts
)

SELECT
    region,
    certificate_name,
    total_count,
    department
FROM ranked_certifications
WHERE regional_rank <= 3
ORDER BY region, regional_rank;


---


"Q3:"
WITH ranked_employees AS (
    SELECT
        region,
        RANK() OVER (PARTITION BY region ORDER BY total_comp DESC) AS rank,
        employee_id,
        full_name,
        department,
        total_comp,
        billing_rate
    FROM employees
),
regional_avg_billing AS (
    SELECT
        region,
        ROUND(AVG(billing_rate)::NUMERIC, 2) AS avg_billing_rate
    FROM employees
    GROUP BY region
)
SELECT
    r.*,
    rab.avg_billing_rate
FROM ranked_employees r
JOIN regional_avg_billing rab
    ON r.region = rab.region
WHERE rank <= 10 
AND r.billing_rate > rab.avg_billing_rate;


---


"Q4:"
WITH regional_avg AS (
    SELECT
        region,
        ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS avg_actual_utilization
    FROM employees
    WHERE region = 'Americas'
    GROUP BY region
)
SELECT
    e.employee_id,
    e.full_name,
    e.position,
    e.active_projects,
    e.actual_utilization, 
    ROUND(CAST((((e.actual_utilization - ra.avg_actual_utilization) / ra.avg_actual_utilization) * 100) AS NUMERIC), 2) AS difference
FROM employees e
JOIN regional_avg ra
    ON e.region = ra.region
WHERE e.active_projects > 2 
    AND ((e.actual_utilization - ra.avg_actual_utilization) / ra.avg_actual_utilization) * 100 > 10
    AND e.region = 'Americas';


---


"Q5:"

WITH dept_avg AS (
SELECT
    department,
    ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) AS dept_avg_project_satisfaction
FROM employees
WHERE region = 'EMEA' AND active_projects > 2 AND actual_utilization > 85
GROUP BY department
),
overall_avg AS (
SELECT
    department,
    ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) AS overall_avg_project_satisfaction
FROM employees
WHERE active_projects > 2 AND actual_utilization > 85
GROUP BY department
)
SELECT
    d.department,
    d.dept_avg_project_satisfaction,
    o.overall_avg_project_satisfaction
FROM dept_avg d 
JOIN overall_avg o 
    ON d.department = o.department
WHERE o.overall_avg_project_satisfaction > d.dept_avg_project_satisfaction


---


"Q6:"

WITH regional_and_dept_avg_util AS (
    SELECT
        region,
        department,
        ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS reg_and_dept_avg_util
    FROM employees
    GROUP BY region, department
),
median_team_size AS (
    SELECT
    region,
    department,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY avg_team_size) AS medain_team_size
    FROM employees
    GROUP BY region, department
)
SELECT
    e.employee_id,
    e.full_name,
    e.region,
    e.department,
    ROUND(CAST(e.avg_team_size AS NUMERIC), 0) AS employee_team_size,
    md.medain_team_size,
    e.actual_utilization,
    rd.reg_and_dept_avg_util
FROM employees e
JOIN regional_and_dept_avg_util rd
    ON e.region = rd.region AND e.department = rd.department
JOIN median_team_size md
    ON e.region = md.region AND e.department = md.department
WHERE e.avg_team_size > md.medain_team_size
    AND e.active_projects >= 3
    AND e.actual_utilization > rd.reg_and_dept_avg_util;


---


"Q7:"

WITH certificates_names AS (
    SELECT
        level,
        region,
        UNNEST(STRING_TO_ARRAY(certifications, ',')) AS certificate_name,
        department,
        innovation_score
    FROM employees
 ),
certification_counts AS (
    SELECT
        level,
        certificate_name,
        department,
        COUNT(*) AS count_of_cert_held_by_emp,
        ROUND(CAST(AVG(innovation_score) AS NUMERIC), 2) AS avg_innovation_score
    FROM certificates_names
    GROUP BY certificate_name, department, level
),
ranked_certs AS (
    SELECT
        department,
        certificate_name,
        avg_innovation_score,
        count_of_cert_held_by_emp,
        RANK() OVER (PARTITION BY department ORDER BY avg_innovation_score DESC) AS rnk
    FROM certification_counts
    WHERE count_of_cert_held_by_emp >= 5 AND level = 'entry'
)
SELECT
    department,
    certificate_name,
    count_of_cert_held_by_emp,
    avg_innovation_score
FROM ranked_certs
WHERE rnk = 1
ORDER BY avg_innovation_score DESC;


---


"Q8:"

WITH emp_count AS (
SELECT
    region,
    department,
    AVG(training_hours) AS avg_emp_training_hours
FROM employees
WHERE level = 'entry'
GROUP BY region, employee_id
),
rank_by_dept AS (
    SELECT
        DENSE_RANK() OVER (PARTITION BY department ORDER BY avg_emp_training_hours DESC) AS rnk,
        region,
        COUNT(*) AS total_count,
        avg_emp_training_hours
    FROM emp_count
    GROUP BY region, avg_emp_training_hours, department
)
SELECT
    rnk,
    region,
    total_count,
    avg_emp_training_hours
FROM rank_by_dept
    WHERE rnk <= 10
    ORDER BY region, rnk;


---


"Q9:"

SELECT
    region,
    SUM(revenue) as total_revenue
FROM employees
WHERE department = 'Client Services'
GROUP BY region
HAVING COUNT(employee_id) >= 5
ORDER BY total_revenue DESC;


---


"Q10:"

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


"Q11:"

WITH avg_act_util AS (
    SELECT
        employee_id,
        full_name,
        department,
        level,
        AVG(actual_utilization) AS avg_actual_utilization,
        base_salary,
        total_comp
    FROM employees
    GROUP BY employee_id, department, level, base_salary, total_comp
),
max_util_table AS (
    SELECT
        MAX(avg_actual_utilization) AS max_util,
        department,
        level
    FROM avg_act_util
    GROUP BY department, level
)

SELECT *
FROM (
    SELECT
        a.employee_id,
        a.full_name,
        m.department,
        m.level AS job_level,
        a.avg_actual_utilization,
        DENSE_RANK() OVER (PARTITION BY a.department, a.level ORDER BY a.avg_actual_utilization DESC) AS rnk,
        ROUND(((m.max_util - a.avg_actual_utilization))::numeric, 2) AS utilization_gap,
        ROUND((((m.max_util - a.avg_actual_utilization) / m.max_util * 100))::numeric, 2) AS percentage_gap
    FROM avg_act_util a
    JOIN max_util_table m
        ON a.department = m.department 
        AND a.level = m.level
) sub
WHERE percentage_gap <= 10;


"Q12:"

