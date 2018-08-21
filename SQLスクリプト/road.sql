DROP TABLE IF EXISTS ro_data CASCADE;
CREATE TABLE ro_data(
    user_id int
    ,order_date date
    ,order_amount int
);
COPY
  ro_data
FROM 'C:\Program Files\PostgreSQL\data\ro_data.csv'

WITH
  CSV
  HEADER
;
