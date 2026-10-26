# Ejemplo de Postgresql
El presente repositorio tiene la finalidad de presentar ejemplos de código SQL para PostgreSQL.

## Actualización del repositorio Oct-2026
_*Aviso:*_ He decidido cambiar la meta de este repositorio, inicialmente se tenia como finalidad ser una colección de scripts sobre diferentes tipos de consulta sobre la BD PostgreSQL.

La presente actualización permite, con ayuda de `Docker compose`, crear un ambiente de desarrollo para cualquier aplicación que requiera una base de datos de soporte. Consideralo como una plantilla para el desarrollo de `backends`.

## Como usar este repositorio
Se requiere haber instalado previamente _Docker_ en la computadora, una vez descargado el repositorio tedras la siguiente estructura de directorios:

```
    ejemplo-postgresql/
    |-- container/
    |   |-- bin/
    |   |   |-- backup.sh
    |   |   |-- migrations.sh
    |   |   └-- restore.sh
    |   |-- Dockerfile
    |   └-- install.sql
    |-- secrets/
    |   └-- .gitkeep
    |-- volumes/
    |   |-- backups/
    |   |   └-- .gitkeep
    |   |-- migrations/
    |   |   |-- # archivos con cambios a la BD # 
    |   |   └-- README.md
    |   |-- pgdata/
    |   |   └-- .gitkeep
    |   └-- temp/
    |       └-- .gitkeep
    |-- .gitignore
    |-- compose.yaml
    |-- LICENSE
    └-- README.md
```
### Descripción del contenido

* _*Directorio container.*_ Contiene el archivo `Dockerfile` con las instrucciones para la creación de la imagen del contenedor, el archivo `install.sql` para inicializar la Base de Datos, adicionalmente el subdirectorio `bin/` con los scripts necearios para el mantenimiento de las bases de datos.

* _*Directorio secrets.*_ Destinado para las variables de entorno del contenedor, `git` no lleva el registro del contenido de este directorio.

* _*Directorio volumes*_ Este contenedor tiene los directorios compartidas entre el host y el contenedor de docker, estás son utilizadas tanto por PostgreSQL como los scripts de mantenimieto.

## Instalación de PostgreSQL con este repositorio
Realiza los siguientes pasos:

### 1. Declarar usuario contraseña de PostgreSQL
Dentro de la directorio `secrets` crea dos archivos, el primero con el nombre `psql-user` donde se declara el nombre del usuario que utilizará el contenedor PostgreSQL, este mismo será el nombre para la base de datos del mismo. En una instalación de PostgreSQL este suele ser `postgres`.

El segundo archivo debe tener el nombre de `psql-password` donde se declara la contraseña para el usuario de PostgreSQL.

Ninguno de los archivos dentro de este directorio son rastreados por `git`. 

### 2. Iniciar la red `localnet`
Este contenedor utiliza la network `localnet` de Docker esto permite a otros contenedores interactuar entre ellos dentro del mismo host. Previo a crear la imagen o crear el contenedor es necesario crear la red.

```
docker network crate localnet
```

### 3. Crear la imagen e iniciar el contenedor
Te recomiendo que antes de inicar el contenedor PostgreSQL generes la imagen del mismo para detectar cualquier error durante la instalación de los paquetes.

```
docker compose build
```
Una vez validado que la imagen fue creada sin problemas inicia el contenedor.
```
docker compose up -d
```

### 4. Ingresar al servidor 
Ingresa al servidor de PostgreSQL con el siguiente comando:
```
docker exec -it postgresql bash
```
Utilizar `psql` para ejecutar consultas:
```
psql -U postgres
```

### 5. Conectarse a postgreSQL con una aplicación
Considera los siguientes datos para establecer la conexión a PostgreSQL desde otro contenedor usando la red `localnet`:
```
host=postgresql
port=5432
user=POSTGRES_USER
password=POSTGRES_PASSWORD
dbname=POSTGRES_DB
```
En lugar de usar `postgesql` como nombre del host puedes usar `localhost` para establecer la conexión directa desde la computadora del contenedor. 

## Herramientas para el mantenimieto de la BD
Una vez que el contenedor esté activo puedes utilizar los siguientes scripts para la gestion de las Bases de Datos:

### Generar un respaldo de la Base de Datos
Puedes obtener un respaldo de la base de datos con ayuda del _script_ `backup.sh` con el siguiente comando en la terminal. 

```
docker exec postgresql backup.sh <base_de_datos>
```

Esto genera un archivo `.backup` dentro de `volumes/backups`. De manera interna en la imagen de _Docker_ los archivos de respaldo están localizados en `/db/backups`.

### Restaurar la Base de Datos desde un backup
Esta imagen cuenta con un script para restaurar una base de datos desde un archivo `.backup`. Desde la terminal ejecuta el siguiente comando:

```
docker exec postgresql restore.sh <nombre_del_archivo>
```

El archivo de respaldo debe estar ubicado dentro del directorio `volumes/backups`. Como resultado se obtendra una nueva base de datos con el mismo `<nombre_del_archivo>`, si es necesario actualiza el nombre antes de ejecutar el comando.

Toma en cuenta que si existe una base de datos con el mismo `<nombre_del_archivo>` el _script_ eliminará dicha base de datos y la nueva tomará su lugar

### Actualizar la base de datos desde una migración
El _script_ `migrations.sh` ejecutará los archivos que se encuentren dentro del directorio `volumes/migrations`, aquellos previamente marcados como 'ejecutados con exito' serán omitidos durante la ejecución del _script_. Utilizá el siguiente comando:

```
docker exec postgresql migrations.sh <base_de_datos>
```
Consulta el archivo `README.md` dentro del directorio `volumes/migrations` para tener más información sobre su uso.

## ChangeLog
