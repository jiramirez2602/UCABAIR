import { pool } from "../db.js";

export const leerCargos = async (limit, page, search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_cargos($1, $2, $3)", [
      limit,
      page,
      search,
    ]);
    return {
      status: "success",
      message: "Cargos obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener l@s cargos",
      data: [],
      details: error.message,
    };
  }
};