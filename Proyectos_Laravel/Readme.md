### Dar permisos de escritura en el volumen de Docker

```bash

# Proyecto 1
docker-compose exec laravel-server1 chown -R www-data:www-data /var/www/html/proyecto1/storage
docker-compose exec laravel-server1 chmod -R 775 /var/www/html/proyecto1/storage

# Proyecto 2
docker-compose exec laravel-server2 chown -R www-data:www-data /var/www/html/proyecto2/storage
docker-compose exec laravel-server2 chmod -R 775 /var/www/html/proyecto2/storage


```


### Migracion

```bash

# Proyecto 1
docker-compose exec laravel-server1 bash -c "cd /var/www/html/proyecto1 && php artisan migrate"

# Proyecto 2
docker-compose exec laravel-server2 bash -c "cd /var/www/html/proyecto2 && php artisan migrate"


```         


### Consejos profesionales:

- Para desarrollo: Usa este comando que instala dependencias y ejecuta migraciones:

```bash
 
 docker-compose exec laravel-server1 bash -c "cd /var/www/html/proyecto1 && composer install && php artisan migrate"

```



## Crear un nuevo proyecto

- Crea la carpeta con el código:
```bash

mkdir proyecto3

```

- Crea su configuración Apache en docker/apache-proyecto3.conf:

```bash

<VirtualHost *:80>
    DocumentRoot "/var/www/html/proyecto3/public"
    <Directory "/var/www/html/proyecto3/public">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

```

- Crea su archivo YAML en proyectos/proyecto3.yml (copia proyecto1.yml y cambia puerto/rutas).

- Agrega la referencia en docker-compose.proyectos.yml:

```bash

laravel-server3:
  extends:
    file: ./proyectos/proyecto3.yml
    service: proyecto

```

### Levantar todos los servicios (base + proyectos):
```bash
docker-compose -f docker-compose.yml -f docker-compose.proyectos.yml up -d

```

### Detener y eliminar:
```bash	
docker-compose -f docker-compose.yml -f docker-compose.proyectos.yml down

```

## ACEDER al proyecto de docker para configuarecines y migraciones

```bash	
docker exec -it proyectos_laravel-laravel-server1-1 bash

# despues entrer a la carpeta del proyecto
cd proyecto1 # en este caso es esta

```

# .env del proyecto1
```bash

DB_CONNECTION=mysql
DB_HOST=db         # Nombre del servicio MySQL en docker-compose
DB_PORT=3306       # Puerto interno del contenedor (no el mapeado 3307)
DB_DATABASE=proyecto1_db  # ¡Debes crear esta BD primero en MySQL!
DB_USERNAME=root
DB_PASSWORD=root

```