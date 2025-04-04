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
    # Query 1: vehicle_age > 5 AND charger_type = 'Level 1'
    query1 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age > 5 AND charger_type = 'Level 1';
    """
    run_query_to_csv(query1, "over5_level1.csv")

    # Query 2: vehicle_age > 5 AND charger_type = 'Level 2'
    query2 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age > 5 AND charger_type = 'Level 2';
    """
    run_query_to_csv(query2, "over5_level2.csv")

    # Query 3: vehicle_age > 5 AND charger_type = 'DC Fast Charger'
    query3 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age > 5 AND charger_type = 'DC Fast Charger';
    """
    run_query_to_csv(query3, "over5_dc_fast.csv")

    # Query 4: vehicle_age < 5 AND charger_type = 'Level 1'
    query4 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age < 5 AND charger_type = 'Level 1';
    """
    run_query_to_csv(query4, "under5_level1.csv")

    # Query 5: vehicle_age < 5 AND charger_type = 'Level 2'
    query5 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age < 5 AND charger_type = 'Level 2';
    """
    run_query_to_csv(query5, "under5_level2.csv")

    # Query 6: vehicle_age < 5 AND charger_type = 'DC Fast Charger'
    query6 = """
        SELECT *
        FROM ev_charging_patterns
        WHERE vehicle_age < 5 AND charger_type = 'DC Fast Charger';
    """
    run_query_to_csv(query6, "under5_dc_fast.csv")

if __name__ == "__main__":
    main()
