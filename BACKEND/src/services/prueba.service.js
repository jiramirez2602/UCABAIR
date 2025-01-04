import { pool } from "../db.js";

export const prueba_SR = async (search) => {
  try {
    const result = await pool.query("SELECT * FROM leer_pruebas($1)", [
      search,
    ]);
    return {
      status: "success",
      message: "Prueba obtenid@s con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener l@s pruebas",
      data: [],
      details: error.message,
    };
  }
};


export const prueba_SC = async (
  nombre,
  descripcion,
  duracion_estimada,
  fk_tipo_pieza
) => {
  try {
    const { rows } = await pool.query("CALL crear_prueba($1, $2, $3, $4)", [
      nombre,
      descripcion,
      duracion_estimada,
      fk_tipo_pieza,
    ]);
    return {
      status: "success",
      message: "Prueba creada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al crear prueba",
      data: [],
      details: error.message,
    };
  }
};

export const prueba_SU = async (
  codigo,
  nombre,
  descripcion,
  duracion_estimada,
  fk_tipo_pieza
) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_prueba($1, $2, $3, $4, $5)",
      [codigo, nombre, descripcion, duracion_estimada, fk_tipo_pieza]
    );
    return {
      status: "success",
      message: "Prueba actualizada exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al actualizar la prueba",
      data: [],
      details: error.message,
    };
  }
};

export const prueba_SD = async (codigo) => {
  try {
    const checkResult = await pool.query(
      "SELECT 1 FROM ucabair.prueba WHERE pru_codigo = $1",
      [codigo]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: "error",
        message: "La prueba con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_prueba($1)", [codigo]);
    return {
      status: "success",
      message: "Prueba eliminada exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al eliminar la prueba",
      data: [],
      details: error.message,
    };
  }
};
