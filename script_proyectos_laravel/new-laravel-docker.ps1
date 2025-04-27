<#
.SYNOPSIS
    Crea un nuevo proyecto Laravel con Docker en Windows (Versión estable)
.DESCRIPTION
    Versión corregida que soluciona los problemas de Nginx y permisos
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# 1. Configuración inicial
Write-Host "`nIniciando creación de proyecto Laravel con Docker..." -ForegroundColor Cyan

# Verificar Docker
try {
    docker --version | Out-Null
} catch {
    Write-Host "ERROR: Docker no está disponible" -ForegroundColor Red
    exit 1
}

# 2. Preparar directorio del proyecto
$ProjectDir = "$PWD\$ProjectName"
if (Test-Path $ProjectDir) {
    Write-Host "El directorio $ProjectDir ya existe" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $ProjectDir | Out-Null
Set-Location $ProjectDir

# 3. Crear proyecto Laravel
Write-Host "`nCreando proyecto Laravel..." -ForegroundColor Cyan
try {
    docker run --rm `
        -v "${PWD}:/app" `
        composer create-project --prefer-dist laravel/laravel .
    
    if (-not (Test-Path "composer.json")) {
        throw "No se creó el proyecto Laravel correctamente"
    }
} catch {
    Write-Host "ERROR al crear proyecto: $_" -ForegroundColor Red
    Remove-Item $ProjectDir -Recurse -Force -ErrorAction SilentlyContinue
    exit 1
}

# 4. Configurar Nginx correctamente
Write-Host "`nConfigurando Nginx..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path ".\docker\nginx\conf.d" -Force | Out-Null

@"
server {
    listen 80;
    index index.php index.html;
    server_name localhost;
    root /var/www/html/public;

    location / {
        try_files `$uri `$uri/ /index.php?`$query_string;
    }

    location ~ \.php`$ {
        try_files `$uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)`$;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME `$document_root`$fastcgi_script_name;
        fastcgi_param PATH_INFO `$fastcgi_path_info;
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
"@ | Out-File -FilePath ".\docker\nginx\conf.d\app.conf" -Encoding UTF8

# 5. Configurar docker-compose.yml
Write-Host "`nConfigurando Docker Compose..." -ForegroundColor Cyan

@"
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${ProjectName}-app
    restart: unless-stopped
    volumes:
      - ./:/var/www/html
    networks:
      - laravel-network

  webserver:
    image: nginx:alpine
    container_name: ${ProjectName}-webserver
    restart: unless-stopped
    ports:
      - "8000:80"
    volumes:
      - ./:/var/www/html
      - ./docker/nginx/conf.d:/etc/nginx/conf.d
    depends_on:
      - app
    networks:
      - laravel-network

  db:
    image: mysql:8.0
    container_name: ${ProjectName}-db
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_ROOT_PASSWORD: secret
    ports:
      - "3306:3306"
    volumes:
      - dbdata:/var/lib/mysql
    networks:
      - laravel-network

volumes:
  dbdata:
    driver: local

networks:
  laravel-network:
    driver: bridge
"@ | Out-File -FilePath ".\docker-compose.yml" -Encoding UTF8

# 6. Configurar Dockerfile con permisos corregidos
@"
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git zip unzip \
    libzip-dev libpng-dev libonig-dev \
    && docker-php-ext-install pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html
COPY . .

# Asegurar los permisos correctos para www-data (usuario del servidor web)
RUN composer install
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
"@ | Out-File -FilePath ".\Dockerfile" -Encoding UTF8

# 7. Configurar .env
(Get-Content ".\.env") -replace 'DB_HOST=.*', 'DB_HOST=db' `
                      -replace 'DB_PASSWORD=.*', 'DB_PASSWORD=secret' | Set-Content ".\.env"

# 8. Iniciar contenedores
Write-Host "`nIniciando contenedores Docker..." -ForegroundColor Cyan
docker-compose up -d --build

# Esperar a que los servicios estén listos
Start-Sleep -Seconds 15

# 9. Configuración final con comandos adicionales para permisos
Write-Host "`nFinalizando configuración..." -ForegroundColor Cyan
docker-compose exec app composer install
docker-compose exec app php artisan key:generate

# Configurar permisos correctamente dentro del contenedor
Write-Host "`nAsegurando permisos de directorios..." -ForegroundColor Cyan
docker-compose exec -u root app chown -R www-data:www-data /var/www/html
docker-compose exec -u root app chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

Write-Host "`n¡PROYECTO CREADO EXITOSAMENTE!`n" -ForegroundColor Green
Write-Host "Accede a tu aplicación en: http://localhost:8000" -ForegroundColor Yellow
Write-Host "`nPara ver los logs de Nginx:" -ForegroundColor DarkYellow
Write-Host "  docker-compose logs webserver" -ForegroundColor DarkYellow