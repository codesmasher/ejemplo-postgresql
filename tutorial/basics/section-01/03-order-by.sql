-- Sentencia ORDER BY
-- Al consultar una tabla los datos son devueltos sin algun orden en particular
-- para organizar las filas es necesario usar la sentencia ORDER BY en una
-- sentencia SELECT.

-- El ordenamiento puede ser asencente o descendente de acuerdo lo indicado en
-- la expresión de ordenamiento de la sentencia ORDER BY.

-- Sintaxis básica:
-- SELECT select_list
-- FROM table_name
-- ORDER BY sort_expression1 [ASC | DESC],
--   ...,
--   sort_expressionN [ASC | DESC];

-- Donde:
-- sort_expression1 puede ser una columna o una expresión, si es necesario puede
-- incluirse más columnas o expresiones separadas por comas (,) para cambiar el
-- resultado del ordenamiento.

-- La opción ASC o DESC define el tipo de ordenamiento, ascendente con ASC y
-- descendente con DESC. Si se omite esta opción el valor por defecto será ASC.

-- PostgreSQL evalua en tercer lugar la sentencia ORDER BY, justo despúes que
-- FROM y SELECT. Si algún campo ha sido asignado con un alias debe ser indicado
-- en la sentencia ORDER BY con el nombre del alias.

-- Ejemplos:
-- 1) Ordenar las filas de forma ascendente por el campo first_name.
SELECT first_name, last_name FROM customer ORDER BY first_name ASC;

-- 2) Ordernar las filas primero de forma ascendente por el campo first_name,
-- posteriormente de forma descendente por el campo last_name.
SELECT first_name, last_name FROM customer ORDER BY first_name, last_name DESC;

-- 3) Ordenar las filas de forma descendente por el resultado de la expresión
-- length, la cual ha sido asignado el alias len.
SELECT first_name, length(first_name) len FROM customer ORDER BY len DESC;

-- La sentencia ORDER BY y el valor NULL
-- El valor de NULL es un marcador que indica un valor perdido u omitido al
-- momento de registrar la fila en la tabla.

-- Cuando ordenas las filas en una consulta puedes indicar la posicion de los
-- valores NULL al principio o el final del resultado usando la sentencia NULLS
-- FIRST o NULLS LAST al final de cada sort_expression.

-- Sintaxis básica:
-- ORDER BY sort_expression [ASC | DESC] [NULLS FIRST | NULLS LAST]

-- Donde:
-- NULLS FIRST es el valor por defecto si se omite al declarar la sentencia
-- ORDER BY.

-- Ejemplos:
-- 1) Ordenar los valores NULL al principio antes del resto de valores.
SELECT postal_code FROM address ORDER BY postal_code;

-- 2) Ordenar los valores NULL al final después del resto de los valores.
SELECT postal_code FROM address ORDER BY postal_code NULLS LAST;
