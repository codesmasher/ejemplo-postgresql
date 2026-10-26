-- delete previous database if exists
DROP DATABASE IF EXISTS example;

-- create an empty database from sql
CREATE DATABASE example
  WITH OWNER = postgres
  ENCODING = 'UTF8'
  TABLESPACE = pg_default
  CONNECTION LIMIT -1;
