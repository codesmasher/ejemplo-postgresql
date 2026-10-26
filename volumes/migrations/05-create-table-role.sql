-- create table if not exists and named role
CREATE TABLE IF NOT EXISTS role (
  id smallint NOT NULL,
  role_name character varying(32) NOT NULL,
  description character varying(64) DEFAULT 'there is no description for this role',
  created timestamp with time zone NOT NULL DEFAULT now(),
  modified timestamp with time zone,
  CONSTRAINT role_key PRIMARY KEY (id),
  CONSTRAINT role_name_unique UNIQUE (role_name)
)
WITH (OIDS = FALSE);

-- define postgres as owner of this table
ALTER TABLE role
  OWNER TO postgres;
