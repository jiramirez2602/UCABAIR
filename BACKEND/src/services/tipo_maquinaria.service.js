import { pool } from "../db.js";

export const leerTipoMaquinaria = async (limit, page, search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_tipos_maquinaria($1, $2, $3)", [
      limit,
      page,
      search,
    ]);
    return {
      status: "success",
      message: "Tipos de Maquinaria obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener l@s tipos de maquinaria ",
      data: [],
      details: error.message,
    };
  }
};