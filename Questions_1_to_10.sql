--Question 1:Retrieve all employees hired in the last 12 months.

SELECT employee_id,full_name,hire_date 
FROM employees
WHERE hire_date > CURRENT_DATE - INTERVAL '1 year';
-- ANSWER: 19

-- Question 2: List the total number of employees in each department.

SELECT employee_id, department
FROM employees
