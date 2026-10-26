-- create function to validate user_account before insert
CREATE OR REPLACE FUNCTION before_insert_account()
  RETURNS trigger AS
$BODY$
BEGIN
  -- prevent wrong values or empty columns
  IF NEW.username IS NULL THEN
    NEW.username = (SELECT to_char(now(), 'YYYYMMDDHH24MISS'));
  END IF;

  IF NEW.parent IS NULL THEN
    NEW.parent = 0;
  END IF;

  -- account_type
  IF NOT EXISTS (SELECT id FROM role WHERE role_name = NEW.account_type) THEN
    RAISE EXCEPTION 'invalid account_status value';
  END IF;

  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION before_insert_account()
  OWNER TO postgres;

-- assign function as trigger
CREATE TRIGGER validate_account
  BEFORE INSERT
  ON user_account
  FOR EACH ROW
  EXECUTE PROCEDURE before_insert_account();
