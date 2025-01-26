import pandas as pd
import psycopg2
import numpy as np
import os

def create_connection():
    return psycopg2.connect(                # PostgreSQL adapter for Python
        dbname=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        host=os.getenv('DB_HOST'),
        port=os.getenv('DB_PORT')
    )

def create_tables(conn):
    with conn.cursor() as cur: # a `cursor` is a tool for managing query execution
        # Main employees table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS employees (
            employee_id INTEGER PRIMARY KEY,
            full_name VARCHAR(100),
            department VARCHAR(50),
            position VARCHAR(100),
            level VARCHAR(20),
            hire_date DATE,
            city VARCHAR(50),
            country VARCHAR(50),
            region VARCHAR(20),
            remote_work_ratio FLOAT,
            travel_percentage FLOAT,
            base_salary FLOAT,
            total_comp FLOAT,
            billing_rate FLOAT,
            utilization_target FLOAT,
            actual_utilization FLOAT,
            primary_specialization VARCHAR(100),
            secondary_specialization VARCHAR(100),
            industry_expertise TEXT,
            certifications TEXT,
            active_projects INTEGER,
            avg_project_complexity FLOAT,
            avg_project_duration FLOAT,
            avg_team_size FLOAT,
            projects_on_time FLOAT,
            project_satisfaction FLOAT,
            training_hours INTEGER,
            mentorship_hours INTEGER,
            knowledge_sharing_score FLOAT,
            promotion_readiness FLOAT,
            engagement_score FLOAT,
            flight_risk FLOAT,
            retention_risk VARCHAR(20),
            performance_score FLOAT,
            innovation_score FLOAT,
            delivery_quality FLOAT,
            manager_id INTEGER,
            is_manager BOOLEAN,
            management_level VARCHAR(20),
            direct_reports INTEGER,
            span_of_control VARCHAR(20),
            team_lead_projects INTEGER
        )
        """)

        # Flight risk analysis table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS flight_risk_analysis (
            risk_level VARCHAR(20),
            employee_count INTEGER,
            avg_tenure FLOAT,
            avg_performance FLOAT,
            avg_salary FLOAT,
            avg_utilization FLOAT,
            dept_distribution JSONB,
            common_specializations JSONB,
            PRIMARY KEY (risk_level)
        )
        """)

        # Manager performance insights
        cur.execute("""
        CREATE TABLE IF NOT EXISTS manager_performance_insights (
            management_level VARCHAR(20),
            performance_category VARCHAR(20),
            manager_count INTEGER,
            avg_team_size FLOAT,
            avg_team_performance FLOAT,
            avg_team_satisfaction FLOAT,
            avg_team_retention FLOAT,
            dept_distribution JSONB,
            success_factors JSONB,
            PRIMARY KEY (management_level, performance_category)
        )
        """)

        # Promotion readiness analysis
        cur.execute("""
        CREATE TABLE IF NOT EXISTS promotion_readiness_analysis (
            readiness_band VARCHAR(20),
            level VARCHAR(20),
            employee_count INTEGER,
            avg_performance FLOAT,
            avg_knowledge_sharing FLOAT,
            avg_project_complexity FLOAT,
            critical_skills JSONB,
            dept_distribution JSONB,
            PRIMARY KEY (readiness_band, level)
        )
        """)

        # Skills gap analysis
        cur.execute("""
        CREATE TABLE IF NOT EXISTS skills_gap_analysis (
            department VARCHAR(50),
            critical_skill VARCHAR(100),
            current_coverage FLOAT,
            required_coverage FLOAT,
            gap_severity VARCHAR(20),
            affected_projects INTEGER,
            training_recommendations JSONB,
            PRIMARY KEY (department, critical_skill)
        )
        """)

        # Project performance metrics
        cur.execute("""
        CREATE TABLE IF NOT EXISTS project_performance_metrics (
            complexity_level INTEGER,
            department VARCHAR(50),
            project_count INTEGER,
            avg_duration FLOAT,
            success_rate FLOAT,
            avg_team_size FLOAT,
            key_success_factors JSONB,
            risk_factors JSONB,
            PRIMARY KEY (complexity_level, department)
        )
        """)

        # Compensation analysis
        cur.execute("""
        CREATE TABLE IF NOT EXISTS compensation_analysis (
            department VARCHAR(50),
            level VARCHAR(20),
            performance_band VARCHAR(20),
            employee_count INTEGER,
            avg_base_salary FLOAT,
            avg_total_comp FLOAT,
            salary_range JSONB,
            market_position FLOAT,
            PRIMARY KEY (department, level, performance_band)
        )           
        """)
        # Employee Analytics Table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS employee_analytics (
            employee_id INTEGER PRIMARY KEY REFERENCES employees(employee_id),
            risk_level VARCHAR(20),
            risk_factors JSONB,
            readiness_band VARCHAR(20),
            readiness_metrics JSONB,
            performance_metrics JSONB,
            skill_metrics JSONB,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        """)

        # Manager Analytics Table
        cur.execute("""
        CREATE TABLE IF NOT EXISTS manager_analytics (
            manager_id INTEGER PRIMARY KEY REFERENCES employees(employee_id),
            management_level VARCHAR(20),
            performance_category VARCHAR(20),
            team_metrics JSONB,
            success_metrics JSONB,
            department_impact JSONB,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        """)

        # Department Level Analytics
        cur.execute("""
        CREATE TABLE IF NOT EXISTS department_analytics (
            department VARCHAR(50),
            level VARCHAR(20),
            position VARCHAR(100),
            employee_count INTEGER,
            avg_metrics JSONB,
            risk_distribution JSONB,
            readiness_distribution JSONB,
            performance_distribution JSONB,
            PRIMARY KEY (department, level, position)
        );
        """)


def import_main_data(conn, df):
    """
    Import data into the employees table with proper error handling and data validation
    """
    # Ensure all columns exist and are in the correct order
    expected_columns = [
        'employee_id', 'full_name', 'department', 'position', 'level', 
        'hire_date', 'city', 'country', 'region', 'remote_work_ratio',
        'travel_percentage', 'base_salary', 'total_comp', 'billing_rate', 
        'utilization_target', 'actual_utilization', 'primary_specialization',
        'secondary_specialization', 'industry_expertise', 'certifications',
        'active_projects', 'avg_project_complexity', 'avg_project_duration',
        'avg_team_size', 'projects_on_time', 'project_satisfaction',
        'training_hours', 'mentorship_hours', 'knowledge_sharing_score',
        'promotion_readiness', 'engagement_score', 'flight_risk',
        'retention_risk', 'performance_score', 'innovation_score',
        'delivery_quality', 'manager_id', 'is_manager', 'management_level',
        'direct_reports', 'span_of_control', 'team_lead_projects'
    ]

    # Convert list columns to strings
    df['industry_expertise'] = df['industry_expertise'].apply(lambda x: str(x) if isinstance(x, list) else x)
    df['certifications'] = df['certifications'].apply(lambda x: str(x) if isinstance(x, list) else x)
    
    # Ensure hire_date is in the correct format
    df['hire_date'] = pd.to_datetime(df['hire_date']).dt.date
    
    # Convert boolean values
    df['is_manager'] = df['is_manager'].astype(bool)
    
    # Handle null values
    numeric_columns = df.select_dtypes(include=[np.number]).columns
    df[numeric_columns] = df[numeric_columns].fillna(0)
    df = df.fillna('')

    with conn.cursor() as cur:
        # Clear existing data
        cur.execute("TRUNCATE TABLE employees CASCADE")
        
        # Prepare the INSERT statement with the correct number of placeholders
        placeholders = ','.join(['%s'] * len(expected_columns))
        insert_query = f"""
            INSERT INTO employees ({','.join(expected_columns)})
            VALUES ({placeholders})
        """
        
        # Import data row by row with error handling
        for idx, row in df.iterrows():
            try:
                # Ensure row data is in the correct order
                row_data = [row[col] if col in row else None for col in expected_columns]
                cur.execute(insert_query, row_data)
            except Exception as e:
                print(f"Error importing row {idx}: {str(e)}")
                print(f"Row data: {row_data}")
                raise

def populate_analytical_tables(conn):
    with conn.cursor() as cur:
        try:
            # Clear all analytical tables
            cur.execute("""
                TRUNCATE TABLE 
                    flight_risk_analysis,
                    manager_performance_insights,
                    promotion_readiness_analysis,
                    skills_gap_analysis,
                    project_performance_metrics,
                    compensation_analysis,
                    department_analytics
            """)
            
            # Flight risk analysis
            cur.execute("""
                WITH risk_groups AS (
                    SELECT 
                        CASE 
                            WHEN flight_risk >= 70 THEN 'High'
                            WHEN flight_risk >= 40 THEN 'Medium'
                            ELSE 'Low'
                        END as risk_level,
                        department,
                        primary_specialization,
                        hire_date,
                        performance_score,
                        base_salary,
                        actual_utilization
                    FROM employees
                ),
                dept_counts AS (
                    SELECT risk_level, department, COUNT(*) as dept_count
                    FROM risk_groups
                    GROUP BY risk_level, department
                ),
                spec_counts AS (
                    SELECT risk_level, primary_specialization, COUNT(*) as spec_count
                    FROM risk_groups
                    GROUP BY risk_level, primary_specialization
                )
                INSERT INTO flight_risk_analysis
                SELECT 
                    rg.risk_level,
                    COUNT(DISTINCT rg.department) as employee_count,
                    AVG(DATE_PART('year', CURRENT_DATE) - DATE_PART('year', rg.hire_date)) as avg_tenure,
                    AVG(rg.performance_score) as avg_performance,
                    AVG(rg.base_salary) as avg_salary,
                    AVG(rg.actual_utilization) as avg_utilization,
                    (SELECT jsonb_object_agg(department, dept_count)
                     FROM dept_counts dc
                     WHERE dc.risk_level = rg.risk_level) as dept_distribution,
                    (SELECT jsonb_object_agg(primary_specialization, spec_count)
                     FROM spec_counts sc
                     WHERE sc.risk_level = rg.risk_level) as common_specializations
                FROM risk_groups rg
                GROUP BY rg.risk_level
            """)

            # manager performance insights
            cur.execute("""
                WITH perf_categories AS (
                    SELECT 
                        e.employee_id,
                        e.management_level,
                        e.department,
                        e.knowledge_sharing_score,
                        e.avg_project_complexity,
                        e.mentorship_hours,
                        CASE 
                            WHEN e.performance_score >= 4.5 THEN 'Top'
                            WHEN e.performance_score >= 3.5 THEN 'Average'
                            ELSE 'Below'
                        END as performance_category
                    FROM employees e
                    WHERE e.is_manager = true
                ),
                team_metrics AS (
                    SELECT 
                        e.manager_id,
                        AVG(e.performance_score) as team_performance,
                        AVG(e.project_satisfaction) as team_satisfaction,
                        1 - AVG(e.flight_risk/100) as team_retention,
                        COUNT(*) as team_size
                    FROM employees e
                    GROUP BY e.manager_id
                ),
                dept_counts AS (
                    SELECT 
                        management_level,
                        performance_category,
                        department,
                        COUNT(*) as dept_count
                    FROM perf_categories
                    GROUP BY management_level, performance_category, department
                )
                INSERT INTO manager_performance_insights
                SELECT 
                    pc.management_level,
                    pc.performance_category,
                    COUNT(DISTINCT pc.employee_id) as manager_count,
                    AVG(tm.team_size) as avg_team_size,
                    AVG(tm.team_performance) as avg_team_performance,
                    AVG(tm.team_satisfaction) as avg_team_satisfaction,
                    AVG(tm.team_retention) as avg_team_retention,
                    (SELECT jsonb_object_agg(department, dept_count)
                     FROM dept_counts dc
                     WHERE dc.management_level = pc.management_level 
                     AND dc.performance_category = pc.performance_category) as dept_distribution,
                    jsonb_build_object(
                        'avg_knowledge_sharing', AVG(pc.knowledge_sharing_score),
                        'avg_project_complexity', AVG(pc.avg_project_complexity),
                        'avg_mentorship_hours', AVG(pc.mentorship_hours)
                    ) as success_factors
                FROM perf_categories pc
                LEFT JOIN team_metrics tm ON pc.employee_id = tm.manager_id
                GROUP BY pc.management_level, pc.performance_category
            """)

            # promotion readiness analysis
            cur.execute("""
                WITH readiness_groups AS (
                    SELECT 
                        employee_id,
                        CASE 
                            WHEN promotion_readiness >= 80 THEN 'Ready Now'
                            WHEN promotion_readiness >= 60 THEN 'Ready Soon'
                            WHEN promotion_readiness >= 40 THEN 'Developing'
                            ELSE 'Not Ready'
                        END as readiness_band,
                        level,
                        department,
                        primary_specialization,
                        performance_score,
                        knowledge_sharing_score,
                        avg_project_complexity
                    FROM employees
                    WHERE level != 'senior'
                ),
                skill_counts AS (
                    SELECT 
                        readiness_band,
                        level,
                        primary_specialization,
                        COUNT(*) as skill_count
                    FROM readiness_groups
                    GROUP BY readiness_band, level, primary_specialization
                ),
                dept_counts AS (
                    SELECT 
                        readiness_band,
                        level,
                        department,
                        COUNT(*) as dept_count
                    FROM readiness_groups
                    GROUP BY readiness_band, level, department
                )
                INSERT INTO promotion_readiness_analysis
                SELECT 
                    rg.readiness_band,
                    rg.level,
                    COUNT(DISTINCT rg.employee_id) as employee_count,
                    AVG(rg.performance_score) as avg_performance,
                    AVG(rg.knowledge_sharing_score) as avg_knowledge_sharing,
                    AVG(rg.avg_project_complexity) as avg_project_complexity,
                    (SELECT jsonb_object_agg(primary_specialization, skill_count)
                     FROM skill_counts sc
                     WHERE sc.readiness_band = rg.readiness_band 
                     AND sc.level = rg.level) as critical_skills,
                    (SELECT jsonb_object_agg(department, dept_count)
                     FROM dept_counts dc
                     WHERE dc.readiness_band = rg.readiness_band 
                     AND dc.level = rg.level) as dept_distribution
                FROM readiness_groups rg
                GROUP BY rg.readiness_band, rg.level
            """)

            # skills gap analysis
            cur.execute("""
                WITH skill_coverage AS (
                    SELECT 
                        department,
                        primary_specialization as critical_skill,
                        COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (PARTITION BY department), 0) as current_coverage,
                        CASE 
                            WHEN department = 'Engineering Delivery' THEN 85
                            WHEN department = 'Product Architecture' THEN 80
                            ELSE 75
                        END as required_coverage
                    FROM employees
                    GROUP BY department, primary_specialization
                )
                INSERT INTO skills_gap_analysis
                SELECT 
                    department,
                    critical_skill,
                    current_coverage,
                    required_coverage,
                    CASE 
                        WHEN (required_coverage - current_coverage) >= 20 THEN 'High'
                        WHEN (required_coverage - current_coverage) >= 10 THEN 'Medium'
                        ELSE 'Low'
                    END as gap_severity,
                    (SELECT COUNT(DISTINCT e.active_projects)
                     FROM employees e
                     WHERE e.department = sc.department 
                     AND e.primary_specialization = sc.critical_skill) as affected_projects,
                    jsonb_build_object(
                        'recommended_training', ARRAY['Technical Certification', 'Mentorship Program', 'External Training'],
                        'estimated_time', '6 months',
                        'priority', CASE 
                            WHEN (required_coverage - current_coverage) >= 20 THEN 'High'
                            WHEN (required_coverage - current_coverage) >= 10 THEN 'Medium'
                            ELSE 'Low'
                        END
                    ) as training_recommendations
                FROM skill_coverage sc
            """)

            # project_performance_metrics
            cur.execute("""
                WITH project_metrics AS (
                    SELECT 
                        department,
                        ROUND(avg_project_complexity) as complexity_level,
                        COUNT(*) as project_count,
                        AVG(avg_project_duration) as avg_duration,
                        AVG(projects_on_time) as success_rate,
                        AVG(avg_team_size) as avg_team_size
                    FROM employees
                    WHERE active_projects > 0
                    GROUP BY department, ROUND(avg_project_complexity)
                )
                INSERT INTO project_performance_metrics
                SELECT 
                    complexity_level::integer,
                    department,
                    project_count,
                    avg_duration,
                    success_rate,
                    avg_team_size,
                    jsonb_build_object(
                        'team_expertise', 'High',
                        'clear_requirements', true,
                        'stakeholder_engagement', 'Strong'
                    ) as key_success_factors,
                    jsonb_build_object(
                        'resource_constraints', 'Medium',
                        'technical_complexity', 'High',
                        'timeline_pressure', 'Medium'
                    ) as risk_factors
                FROM project_metrics
            """)

            # compensation_analysis
            cur.execute("""
                WITH comp_metrics AS (
                    SELECT 
                        department,
                        level,
                        CASE 
                            WHEN performance_score >= 4.5 THEN 'High'
                            WHEN performance_score >= 3.5 THEN 'Medium'
                            ELSE 'Low'
                        END as performance_band,
                        COUNT(*) as employee_count,
                        AVG(base_salary) as avg_base_salary,
                        AVG(total_comp) as avg_total_comp,
                        MIN(base_salary) as min_salary,
                        MAX(base_salary) as max_salary
                    FROM employees
                    GROUP BY department, level, 
                        CASE 
                            WHEN performance_score >= 4.5 THEN 'High'
                            WHEN performance_score >= 3.5 THEN 'Medium'
                            ELSE 'Low'
                        END
                )
                INSERT INTO compensation_analysis
                SELECT 
                    department,
                    level,
                    performance_band,
                    employee_count,
                    avg_base_salary,
                    avg_total_comp,
                    jsonb_build_object(
                        'min', min_salary,
                        'max', max_salary,
                        'range', max_salary - min_salary
                    ) as salary_range,
                    CASE 
                        WHEN department = 'Engineering Delivery' THEN 1.1
                        WHEN department = 'Product Architecture' THEN 1.15
                        ELSE 1.0
                    END as market_position
                FROM comp_metrics
            """)

            conn.commit()

        except Exception as e:
            conn.rollback()
            print(f"Error during import: {str(e)}")
            raise

def populate_detailed_analytics(conn):
    """Populate the detailed analytics tables using existing CTEs and additional metrics"""
    with conn.cursor() as cur:
        try:
            # Clear existing data
            cur.execute("TRUNCATE TABLE employee_analytics, manager_analytics, department_analytics")
            
            # Populate employee_analytics
            cur.execute("""
                WITH risk_groups AS (
                    SELECT 
                        employee_id,
                        CASE 
                            WHEN flight_risk >= 70 THEN 'High'
                            WHEN flight_risk >= 40 THEN 'Medium'
                            ELSE 'Low'
                        END as risk_level,
                        jsonb_build_object(
                            'flight_risk', flight_risk,
                            'retention_risk', retention_risk,
                            'engagement_score', engagement_score,
                            'performance_score', performance_score
                        ) as risk_factors
                    FROM employees
                ),
                readiness_metrics AS (
                    SELECT 
                        employee_id,
                        CASE 
                            WHEN promotion_readiness >= 80 THEN 'Ready Now'
                            WHEN promotion_readiness >= 60 THEN 'Ready Soon'
                            WHEN promotion_readiness >= 40 THEN 'Developing'
                            ELSE 'Not Ready'
                        END as readiness_band,
                        jsonb_build_object(
                            'promotion_readiness', promotion_readiness,
                            'knowledge_sharing_score', knowledge_sharing_score,
                            'training_hours', training_hours,
                            'mentorship_hours', mentorship_hours
                        ) as readiness_metrics
                    FROM employees
                )
                INSERT INTO employee_analytics (
                    employee_id, 
                    risk_level, 
                    risk_factors, 
                    readiness_band, 
                    readiness_metrics,
                    performance_metrics,
                    skill_metrics
                )
                SELECT 
                    e.employee_id,
                    rg.risk_level,
                    rg.risk_factors,
                    rm.readiness_band,
                    rm.readiness_metrics,
                    jsonb_build_object(
                        'performance_score', e.performance_score,
                        'innovation_score', e.innovation_score,
                        'delivery_quality', e.delivery_quality,
                        'project_satisfaction', e.project_satisfaction
                    ) as performance_metrics,
                    jsonb_build_object(
                        'primary_specialization', e.primary_specialization,
                        'secondary_specialization', e.secondary_specialization,
                        'certifications', e.certifications,
                        'avg_project_complexity', e.avg_project_complexity
                    ) as skill_metrics
                FROM employees e
                JOIN risk_groups rg ON e.employee_id = rg.employee_id
                JOIN readiness_metrics rm ON e.employee_id = rm.employee_id
            """)

            # Populate manager_analytics with fixed query
            cur.execute("""
                WITH team_metrics AS (
                    SELECT 
                        e.manager_id,
                        COUNT(*) as team_size,
                        AVG(e.performance_score) as avg_team_performance,
                        AVG(e.project_satisfaction) as avg_team_satisfaction,
                        1 - AVG(e.flight_risk/100) as avg_retention_rate
                    FROM employees e
                    WHERE e.manager_id IS NOT NULL
                    GROUP BY e.manager_id
                )
                INSERT INTO manager_analytics (
                    manager_id,
                    management_level,
                    performance_category,
                    team_metrics,
                    success_metrics,
                    department_impact
                )
                SELECT 
                    e.employee_id,
                    e.management_level,
                    CASE 
                        WHEN e.performance_score >= 4.5 THEN 'Top'
                        WHEN e.performance_score >= 3.5 THEN 'Average'
                        ELSE 'Below'
                    END as performance_category,
                    jsonb_build_object(
                        'team_size', COALESCE(tm.team_size, 0),
                        'avg_team_performance', COALESCE(tm.avg_team_performance, 0),
                        'avg_team_satisfaction', COALESCE(tm.avg_team_satisfaction, 0),
                        'avg_retention_rate', COALESCE(tm.avg_retention_rate, 0)
                    ) as team_metrics,
                    jsonb_build_object(
                        'knowledge_sharing_score', e.knowledge_sharing_score,
                        'mentorship_hours', e.mentorship_hours,
                        'team_lead_projects', e.team_lead_projects,
                        'span_of_control', e.span_of_control
                    ) as success_metrics,
                    jsonb_build_object(
                        'department', e.department,
                        'direct_reports', e.direct_reports,
                        'projects_on_time', e.projects_on_time
                    ) as department_impact
                FROM employees e
                LEFT JOIN team_metrics tm ON e.employee_id = tm.manager_id
                WHERE e.is_manager = true
            """)

            # Populate department_analytics
            cur.execute("""
                INSERT INTO department_analytics
                SELECT 
                    e.department,
                    e.level,
                    e.position,
                    COUNT(*) as employee_count,
                    jsonb_build_object(
                        'avg_performance', AVG(e.performance_score),
                        'avg_satisfaction', AVG(e.project_satisfaction),
                        'avg_utilization', AVG(e.actual_utilization),
                        'avg_salary', AVG(e.base_salary)
                    ) as avg_metrics,
                    jsonb_build_object(
                        'high_risk', COUNT(*) FILTER (WHERE e.flight_risk >= 70),
                        'medium_risk', COUNT(*) FILTER (WHERE e.flight_risk >= 40 AND e.flight_risk < 70),
                        'low_risk', COUNT(*) FILTER (WHERE e.flight_risk < 40)
                    ) as risk_distribution,
                    jsonb_build_object(
                        'ready_now', COUNT(*) FILTER (WHERE e.promotion_readiness >= 80),
                        'ready_soon', COUNT(*) FILTER (WHERE e.promotion_readiness >= 60 AND e.promotion_readiness < 80),
                        'developing', COUNT(*) FILTER (WHERE e.promotion_readiness >= 40 AND e.promotion_readiness < 60),
                        'not_ready', COUNT(*) FILTER (WHERE e.promotion_readiness < 40)
                    ) as readiness_distribution,
                    jsonb_build_object(
                        'top_performers', COUNT(*) FILTER (WHERE e.performance_score >= 4.5),
                        'average_performers', COUNT(*) FILTER (WHERE e.performance_score >= 3.5 AND e.performance_score < 4.5),
                        'below_average', COUNT(*) FILTER (WHERE e.performance_score < 3.5)
                    ) as performance_distribution
                FROM employees e
                GROUP BY e.department, e.level, e.position
            """)

            conn.commit()
            print("Detailed analytics tables populated successfully!")
        except Exception as e:
            conn.rollback()
            print(f"Error populating detailed analytics: {e}")
            raise

def validate_data(df):
    """
    Validate the input data before processing
    """
    required_columns = [
        'employee_id', 'full_name', 'department', 'position', 'level',
        'hire_date', 'base_salary', 'manager_id', 'is_manager'
    ]
    
    missing_columns = [col for col in required_columns if col not in df.columns]
    if missing_columns:
        raise ValueError(f"Missing required columns: {missing_columns}")
    
    if df['employee_id'].duplicated().any():
        raise ValueError("Duplicate employee IDs found")
    
    if not all(isinstance(x, (int, float, np.integer)) for x in df['employee_id']):
        raise ValueError("Invalid employee_id values")

def main():
    df = pd.read_excel("C:\\Users\\govar\\OneDrive\\Documents\\SQL_Enigma\\consultancy_data_5400.xlsx")
    df['hire_date'] = pd.to_datetime(df['hire_date'])
    with create_connection() as conn:
        try:
            create_tables(conn)
            import_main_data(conn, df)
            populate_analytical_tables(conn)
            populate_detailed_analytics(conn)
            conn.commit()
            print("Data import completed successfully!")
        except Exception as e:
            conn.rollback()
            print(f"Error during import: {e}")

if __name__ == "__main__":
    main()