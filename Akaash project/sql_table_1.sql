SELECT 
    vehicle_age,
    vehicle_model,
    charging_station_location
FROM ev_charging_patterns
WHERE vehicle_age <= 5
ORDER BY vehicle_age ASC;


SELECT 
    vehicle_age,
    vehicle_model,
    charging_station_location
FROM ev_charging_patterns
WHERE vehicle_age > 5
ORDER BY vehicle_age ASC;

SELECT
    charger_type,
    vehicle_model,
    charging_station_location
FROM ev_charging_patterns
WHERE charger_type = 'Level 1' OR charger_type = 'Level 2'
ORDER BY charger_type, charging_station_location

SELECT
    charger_type,
    vehicle_model,
    charging_station_location
FROM ev_charging_patterns
WHERE charger_type = 'DC Fast Charger'
ORDER BY charging_station_location;