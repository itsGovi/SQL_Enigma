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



-- Question 22: compare the average delivery_quality of employees with the AWS Solutions Architect certification to those without it, within the department where this certification is present. The comparison should be based on the department and certification status.
WITH certified AS (
    SELECT
        COUNT(employee_id) AS emp_cnt_with_aws,
        position,
        level,
        AVG(delivery_quality) AS avg_with_aws
    FROM employees
    WHERE certifications LIKE '%AWS Solutions Architect%' 
      AND department = 'Product Architecture'
    GROUP BY position, level
),
not_certified AS (
    SELECT
        COUNT(employee_id) AS emp_cnt_without_aws,
        position,
        level,
        AVG(delivery_quality) AS avg_without_aws
    FROM employees
    WHERE (certifications NOT LIKE '%AWS Solutions Architect%' OR certifications IS NULL) 
      AND department = 'Product Architecture'
    GROUP BY position, level
)
SELECT
    c.position,
    c.level,
    c.emp_cnt_with_aws,
    c.avg_with_aws,
    nc.emp_cnt_without_aws,
    nc.avg_without_aws
FROM certified c
JOIN not_certified nc
    ON c.position = nc.position
    AND c.level = nc.level;



-- Questions 23: Explore the relationship between `remote_work_ratio` and `engagement_score` across regions, grouping employees by `job level`.
WITH remote_work_classification AS (
    SELECT
        region,
        position,
        level,
        CASE
            WHEN remote_work_ratio BETWEEN 0 AND 5 THEN '0-5%'
            WHEN remote_work_ratio BETWEEN 6 AND 10 THEN '6-10%'
            WHEN remote_work_ratio BETWEEN 11 AND 15 THEN '11-15%'
            WHEN remote_work_ratio BETWEEN 16 AND 20 THEN '16-20%'
            WHEN remote_work_ratio BETWEEN 21 AND 25 THEN '21-25%'
            WHEN remote_work_ratio BETWEEN 26 AND 30 THEN '26-30%'
            WHEN remote_work_ratio BETWEEN 31 AND 40 THEN '31-40%'  -- Grouped wider for sparse data
            ELSE '41-50%' -- Include the highest remote work ratio
        END AS remote_work_class,
        remote_work_ratio,
        engagement_score
    FROM employees
)
SELECT
    position,
    level,
    COUNT(*) AS employee_cnt,
    remote_work_class,
    ROUND(CAST(AVG(remote_work_ratio) AS NUMERIC), 2) AS avg_remote_ratio,
    ROUND(CAST(AVG(engagement_score) AS NUMERIC), 2) AS avg_engagement_score
FROM remote_work_classification
WHERE region = 'APAC'  -- Restrict to the Americas region
GROUP BY position, level, remote_work_class
ORDER BY position, level, remote_work_class;



