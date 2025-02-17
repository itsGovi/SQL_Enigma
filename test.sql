ALTER TABLE employees DROP COLUMN IF EXISTS revenue;

-- Step 1: Add the 'revenue' column
ALTER TABLE employees ADD COLUMN revenue DECIMAL(14,2);

-- Step 2: Update 'revenue' column with a realistic revenue calculation
UPDATE employees
SET revenue =
    -- Base annual revenue from billable hours
    (billing_rate * (actual_utilization / 100) * 2000)
    -- Bonus revenue factor from project count and complexity
    + (active_projects * avg_project_complexity * 500)
    -- Subtract an overhead cost (15% of total compensation)
    - (total_comp * 0.15);
