import { pool } from '../db.js';

export const rol_SR = async (search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_roles($1)",
      [search]
    );
    return {
      status: 'success',
      message: "Roles obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los roles',
      data: [],
      details: error.message,
    };
  }
};


export const rol_SC = async (nombre, descripcion) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_rol($1, $2)",
      [nombre, descripcion]
    );
    return {
      status: 'success',
      message: "Rol creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear rol',
      data: [],
      details: error.message
    };
  }
};

export const rol_SU = async (codigo, nombre, descripcion) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_rol($1, $2, $3)",
      [codigo, nombre, descripcion]
    );
    return {
      status: 'success',
      message: "Rol actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar rol',
      data: [],
      details: error.message
    };
  }
};

export const rol_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM ROL WHERE Rol_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "El rol con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_rol($1)", [id]);
    return {
      status: 'success',
      message: "Rol eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar rol',
      data: [],
      details: error.message
    };
  }
};
