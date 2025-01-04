import { pool } from '../db.js';

export const leerTipoMaquinariaFase = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_tipo_maquinaria_fase($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Tipo de maquinaria con fase obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los tipos de maquinaria con fases',
      data: [],
      details: error.message
    };
  }
};

export const crearTipoMaquinariaFase = async (fk_tipo_maquinaria, fk_fase_configuracion) => {
    try {
      const { rows } = await pool.query(
        "CALL crear_tipo_maquinaria_fase($1, $2)",
        [fk_tipo_maquinaria, fk_fase_configuracion]
      );
      return {
        status: 'success',
        message: "Creado exitosamente",
        data: rows[0],
        details: "",
      };
    } catch (error) {
      return {
        status: 'error',
        message: 'Error al crear',
        data: [],
        details: error.message
      };
    }
  };
  
  export const actualizarTipoMaquinariaFase = async (codigo, fk_tipo_maquinaria, fk_fase_configuracion) => {
    try {
      const { rows } = await pool.query(
        "CALL actualizar_tipo_maquinaria_fase($1, $2, $3)",
        [codigo, fk_tipo_maquinaria, fk_fase_configuracion]
      );
      return {
        status: 'success',
        message: "Actualizado exitosamente",
        data: rows[0],
        details: "",
      };
    } catch (error) {
      return {
        status: 'error',
        message: 'Error al actualizar',
        data: [],
        details: error.message
      };
    }
  };
  
  export const eliminarTipoMaquinariaFase = async (id) => {
    try {
      // Verificación de la existencia del registro
      const checkResult = await pool.query(
        "SELECT 1 FROM ucabair.TIPO_MAQUINARIA_CONFIGURACION WHERE tmc_codigo = $1",
        [id]
      );
      if (checkResult.rowCount === 0) {
        return {
          status: 'error',
          message: "El ID proporcionado no existe",
          data: [],
          details: "",
        };
      }
      const result = await pool.query("CALL eliminar_tipo_maquinaria_fase($1)", [id]);
      return {
        status: 'success',
        message: "Eliminado exitosamente",
        data: result.rowCount > 0 ? result.rows[0] : null,
        details: "",
      };
    } catch (error) {
      return {
        status: 'error',
        message: 'Error al eliminar',
        data: [],
        details: error.message
      };
    }
  };
  