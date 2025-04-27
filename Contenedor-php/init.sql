-- Otorga todos los permisos al usuario 'laravel' desde cualquier host
GRANT ALL PRIVILEGES ON *.* TO 'laravel'@'%' WITH GRANT OPTION;

-- Permisos específicos para la base de datos 'laravel' (opcional pero recomendado)
GRANT ALL PRIVILEGES ON `laravel`.* TO 'laravel'@'%';

-- Actualiza permisos
FLUSH PRIVILEGES;