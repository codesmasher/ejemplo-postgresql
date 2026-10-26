-- create function to get the last id from a table
CREATE OR REPLACE FUNCTION new_id(varchar)
  RETURNS integer AS
$BODY$
DECLARE
  _table ALIAS FOR $1;
  _new_id integer;

BEGIN
  -- concat the name with the query
  EXECUTE 'SELECT coalesce(max(id)::integer + 1, 0) AS id FROM ' || _table INTO _new_id;
  RETURN _new_id;

END; $BODY$
LANGUAGE 'plpgsql' VOLATILE
  COST 100;

-- define postgres as owner of this function
ALTER FUNCTION new_id(varchar)
  OWNER TO postgres;
