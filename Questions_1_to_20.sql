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

-- Question 12: Find the department with the highest average `base_salary` and the lowest average `performance_score`.
"""
Identify the top 25 employees in the department with the strongest negative \
correlation between base_salary and performance_score. Display their
employee_id, full_name, department, position, base_salary, and performance_score,
sorted by performance_score in ascending order.
"""
/* original query:
SELECT
  AVG(base_salary) AS avg_base_salary,
  department,
  AVG(performance_score) AS avg_performance_score
FROM employees
GROUP BY department
ORDER BY AVG(base_salary) DESC, AVG(performance_score) ASC;
*/
WITH department_correlation AS(
  SELECT
    department,
    CORR(base_salary, performance_score) AS salary_performance_correlation
  FROM employees
  GROUP BY department
  ORDER BY salary_performance_correlation ASC
  LIMIT 1
)
SELECT
  employee_id,
  full_name,
  department,
  position,
  base_salary,
  performance_score
FROM employees
WHERE department = (SELECT department FROM department_correlation)
ORDER BY performance_score ASC
LIMIT 25;


--Question 13: Retrieve the details of employees whose `travel_percentage` exceeds the department average.
SELECT
  employee_id,
  full_name,
  department,
  travel_percentage
FROM employees e
WHERE travel_percentage > (
  SELECT AVG(travel_percentage)
  FROM employees
  WHERE department = e.department
)
ORDER BY travel_percentage DESC LIMIT 50;


-- Question 14: Identify employees with no `direct_reports`.
SELECT
  e.employee_id,
  e.full_name,
  e.department,
  e.position
FROM employees e
LEFT JOIN employees m ON e.employee_id = m.manager_id
WHERE m.manager_id IS NULL;


--Question 15: Rank employees by `delivery_quality` within their departments.
SELECT
  employee_id,
  full_name,
  department,
  delivery_quality,
  RANK() OVER (PARTITION BY department ORDER BY delivery_quality DESC) AS rank
FROM employees
WHERE department = 'Design & UX' --choose any dept of your desire
ORDER BY department, rank LIMIT 10;


-- Question 16: List the `primary_specialization` and the number of employees in each specialization.
"""
For each primary_specialization, calculate the total number of employees, the
average years of experience, and the percentage of employees with a
performance_score above 7. Rank the specializations by the total number of
employees and filter out specializations with fewer than 10 employees.
"""
/* The original question:
SELECT
  COUNT(employee_id) AS total_employees,
  primary_specialization
FROM employees
GROUP BY primary_specialization;
*/
SELECT
  primary_specialization,
  COUNT(employee_id),
  AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM hire_date)) AS avg_years_of_experience,
  100*SUM((CASE WHEN performance_score > 7 THEN 1 ELSE 0 END) / COUNT(employee_id)) AS high_performance_score,
  RANK() OVER (ORDER BY count(employee_id) DESC) AS rank_of_specialization
FROM employees
GROUP BY primary_specialization


--Question 17: Retrieve the top 3 certifications based on the number of employees holding them.
"""
why I didn't use COUNT(employee_id) but choose COUNT(*):
When you unnest string_to_array(certifications, ',') to create one row per certification,
the result is something like this:

certificate	| emp_id
AWS	| 101
Azure |	101
AWS	| 102
GCP	| 103
Azure	| 104
After unnesting, each certification is already linked to a specific row. Since the column
emp_id is not used for grouping, counting all rows with COUNT(*) gives you the total
number of employees holding each certification.
"""
WITH popular_certifications AS (
  SELECT
    UNNEST(string_to_array(certifications, ',')) AS certificate
  FROM employees
),
certification_counts AS (
  SELECT
    certificate,
    COUNT(*) AS employee_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS certificate_rank
  FROM popular_certifications
  GROUP BY certificate
)
SELECT
  certificate_rank,
  certificate,
  employee_count
FROM certification_counts
WHERE certificate_rank <= 10


-- Question 18: Find employees whose actual_utilization is more than their department's utilization_target.
"""

"""
WITH department_avg AS (
  SELECT
    department,
    AVG(utilization_target) AS avg_utilization_target
  FROM employees
  GROUP BY department
)
SELECT
  e.employee_id,
  e.full_name,
  e.department,
  e.actual_utilization,
  d.avg_utilization_target
FROM employees e
JOIN department_avg d ON e.department = d.department
WHERE e.actual_utilization > d.avg_utilization_target


-- Question 19: Display all employees in the `senior` level sorted by their `project_satisfaction`.
"""

"""
SELECT
    RANK() OVER (ORDER BY project_satisfaction DESC) AS rank,
  employee_id,
  full_name,
  department,
  project_satisfaction
FROM employees
WHERE position = 'senior'
ORDER BY project_satisfaction DESC


-- Question 20: Retrieve all employees in the `APAC` region with `promotion_readiness` above 75%.
"""

"""
SELECT
  employee_id,
  full_name,
  department,
  position,
  promotion_readiness
FROM employees
WHERE region = 'APAC' AND promotion_readiness > 75