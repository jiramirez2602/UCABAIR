import {
  personaJuridica_SR,
  personaJuridica_SC,
  personaJuridica_SU,
  personaJuridica_SD,
  proveedor_SR,
} from '../services/persona_juridica.service.js';

export const getProveedores = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const allProveedores = await proveedor_SR(search);
    
    // Paginar los resultados
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedProveedores = allProveedores.data.slice(startIndex, endIndex);

    const totalElements = allProveedores.data.length; // Cantidad de elementos de la consulta
    const totalPages = Math.ceil(totalElements / limit); // Número de páginas

    res.status(allProveedores.status === 'success' ? 200 : 500).json({
      ...allProveedores,
      data: paginatedProveedores,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los proveedores',
      data: [],
      details: err.message,
    });
  }
};


export const getPersonasJuridicas = async (req, res) => {
  const search = req.query.search || '';
  const limit = parseInt(req.query.limit, 10) || 10; // Default value 10
  const page = parseInt(req.query.page, 10) || 1; // Default value 1

  try {
    const allPersonas = await personaJuridica_SR(search);

    // Paginate the results
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedPersonas = allPersonas.data.slice(startIndex, endIndex);

    const totalElements = allPersonas.data.length; // Total number of elements in the query
    const totalPages = Math.ceil(totalElements / limit); // Number of pages

    res.status(allPersonas.status === 'success' ? 200 : 500).json({
      ...allPersonas,
      data: paginatedPersonas,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener las personas jurídicas',
      data: [],
      details: err.message,
    });
  }
};


export const createPersonaJuridica = async (req, res) => {
  const { nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar } = req.body;

  // Validación de entrada
  if (!nombre || !direccion || !fecha_registro || !identificacion || !pagina_web || !fk_lugar) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar'
    });
  }

  try {
    const response = await personaJuridica_SC(nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al crear persona jurídica',
      data: [],
      details: err.message,
    });
  }
};

export const updatePersonaJuridica = async (req, res) => {
  const { codigo, nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar } = req.body;

  // Validación de entrada
  if (!codigo || !nombre || !direccion || !fecha_registro || !identificacion || !pagina_web || !fk_lugar) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: codigo, nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar'
    });
  }

  try {
    const response = await personaJuridica_SU(codigo, nombre, direccion, fecha_registro, identificacion, pagina_web, fk_lugar);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al actualizar persona jurídica',
      data: [],
      details: err.message,
    });
  }
};

export const deletePersonaJuridica = async (req, res) => {
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
    const response = await personaJuridica_SD(id);
    res.status(response.status === 'success' ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al eliminar persona jurídica',
      data: [],
      details: err.message,
    });
  }
};
