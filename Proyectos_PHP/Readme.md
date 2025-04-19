```php
// para consultas los proyectos Forma #1
    http://proyecto1.test
    http://proyecto2.test
    http://proyecto3.test


```

### Correr crear y alzar los contenedores
```docker

docker-compose build --no-cache
docker-compose up -d

```

### Descargar librerías composer
```docker

// este es un ejemplo para el proyecto 1
docker-compose exec php-apache bash -c "cd /var/www/html/proyecto1 && composer require dompdf/dompdf"

```