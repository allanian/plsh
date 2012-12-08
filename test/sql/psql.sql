CREATE TABLE pbar (a int, b text);
INSERT INTO pbar VALUES (1, 'one'), (2, 'two');

CREATE FUNCTION query (x int) RETURNS text
LANGUAGE plsh
AS $$
#!/bin/sh
psql -At -c "select b from pbar where a = $1"
$$;

SELECT query(1);
