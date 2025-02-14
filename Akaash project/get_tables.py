import os
import psycopg2
import pandas as pd

def create_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        host=os.getenv('DB_HOST'),
        port=os.getenv('DB_PORT')
    )

def run_query_to_csv(query, output_csv):
    """Execute a SQL query and save the results to a CSV file."""
    try:
        with create_connection() as conn:
            df = pd.read_sql_query(query, conn)
            df.to_csv(output_csv, index=False)
            print(f"Query results saved to {output_csv}")
    except Exception as e:
        print(f"Error executing query: {e}")

def main():
    # Query 1: vehicle_age <= 5
    query1 = """
        SELECT 
            vehicle_age,
            vehicle_model,
            charging_station_location
        FROM ev_charging_patterns
        WHERE vehicle_age <= 5
        ORDER BY vehicle_age ASC;
    """
    run_query_to_csv(query1, "results_vehicle_age_under_5.csv")
    
    # Query 2: vehicle_age > 5
    query2 = """
        SELECT 
            vehicle_age,
            vehicle_model,
            charging_station_location
        FROM ev_charging_patterns
        WHERE vehicle_age > 5
        ORDER BY vehicle_age ASC;
    """
    run_query_to_csv(query2, "results_vehicle_age_over_5.csv")
    
    # Query 3: Level 1 or Level 2 chargers
    query3 = """
        SELECT
            charger_type,
            vehicle_model,
            charging_station_location
        FROM ev_charging_patterns
        WHERE charger_type IN ('Level 1', 'Level 2')
        ORDER BY charger_type, charging_station_location;
    """
    run_query_to_csv(query3, "results_level_chargers.csv")
    
    # Query 4: DC Fast Charger
    query4 = """
        SELECT
            charger_type,
            vehicle_model,
            charging_station_location
        FROM ev_charging_patterns
        WHERE charger_type = 'DC Fast Charger'
        ORDER BY charging_station_location;
    """
    run_query_to_csv(query4, "results_dc_fast_charger.csv")

if __name__ == "__main__":
    main()