-- Question 24: Find employees whose certifications align perfectly with their `primary_specialization` and calculate their average `performance_score`.
"""
Complete List of Primary Specializations and Suggested Certifications

| **Primary Specialization**      | **Suggested Certifications**                                                       |
|----------------------------------|-----------------------------------------------------------------------------------|
| **Mobile Development**           | AWS Developer, Azure Developer                                                   |
| **System Integration**           | TOGAF, Azure Architect                                                            |
| **Full Stack**                   | AWS Solutions Architect, Azure Developer                                          |
| **DevOps**                       | Kubernetes, AWS Developer                                                         |
| **User Research**                | Google UX Design, Human Factors International                                     |
| **Change Management**            | PMP, Prince2                                                                     |
| **Cloud Native**                 | AWS Solutions Architect, Google Cloud Architect                                   |
| **Web Applications**             | AWS Developer, Google Cloud Architect                                             |
| **Digital Transformation**       | Agile Product Management, Google Cloud Architect                                  |
| **Service Design**               | Interaction Design Foundation, Human Factors International                        |
| **Data Architecture**            | AWS Solutions Architect, Google Cloud Architect                                   |
| **Go-to-Market**                 | Agile Project Management, PMP                                                    |
| **Market Analysis**              | Product Management (PMP), PSPO                                                   |
| **Innovation Strategy**          | Strategic Planning, Agile Leadership                                              |
| **Product Discovery**            | Design Thinking, Google UX Design                                                |
| **Portfolio Management**         | PMP, Prince2                                                                     |
| **Microservices**                | AWS Solutions Architect, Kubernetes                                              |
| **Digital Strategy**             | PSPO, Agile Product Management                                                   |
| **Backend**                      | AWS Solutions Architect, Google Cloud Architect                                   |
| **Strategic Planning**           | Strategic Planning Certification, Agile Leadership                                |
| **Cloud Infrastructure**         | AWS Solutions Architect, Azure Architect                                         |
| **Frontend**                     | Google UX Design, Interaction Design Foundation                                  |
| **Design Thinking**              | Design Thinking Certification, Google UX Design                                  |
| **Design Systems**               | Design Thinking, Interaction Design Foundation                                   |
| **API Design**                   | AWS Solutions Architect, Google Cloud Architect                                   |
| **Agile Delivery**               | Scrum Master, Agile Project Management                                           |
| **Mobile Design**                | Google UX Design, Human Factors International                                     |
| **Security Architecture**        | AWS Solutions Architect, Azure Architect                                         |



Role and Suggested Certifications Mapping

| **Department**           | **Position**               | **Level**   | **Suggested Certifications**                       |
|---------------------------|----------------------------|-------------|---------------------------------------------------|
| **Engineering Delivery**  | Associate Developer        | Entry       | AWS Developer, Scrum Master                       |
|                           | Senior Developer           | Mid         | AWS Solutions Architect, Kubernetes               |
|                           | Cloud Architect            | Mid         | Azure Architect, Google Cloud Architect           |
|                           | Principal Engineer         | Senior      | TOGAF, AWS Solutions Architect                    |
|                           | QA Engineer I              | Entry       | ISTQB Certification, Azure Developer              |
|                           | Junior DevOps              | Entry       | DevOps Foundation, AWS Developer                  |
|                           | Tech Lead                 | Mid         | TOGAF, DevOps Engineer                            |
| **Product Architecture**  | Solution Architect         | Mid         | AWS Solutions Architect, TOGAF                   |
|                           | Enterprise Architect       | Mid         | Google Cloud Architect, TOGAF                    |
|                           | Senior Enterprise Architect | Senior     | TOGAF, Azure Architect                            |
|                           | System Analyst I           | Entry       | Business Analysis, AWS Solutions Architect        |
| **Design & UX**           | UI Designer I              | Entry       | Google UX Design, Interaction Design Foundation   |
|                           | Senior UX Designer         | Mid         | Human Factors International, Google UX Design     |
|                           | Principal Designer         | Senior      | Design Thinking, Human Factors International     |
|                           | Design System Specialist   | Entry       | Interaction Design Foundation, Design Thinking   |
| **Client Services**       | Engagement Analyst         | Entry       | Agile Project Management, PMP                     |
|                           | Engagement Manager         | Mid         | Prince2, Scrum Master                             |
|                           | Senior Program Director    | Senior      | PMP, Prince2                                      |
|                           | Project Coordinator        | Entry       | Agile Project Management, Prince2                 |
|                           | Program Manager            | Mid         | Prince2, PMP                                      |
|                           | Client Partner             | Mid         | PMP, Agile Leadership                             |
| **Product Strategy**      | Product Analyst            | Entry       | Agile Product Management, Scrum Master            |
|                           | Product Strategist         | Mid         | PSPO, Product Management (PMP)                   |
|                           | Senior Strategy Lead       | Senior      | Strategic Planning, Agile Leadership             |
|                           | Chief Product Officer      | Senior      | Product Management (PMP), TOGAF                  |
"""

WITH matched_certifications AS (
    -- Join the employees table with the Specialization & Certifications table
    SELECT
        e.employee_id,
        e.primary_specialization,
        e.certifications,
        s.certifications AS required_certifications,
        e.performance_score
    FROM employees e
    JOIN "Specialization & Certifications" s
        ON e.primary_specialization = s.primary_specialization
    -- Check if employee certifications match the required certifications for their specialization
    WHERE e.certifications LIKE '%' || s.certifications || '%'
),
employee_counts AS (
    -- Group by specialization and calculate the count of matching employees and their average performance score
    SELECT
        primary_specialization,
        required_certifications,  -- Include required certifications in the grouped data
        COUNT(*) AS employee_cnt,
        AVG(performance_score) AS avg_performance_score
    FROM matched_certifications
    GROUP BY primary_specialization, required_certifications
)
SELECT
    primary_specialization,
    required_certifications,   -- Show the certifications required for the specialization
    employee_cnt,
    ROUND(CAST((avg_performance_score) AS NUMERIC), 2) AS avg_performance_score
FROM employee_counts
ORDER BY employee_cnt DESC;  -- You can adjust sorting as needed



