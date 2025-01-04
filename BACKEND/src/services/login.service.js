import { pool } from '../db.js';

export const obtenerPrivilegiosUsuario = async (usuNombre, usuContrasena) => {
  try {
    const result = await pool.query(
      "SELECT * FROM obtener_privilegios_usuario($1, $2)",
      [usuNombre, usuContrasena]
    );
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
