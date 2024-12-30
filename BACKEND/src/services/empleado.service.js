import { pool } from '../db.js';

export const obtenerEmpleados_SR = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_empleados($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Empleados obtenidos con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener los empleados',
      data: [],
      details: error.message
    };
  }
};

export const crearEmpleado_SC = async (exp_profesional, titulacion, fk_persona_natural) => {
  try {
    const { rows } = await pool.query(
      "CALL crear_empleado($1, $2, $3)",
      [exp_profesional, titulacion, fk_persona_natural]
    );
    return {
      status: 'success',
      message: "Empleado creado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al crear el empleado',
      data: [],
      details: error.message
    };
  }
};

export const actualizarEmpleado_SU = async (codigo, exp_profesional, titulacion, fk_persona_natural) => {
  try {
    const { rows } = await pool.query(
      "CALL actualizar_empleado($1, $2, $3, $4)",
      [codigo, exp_profesional, titulacion, fk_persona_natural]
    );
    return {
      status: 'success',
      message: "Empleado actualizado exitosamente",
      data: rows[0],
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al actualizar el empleado',
      data: [],
      details: error.message
    };
  }
};


export const eliminarEmpleado_SD = async (id) => {
  try {
    // Verificación de la existencia del registro
    const checkResult = await pool.query(
      "SELECT 1 FROM EMPLEADO WHERE Emp_codigo = $1",
      [id]
    );
    if (checkResult.rowCount === 0) {
      return {
        status: 'error',
        message: "El empleado con el ID proporcionado no existe",
        data: [],
        details: "",
      };
    }
    const result = await pool.query("CALL eliminar_empleado($1)", [id]);
    return {
      status: 'success',
      message: "Empleado eliminado exitosamente",
      data: result.rowCount > 0 ? result.rows[0] : null,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al eliminar el empleado',
      data: [],
      details: error.message
    };
  }
};
