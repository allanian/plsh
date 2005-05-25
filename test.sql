CREATE SCHEMA plsh_test;
SET search_path TO plsh_test;

DROP FUNCTION shtest(text, text);
CREATE FUNCTION shtest (text, text) RETURNS text AS '
#!/bin/sh
echo "One: $1 Two: $2"
if test $1 = $2; then
    echo ''this is an error'' 1>&2
fi
exit 0
' LANGUAGE plsh;

SELECT shtest('foo', 'bar');
SELECT shtest('xxx', 'xxx');

DROP FUNCTION shtrigger();
CREATE FUNCTION shtrigger() RETURNS trigger AS '
#!/bin/sh
(
for arg do
    echo "Arg is $arg"
done
) >> $HOME/voodoo-pgplsh-test
exit 0
' LANGUAGE plsh;

DROP TABLE pfoo;
CREATE TABLE pfoo (a int, b text);

DROP TRIGGER testtrigger ON pfoo;
CREATE TRIGGER testtrigger AFTER INSERT ON pfoo
    FOR EACH ROW EXECUTE PROCEDURE shtrigger('dummy');

INSERT INTO pfoo VALUES (1, 'one');
INSERT INTO pfoo VALUES (2, 'two');
INSERT INTO pfoo VALUES (3, 'three');

\!cat $HOME/voodoo-pgplsh-test
\!rm $HOME/voodoo-pgplsh-test
