-- Step 1: Add the 'created' column
ALTER TABLE employees ADD COLUMN revenue DECIMAL(10,2);

-- Step 2: Update 'created' column with calculated revenue
UPDATE employees
SET revenue = billing_rate * (actual_utilization / 100) * active_projects;
