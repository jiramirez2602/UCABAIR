import {
  modeloAvion_SR,
  modeloAvion_SC,
  modeloAvion_SU,
  modeloAvion_SD
} from '../services/modelo_avion.service.js';

export const getModeloAviones = async (req, res) => {
  const search = req.query.search || '';
  const limit = parseInt(req.query.limit, 10) || 10; // Valor predeterminado 10
  const page = parseInt(req.query.page, 10) || 1; // Valor predeterminado 1

  try {
    const allModelos = await modeloAvion_SR(search);
    
    // Paginar los resultados
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedModelos = allModelos.data.slice(startIndex, endIndex);

    const totalElements = allModelos.data.length; // Cantidad de elementos de la consulta
    const totalPages = Math.ceil(totalElements / limit); // Número de páginas

    res.status(allModelos.status === 'success' ? 200 : 500).json({
      ...allModelos,
      data: paginatedModelos,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los modelos de avión',
      data: [],
      details: err.message,
    });
  }
};

export const createModeloAvion = async (req, res) => {
  const { nombre, descripcion, longitud, envergadura, altura, peso_vacio } = req.body;

  // Validación de entrada
  if (!nombre || !descripcion || !longitud || !envergadura || !altura || !peso_vacio) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: nombre, descripcion, longitud, envergadura, altura, peso_vacio'
    });
  }

  try {
    const response = await modeloAvion_SC(nombre, descripcion, longitud, envergadura, altura, peso_vacio);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear modelo de avión',
      data: [],
      details: err.message,
    });
  }
};

export const updateModeloAvion = async (req, res) => {
  const { codigo, nombre, descripcion, longitud, envergadura, altura, peso_vacio } = req.body;

  // Validación de entrada
  if (!codigo || !nombre || !descripcion || !longitud || !envergadura || !altura || !peso_vacio) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, nombre, descripcion, longitud, envergadura, altura, peso_vacio'
    });
  }

  try {
    const response = await modeloAvion_SU(codigo, nombre, descripcion, longitud, envergadura, altura, peso_vacio);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar modelo de avión',
      data: [],
      details: err.message,
    });
  }
};

export const deleteModeloAvion = async (req, res) => {
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
    const response = await modeloAvion_SD(id);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar modelo de avión',
      data: [],
      details: err.message,
    });
  }
};
