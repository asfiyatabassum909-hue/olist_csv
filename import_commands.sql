-- Olist Dataset: Import Commands
-- IMPORTANT: Run schema.sql FIRST to create the tables.
--
-- HOW TO USE THIS FILE:
-- 1. Place all the CSV files from this folder into one location on your computer,
--    e.g. C:\Users\Asfiya\Downloads\olist_csv\
-- 2. Replace the file path below with YOUR actual folder path.
-- 3. Run these commands in psql (not a regular SQL editor tab) OR use your
--    PostgreSQL client's "Import" feature and point it at each CSV, matching
--    each CSV to its table name below.
--
-- If you're using VS Code's SQLTools/PostgreSQL extension, it's often easier to
-- right-click each table (after running schema.sql) and choose "Import CSV" from
-- the extension's UI instead of using \copy — either approach works.

\copy product_category_name_translation FROM 'product_category_name_translation.csv' DELIMITER ',' CSV HEADER;
\copy sellers FROM 'sellers.csv' DELIMITER ',' CSV HEADER;
\copy customers FROM 'customers.csv' DELIMITER ',' CSV HEADER;
\copy geolocation FROM 'geolocation.csv' DELIMITER ',' CSV HEADER;
\copy products FROM 'products.csv' DELIMITER ',' CSV HEADER;
\copy orders FROM 'orders.csv' DELIMITER ',' CSV HEADER;
\copy order_items FROM 'order_items.csv' DELIMITER ',' CSV HEADER;
\copy order_payments FROM 'order_payments.csv' DELIMITER ',' CSV HEADER;
\copy order_reviews FROM 'order_reviews.csv' DELIMITER ',' CSV HEADER;
\copy leads_qualified FROM 'leads_qualified.csv' DELIMITER ',' CSV HEADER;
\copy leads_closed FROM 'leads_closed.csv' DELIMITER ',' CSV HEADER;

-- NOTE: \copy commands must be run from the SAME folder as the CSV files
-- (or use full absolute paths instead of just the filename), otherwise
-- Postgres won't be able to find them.
