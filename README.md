# PostgreSQL playground

Start database:

```sh
docker compose up -d
```

Connect to database:

```sh
docker exec -it postgres_playground psql -U postgres -d database
```

Stop database:

```sh
docker compose down
```

Stop database and delete all data:

```sh
docker compose down -v
```
