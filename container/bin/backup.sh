#!/bin/bash

# Terminar el script inmediatamente si ocurre un error
set -e

# 1. Definir la carpeta de respaldos y el usuario de PostgreSQL
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

# 4. Asegurar que el directorio para los respaldos exista
mkdir -p "$BACKUP_DIR"

# 5. Generar la fecha con el formato especificado: %Y-%m-%d_%H-%M-%S
DATE=$(date +'%Y-%m-%d_%H-%M-%S')

# 6. Construir el nombre final del archivo: nombre_db@YYYY-MM-DD_HH-MM-SS.backup
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}@${DATE}.backup"

# 7. Ejecutar pg_dump usando el formato 'custon' (-Fc)
echo "🚀 Iniciando respaldo de la base de datos '$DB_NAME'..."

pg_dump -U "$PG_USER" -F c -b -v -f "$BACKUP_FILE" "$DB_NAME"

# 8. Validar el resultado de la ejecución
if [ $? -eq 0 ]; then
    echo "✅ ¡Respaldo completado con éxito!"
    echo "📦 Archivo generado: $BACKUP_FILE"
else
    echo "❌ Error: Ocurrió un problema al generar el respaldo de '$DB_NAME'."
    exit 1
fi
