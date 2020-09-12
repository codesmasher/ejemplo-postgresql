-- create sequence for user_account table
CREATE SEQUENCE account_id_seq 
  INCREMENT 1
  START 1000;

ALTER TABLE account_id_seq
  OWNER TO postgres;

-- assign sequence to id column for user_account table
ALTER TABLE user_account
  ALTER COLUMN id SET DEFAULT nextval('account_id_seq');
