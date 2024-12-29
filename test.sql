WITH yearly_utilization AS (
    SELECT
        EXTRACT(YEAR FROM hire_date) AS year,
        ROUND(CAST(AVG(actual_utilization) AS NUMERIC), 2) AS avg_utilization
    FROM employees
    WHERE region = 'EMEA'
    GROUP BY EXTRACT(YEAR FROM hire_date)
    ORDER BY year ASC
)
SELECT
    year,
    avg_utilization,
    LAG(avg_utilization) OVER (ORDER BY year) AS prev_year_utilization,
    ROUND(CAST(
        (avg_utilization - LAG(avg_utilization) OVER (ORDER BY year)) / 
        LAG(avg_utilization) OVER (ORDER BY year) AS NUMERIC) * 100, 2
    ) AS yoy_change
FROM yearly_utilization;