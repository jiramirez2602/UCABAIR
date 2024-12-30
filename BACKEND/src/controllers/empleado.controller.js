import { obtenerEmpleados_SR } from '../services/empleado.service.js';

export const getEmpleados = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const response = await obtenerEmpleados_SR(limit, page, search);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los empleados',
      data: [],
      details: err.message,
    });
  }
};
import { crearEmpleado_SC } from '../services/empleado.service.js';

export const createEmpleado = async (req, res) => {
  const { exp_profesional, titulacion, fk_persona_natural } = req.body;

  // Validación de entrada
  if (!exp_profesional || !titulacion || !fk_persona_natural) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: exp_profesional, titulacion, fk_persona_natural'
    });
  }

  try {
    const response = await crearEmpleado_SC(exp_profesional, titulacion, fk_persona_natural);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear el empleado',
      data: [],
      details: err.message,
    });
  }
};
import { actualizarEmpleado_SU } from '../services/empleado.service.js';

export const updateEmpleado = async (req, res) => {
  const { codigo, exp_profesional, titulacion, fk_persona_natural } = req.body;

  // Validación de entrada
  if (!codigo || !exp_profesional || !titulacion || !fk_persona_natural) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, exp_profesional, titulacion, fk_persona_natural'
    });
  }

  try {
    const response = await actualizarEmpleado_SU(codigo, exp_profesional, titulacion, fk_persona_natural);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar el empleado',
      data: [],
      details: err.message,
    });
  }
};
import { eliminarEmpleado_SD } from '../services/empleado.service.js';

export const deleteEmpleado = async (req, res) => {
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
    const response = await eliminarEmpleado_SD(id);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar el empleado',
      data: [],
      details: err.message,
    });
  }
};
