/*
* Identify employees with a **flight_risk** below 20 and **span_of_control** above 3. Then, for each department, do the following:

1. **Department-Level Aggregation:**
   * Compute the **median flight_risk** and **average span_of_control** for each department.
2. **Advanced Filtering:**
   * From the employees meeting the initial conditions, further filter to include only those whose:
     * **flight_risk** is not only below 20 but also at least 10% lower than the department’s median flight_risk, and
     * **span_of_control** is not only above 3 but also at least 10% higher than the department’s average span_of_control.
3. **Ranking Within Departments:**
   * Rank the filtered employees in each department using a window function, ordering by:
     * The largest deviation below the department median for flight risk, and then
     * The largest deviation above the department average for span of control.
   * Return only the **top 3 employees per department** based on this ranking.
4. **Trigger Implementation (Advanced Bonus):**
   * Design a trigger that automatically logs any new insertion into the employees table that meets the above criteria into a separate audit table (`employee_stability_audit`). The audit should record the employee ID, insertion timestamp, and a summary of the key metrics (flight_risk, span_of_control, and the calculated deviations).

**Return:**
Employee ID, full_name, department, flight_risk, span_of_control, department median flight_risk, department average span_of_control, and the employee’s rank within their department.
*/