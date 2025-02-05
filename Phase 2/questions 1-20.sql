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
