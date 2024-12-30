WITH RiskSummary AS (
    SELECT 
        region,
        department,
        COUNT(CASE WHEN retention_risk = 'High' THEN 1 END) AS high_risk_count,
        COUNT(*) AS total_count,
        COUNT(CASE WHEN retention_risk = 'High' THEN 1 END) * 1.0 / COUNT(*) AS high_risk_ratio
    FROM employees
    GROUP BY region, department
),
AvgRisk AS (
    SELECT 
        AVG(high_risk_ratio) AS avg_risk_ratio
    FROM RiskSummary
),
FilteredRisk AS (
    SELECT 
        region,
        department,
        high_risk_count,
        total_count,
        high_risk_ratio,
        high_risk_ratio > (SELECT avg_risk_ratio * 1.2 FROM AvgRisk) AS exceeds_threshold
    FROM RiskSummary
)
SELECT 
    region,
    department,
    high_risk_count,
    total_count,
    high_risk_ratio
FROM FilteredRisk
WHERE exceeds_threshold = TRUE
ORDER BY high_risk_ratio DESC;