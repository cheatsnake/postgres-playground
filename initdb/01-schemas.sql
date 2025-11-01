CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  login VARCHAR(64) NOT NULL,
  email VARCHAR(64) NOT NULL,
  birthdate DATE NOT NULL,
  country VARCHAR(64) NOT NULL
);

CREATE TABLE balances (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  from_user_id INTEGER NOT NULL REFERENCES users(id),
  to_user_id INTEGER NOT NULL REFERENCES users(id),
  amount DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT now()
);
