import pg from "pg";
import {
  DB_DATABASE,
  DB_HOST,
  DB_PASSWORD,
  DB_PORT,
  DB_USER,
  DB_SCHEMA
} from "./config.js";

export const pool = new pg.Pool({
  user: DB_USER,
  host: DB_HOST,
  password: DB_PASSWORD,
  database: DB_DATABASE,
  port: DB_PORT,
});

// Función para establecer el esquema por defecto
async function setDefaultSchema(client, schema) {
  await client.query(`SET search_path TO ${schema}`);
}

// Middleware para asegurar que el esquema está configurado por defecto
pool.on("connect", async (client) => {
  await setDefaultSchema(client, DB_SCHEMA); // Reemplaza con tu esquema
});
