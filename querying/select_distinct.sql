-- Consultando nombres únicos de clientes
SELECT
    DISTINCT first_name,
    last_name
FROM
    customer
ORDER BY
    last_name,
    first_name;
