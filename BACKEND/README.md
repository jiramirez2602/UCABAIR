# BACKEND ABAIR
Una API REST utilizando Node.js y PostgreSQL con la biblioteca `pg` y usando Express.js para el enrutamiento.

## Requisitos
- Node.js
- PostgreSQL

## Iniciar servidor
1. npm install
2. Crea un archivo `.env` en el directorio raíz y agrega lo siguiente:
    DB_USER=tu_usuario
    DB_PASSWORD=tu_contraseña
    DB_HOST=tu_host
    DB_PORT=tu_puerto
    DB_DATABASE=tu_base_de_datos
    DB_SCHEMA=nombre_de_esquema
    PORT=numero_de_puerto
3. Ejecuta el servidor: npm run dev