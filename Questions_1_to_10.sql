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
"I'm thinking of taking it up a notch:
Identify the top 5 oldest employees (based on hire_date) in each department,
along with their years_in_role (calculated as the difference between hire_date and current date)."
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

-- Quesiton 7: 