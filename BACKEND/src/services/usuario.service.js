// userService.js
import { pool } from '../db.js';

export const obtenerUsuariosSinCliente = async () => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_usuarios_sin_cliente()"
    );
    return {
      status: 'success',
      message: "Usuarios obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los usuarios',
      data: [],
      details: error.message,
    };
  }
};
