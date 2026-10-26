-- create function to validate user_account before insert
CREATE OR REPLACE FUNCTION get_new_id()
  RETURNS trigger AS
$BODY$
BEGIN
  -- get a new id if there isn't set
  IF NEW.id IS NULL THEN
    NEW.id = (SELECT new_id(TG_TABLE_NAME::varchar));
  END IF;

  RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION get_new_id()
  OWNER TO postgres;

-- assign function as trigger
CREATE TRIGGER validate_role_id 
  BEFORE INSERT
  ON role
  FOR EACH ROW
  EXECUTE PROCEDURE get_new_id();
