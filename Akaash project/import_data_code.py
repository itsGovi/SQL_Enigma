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
    """
    Drops and creates the ev_charging_patterns table with the new schema.
    The table includes the following columns:
      - user_id, vehicle_model, battery_capacity, charging_station_id,
      - charging_station_location, charging_start_time, charging_end_time,
      - energy_consumed, charging_duration, charging_rate, charging_cost,
      - time_of_day, day_of_week, soc_start, soc_end, distance_driven,
      - temperature, vehicle_age, charger_type, user_type.
    """
    with conn.cursor() as cur:
        cur.execute("DROP TABLE IF EXISTS ev_charging_patterns;")
        cur.execute("""
            CREATE TABLE ev_charging_patterns (
                user_id VARCHAR(50),
                vehicle_model VARCHAR(100),
                battery_capacity NUMERIC,
                charging_station_id VARCHAR(50),
                charging_station_location VARCHAR(100),
                charging_start_time TIMESTAMP,
                charging_end_time TIMESTAMP,
                energy_consumed FLOAT,
                charging_duration FLOAT,
                charging_rate FLOAT,
                charging_cost NUMERIC,
                time_of_day VARCHAR(50),
                day_of_week VARCHAR(50),
                soc_start NUMERIC,
                soc_end NUMERIC,
                distance_driven FLOAT,
                temperature FLOAT,
                vehicle_age INTEGER,
                charger_type VARCHAR(50),
                user_type VARCHAR(50)
            );
        """)
    conn.commit()

def import_ev_data(conn, csv_file_path):
    """
    Reads CSV data into a DataFrame, renames columns to match the PostgreSQL table,
    converts data types as necessary, and uses PostgreSQL's COPY command to load the data.
    
    The CSV file is expected to have the following columns:
      - User ID, Vehicle Model, Battery Capacity (kWh), Charging Station ID,
      - Charging Station Location, Charging Start Time, Charging End Time,
      - Energy Consumed (kWh), Charging Duration (hours), Charging Rate (kW),
      - Charging Cost (USD), Time of Day, Day of Week, State of Charge (Start %),
      - State of Charge (End %), Distance Driven (since last charge) (km),
      - Temperature (°C), Vehicle Age (years), Charger Type, User Type.
    """
    # Read CSV file into DataFrame
    df = pd.read_csv(csv_file_path)
    
    # Rename columns to match the database schema (using snake_case)
    df.rename(columns={
        "User ID": "user_id",
        "Vehicle Model": "vehicle_model",
        "Battery Capacity (kWh)": "battery_capacity",
        "Charging Station ID": "charging_station_id",
        "Charging Station Location": "charging_station_location",
        "Charging Start Time": "charging_start_time",
        "Charging End Time": "charging_end_time",
        "Energy Consumed (kWh)": "energy_consumed",
        "Charging Duration (hours)": "charging_duration",
        "Charging Rate (kW)": "charging_rate",
        "Charging Cost (USD)": "charging_cost",
        "Time of Day": "time_of_day",
        "Day of Week": "day_of_week",
        "State of Charge (Start %)": "soc_start",
        "State of Charge (End %)": "soc_end",
        "Distance Driven (since last charge) (km)": "distance_driven",
        "Temperature (°C)": "temperature",
        "Vehicle Age (years)": "vehicle_age",
        "Charger Type": "charger_type",
        "User Type": "user_type"
    }, inplace=True)

    # Convert date columns to datetime
    df['charging_start_time'] = pd.to_datetime(df['charging_start_time'])
    df['charging_end_time'] = pd.to_datetime(df['charging_end_time'])
    
    # Convert numeric columns (coerce errors if necessary)
    numeric_cols = [
        'battery_capacity', 'energy_consumed', 'charging_duration',
        'charging_rate', 'charging_cost', 'soc_start', 'soc_end',
        'distance_driven', 'temperature'
    ]
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors='coerce')
    
    # Ensure vehicle_age is integer
    df['vehicle_age'] = df['vehicle_age'].astype(int)
    
    # Prepare CSV data for PostgreSQL's COPY command using StringIO
    csv_buffer = StringIO()
    df.to_csv(csv_buffer, index=False, header=False)
    csv_buffer.seek(0)

    with conn.cursor() as cur:
        copy_sql = """
            COPY ev_charging_patterns (
                user_id,
                vehicle_model,
                battery_capacity,
                charging_station_id,
                charging_station_location,
                charging_start_time,
                charging_end_time,
                energy_consumed,
                charging_duration,
                charging_rate,
                charging_cost,
                time_of_day,
                day_of_week,
                soc_start,
                soc_end,
                distance_driven,
                temperature,
                vehicle_age,
                charger_type,
                user_type
            )
            FROM STDIN WITH CSV
        """
        cur.copy_expert(sql=copy_sql, file=csv_buffer)
    conn.commit()

def main():
    csv_file_path = r"Akaash project\ev_charging_patterns dataset (1).csv"  # Update with your CSV file path
    try:
        with create_connection() as conn:
            create_ev_charging_table(conn)
            import_ev_data(conn, csv_file_path)
            print("EV charging data import completed successfully!")
    except Exception as e:
        print(f"Error during import: {e}")

if __name__ == "__main__":
    main()