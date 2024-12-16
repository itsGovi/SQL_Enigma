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
Primary Specialization and Suggested Certifications

| Primary Specialization      |     Suggested Certifications                           |
|----------------------------------|-------------------------------------------------------|
| **Cloud Native**                 | AWS Solutions Architect, Google Cloud Architect       |
| **DevOps**                       | Kubernetes, DevOps Engineer                          |
| **Agile Delivery**               | Scrum Master, Agile Project Management               |
| **Product Management**           | PSPO (Professional Scrum Product Owner), PMP         |
| **UX/UI Design**                 | Google UX Design, Human Factors International        |
| **Enterprise Architecture**      | TOGAF, Azure Architect                               |
| **Business Analysis**            | Business Analysis Certification, Agile Business Analysis |
| **Quality Assurance (QA)**       | ISTQB Certification, Six Sigma                       |
| **Solution Architecture**        | AWS Solutions Architect, Google Cloud Architect      |
| **Design Thinking**              | Design Thinking Certification, Interaction Design Foundation |
| **Strategic Planning**           | Agile Leadership, Strategic Planning Certification   |
| **Project Management**           | PMP (Project Management Professional), Prince2       |



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


