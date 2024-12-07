# The Columns Definition

### **Columns and Their Purpose**

1. **`employee_id`** :

* A unique identifier assigned to each employee.
* Used to track employees across records without relying on names (e.g., in relational joins).

1. **`full_name`** :

* The employee's name for identification purposes.

1. **`department`** :

* The business unit the employee belongs to (e.g., `Engineering Delivery`, `Client Services`).
* Helps categorize employees by functional area.

1. **`position`** :

* The specific role or title of the employee (e.g., `Associate Developer`, `Engagement Manager`).
* Indicates the level of responsibility and type of work.

1. **`level`** :

* The career level (`entry`, `mid`, `senior`).
* Reflects the employee's seniority and experience within the organization.

1. **`hire_date`** :

* The date the employee joined the organization.
* Useful for tenure analysis and time-based insights.

1. **`city`, `country`, `region`** :

* The geographic location where the employee works.
* `region` groups locations into broader areas (e.g., `APAC`, `EMEA`).
* Useful for regional salary trends, utilization, and engagement scores.

1. **`remote_work_ratio`** :

* The percentage of time an employee works remotely.
* Indicates flexibility and work-from-home trends.

1. **`travel_percentage`** :

* The percentage of time spent traveling for work.
* Reflects the demands of the role, often higher in client-facing positions.

1. **`base_salary`** :

* The fixed annual salary of the employee in monetary units.
* Useful for analyzing compensation trends and cost metrics.

1. **`billing_rate`** :

* The rate charged to clients for the employee’s time (per hour or day).
* Indicates the revenue potential for each employee.

1. **`utilization_target`** :

* The expected percentage of billable hours out of total working hours.
* Reflects organizational goals for employee productivity.

1. **`actual_utilization`** :

* The actual percentage of billable hours achieved.
* A metric to compare against the `utilization_target` for performance evaluation.

1. **`primary_specialization`, `secondary_specialization`** :

* The employee's main and secondary technical or domain expertise (e.g., `Mobile Development`, `Cloud Native`).
* Useful for matching skills to projects or roles.

1. **`industry_expertise`** :

* A list of industries the employee is experienced in (e.g., `FinTech`, `E-commerce`).
* Helps identify areas where their skills are applicable.

1. **`certifications`** :

* A list of professional certifications held by the employee (e.g., `AWS Solutions Architect`).
* Indicates formal qualifications relevant to their role.

1. **`performance_score`** :

* A rating (typically 1-5) reflecting the employee’s overall performance.
* Derived from project outcomes and other performance metrics.

1. **`innovation_score`** :

* A score (typically 1-10) representing the employee's contribution to innovation.
* Higher scores indicate more innovative roles or achievements.

1. **`delivery_quality`** :

* A score (typically 1-100) that reflects the quality of project outcomes.
* High scores imply better performance and client satisfaction.

1. **`active_projects`** :

* The number of ongoing projects the employee is working on.
* Indicates workload and involvement.

1. **`avg_project_complexity`** :

* The average complexity score (1-5) of the employee’s projects.
* Higher values represent more challenging projects.

1. **`avg_project_duration`** :

* The average duration (in months) of the employee’s projects.
* Useful for understanding project cycles.

1. **`avg_team_size`** :

* The average size of teams the employee works with.
* Reflects the scale of collaboration.

1. **`projects_on_time`** :

* The percentage of the employee’s projects completed on time.
* Indicates timeliness and efficiency.

1. **`project_satisfaction`** :

* A score (1-5) reflecting satisfaction with project outcomes, likely from client feedback.
* Measures the quality of delivery from a stakeholder perspective.

1. **`training_hours`** :

* Hours spent in formal training during the year.
* Indicates investment in skill development.

1. **`mentorship_hours`** :

* Hours spent mentoring others.
* Reflects leadership and contribution to team growth.

1. **`knowledge_sharing_score`** :

* A score (1-10) reflecting the employee’s contribution to knowledge-sharing initiatives.
* Higher values indicate active involvement in team learning.

1. **`promotion_readiness`** :

* A score (1-100) representing the likelihood of the employee being promoted.
* Derived from factors like tenure, performance, and certifications.

1. **`engagement_score`** :

* A score (1-10) that measures the employee’s engagement level.
* Lower scores indicate disengagement, higher scores suggest satisfaction and motivation.

1. **`flight_risk`** :

* A percentage representing the likelihood of the employee leaving the company.
* Helps HR focus on retention strategies.

1. **`retention_risk`** :

* A qualitative risk category (`Low`, `Medium`, `High`) for employee retention.
* Derived from the `flight_risk`.

1. **`manager_id`** :

* The `employee_id` of the employee's manager.
* Useful for hierarchical and team analysis.

1. **`total_comp`** :

* The total compensation (base salary + additional premiums).
* Represents the total monetary investment in the employee.

1. **`team_lead_projects`** :

* The number of projects the employee leads.
* Indicates managerial and leadership roles.

1. **`direct_reports`** :

* The number of employees reporting directly to the employee.
* Reflects span of control in managerial roles.

1. **`is_manager`** :

* Boolean indicating if the employee has managerial responsibilities.
* Useful for role classification.

1. **`management_level`** :

* Indicates whether the manager is `mid` or `senior`.
* Helps in identifying the hierarchy.

1. **`span_of_control`** :

* Qualitative categorization of the number of direct reports (`None`, `Small`, `Medium`, `Large`).
* Reflects management workload.

