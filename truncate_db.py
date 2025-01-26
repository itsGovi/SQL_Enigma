import psycopg2

def create_connection():
    return psycopg2.connect(
        dbname="SQL_Enigma",
        user="postgres",
        password="1234",
        host="localhost",
        port="5432"
    )

def delete_all_data():
    try:
        # Connect to the database
        conn = create_connection()
        conn.autocommit = True  # Ensure changes are committed immediately
        
        with conn.cursor() as cur:
            # Disable constraints temporarily
            cur.execute("SET session_replication_role = 'replica';")
            
            # Fetch all table names in the schema
            cur.execute("""
                SELECT tablename
                FROM pg_tables
                WHERE schemaname = 'public';
            """)
            tables = cur.fetchall()
            
            # Truncate each table
            for table in tables:
                table_name = table[0]
                print(f"Truncating table: {table_name}")
                cur.execute(f'TRUNCATE TABLE "{table_name}" CASCADE;')  # Quote table name
            
            # Re-enable constraints
            cur.execute("SET session_replication_role = 'origin';")
        
        print("All data has been deleted successfully!")
    except Exception as e:
        print(f"Error while deleting data: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

# Run the function
delete_all_data()
