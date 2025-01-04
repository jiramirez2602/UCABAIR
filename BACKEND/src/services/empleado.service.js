import { pool } from "../db.js";

export const obtenerEmpleadosConUsuarios_SR = async (search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_empleados_con_usuarios($1)",
      [search]
    );
    return {
      status: "success",
      message: "Empleados con usuarios obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al obtener los empleados con usuarios",
      data: [],
      details: error.message,
    };
  }
};

export const crearEmpleadoConUsuario_SC = async (
  exp_profesional,
  titulacion,
  fk_persona_natural,
  usu_nombre,
  usu_contrasena
) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_empleado_con_usuario($1, $2, $3, $4, $5)",
      [
        exp_profesional,
        titulacion,
        fk_persona_natural,
        usu_nombre,
        usu_contrasena,
      ]
    );
    return {
      status: "success",
      message: "Empleado con usuario creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al crear el empleado con usuario",
      data: [],
      details: error.message,
    };
  }
};

export const actualizarEmpleadoConUsuario_SU = async (
  codigo,
  exp_profesional,
  titulacion,
  fk_persona_natural,
  usu_nombre,
  usu_contrasena
) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_empleado_con_usuario($1, $2, $3, $4, $5, $6)",
      [
        codigo,
        exp_profesional,
        titulacion,
        fk_persona_natural,
        usu_nombre,
        usu_contrasena,
      ]
    );
    return {
      status: "success",
      message: "Empleado con usuario actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al actualizar el empleado con usuario",
      data: [],
      details: error.message,
    };
  }
};

export const eliminarEmpleadoConUsuario_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM EMPLEADO WHERE Emp_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: "error",
        message: "El empleado con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_empleado_con_usuario($1)", [
      id,
    ]);
    return {
      status: "success",
      message: "Empleado con usuario eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: "error",
      message: "Error al eliminar el empleado con usuario",
      data: [],
      details: error.message,
    };
  }
};
