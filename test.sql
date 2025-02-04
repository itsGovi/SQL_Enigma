/*
For each department in the EMCA region, calculate the average project
satisfaction of employees who have more than three active projects and
actual utilization above 90%. Then, compare this department-level average
with the overall company-wide average project satisfaction. Return only the
departments where the average project satisfaction is below the company-wide
average.*/

SELECT DISTINCT department
FROM employees