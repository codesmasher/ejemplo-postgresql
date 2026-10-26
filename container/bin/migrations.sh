#!/bin/bash

# Terminar el script inmediatamente si ocurre un error
set -e

# 1. Definir la carpeta de respaldos y el usuario de PostgreSQL
MIGRATIONS_DIR="/db/migrations"
BACKUP_DIR="/db/backups"
PG_USER="${POSTGRES_USER:-postgres}"

# 2. Validar que se haya proporcionado el nombre de la base de datos como argumento
DB_NAME="$1"

if [ -z "$DB_NAME" ]; then
    echo "❌ Error: No se proporcionó el nombre de la base de datos."
    echo "Uso: $0 <nombre_de_la_base_de_datos>"
    exit 1
fi

# 3. Validar que la base de datos exista en PostgreSQL
DB_EXISTS=$(psql -U "$PG_USER" -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME';")

if [ "$DB_EXISTS" != "1" ]; then
    echo "❌ Error: La base de datos '$DB_NAME' no existe."
    exit 1
fi

echo "usuario = ${PG_USER} y base de datos = ${DB_NAME}"

# 4. Verificar si el directorio de respaldos existe
if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo "❌ Error: El directorio '$MIGRATIONS_DIR' no existe."
    exit 1
fi

# 5. Crear archivo de respaldo
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}@${DATE}.backup"

# 6. Ejecutar pg_dump usando el formato 'custon' (-Fc)
echo "🚀 Iniciando respaldo de la base de datos '$DB_NAME'..."
pg_dump -U "$PG_USER" -F c -b -v -f "$BACKUP_FILE" "$DB_NAME"

if [ ! $? -eq 0 ]; then
    echo "❌ Error: Ocurrió un problema al generar el respaldo de '$DB_NAME'."
    exit 1
fi

echo "🚀 Iniciando procesamiento de migrations..."
echo "----------------------------------------"

# 7. Iterar sobre cada archivo .sql en el directorio
for MIGRATION_FILE in "$MIGRATIONS_DIR"/*.sql; do
    # 8. Validar que existan archivos reales (evita que tome el patrón literal si está vacío)
    [ -e "$MIGRATION_FILE" ] || continue

    # 9. Obtener nombe y tamaño del archivo en bytes
    FILE_NAME=$(basename "$MIGRATION_FILE")
    FILE_SIZE=$(stat -c%s "$MIGRATION_FILE")

    TID=$(psql -U "$PG_USER" -d "$DB_NAME" -tAc "
    SELECT tid
    FROM based.migrations
    WHERE migration_name = '$FILE_NAME'
    AND migration_size = $FILE_SIZE
    AND migration_status = 'success'
    ORDER BY created DESC
    LIMIT 1;")

    if [[ ! -z "$TID" && "$TID" =~ ^[0-9]+$ ]]; then
        continue
    fi

    # 10. Validar tamaño del archivo
    if [ $FILE_SIZE -gt 1048576 ]; then
        echo "⚠️ Advertencia: El archivo '${FILE_NAME}' supera 1MB de tamaño."
        continue
    fi

    echo "➕ Procesando: $FILE_NAME ($FILE_SIZE bytes)"
    # # 11. Registrar en la base de datos y capturar el ID devuelto
    # # Usamos -t (tuples_only) y -A (unaligned) para que psql devuelva estrictamente 
    # # el valor del ID sin espacios ni bordes
    ROW_ID=$(psql -U "$PG_USER" -d "$DB_NAME" -t -A -c "
    INSERT INTO based.migrations (migration_name, migration_size)
    VALUES ('$FILE_NAME', '$FILE_SIZE')
    RETURNING tid;" | head -n 1 | tr -d '[:space:]')

    if [ -z "$ROW_ID" ]; then
        echo "⚠️ Error: No se pudo registrar el archivo $FILE_NAME en la base de datos."
        continue
    fi

    # 12. Ejecutar el contenido del archivo con psql
    # Nota: -v ON_ERROR_STOP=1 fuerza a psql a detenerse y retornar un código de 
    # error si ocurre un fallo SQL dentro del archivo .sql
    psql -U "$PG_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -f "$MIGRATION_FILE"
    exit_code=$?

    # 13. Actualizar el status según el resultado de la ejecución
    if [ $exit_code -eq 0 ]; then
        echo "✅ Éxito: Migration '$FILE_NAME' ejecutada correctamente."
        STATUS="success"
    else
        echo "❌ Error: Falló la ejecución del archivo $FILE_NAME."
        STATUS="error"
    fi

    # 14. Ejecutar la actualización del estado
    psql -U "$PG_USER" -d "$DB_NAME" -c "
    UPDATE based.migrations 
    SET migration_status = '$STATUS' 
    WHERE tid = $ROW_ID;" > /dev/null
done

echo "----------------------------------------"
echo "🤖 ¡Proceso de migrations finalizada!"
