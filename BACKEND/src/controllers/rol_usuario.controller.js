import {
    usuarioRol_SR,
    usuarioRol_SC,
    usuarioRol_SU,
    usuarioRol_SD
  } from '../services/rol_usuario.service.js';
  
  export const getUsuarioRoles = async (req, res) => {
    const limit = parseInt(req.query.limit, 10) || 10;
    const page = parseInt(req.query.page, 10) || 1;
    const search = req.query.search || '';
  
    try {
      const response = await usuarioRol_SR(limit, page, search);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al obtener los roles de usuario',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const createUsuarioRol = async (req, res) => {
    const { fk_usuario, fk_rol } = req.body;
  
    // Validación de entrada
    if (!fk_usuario || !fk_rol) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: fk_usuario, fk_rol'
      });
    }
  
    try {
      const response = await usuarioRol_SC(fk_usuario, fk_rol);
      res.status(response.status === 'success' ? 201 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al crear rol de usuario',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const updateUsuarioRol = async (req, res) => {
    const { usr_codigo, fk_usuario, fk_rol } = req.body;
  
    // Validación de entrada
    if (!usr_codigo || !fk_usuario || !fk_rol) {
      return res.status(400).json({
        status: 'error',
        message: 'Faltan datos obligatorios',
        data: [],
        details: 'Todos los campos son obligatorios: codigo, fk_usuario, fk_rol'
      });
    }
  
    try {
      const response = await usuarioRol_SU(usr_codigo, fk_usuario, fk_rol);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al actualizar rol de usuario',
        data: [],
        details: err.message,
      });
    }
  };
  
  export const deleteUsuarioRol = async (req, res) => {
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
      const response = await usuarioRol_SD(id);
      res.status(response.status === 'success' ? 200 : 404).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al eliminar rol de usuario',
        data: [],
        details: err.message,
      });
    }
  };
  