import {
    rol_SR,
    rol_SC,
    rol_SU,
    rol_SD
  } from '../services/rol.service.js';
  
  export const getRoles = async (req, res) => {
    const limit = parseInt(req.query.limit, 10) || 10;
    const page = parseInt(req.query.page, 10) || 1;
    const search = req.query.search || '';
  
    try {
      const allRoles = await rol_SR(search);
      
      // Paginar los resultados
      const startIndex = (page - 1) * limit;
      const endIndex = startIndex + limit;
      const paginatedRoles = allRoles.data.slice(startIndex, endIndex);
  
      const totalElements = allRoles.data.length; // Cantidad de elementos de la consulta
      const totalPages = Math.ceil(totalElements / limit); // Número de páginas
  
      res.status(allRoles.status === 'success' ? 200 : 500).json({
        ...allRoles,
        data: paginatedRoles,
        totalElements,
        totalPages,
      });
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al obtener los roles',
        data: [],
        details: err.message,
      });
    }
  };  
  
  export const createRol = async (req, res) => {
    const { nombre, descripcion } = req.body;
  
    // Validación de entrada
    if (!nombre || !descripcion) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: nombre, descripcion'
      });
    }
  
    try {
      const response = await rol_SC(nombre, descripcion);
      res.status(response.status === 'success' ? 201 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al crear rol',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const updateRol = async (req, res) => {
    const { codigo, nombre, descripcion } = req.body;
  
    // Validación de entrada
    if (!codigo || !nombre || !descripcion) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: codigo, nombre, descripcion'
      });
    }
  
    try {
      const response = await rol_SU(codigo, nombre, descripcion);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al actualizar rol',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const deleteRol = async (req, res) => {
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
      const response = await rol_SD(id);
      res.status(response.status === 'success' ? 200 : 404).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al eliminar rol',
        data: [],
        details: err.message,
      });
    }
  };
  