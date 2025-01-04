import { pool } from '../db.js';

export const privilegio_SR = async () => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_privilegios()" );
    return {
      status: 'success',
      message: "Privilegios obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los privilegios',
      data: [],
      details: error.message
    };
  }
};
