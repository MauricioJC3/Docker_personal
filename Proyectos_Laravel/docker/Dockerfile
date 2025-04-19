FROM php:8.3-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar Apache
RUN a2enmod rewrite

# Permisos
RUN chown -R www-data:www-data /var/www/html \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

CMD ["apache2-foreground"]