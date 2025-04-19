# Usamos la imagen oficial de PHP + Apache
FROM php:8.3-apache

# Instalamos extensiones comunes (MySQL, GD, etc.)
RUN docker-php-ext-install pdo pdo_mysql

# Instalamos Composer
RUN apt-get update && apt-get install -y unzip curl \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Habilitamos mod_rewrite para .htaccess
RUN a2enmod rewrite

# Copiamos la configuración de Virtual Hosts
COPY ./docker/vhosts.conf /etc/apache2/sites-available/000-default.conf

# Cambiamos el dueño de /var/www/html para evitar problemas de permisos
RUN chown -R www-data:www-data /var/www/html
