import { pool } from "../db.js";

export const leer_metodos_pago = async (limit, page, search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_metodos_pago($1, $2, $3)", [
      limit,
      page,
      search,
    ]);
    return {
      status: "success",
      message: "Los metodos de pago obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener los metodos de pago ",
      data: [],
      details: error.message,
    };
  }
};