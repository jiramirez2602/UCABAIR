import { pool } from '../db.js';

export const leerPersonasNaturales_SR = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_personas_natural($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Personas naturales obtenidas con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener las personas naturales',
      data: [],
      details: error.message
    };
  }
};


export const crearPersonaNatural_SC = async (nombre, direccion, fecha_registro, identificacion, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac, fk_lugar) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_persona_natural($1, $2, $3, $4, $5, $6, $7, $8, $9)",
      [nombre, direccion, fecha_registro, identificacion, primer_apellido, fecha_nac, fk_lugar, segundo_nombre, segundo_apellido]
    );
    return {
      status: 'success',
      message: "Persona natural creada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear la persona natural',
      data: [],
      details: error.message
    };
  }
};
export const actualizarPersonaNatural_SU = async (codigo, nombre, direccion, fecha_registro, identificacion, segundo_nombre, primer_apellido, segundo_apellido, fecha_nac, fk_lugar) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_persona_natural($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
      [codigo, nombre, direccion, fecha_registro, identificacion, primer_apellido, fecha_nac, fk_lugar, segundo_nombre, segundo_apellido]
    );
    return {
      status: 'success',
      message: "Persona natural actualizada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar la persona natural',
      data: [],
      details: error.message
    };
  }
};
export const eliminarPersonaNatural_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM PERSONA_NATURAL WHERE Per_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "La persona natural con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_persona_natural($1)", [id]);
    return {
      status: 'success',
      message: "Persona natural eliminada exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar la persona natural',
      data: [],
      details: error.message
    };
  }
};
