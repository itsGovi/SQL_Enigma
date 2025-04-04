SELECT *
FROM ev_charging_patterns
WHERE vehicle_age > 5 AND charger_type = 'Level 1';

SELECT *
FROM ev_charging_patterns
WHERE vehicle_age > 5 AND charger_type = 'Level 2';

SELECT *
FROM ev_charging_patterns
WHERE vehicle_age > 5 AND charger_type = 'DC Fast Charger';

SELECT *
FROM ev_charging_patterns
WHERE vehicle_age < 5 AND charger_type = 'Level 1';

SELECT *
FROM ev_charging_patterns
WHERE vehicle_age < 5 AND charger_type = 'Level 2';

SELECT *
FROM ev_charging_patterns
WHERE vehicle_age < 5 AND charger_type = 'DC Fast Charger';
