-- Consultando clientes
SELECT
    'Customer:',
    first_name || ' ' || last_name,
    email,
    now()
FROM
    customer;
