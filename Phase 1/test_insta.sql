CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name TEXT,
    department TEXT,
    salary NUMERIC
);

CREATE TABLE IF NOT EXISTS departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name TEXT,
    location TEXT
);

---

CREATE TABLE json_import(
    data JSONB
);

---

COPY json_import(data) FROM '/path/to/data.json';

---

INSERT INTO employees (id, name, department, salary)
SELECT
    (jsonb_array_elements(data->'employees')->> 'id')::INT,
    (jsonb_array_elements(data->'employees')->>'name'),
    (jsonb_array_elements(data->'employees')->>'department'),
    (jsonb_array_elements(data->'employees')->>'salary')::NUMERIC
FROM json_import;

---

