import { pool } from "../db.js";

export const personaJuridica_SR = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_personas_juridicas($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: "success",
      message: "Personas jurídicas obtenidas con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener las personas jurídicas",
      data: [],
      details: error.message,
    };
  }
};

export const proveedor_SR = async (search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_proveedor($1)", [
      search,
    ]);
    return {
      status: "success",
      message: "Proveedores obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener los proveedores",
      data: [],
      details: error.message,
    };
  }
};

export const personaJuridica_SC = async (
  nombre,
  direccion,
  fecha_registro,
  identificacion,
  pagina_web,
  fk_lugar
) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_persona_juridica($1, $2, $3, $4, $5, $6)",
      [nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar]
    );
    return {
      status: "success",
      message: "Persona jurídica creada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al crear persona jurídica",
      data: [],
      details: error.message,
    };
  }
};

export const personaJuridica_SU = async (
  codigo,
  nombre,
  direccion,
  fecha_registro,
  identificacion,
  pagina_web,
  fk_lugar
) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_persona_juridica($1, $2, $3, $4, $5, $6, $7)",
      [
        codigo,
        nombre,
        direccion,
        fecha_registro,
        identificacion,
        pagina_web,
        fk_lugar,
      ]
    );
    return {
      status: "success",
      message: "Persona jurídica actualizada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al actualizar persona jurídica",
      data: [],
      details: error.message,
    };
  }
};

export const personaJuridica_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM PERSONA_JURIDICA WHERE Per_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: "error",
        message: "La persona jurídica con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_persona_juridica($1)", [id]);
    return {
      status: "success",
      message: "Persona jurídica eliminada exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al eliminar persona jurídica",
      data: [],
      details: error.message,
    };
  }
};
