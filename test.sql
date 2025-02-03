/*
Identify employees in the Americas region who have more than two active
projects and an actual utilization >= 90%. Additionally, calculate the
percentage difference between each employee's actual utilization and their
region's average actual utilization. Only include employees whose actual
utilization is at least 10% higher than the regional average.*/

    SELECT
    region,
    ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS avg_actual_utilization
    FROM employees
    WHERE region = 'Americas'
    GROUP BY region