-- Question 25: Compute the average `project_satisfaction` for departments with >= 3 `active_projects`, highlighting any outliers in satisfaction.
WITH dept_satis AS (
    SELECT
        department,
        ROUND(CAST(AVG(project_satisfaction) AS NUMERIC), 2) as avg_dept_project_satis
    FROM employees
    GROUP BY department
)
SELECT
    e.department,
    e.active_projects,
    e.employee_id,
    e.full_name,
    e.position,
    e.level,
    e.project_satisfaction,
    d.avg_dept_project_satis
FROM employees e
JOIN dept_satis d
    ON e.department = d.department
WHERE active_projects >= 3 AND e.project_satisfaction > d.avg_dept_project_satis



-- Question 26. Compare the `flight_risk` of employees across departments, grouping by `management_level` and `travel_percentage`.

WITH general_flight_risk AS (
    SELECT
        department,
        management_level,
        ROUND(CAST(AVG(flight_risk) AS NUMERIC), 2) AS avg_flight_risk,
        ROUND(CAST(STDDEV(flight_risk) AS NUMERIC), 2) AS flight_risk_variance
    FROM employees
    GROUP BY department, management_level
)
SELECT *
FROM (
    SELECT
        e.department,
        e.management_level,
        e.employee_id,
        e.full_name,
        e.travel_percentage,
        e.flight_risk,
        g.avg_flight_risk,
        g.flight_risk_variance,
        CASE
            WHEN e.flight_risk > g.avg_flight_risk THEN 'Above Average'
            WHEN e.flight_risk < g.avg_flight_risk THEN 'Below Average'
            ELSE 'Average'
        END AS comparision
    FROM employees e
    JOIN general_flight_risk g
        ON e.department = g.department
) subquery
ORDER BY comparision, flight_risk_variance DESC;

"""
-> When SQL sees ORDER BY comparision, it fails if comparision isn't precomputed or directly available.
-> By turning the query into a subquery, you explicitly precompute comparision and pass it to the outer query.

Why This Works:
-> The subquery ensures comparision is available as a column in the temporary result, so ORDER BY comparision is valid.
"""



-- Question 27. Identify employees whose `knowledge_sharing_score` exceeds the department average by 25% or more and list their `primary_specialization`.
WITH sharing_score_bar AS (
    SELECT
        department,
        AVG(knowledge_sharing_score) * 1.25 AS knowledge_sharing_bar
    FROM employees
    GROUP BY department
)
SELECT
    e.department,
    e.employee_id,
    e.full_name,
    e.primary_specialization,
    e.knowledge_sharing_score
FROM employees e
JOIN sharing_score_bar s
    ON e.department = s.department
WHERE e.knowledge_sharing_score > s.knowledge_sharing_bar
ORDER BY e.knowledge_sharing_score DESC;



-- Question 28: List underutilized employees (`actual_utilization` < `utilization_target`) with a `performance_score` greater than 4, ranking them by their `engagement_score`.
WITH less_used_emps AS (
    SELECT
        department,
        CASE WHEN actual_utilization < utilization_target THEN TRUE ELSE FALSE END underutilization_bar
    FROM employees
    GROUP BY department, underutilization_bar
)
SELECT
    e.department,
    e.employee_id,
    e.full_name,
    e.performance_score,
    e.engagement_score
FROM employees e
JOIN less_used_emps l
    ON e.department = l.department
WHERE e.performance_score > 4 AND l.underutilization_bar = TRUE
ORDER BY engagement_score DESC;



-- Question 29: Identify employees who have worked for more than 5 years but have a `retention_risk` of 'High' and analyze their `engagement_score`.
WITH high_risk_emps AS (
    SELECT
        department,
        employee_id,
        full_name,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) AS emp_yrs_in_cmpny,
        engagement_score
    FROM employees
    WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date) > 5
        AND retention_risk = 'High'
),
department_engagement_stats AS (
    SELECT
        department,
        AVG(engagement_score) AS avg_engagement_score,
        STDDEV(engagement_score) AS engagement_score_variance
    FROM high_risk_emps
    GROUP BY department
)
SELECT
    h.department,
    h.employee_id,
    h.full_name,
    h.engagement_score,
    d.avg_engagement_score,
    d.engagement_score_variance,
    CASE
        WHEN h.engagement_score > d.avg_engagement_score THEN 'Above Average'
        WHEN h.engagement_score < d.avg_engagement_score THEN 'Below Average'
        ELSE 'Average'
    END AS is_average 
FROM high_risk_emps h
JOIN department_engagement_stats d ON h.department = d.department
ORDER BY d.engagement_score_variance DESC;



-- Question 30: Identify employees from 'Engineering Delivery' and 'Design & UX' whose promotion_readiness is in the top 25% of their respective departments. List their employee_id, full_name, department, and promotion_readiness, sorted by department and readiness in descending order.

