#!/bin/bash

# Terminar el script inmediatamente si ocurre un error
set -e

# 1. Definir la carpeta de respaldos y el usuario de PostgreSQL
BACKUP_DIR="/db/backups"
PG_USER="${POSTGRES_USER:-postgres}"

# 2. Validar que se haya pasado el nombre del archivo como parámetro
IFILE="$1"

if [ -z "$IFILE" ]; then
    echo "❌ Error: Debe proporcionar el nombre del archivo de respaldo."
    echo "Uso: ./restore.sh mi_base_de_datos.backup"
fi

# Extraer solo el nombre de la base de datos (sin la ruta ni la extensión .backup)
DB_NAME=$(basename "$IFILE" .backup)
FULL_PATH="${BACKUP_DIR}/${IFILE}"

# Validar que el archivo de respaldo exista
if [ ! -f "$FULL_PATH" ]; then
    echo "❌ Error: El archivo '$FULL_PATH' no existe."
    exit 1
fi

echo "🚀 Iniciando processo de restauración para la BD: '$DB_NAME'..."

# 3. Terminar todas las conexiones activas de la base de datos
echo "🔌 Terminando conexiones activas a '$DB_NAME'..."
psql -U "$PG_USER" -d postgresql -c "
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '$DB_NAME' AND pid <> pg_backend_pid()" > /dev/null 2>&1 || true

# 4. Eliminar la base de datos si existe
echo "🗑 Eliminando base de datos '$DB_NAME' (si existe)..."
dropdb -U "$PG_USER" --if-exists "$DB_NAME"

# 5. Crear la nueva base de datos limpia
echo "➕ Creando base de datos '$DB_NAME'..."
createdb -U "$PG_USER" "$DB_NAME"

# 6. Ejecutar la restauración con pg_restore
echo "📦 Restaurando el archivo '$IFILE' en '$DB_NAME'..."
pg_restore -U "$PG_USER" -d "$DB_NAME" --clean --if-exists --no-owner --no-privileges "$FULL_PATH"

echo "✅ ¡Restauración completada con éxito para la BD: '$DB_NAME'!"
