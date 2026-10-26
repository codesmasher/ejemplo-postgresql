# Directorio migrations
Este directorio tiene la funcionalidad de registrar los cambios en la estructura de datos de la base de datos.

## Lógica de uso
Realiza los siguientes pasos cuando sea necesario aplicar un cambio en la base de datos:

1. Escribe las instrucciones que se ejecutaran en la base de datos, guarda el archivo dentro de `volumes/migrations`.
2. Ejecuta el _script_ `migrations.sh` como se indica en el archivo `README.md` de este repositorio
3. Las migraciones quedan registradas en la tabla _migrations_ puedes consultar el _status_ de cada una o revisar el log de ejecución. 

Antes de efectuar las actulizacione por migración el _script_ `migrations.sh` genera un respaldo con el estado actual de la base de datos, revisa el directorio `volumes/backups` para asegurar la imagen previa a la actualización.

Si durante la ejecución del _script_ `migrations.sh` un archivo devuelve error quedará marcado en el campo _status_ en la tabla _migrations_, actualiza el archivo y vuelve a ejecutar el script, no es necesario cambiar su nombre. 

## Recomendaciones:
* Identifica en el nombre del archivo la actividad que realiza la migración.
* Guarda con extensión `.sql` el archivo.
* Es recomendado que mantengas un orden de ejecución de las migraciones.
* Evita renombrar los archivos que ya fueron ejecutados. 
