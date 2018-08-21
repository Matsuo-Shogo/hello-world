--２つの日付を指定し、ランク毎のユーザー推移を出力するプログラム

DROP FUNCTION IF EXISTS count_rank2(in last_day date, in last_day2 date, out user_rank_old  text, out user_rank_new text, out COUNT bigint);
CREATE OR REPLACE FUNCTION count_rank2(in last_day date, in last_day2 date, out user_rank_old  text, out user_rank_new text, out COUNT bigint)
RETURNS setof record AS $$

WITH A AS(
  SELECT
    user_id
    ,CASE
      WHEN last_day - MAX(order_date) <= 30 AND COUNT(*) >= 7 AND SUM(order_amount) >= 50000 THEN 'A'
      WHEN last_day - MAX(order_date) <= 60 AND COUNT(*) >= 5 AND SUM(order_amount) >= 30000 THEN 'B'
      WHEN last_day - MAX(order_date) <= 120 AND COUNT(*) >= 3 AND SUM(order_amount) >= 10000 THEN 'C'
      ELSE 'D'
    END AS first_rank
  FROM
    ro_data
  WHERE
    order_date <= last_day
  GROUP BY
    user_id
)
, B AS(
  SELECT
    user_id
    ,CASE
      WHEN last_day2 - MAX(order_date) <= 30 AND COUNT(*) >= 7 AND SUM(order_amount) >= 50000 THEN 'A'
      WHEN last_day2 - MAX(order_date) <= 60 AND COUNT(*) >= 5 AND SUM(order_amount) >= 30000 THEN 'B'
      WHEN last_day2 - MAX(order_date) <= 120 AND COUNT(*) >= 3 AND SUM(order_amount) >= 10000 THEN 'C'
      ELSE 'D'
    END AS second_rank
  FROM
    ro_data
  WHERE
    order_date <= last_day2
  GROUP BY
    user_id
)
, C AS(
  SELECT
    A.user_id
    ,first_rank
    ,second_rank
  FROM
    A
  LEFT JOIN
    B
  ON
    A.user_id = B.user_id
)
SELECT
  first_rank
  ,second_rank
  ,COUNT(*)
FROM
  C
GROUP BY
  first_rank,second_rank
ORDER BY
  first_rank,second_rank
;

$$ LANGUAGE sql
;

SELECT *
FROM count_rank2('2017-09-30','2017-11-20')
;

