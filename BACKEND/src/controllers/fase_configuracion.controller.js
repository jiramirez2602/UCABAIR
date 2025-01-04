import {
  leerFaseConfiguracion,
  crearFaseConfiguracion,
  eliminarFaseConfiguracion,
  actualizarFaseConfiguracion
} from '../services/fase_configuracion.service.js';

export const getFaseConfiguracion = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const response = await leerFaseConfiguracion(limit, page, search);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener las fases de configuración',
      data: [],
      details: err.message,
    });
  }
};

export const createFaseEjecucion = async (req, res) => {
  const { nombre, descripcion, duracion, modelo, zona} = req.body;

  // Validación de entrada
  if (!nombre || !descripcion || !duracion || !modelo || !zona) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: nombre, descripcion, duracion, Fk_modelo_avion, Fk_zona'
    });
  }

  try {
    const response = await crearFaseConfiguracion(nombre, descripcion, duracion, modelo, zona);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear la fase de ejecución',
      data: [],
      details: err.message,
    });
  }
};

export const deleteFaseEjecucion = async (req, res) => {
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
    const response = await eliminarFaseConfiguracion(id);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar la Fase de Ejecución',
      data: [],
      details: err.message,
    });
  }
};

export const updateFaseConfiguracion = async (req, res) => {
  const { codigo, nombre, descripcion, duracion, modelo, zona } = req.body;

  // Validación de entrada
  if (!codigo || !nombre || !descripcion || !duracion || !modelo || !zona) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, nombre, descripcion, duracion, modelo, zona'
    });
  }

  try {
    const response = await actualizarFaseConfiguracion(codigo, nombre, descripcion, duracion, modelo, zona);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar la Fase de configuración',
      data: [],
      details: err.message,
    });
  }
};