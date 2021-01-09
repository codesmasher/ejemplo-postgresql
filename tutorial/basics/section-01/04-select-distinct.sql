-- Sentencia DISTINCT
-- Se utiliza para eliminar valores duplicados en las filas resultantes de una
-- consulta quedando solo valores únicos. La sentencia DISTINCT puede aplicarse
-- a una o más columnas en el select_list de una sentencia SELECT. 

-- Sintaxis básica:
-- SELECT DISTINCT column1 FROM table_name;

-- Donde:
-- los valores en column1 son utilizados para seleccionar valores sin duplicados
-- si se indica más de una columna en la sentencia se evaluara la combinación de
-- valores en cada caso.

-- PostgreSQL además provee la sentencia DISTINCT ON(expression) para mantener
-- la primer fila de cada grupo de duplicados usando la sintaxis:
-- SELECT DISTINCT ON(column1) AS column_alias, column2
-- FROM table_name
-- ORDER BY column1, column2;

-- Como buena practica siempre debe utilizarse la sentencia ORDER BY en conjunto
-- a DISTINCT ON para que el resultado sea predecible. También debe notar que
-- las columnas de ORDER BY deben coincidir con lo indicado en DISTINCT ON.

-- Ejemplos:
-- 1) Obtener los valores únicos del campo first_name.
SELECT DISTINCT first_name FROM customer ORDER BY first_name;

-- 2) Obtener los valores únicos de los campos first_name y last_name.
SELECT DISTINCT first_name, last_name
FROM customer
ORDER BY first_name, last_name;

-- 3) Obtener la primer fila de cada valor único del campo fist_name.
SELECT DISTINCT ON(first_name) first_name, last_name
FROM customer
ORDER BY first_name, last_name;
