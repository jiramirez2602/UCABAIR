import { pool } from '../db.js';

export const filtrarLugares_SR = async (lug_tipo = null, fk_lugar = null) => {
  try {
    const result = await pool.query(
      "SELECT * FROM filtrar_lugares($1, $2)",
      [lug_tipo, fk_lugar]
    );
    return {
      status: 'success',
      message: "Lugares obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los lugares',
      data: [],
      details: error.message
    };
  }
};

