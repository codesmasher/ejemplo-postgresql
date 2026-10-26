-- Creación de schema based
CREATE SCHEMA IF NOT EXISTS based;
-- Creación de tipo de datos para el campo estatus
CREATE TYPE based.migrations_status AS ENUM 
    ('pending', 'error', 'success');
-- Creación de la secuencia para las migraciones
CREATE SEQUENCE based.migrations_id_seq
    INCREMENT 1
    START 100;
-- Creación de la tabla para las migraciones
CREATE TABLE IF NOT EXISTS based.migrations (
    tid integer NOT NULL DEFAULT nextval('based.migrations_id_seq'::regclass),
    migration_name character varying NOT NULL,
    migration_size bigint NOT NULL,
    migration_status based.migrations_status NOT NULL DEFAULT 'pending',
    created timestamp without time zone DEFAULT now(),
    CONSTRAINT migration_pkey PRIMARY KEY (tid)
);
