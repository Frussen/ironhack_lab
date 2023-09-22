use lab_db_python_sql;

SELECT * FROM leetcode;

SET @a = (
  SELECT COUNT(*)
  FROM (
    SELECT COUNT(*) AS num
    FROM (
		SELECT requester_id AS id FROM leetcode
		UNION ALL
		SELECT accepter_id AS id FROM leetcode
	) AS t
    GROUP BY id
    ORDER BY num DESC
  ) AS t2
  GROUP BY num
  LIMIT 1
);

SET @s = '
  SELECT t.id, COUNT(*) AS num
  FROM (
    SELECT requester_id AS id FROM leetcode
    UNION ALL
    SELECT accepter_id AS id FROM leetcode
  ) AS t
  GROUP BY t.id
  ORDER BY num DESC
  LIMIT ?
';

PREPARE STMT FROM @s;
EXECUTE STMT USING @a;