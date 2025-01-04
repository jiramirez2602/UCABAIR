import {
    leerCargoFase,
    crearCargoFase,
    actualizarCargoFase,
    eliminarCargoFase
  } from '../services/cargo_fase.service.js';
  
  export const getCargoFase = async (req, res) => {
    const limit = parseInt(req.query.limit, 10) || 10;
    const page = parseInt(req.query.page, 10) || 1;
    const search = req.query.search || '';
  
    try {
      const response = await leerCargoFase(limit, page, search);
      res.status(response.status === 'success' ? 200 : 500).json(response);
    } catch (err) {
      res.status(500).json({
        status: 'error',
        message: 'Error al obtener los cargos con la fase',
        data: [],
        details: err.message,
      });
    }
  };

  export const createCargoFase = async (req, res) => {
      const { fk_cargo, fk_fase_configuracion } = req.body;
    
      // Validación de entrada
      if (!fk_cargo || !fk_fase_configuracion) {
        return res.status(400).json({
          status: 'error',
          message: 'Faltan datos obligatorios',
          data: [],
          details: 'Todos los campos son obligatorios'
        });
      }
    
      try {
        const response = await crearCargoFase(fk_cargo, fk_fase_configuracion);
        res.status(response.status === 'success' ? 201 : 500).json(response);
      } catch (err) {
        res.status(500).json({
          status: 'error',
          message: 'Error al crear',
          data: [],
          details: err.message,
        });
      }
    };
    
    export const updateCargoFase = async (req, res) => {
      const { cac_codigo, fk_cargo, fk_fase_configuracion } = req.body;

      if (!cac_codigo || !fk_cargo || !fk_fase_configuracion) {
        return res.status(400).json({
          status: 'error',
          message: 'Faltan datos obligatorios',
          data: [],
          details: 'Todos los campos son obligatorios'
        });
      }
    
      try {
        const response = await actualizarCargoFase(cac_codigo, fk_cargo, fk_fase_configuracion);
        res.status(response.status === 'success' ? 200 : 500).json(response);
      } catch (err) {
        res.status(500).json({
          status: 'error',
          message: 'Error al actualizar',
          data: [],
          details: err.message,
        });
      }
    };
    
    export const deleteCargoFase = async (req, res) => {
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
        const response = await eliminarCargoFase(id);
        res.status(response.status === 'success' ? 200 : 404).json(response);
      } catch (err) {
        res.status(500).json({
          status: 'error',
          message: 'Error al eliminar',
          data: [],
          details: err.message,
        });
      }
    };