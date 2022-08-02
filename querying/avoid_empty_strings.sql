-- WHERE IS NOT NULL devuelve cadenas vacías (''), para omitir este tipo de valor en los resultados se puede ocupar la
-- función length
SELECT
    address2
FROM
    address
WHERE (
        address2 IS NOT NULL
        AND length(address2) > 0
    );
