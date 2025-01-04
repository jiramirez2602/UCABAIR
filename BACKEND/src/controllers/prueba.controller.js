import {
  prueba_SR,
  prueba_SC,
  prueba_SU,
  prueba_SD
} from '../services/prueba.service.js';

export const getPrueba = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const allPruebas = await prueba_SR(search);
    
    // Paginar los resultados
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedPruebas = allPruebas.data.slice(startIndex, endIndex);

    const totalElements = allPruebas.data.length; // Cantidad de elementos de la consulta
    const totalPages = Math.ceil(totalElements / limit); // Número de páginas

    res.status(allPruebas.status === 'success' ? 200 : 500).json({
      ...allPruebas,
      data: paginatedPruebas,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener l@s pruebas',
      data: [],
      details: err.message,
    });
  }
};


export const createPrueba = async (req, res) => {
  const { nombre, descripcion, duracion_estimada, fk_tipo_pieza } = req.body;

  // Validación de entrada
  if (!nombre || !descripcion || !duracion_estimada || !fk_tipo_pieza) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: nombre, descripcion, duracion_estimada, fk_tipo_pieza'
    });
  }

  try {
    const response = await prueba_SC(nombre, descripcion, duracion_estimada, fk_tipo_pieza);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear la prueba',
      data: [],
      details: err.message,
    });
  }
};

export const updatePrueba = async (req, res) => {
  const { codigo, nombre, descripcion, duracion_estimada, fk_tipo_pieza } = req.body;

  // Validación de entrada
  if (!codigo || !nombre || !descripcion || !duracion_estimada || !fk_tipo_pieza) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, nombre, descripcion, duracion_estimada, fk_tipo_pieza'
    });
  }

  try {
    const response = await prueba_SU(codigo, nombre, descripcion, duracion_estimada, fk_tipo_pieza);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar la prueba',
      data: [],
      details: err.message,
    });
  }
};

export const deletePrueba = async (req, res) => {
  const codigo = parseInt(req.query.id, 10);

  if (isNaN(codigo)) {
    return res.status(400).json({
      status: 'error',
      message: 'ID inválido',
      data: [],
      details: 'El ID proporcionado no es un número válido'
    });
  }

  try {
    const response = await prueba_SD(codigo);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar la prueba',
      data: [],
      details: err.message,
    });
  }
};
