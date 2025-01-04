import { obtenerEmpleadosConUsuarios_SR, eliminarEmpleadoConUsuario_SD, crearEmpleadoConUsuario_SC, actualizarEmpleadoConUsuario_SU } from '../services/empleado.service.js';

export const getEmpleadosConUsuarios = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const allEmpleadosConUsuarios = await obtenerEmpleadosConUsuarios_SR(search);
    
    // Paginar los resultados
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedEmpleadosConUsuarios = allEmpleadosConUsuarios.data.slice(startIndex, endIndex);

    const totalElements = allEmpleadosConUsuarios.data.length; // Cantidad de elementos de la consulta
    const totalPages = Math.ceil(totalElements / limit); // Número de páginas

    res.status(allEmpleadosConUsuarios.status === 'success' ? 200 : 500).json({
      ...allEmpleadosConUsuarios,
      data: paginatedEmpleadosConUsuarios,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los empleados con usuarios',
      data: [],
      details: err.message,
    });
  }
};

export const createEmpleadoConUsuario = async (req, res) => {
  const { exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena } = req.body;

  // Validación de entrada
  if (!exp_profesional || !titulacion || !fk_persona_natural || !usu_nombre || !usu_contrasena) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena'
    });
  }

  try {
    const response = await crearEmpleadoConUsuario_SC(exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear el empleado con usuario',
      data: [],
      details: err.message,
    });
  }
};

export const updateEmpleadoConUsuario = async (req, res) => {
  const { codigo, exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena } = req.body;

  // Validación de entrada
  if (!codigo || !exp_profesional || !titulacion || !fk_persona_natural || !usu_nombre || !usu_contrasena) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena'
    });
  }

  try {
    const response = await actualizarEmpleadoConUsuario_SU(codigo, exp_profesional, titulacion, fk_persona_natural, usu_nombre, usu_contrasena);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar el empleado con usuario',
      data: [],
      details: err.message,
    });
  }
};

export const deleteEmpleadoConUsuario = async (req, res) => {
  const id = parseInt(req.query.id, 10);

  if (isNaN(id)) {
    return res.status(400).json({
      status: 'error',
      message: 'ID inválido',
      data: [],
      details: 'El ID proporcionado no es un número válido'
    });
  }

  try {
    const response = await eliminarEmpleadoConUsuario_SD(id);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar el empleado con usuario',
      data: [],
      details: err.message,
    });
  }
};
