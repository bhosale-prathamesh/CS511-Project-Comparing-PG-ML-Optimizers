-- Create TPC-H tables
\i /usr/local/pgsql/tpch_data/schemata.sql

-- Load data from the copied .tbl files
COPY region FROM '/usr/local/pgsql/tpch_data/region.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY nation FROM '/usr/local/pgsql/tpch_data/nation.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY supplier FROM '/usr/local/pgsql/tpch_data/supplier.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY part FROM '/usr/local/pgsql/tpch_data/part.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY partsupp FROM '/usr/local/pgsql/tpch_data/partsupp.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY customer FROM '/usr/local/pgsql/tpch_data/customer.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY orders FROM '/usr/local/pgsql/tpch_data/orders.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
COPY lineitem FROM '/usr/local/pgsql/tpch_data/lineitem.tbl' DELIMITER '|' CSV NULL '' ESCAPE '\';
