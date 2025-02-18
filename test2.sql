/*
1. The **department average** across all regions.
2. The **regional median project duration** (specific to APAC).

Additionally, classify each employee into **tenure groups** based on their  **years of experience** :

* **0–2 years:** "Junior"
* **3–5 years:** "Mid-Level"
* **6+ years:** "Senior"

Ensure that:

* Use **window functions** to calculate department-level averages and regional medians.
* Use **recursive CTEs** to generate tenure groups dynamically.
* Exclude employees who have worked on **fewer than 3 projects** to filter out anomalies.

**Return:** Employee ID, Name, Department, Region, Avg_Project_Duration, Department_Avg_Duration, APAC_Regional_Median, Tenure_Group
*/
WITH employee_experience AS (
    SELECT
        region,
        employee_id,
        full_name,
        date_part('year', age(hire_date)) AS experience_years
    FROM employees
    WHERE region = 'APAC'
)
SELECT
    employee_id,
    full_name,
    CASE
        WHEN experience_years BETWEEN 0 AND 2 THEN 'Junior'
        WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level'
        WHEN experience_years >= 6 THEN 'Senior'
        ELSE 'Unknown'  -- Important: Handle other cases!
    END AS experience_level
FROM employee_experience;