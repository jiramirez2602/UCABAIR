import { pool } from "../db.js";

export const leer_tasas_cambio = async (limit, page, search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_tasas_cambio($1)", [
      search
    ]);
    return {
      status: "success",
      message: "Las tasas de cambio fueron obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener las tasas de cambio",
      data: [],
      details: error.message,
    };
  }
};