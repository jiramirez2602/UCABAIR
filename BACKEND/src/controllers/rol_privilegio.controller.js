import {
    rolPrivilegio_SR,
    rolPrivilegio_SC,
    rolPrivilegio_SU,
    rolPrivilegio_SD
  } from '../services/rol_privilegio.service.js';
  
  export const getRolPrivilegios = async (req, res) => {
    const search = req.query.search || '';
    const limit = parseInt(req.query.limit, 10) || 10; // Valor predeterminado 10
    const page = parseInt(req.query.page, 10) || 1; // Valor predeterminado 1
  
    try {
      const allPrivilegios = await rolPrivilegio_SR(search);
      
      // Paginar los resultados
      const startIndex = (page - 1) * limit;
      const endIndex = startIndex + limit;
      const paginatedPrivilegios = allPrivilegios.data.slice(startIndex, endIndex);
  
      const totalElements = allPrivilegios.data.length; // Cantidad de elementos de la consulta
      const totalPages = Math.ceil(totalElements / limit); // Número de páginas
  
      res.status(allPrivilegios.status === 'success' ? 200 : 500).json({
        ...allPrivilegios,
        data: paginatedPrivilegios,
        totalElements,
        totalPages,
      });
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al obtener roles y privilegios',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const createRolPrivilegio = async (req, res) => {
    const { fk_rol, fk_privilegio } = req.body;
  
    // Validación de entrada
    if (!fk_rol || !fk_privilegio) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: fk_rol, fk_privilegio'
      });
    }
  
    try {
      const response = await rolPrivilegio_SC(fk_rol, fk_privilegio);
      res.status(response.status === 'success' ? 201 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al crear rol y privilegio',
        data: [],
        details: err.message,
      });
    }
  };

  export const updateRolPrivilegio = async (req, res) => {
    const { codigo, fk_rol, fk_privilegio } = req.body;
  
    // Validación de entrada
    if (!codigo || !fk_rol || !fk_privilegio) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: codigo, fk_rol, fk_privilegio'
      });
    }
  
    try {
      const response = await rolPrivilegio_SU(codigo, fk_rol, fk_privilegio);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al actualizar rol y privilegio',
        data: [],
        details: err.message,
      });
    }
  };

  export const deleteRolPrivilegio = async (req, res) => {
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
      const response = await rolPrivilegio_SD(id);
      res.status(response.status === 'success' ? 200 : 404).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al eliminar rol y privilegio',
        data: [],
        details: err.message,
      });
    }
  };
        