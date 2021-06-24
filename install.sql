-- Prevent errors in table creation
DROP TABLE IF EXISTS roles;

DROP SEQUENCE IF EXISTS roles_id_seq;

-- Create sequence for table roles
CREATE SEQUENCE roles_id_seq
    INCREMENT 1
    START 100;

ALTER TABLE roles_id_seq
    OWNER TO postgres;

-- Create table roles
CREATE TABLE roles (
    id integer NOT NULL DEFAULT nextval('roles_id_seq'::regclass),
    name character varying(64) NOT NULL,
    description character varying(512),
    login_attempts integer NOT NULL DEFAULT 5,
    login_permission boolean NOT NULL DEFAULT FALSE,
    create_users boolean NOT NULL DEFAULT FALSE,
    created timestamp without time zone NOT NULL DEFAULT now(),
    modified timestamp without time zone,
    CONSTRAINT role_pkey PRIMARY KEY (id),
    CONSTRAINT unique_role_name UNIQUE (name)
) WITH (
    OIDS = FALSE
);

ALTER TABLE roles
    OWNER TO postgres;

-- Insert default values
INSERT INTO
    roles (
        name,
        description,
        login_attempts,
        login_permission,
        create_users
    )
VALUES
    ('root', 'Root for sistem services', 0, FALSE, FALSE),
    ('admin', 'Role for admins', 1, TRUE, TRUE),
    ('client', 'Role for clients', 5, TRUE, FALSE);

