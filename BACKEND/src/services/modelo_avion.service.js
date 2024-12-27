import { pool } from '../db.js';

export const modeloAvion_SR = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_modelos_avion($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Modelos de avión obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los modelos de avión',
      data: [],
      details: error.message
    };
  }
};

export const modeloAvion_SC = async (nombre, descripcion, longitud, envergadura, altura, peso_vacio) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_modelo_avion($1, $2, $3, $4, $5, $6)",
      [nombre, descripcion, longitud, envergadura, altura, peso_vacio]
    );
    return {
      status: 'success',
      message: "Modelo de avión creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear modelo de avión',
      data: [],
      details: error.message
    };
  }
};

export const modeloAvion_SU = async (codigo, nombre, descripcion, longitud, envergadura, altura, peso_vacio) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_modelo_avion($1, $2, $3, $4, $5, $6, $7)",
      [codigo, nombre, descripcion, longitud, envergadura, altura, peso_vacio]
    );
    return {
      status: 'success',
      message: "Modelo de avión actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar modelo de avión',
      data: [],
      details: error.message
    };
  }
};

export const modeloAvion_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM MODELO_AVION WHERE Moa_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "El modelo de avión con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_modelo_avion($1)", [id]);
    return {
      status: 'success',
      message: "Modelo de avión eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar modelo de avión',
      data: [],
      details: error.message
    };
  }
};
