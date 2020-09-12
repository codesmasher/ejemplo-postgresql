-- create table if not exists and named user_account
CREATE TABLE IF NOT EXISTS user_account (
  id integer NOT NULL,
  account_type character varying(16) NOT NULL DEFAULT 'undefined',
  username character varying(128) NOT NULL,
  pass character varying(512) NOT NULL,
  email character varying(256) NOT NULL,
  parent integer,
  account_status character varying(16) NOT NULL DEFAULT 'blocked',
  created timestamp with time zone NOT NULL DEFAULT now(),
  email_verified boolean NOT NULL DEFAULT FALSE,
  verification_token character varying(512),
  last_login timestamp with time zone
)
  WITH (OIDS = FALSE);

-- define postgres as owner of this table
ALTER TABLE user_account
  OWNER TO postgres;
