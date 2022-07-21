-- Consultando clientes con alias
SELECT
    first_name || ' ' || last_name AS "full name",
    email,
    now() AS today
FROM
    customer;
