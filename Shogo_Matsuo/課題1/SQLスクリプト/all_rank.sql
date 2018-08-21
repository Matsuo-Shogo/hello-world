DROP FUNCTION IF EXISTS test(in last_day date, out user_id integer, out order_date date, out user_rank text);
CREATE OR REPLACE FUNCTION test(in last_day date, out user_id integer, out order_date date, out user_rank text)
RETURNS setof record AS $$

SELECT 
  user_id
  ,last_day
  ,CASE
    WHEN  last_day - MAX(order_date) <= 30 AND COUNT(*) >= 7 AND SUM(order_amount) >= 50000 THEN 'A'
    WHEN  last_day - MAX(order_date) <= 60 AND COUNT(*) >= 5 AND SUM(order_amount) >= 30000 THEN 'B'
    WHEN  last_day - MAX(order_date) <= 120 AND COUNT(*) >= 3 AND SUM(order_amount) >= 10000 THEN 'C'
    ELSE 'D'
  END AS user_rank
FROM
  ro_data
WHERE
  order_date <= last_day
GROUP BY
  user_id
;
$$ LANGUAGE sql
;
