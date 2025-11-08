# PostgreSQL playground

A containerized PostgreSQL instance pre-loaded with a generated data for SQL training and query practice. Provides a instant, consistent environment for learning and testing.

## Tables

<img src="./database.png" alt="Database schema">

## Commands

Start database:

```sh
docker compose up -d
```

Connect to database:

```sh
docker exec -it postgres_playground psql -U postgres -d database
```

> Type `quit` to exit

Perform SQL query from host machine:

```sh
docker exec \
    -it postgres_playground psql \
    -U postgres \
    -d database \
    -c "SELECT * FROM users LIMIT 10;"
```

Stop database:

```sh
docker compose down
```

Stop database and delete all data:

```sh
docker compose down -v
```

## Examples

Select names of inactive users:

```sql
SELECT name FROM users WHERE is_active = False;
```

Select products with prices more than 90:

```sql
SELECT name, price FROM products WHERE price > 90;
```

Select 5 newest products:

```sql
SELECT * FROM products ORDER BY created_at DESC LIMIT 5;
```

Mark user inactive:

```sql
UPDATE users SET is_active = False WHERE id = 1;
```

Create new user:

```sql
INSERT INTO users (name, email, is_active, metadata)
VALUES ('John Doe', 'john@example.com', TRUE, '{"language": "en"}');
```

Create new product:

```sql
INSERT INTO products (name, sku, category_id, price, tags, description)
VALUES ('Example Product Name', 'SKU-EXAMPLE-001', 1,
    29.99, ARRAY['new', 'featured'], 'Good product.'
);
```

Delete user:

```sql
DELETE FROM users WHERE id = 1001;
```

Count products:

```sql
SELECT COUNT(*) FROM products;
```

Find one of the cheapest product:

```sql
SELECT * FROM products ORDER BY price ASC LIMIT 1;
```

Find the most expensive products:

```sql
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);
```

Find products with prices between 40 and 60 (inclusive):

```sql
SELECT * FROM products WHERE price BETWEEN 40 AND 60;
```

Show products with discount tag:

```sql
SELECT * FROM products WHERE 'discount' = ANY(tags);
```

```sql
SELECT * FROM products WHERE tags @> ARRAY['discount'];
```

Show users with English language preference:

```sql
SELECT * FROM users WHERE metadata->>'language' = 'en';
```

Show users created in last 10 days:

```sql
SELECT * FROM users WHERE created_at > NOW() - INTERVAL '10 days';
```

Show reviews that contain word 'fast' in comment column:

```sql
SELECT * FROM reviews WHERE comment ILIKE '%fast%';
```

Count active and inactive users:

```sql
SELECT is_active, COUNT(*) FROM users GROUP BY is_active;
```

Show products with category names:

```sql
SELECT p.*,
       c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id;
```

Pagination on products:

```sql
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 10 OFFSET 0;  -- Page 1: OFFSET = (page-1) * limit
```

```sql
SELECT * FROM products
ORDER BY created_at DESC
LIMIT 10 OFFSET 10;  -- Page 2: skip first 10 records
```

Show order items with order status and product name:

```sql
SELECT oi.id,
       oi.quantity,
       oi.unit_price,
       p.name AS product_name,
       o.status AS order_status
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN orders o ON oi.order_id = o.id;
```

Find products with the same name:

```sql
SELECT name,
       COUNT(*) AS count,
       ARRAY_AGG(id) AS ids
FROM products
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY count DESC, name;
```

Add gender info to user's metadata:

```sql
UPDATE users
SET metadata = COALESCE(metadata, '{}'::JSONB) || '{"gender": "male"}'::JSONB
WHERE id = 1;
```

Remove gender info from user's metadata:

```sql
UPDATE users
SET metadata = metadata - 'gender'
WHERE id = 1;
```

Count the total costs of all ordered products with order status 'shipped':

```sql
SELECT
    SUM(oi.quantity * oi.unit_price) as total_shipped_cost
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'shipped';
```

Show product reviews:

```sql
SELECT u.name, r.comment, r.rating FROM reviews r
JOIN users u ON r.user_id = u.id
WHERE r.product_id = 1;
```

Show last order time for each user:

```sql
WITH last_order AS
  (SELECT user_id, MAX(created_at) last_order_at
   FROM orders
   GROUP BY user_id)
SELECT u.id, u.name, lo.last_order_at
FROM users u
LEFT JOIN last_order lo ON lo.user_id=u.id;
```

Calculate revenue statistics by each day:

```sql
SELECT
    DATE(p.paid_at) as date,
    SUM(p.amount) as revenue,
    COUNT(DISTINCT o.id) as orders_count,
    ROUND(AVG(p.amount), 2) as average_order_value,
    MAX(p.amount) as largest_order_value
FROM payments p
JOIN orders o ON p.order_id = o.id
WHERE o.status IN ('paid', 'shipped')
GROUP BY DATE(p.paid_at)
ORDER BY date DESC;
```
