import { pool } from '../db.js';

export const usuarioRol_SR = async (search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_usuario_roles($1)",
      [search]
    );
    return {
      status: 'success',
      message: "Roles de usuario obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los roles de usuario',
      data: [],
      details: error.message
    };
  }
};

export const usuarioRol_SC = async (fk_usuario, fk_rol) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_usuario_rol($1, $2)",
      [fk_usuario, fk_rol]
    );
    return {
      status: 'success',
      message: "Rol de usuario creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear rol de usuario',
      data: [],
      details: error.message
    };
  }
};

export const usuarioRol_SU = async (codigo, fk_usuario, fk_rol) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_usuario_rol($1, $2, $3)",
      [codigo, fk_usuario, fk_rol]
    );
    return {
      status: 'success',
      message: "Rol de usuario actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar rol de usuario',
      data: [],
      details: error.message
    };
  }
};

export const usuarioRol_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM ucabair.usuario_rol WHERE usr_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "El rol de usuario con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_usuario_rol($1)", [id]);
    return {
      status: 'success',
      message: "Rol de usuario eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar rol de usuario',
      data: [],
      details: error.message
    };
  }
};
