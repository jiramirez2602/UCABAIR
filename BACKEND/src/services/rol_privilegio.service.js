import { pool } from '../db.js';

export const rolPrivilegio_SR = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_rol_privilegios($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Roles y privilegios obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los roles y privilegios',
      data: [],
      details: error.message
    };
  }
};

export const rolPrivilegio_SC = async (fk_rol, fk_privilegio) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_rol_privilegio($1, $2)",
      [fk_rol, fk_privilegio]
    );
    return {
      status: 'success',
      message: "Rol y privilegio creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear rol y privilegio',
      data: [],
      details: error.message
    };
  }
};

export const rolPrivilegio_SU = async (codigo, fk_rol, fk_privilegio) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_rol_privilegio($1, $2, $3)",
      [codigo, fk_rol, fk_privilegio]
    );
    return {
      status: 'success',
      message: "Rol y privilegio actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar rol y privilegio',
      data: [],
      details: error.message
    };
  }
};

export const rolPrivilegio_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM ucabair.rol_privilegio WHERE rop_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "El rol y privilegio con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_rol_privilegio($1)", [id]);
    return {
      status: 'success',
      message: "Rol y privilegio eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar rol y privilegio',
      data: [],
      details: error.message
    };
  }
};
