-- Sentencia SELECT
-- Para realizar una consulta a los datos de una tabla es necesario utilizar la
-- sentencia SELECT.

-- La sentencia SELECT es la más compleja de PostgreSQL debido a que puede
-- complementarse con otras sentencias.

-- Sintaxis básica:
-- SELECT select_list FROM table_name;

-- Donde:
-- select_list es una o varias columnas, separadas por comas (,) de la tabla que
-- será consultada. También es posible utilizar el comodín (*) para obtener
-- todos los campos de la tabla.
-- table_name es el nombre de la tabla que será consultada.

-- Nota: es posible omitir el nombre de la tabla si no deseas consultar una
-- tabla.

-- PostgreSQL evalua primero la sentencia FROM antes de SELECT al momento de
-- ejecutar la consulta.

-- Ejemplos:
-- 1) Consultar un campo de una tabla.
SELECT first_name FROM customer;

-- 2) Consultar una lista de campos de una tabla.
SELECT first_name, last_name, email FROM customer;

-- 3) Consultar todos los campos de una tabla.
SELECT * FROM customer;

-- 4) Concatenar campos con el comodín ||.
SELECT first_name || ' ' || last_name, email FROM customer;

-- 5) Efectuar una operación aritmetica sin consultar una tabla.
SELECT 5 * 3;
