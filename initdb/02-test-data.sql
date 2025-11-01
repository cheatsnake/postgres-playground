-- Generatge 100 random users
INSERT INTO users (login, email, birthdate, country)
SELECT
  'user_' || gs AS login,
  'user' || gs || '@example.com' AS email,
  DATE '1980-01-01' + (random() * 15000)::int * INTERVAL '1 day' AS birthdate,
  (ARRAY['Germany','France','Spain','Italy','Poland','UK','USA'])[floor(random()*7 + 1)] AS country
FROM generate_series(1, 100) AS gs;

-- Generate balance for each user
INSERT INTO balances (user_id, amount)
SELECT
  id,
  round((random() * 10000)::numeric, 2)
FROM users;

-- 10 000 random transactions
INSERT INTO transactions (from_user_id, to_user_id, amount, created_at)
SELECT *
FROM (
  SELECT
    (random() * 99 + 1)::int AS from_user_id,
    (random() * 99 + 1)::int AS to_user_id,
    round((random() * 1000)::numeric, 2) AS amount,
    now() - ((random() * 365)::int * INTERVAL '1 day')
          - (random() * 24 * 60 * 60)::int * INTERVAL '1 second'
    AS created_at
  FROM generate_series(1, 10000)
) t
WHERE from_user_id <> to_user_id;