1. **`management_premium`** ,  **`span_premium`** :

* Additional monetary compensation for managerial responsibilities and span of control.
* Incentivizes effective leadership.

---

### General Tips for Understanding:

* Columns with **percentages** (e.g., `remote_work_ratio`, `flight_risk`) reflect proportions or likelihoods.
* Scores (e.g., `performance_score`, `delivery_quality`) are numerical ratings—higher is generally better.
* Look at **relationships** between columns for insights (e.g., `utilization_target` vs. `actual_utilization`).


Certainly! Let’s dive deeper into columns like `span_premium`, `span_of_control`, and other numeric metrics so that you can fully grasp their meaning and purpose in the dataset. I’ll break them down with **practical analogies** and examples to make them clearer.

---

## Deeper Understanding of few columns

### **`span_of_control`**

* **Definition** : A qualitative metric that categorizes how many direct reports an employee has:
* **`None`** : No direct reports (not a manager).
* **`Small (1-3)`** : Supervises a small team of 1 to 3 employees.
* **`Medium (4-6)`** : Leads a mid-sized team of 4 to 6 employees.
* **`Large (7+)`** : Oversees a large team of 7 or more employees.
* **Purpose** : Helps in workload analysis and identifying managerial responsibilities. Larger spans typically require better delegation and organizational skills.
* **Analogy** : Imagine a manager at a fast-food chain:
* **Small (1-3)** : Supervises a few cashiers or cooks.
* **Medium (4-6)** : Oversees the kitchen team and front-of-house staff.
* **Large (7+)** : Manages the entire store staff, including shift managers.

---

### **`span_premium`**

* **Definition** : An additional compensation amount given to managers based on their `span_of_control`. It’s typically calculated as:
* **0% of base salary** : If they have no direct reports.
* **5% of base salary** : For `Small (1-3)` span.
* **10% of base salary** : For `Medium (4-6)` span.
* **15% of base salary** : For `Large (7+)` span.
* **Purpose** : Recognizes and rewards the complexity and responsibility of managing larger teams.
* **Example** :
* If an employee has a base salary of  **₹200,000** :
  * With `None` span, `span_premium = ₹0`.
  * With `Small` span, `span_premium = ₹10,000` (5%).
  * With `Large` span, `span_premium = ₹30,000` (15%).

---

### **`management_premium`**

* **Definition** : Extra compensation for holding a managerial title, in addition to the `span_premium`. Calculated as:
* **15-25% of base salary** : For `mid-level` managers.
* **25-35% of base salary** : For `senior-level` managers.
* **Purpose** : Incentivizes managerial roles and reflects the value of leadership.
* **Example** :
* A `senior manager` with a base salary of ₹300,000 could get:
  * 30% `management_premium = ₹90,000`.

---

### **`total_comp`**

* **Definition** : The sum of all forms of compensation:
* `base_salary + management_premium + span_premium`.
* **Purpose** : Reflects the total financial investment in an employee.
* **Example** :
* For an employee with:
  * Base salary: ₹300,000.
  * Management premium: ₹90,000.
  * Span premium: ₹30,000.
  * **`total_comp = ₹420,000`.**

---

### **`promotion_readiness`**

* **Definition** : A score (1-100) representing how prepared an employee is for a promotion.
* **Factors Influencing It** :
* **Tenure** : Longer tenure increases readiness.
* **Performance** : High `performance_score` adds to readiness.
* **Certifications** : More certifications improve the score.
* **Leadership Impact** : Contributions like `mentorship_hours` or leading `team_lead_projects`.
* **Example** :
* A score of **80** indicates high readiness and a strong likelihood of promotion soon.
* **Analogy** : Think of a student applying for university:
* **High Score** : Strong grades, extracurriculars, and awards.
* **Low Score** : Minimal qualifications.

---

### **`flight_risk`**

* **Definition** : A percentage (0-100%) indicating how likely the employee is to leave the company.
* **Interpretation** :
* **<20%** : Low risk (likely to stay).
* **20%-50%** : Medium risk.
* **>50%** : High risk (likely to leave soon).
* **Example** :
* An employee with a **flight_risk of 80%** might be actively considering other jobs.
* **Purpose** : Helps HR focus on retention efforts, such as improving engagement or compensation.

---

### **`engagement_score`**

* **Definition** : A rating (1-10) that measures how engaged an employee is with their work and organization.
* **Interpretation** :
* **1-4** : Low engagement (disengaged, unmotivated).
* **5-7** : Moderate engagement.
* **8-10** : High engagement (enthusiastic, motivated).
* **Purpose** : Helps gauge job satisfaction and productivity levels.
* **Example** :
* Employees with low engagement often have high `flight_risk`.

---

### **`delivery_quality`**

* **Definition** : A performance score (1-100) measuring the quality of work delivered by the employee.
* **Purpose** : Used to assess the effectiveness and impact of employees’ work, especially on client satisfaction.
* **Example** :
* A **delivery_quality of 95** indicates excellent project outcomes.

---

### **How These Numbers Work Together**

For managers:

* `span_of_control` determines team size.
* `span_premium` and `management_premium` provide monetary incentives for managing larger teams.
* Combined with `total_comp`, this shows how managerial responsibilities are rewarded.

For general employees:

* Scores like `engagement_score` and `flight_risk` highlight satisfaction and retention risks.
* Metrics like `delivery_quality` and `promotion_readiness` track performance and career progression.
