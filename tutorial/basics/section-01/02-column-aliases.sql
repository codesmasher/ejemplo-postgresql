-- Sentencia AS
-- Es posible asignar un nombre temporal a un campo al momento de efectuar una
-- sentencia SELECT esto es con ayuda de la sentencia AS en el select_list.
-- Estos nombres temporales solo estan disponibles durante la ejecución de la
-- consulta.

-- Sintaxis básica:
-- SELECT column_name AS alias_name FROM table_name;

-- Donde:
-- alias_name es asignado como alias para column_name. La sentencia AS puede ser
-- omitida por lo que la consulta anterior puede escribirse también de la
-- siguiente forma.
-- SELECT column_name alias_name FROM table_name;

-- Además de columnas, es posible asignar alias a las expresiones incluidas en
-- la sentencia SELECT.

-- Ejemplos:
-- 1) Asignar alias a un campo.
SELECT first_name, last_name AS surname FROM customer;

-- 2) Asignar alias a una expresión.
SELECT first_name || ' ' || last_name AS full_name FROM customer;

-- 3) Asignar alias con espacios en blanco a una expresión.
SELECT first_name || ' ' || last_name "full name" FROM customer;
