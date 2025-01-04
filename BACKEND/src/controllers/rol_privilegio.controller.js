import {
    rolPrivilegio_SR,
    rolPrivilegio_SC,
    rolPrivilegio_SU,
    rolPrivilegio_SD
  } from '../services/rol_privilegio.service.js';
  
  export const getRolPrivilegios = async (req, res) => {
    const limit = parseInt(req.query.limit, 10) || 10;
    const page = parseInt(req.query.page, 10) || 1;
    const search = req.query.search || '';
  
    try {
      const response = await rolPrivilegio_SR(limit, page, search);
      res.status(response.status === 'success' ? 200 : 500).json(response);
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
        