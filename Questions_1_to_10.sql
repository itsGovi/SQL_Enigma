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

-- Question 5: 