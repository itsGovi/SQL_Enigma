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
