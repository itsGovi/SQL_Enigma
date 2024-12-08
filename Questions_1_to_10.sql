"""
NOTE: the doctrings below few questions are the up'ed version of each question
I've felt few were a bit bland or 'not so insightful' and gave them my own spin! 😅
"""



--Question 1:Retrieve all employees hired in the last 12 months.

SELECT employee_id,full_name,hire_date 
FROM employees
WHERE hire_date > CURRENT_DATE - INTERVAL '1 year';
-- ANSWER: 19


-- Question 2: List the total number of employees in each department.

SELECT COUNT(employee_id), department
FROM employees
GROUP BY department;
--ANSWER: 5 departments


-- Questions 3: Calculate the average `base_salary` by `region`.
SELECT AVG(base_salary), region
FROM employees
GROUP BY region
-- ANSWER: 3 regions


-- Question 4: Identify employees with department and positions who work remotely more than 30% of the time
SELECT 
    COUNT(employee_id), --remove count for all the employees names
    department,
    level
FROM employees
WHERE remote_work_ratio > 30
GROUP BY department, level
--ANSWER: the range is 36-75 as count from all 10 departments


-- Question 5: Sort employees by their `hire_date` in ascending order.

"""
I'm thinking of taking it up a notch:
Identify the top 5 oldest employees (based on hire_date) in each department,
along with their years_in_role (calculated as the difference between hire_date and current date).
"""
SELECT
    employee_id,
    full_name,
    department,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_in_role
FROM (  
    SELECT
        employee_id,
        full_name,
        department,
        hire_date,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date ASC) AS rank
    FROM employees
) AS ranked_employees
WHERE rank <= 5;
-- ANSWER: 12 - the highest in all dept.

-- Question 6: Find the top 5 employees with the highest `billing_rate` in the `APAC` region.
SELECT
    employee_id,
    full_name,
    department
FROM employees
WHERE region = 'APAC'
ORDER BY billing_rate DES LIMIT 5;


-- Quesiton 7: Retrieve all employees with `actual_utilization` below 70%.

"""
Find the employees with actual_utilization below 70%
whose performance_score is greater than 4 and group them by department, 
showing the count of such employees per department.
"""
SELECT
    COUNT(employee_id),
    department,
FROM employees
where actual_utilization < 70 AND performance_score > 4
GROUP BY department;


-- Question 8: List distinct job `positions` in the 'Product Architecture' department.
"""
Identify the distinct job positions in the 'Product Architecture' department 
and count how many employees hold each position, 
sorted by the count in descending order.
"""
SELECT
    COUNT(employee_id) AS employee_count,
    department,
    position,
    ROUND(CAST(AVG(base_salary) AS ), 2) AS avg_base_salary
FROM employees
WHERE department = 'Product Architecture'
GROUP BY department, position
ORDER BY COUNT(employee_id) DESC;
--ANSWER: 12 positions


-- Question 9: Calculate the total billing_rate generated by employees in 'Engineering Delivery.'
"""
Calculate the total billing_rate generated by employees in 'Engineering Delivery' with
actual_utilization greater than 80%, and also find the average billing_rate
per department for employees whose billing_rate is above the department's average.
"""
SELECT 
    SUM(billing_rate) AS total_billing_rate,
    department,
    AVG(billing_rate) AS department_avg_billing_rate
FROM employees
WHERE department = 'Engineering Delivery' AND actual_utilization > 80
  AND billing_rate > (
      SELECT AVG(billing_rate)
      FROM employees
      WHERE department = employees.department
  )
GROUP BY department;

-- Question 10: Count the number of certifications held by employees in each department.
"""
Identify the department and position combinations with the highest
total certifications by calculating the total certifications held,
the total employees in each combination, and the average certifications
per employee. Rank the results by the total certifications in descending order.
"""
SELECT
    department,
    position,
    level,
    SUM(array_length(string_to_array(certifications, ','), 1)) AS total_certifications,
    COUNT(employee_id) AS total_employees,
    ROUND(SUM(array_length(string_to_array(certifications, ','), 1))::NUMERIC / COUNT(employee_id), 2) AS avg_certifications_per_employee
FROM employees
GROUP BY department, position, level
ORDER BY total_certifications DESC;


-- Question 11: Identify employees in each department and position with a `flight_risk` greater than 50% and an `engagement_score` below 5.
"""
Identify the departments with the highest proportion of disengaged employees
(engagement_score < 6) who are also at risk of leaving (flight_risk > 50%).
For each department, calculate the percentage of disengaged employees relative
to the total employees, the total number of disengaged employees with high flight
risk, and rank the departments by the percentage of disengaged employees
in descending order.
"""
/*original question query:
SELECT
  department,
  position,
  employee_id,
  full_name
FROM employees
WHERE flight_risk > 50 AND engagement_score < 5
GROUP BY department, position, employee_id;
*/
SELECT
    department,
    position,
    COUNT(employee_id) AS total_employees,
    SUM(CASE WHEN flight_risk > 50 AND engagement_score < 6 THEN 1 ELSE 0 END) AS disengaged_with_high_flight_risk
FROM employees
GROUP BY department, position
ORDER BY disengaged_with_high_flight_risk DESC;