WITH top25_readiness AS (
    SELECT
        employee_id,
        full_name,
        department,
        promotion_readiness,
        ROUND(CAST(PERCENT_RANK() OVER (PARTITION BY department ORDER BY promotion_readiness DESC) AS NUMERIC) * 100, 0) AS rank
    FROM employees
)
SELECT
    employee_id,
    full_name,
    department,
    promotion_readiness,
    rank
FROM top25_readiness
WHERE department IN ('Engineering Delivery', 'Design & UX')
  AND rank <= 25
ORDER BY department, promotion_readiness DESC;



-- Question 31: Determine departments with the highest standard deviation in `avg_project_complexity`.

SELECT
    department,
    STDDEV(avg_project_complexity) AS std_avg_project_complex
FROM employees
GROUP BY department
ORDER BY std_avg_project_complex DESC;



-- Question 32: Identify certifications commonly associated with employees having a `delivery_quality` above 90%.

WITH filtered_employees AS (
    SELECT
        employee_id,
        string_to_array(certifications, ',') AS cert_list
    FROM employees
    WHERE delivery_quality >= 90
),
certificates AS (
    SELECT
        employee_id,
        UNNEST(cert_list) AS certificate
    FROM filtered_employees

)
SELECT
    certificate,
    COUNT(DISTINCT employee_id) AS Emps_holding_certificate
FROM certificates
GROUP BY certificate
ORDER BY Emps_holding_certificate DESC



-- Question 33: Identify employees with fewer than 5 mentorship_hours but who have led more than 2 team_lead_projects, grouped by department, and rank them by team_lead_projects in descending order.

SELECT
    employee_id,
    full_name,
    department,
    mentorship_hours,
    team_lead_projects
FROM employees
WHERE mentorship_hours <= 10 AND team_lead_projects > 2
GROUP BY department, employee_id
ORDER BY team_lead_projects DESC



-- Question 34: List employees whose `billing_rate` exceeds the regional average and highlight their `primary_specialization`.

WITH region_avg_billing AS (
    SELECT
        region,
        department,
        position,
        level,
        ROUND(CAST(AVG(billing_rate) AS NUMERIC), 2) AS avg_billing_rate
    FROM employees
    GROUP BY region, department, position, level
)
SELECT
    e.department,
    e.employee_id,
    e.full_name,
    e.position,
    e.level,
    e.primary_specialization,
    e.billing_rate,
    r.avg_billing_rate
FROM employees e
JOIN region_avg_billing r
    ON e.region = r.region -- Match by region
    AND e.department = r.department -- Match by department
    AND e.position = r.position -- Match by position
    AND e.level = r.level -- Match by level
WHERE e.billing_rate > r.avg_billing_rate;



-- Question 35: List the top 3 attributes (e.g., primary_specialization, role, level, or department) with the highest average project_satisfaction for employees in Client Services, ranking them by their contribution.

WITH avg_satisfaction_by_attribute AS (
    -- Compute average project satisfaction by primary_specialization
    SELECT
        'primary_specialization' AS attribute_type,
        primary_specialization AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY primary_specialization

    UNION ALL

    /*Computing average project satisfaction by role*/
    SELECT
        'role' AS attribute_type,
        position AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY position

    UNION ALL

    /*Computing average project satisfaction by level*/
    SELECT
        'level' AS attribute_type,
        level AS attribute_value,
        AVG(project_satisfaction) AS avg_satisfaction
    FROM employees
    WHERE department = 'Client Services'
    GROUP BY level
)
SELECT
    attribute_type,
    attribute_value,
    avg_satisfaction
FROM avg_satisfaction_by_attribute
ORDER BY avg_satisfaction DESC
LIMIT 3;



-- Question 36: Compute the average training_hours and promotion_readiness for each job level, and rank job levels by average promotion_readiness.
SELECT
    department,
    position,
    level AS job_level,
    ROUND(CAST(AVG(training_hours) AS NUMERIC), 2) AS avg_training_hours,
    ROUND(CAST(AVG(promotion_readiness) AS NUMERIC), 2) AS avg_promotion_readiness
FROM employees
GROUP BY level, department, position
ORDER BY avg_promotion_readiness DESC;



-- Question 37: Calculate the average `engagement_score` by `primary_specialization`, comparing trends across regions.
SELECT
    region,
    primary_specialization,
    ROUND(CAST(AVG(engagement_score) AS NUMERIC), 2) AS avg_engagement_score
FROM employees
GROUP BY region, primary_specialization



-- Question 38: Identify employees with at least two certifications and a `flight_risk` below 20%.