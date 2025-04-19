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