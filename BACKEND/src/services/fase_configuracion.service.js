import { pool } from '../db.js';

export const leerFaseConfiguracion = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_fase_configuracion($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Fases de configración obtenidas con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener las Fases de configuración',
      data: [],
      details: error.message
    };
  }
};

export const crearFaseConfiguracion = async (nombre, descripcion, duracion, modelo, zona) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_fase_configuracion($1, $2, $3, $4, $5)",
      [nombre, descripcion, duracion, modelo, zona]
    );
    return {
      status: 'success',
      message: "Fase de configuración creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear la Fase de configuración',
      data: [],
      details: error.message
    };
  }
};

export const eliminarFaseConfiguracion = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM FASE_CONFIGURACION WHERE Fac_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "La fase de configuración con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_fase_configuracion($1)", [id]);
    return {
      status: 'success',
      message: "Fase de ejecución eliminada exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar la fase de ejecución',
      data: [],
      details: error.message
    };
  }
};

export const actualizarFaseConfiguracion = async (codigo, nombre, descripcion, duracion, modelo, zona) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_fase_configuracion($1, $2, $3, $4, $5, $6)",
      [codigo, nombre, descripcion, duracion, modelo, zona]
    );
    return {
      status: 'success',
      message: "Fase de configuración actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar la Fase de configuración',
      data: [],
      details: error.message
    };
  }
};