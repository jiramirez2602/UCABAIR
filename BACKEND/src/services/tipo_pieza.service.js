import { pool } from "../db.js";

export const tipo_pieza_SR = async (limit, page, search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_tipos_pieza($1, $2, $3)", [
      limit,
      page,
      search,
    ]);
    return {
      status: "success",
      message: "Tipos de pieza obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener l@s tipos de pieza ",
      data: [],
      details: error.message,
    };
  }
};