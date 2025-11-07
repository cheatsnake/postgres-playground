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
