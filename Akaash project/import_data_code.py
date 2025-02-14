import os
import psycopg2
import pandas as pd
from io import StringIO

def create_connection():
    return psycopg2.connect(
        dbname=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        host=os.getenv('DB_HOST'),
        port=os.getenv('DB_PORT')
    )

def create_ev_charging_table(conn):
    """Drop and create a table for EV charging data with the specified columns."""
    with conn.cursor() as cur:
        # Drop the table if it already exists
        cur.execute("DROP TABLE IF EXISTS ev_charging_patterns;")
        
        # Create the table with the correct schema
        cur.execute("""
            CREATE TABLE ev_charging_patterns (
                user_id VARCHAR(50),
                vehicle_model VARCHAR(100),
                charging_station_location VARCHAR(100),
                vehicle_age INTEGER,
                charger_type VARCHAR(50),
                user_type VARCHAR(50)
            )
        """)
    conn.commit()

def import_ev_data(conn, csv_file_path):
    """
    Imports data from a CSV file into the ev_charging_patterns table.
    
    Assumes the CSV file has columns:
    - User ID
    - Vehicle Model
    - Charging Station Location
    - Vehicle Age (years)
    - Charger Type
    - User Type
    """
    # Read CSV file into a DataFrame
    df = pd.read_csv(csv_file_path)
    
    # Rename columns to match the table column names
    df.rename(columns={
        "User ID": "user_id",
        "Vehicle Model": "vehicle_model",
        "Charging Station Location": "charging_station_location",
        "Vehicle Age (years)": "vehicle_age",
        "Charger Type": "charger_type",
        "User Type": "user_type"
    }, inplace=True)
    
    # Convert vehicle_age to integer (if not already)
    df['vehicle_age'] = df['vehicle_age'].astype(int)
    
    # Prepare CSV data for PostgreSQL's COPY command using StringIO
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False, header=False)
    csv_buffer.seek(0)
    
    with conn.cursor() as cur:
        copy_sql = """
            COPY ev_charging_patterns (user_id, vehicle_model, charging_station_location, vehicle_age, charger_type, user_type)
            FROM STDIN WITH CSV
        """
        cur.copy_expert(sql=copy_sql, file=csv_buffer)
    conn.commit()

def main():
    csv_file_path = r"C:\Users\govar\OneDrive\Documents\SQL_Enigma\Akaash project\ev_charging_patterns dataset.csv"
    try:
        with create_connection() as conn:
            create_ev_charging_table(conn)
            import_ev_data(conn, csv_file_path)
            print("EV charging data import completed successfully!")
    except Exception as e:
        print(f"Error during import: {e}")

if __name__ == "__main__":
    main()
