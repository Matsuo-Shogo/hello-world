--ある時点（日付）でのRFMランクごとの対象者数を出力するプログラム（時点はデータ上の最初の受注日から最後の受注日までの期間）

DROP FUNCTION IF EXISTS count_rank(in last_day date, out user_rank  text, out COUNT bigint);
CREATE OR REPLACE FUNCTION count_rank(in last_day date, out user_rank  text, out COUNT bigint)
RETURNS setof record AS $$

WITH A AS(
  SELECT
    user_id
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
)
SELECT
  user_rank
  ,COUNT(user_id)
FROM
  A
GROUP BY
  user_rank
ORDER BY
  user_rank
;
$$ LANGUAGE sql
;

SELECT *
FROM count_rank('2017-11-20')
;

