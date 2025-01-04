import {
    obtenerPrivilegiosUsuario
  } from '../services/login.service.js';
  
  export const getPrivilegios = async (req, res) => {
    const usuNombre = req.query.username || null;
    const usuContrasena = req.query.password || null;
  
    try {
      const response = await obtenerPrivilegiosUsuario(usuNombre, usuContrasena);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al obtener los privilegios del usuario',
        data: [],
        details: err.message,
      });
    }
  };
  