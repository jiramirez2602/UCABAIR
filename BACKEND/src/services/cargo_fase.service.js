import { pool } from '../db.js';

export const leerCargoFase = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_cargo_fase($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Cargo con fase obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los cargos con fases',
      data: [],
      details: error.message
    };
  }
};

export const crearCargoFase = async (fk_cargo, fk_fase_configuracion) => {
    try {
      const { rows } = await pool.query(
        "CALL crear_cargo_fase($1, $2)",
        [fk_cargo, fk_fase_configuracion]
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
  
  export const actualizarCargoFase = async (codigo, fk_cargo, fk_fase_configuracion) => {
    try {
      const { rows } = await pool.query(
        "CALL actualizar_cargo_fase($1, $2, $3)",
        [codigo, fk_cargo, fk_fase_configuracion]
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
  
  export const eliminarCargoFase = async (id) => {
    try {
      const checkResult = await pool.query(
        "SELECT 1 FROM ucabair.CARGO_CONFIGURACION WHERE cac_codigo = $1",
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
      const result = await pool.query("CALL eliminar_cargo_fase($1)", [id]);
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
  