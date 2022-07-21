-- Consultando y ordenando datos de los clientes
SELECT
    length(first_name) AS len,
    first_name,
    last_name,
    email
FROM
    customer
ORDER BY
    len DESC,
    first_name,
    last_name DESC;
