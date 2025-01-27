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
