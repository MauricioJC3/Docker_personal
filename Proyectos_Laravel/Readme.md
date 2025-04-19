# Crear nuevo proyecto de laravel con el composer del contenedor

1. entrar al contenedor 

```bash

docker exec -it proyectos_laravel-laravel-server1-1 bash

```

2. ejecutar dentro de este contenedor lo siguinte:

```bash
# Siempre terminara en temp ya que solo se crea el proyecto y copiar el contendio para pasarlo a local
composer create-project laravel/laravel nombre-proyecto_temp

```

3. Salir del contenedor "exit"


4. copiar el proyecto del contenedor y pasarlo al local
```bash

# esto se hara en la terminal local no en la terminal del contenedor
docker cp proyectos_laravel-laravel-server1-1:/var/www/html/nombre-proyecto_temp ./proyecto3

```

5. Eliminar el proyecto temporal del contenedor

```bash

docker exec -it proyectos_laravel-laravel-server1-1 rm -rf /var/www/html/nombre-proyecto_temp

```

6. Reiniciar el contenedor

```bash

docker-compose -f docker-compose.yml -f docker-compose.proyectos.yml up -d

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

---

# Configuración para el docker del proyecto nuevo


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


---
---

### Dar permisos de escritura en el volumen de Docker

```bash

# dentro del contenedor 
# 1. Asignar el usuario/grupo correcto (www-data es el usuario de Apache/Nginx en el contenedor)
chown -R www-data:www-data /var/www/html/nombre-del-nuevo-proyecto/storage

# 2. Dar permisos de lectura, escritura y ejecución al dueño/grupo
chmod -R 775 /var/www/html/nombre-del-nuevo-proyecto/storage

# 3. por si se necesita
chown -R www-data:www-data /var/www/html/proyecto1/bootstrap/cache
chmod -R 775 /var/www/html/proyecto1/bootstrap/cache


#desde la terminal local
docker exec -it proyectos_laravel-laravel-server1-1 chown -R www-data:www-data /var/www/html/proyecto1/storage
docker exec -it proyectos_laravel-laravel-server1-1 chmod -R 775 /var/www/html/proyecto1/storage

```