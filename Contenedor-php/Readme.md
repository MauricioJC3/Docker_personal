🚀 Cómo usarlas (en PowerShell):
- Crear proyecto (igual a tu versión actual):
```powershell	
laravel-pro mi-proyecto
```
- Instalar paquete frontend (ej: axios):
```powershell	
laravel-add mi-proyecto axios
```

- Instalar paquete PHP (ej: sanctum):
```powershell	
laravel-require mi-proyecto laravel/sanctum
```
- compilar assets (Vite)
```powershell	
laravel-dev mi-proyecto
```

- Dar permisos
```bash	
docker exec -it laravel-mysql mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'laravel'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```



# Agregar al $PROFILE

```bash


# ===========================
# Comandos para utilizar contenedo
# ===========================

# Función para crear proyectos Laravel (igual a la que ya tienes)
function laravel-pro {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectName
    )
    docker exec -it laravel-dev bash -c "composer create-project laravel/laravel $ProjectName"
}


# Función para instalar paquetes frontend (axios, vue, etc.)
function laravel-add {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        [Parameter(Mandatory=$true)]
        [string]$Package
    )
    docker exec -it -w "/var/www/html/$ProjectName" laravel-dev pnpm add $Package
}


# Función para instalar paquetes PHP (ej: sanctum)
function laravel-require {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectName,
        [Parameter(Mandatory=$true)]
        [string]$Package
    )
    docker exec -it -w "/var/www/html/$ProjectName" laravel-dev composer require $Package
}


function laravel-dev {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProjectName
    )
    docker exec -it -w "/var/www/html/$ProjectName" laravel-dev pnpm run dev
}




```