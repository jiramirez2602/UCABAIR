import {
  leerSolicitudes,
  registarPago_SC
} from '../services/pago_proveedores.service.js';

export const getSolicitudes = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 10;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const response = await leerSolicitudes(limit, page, search);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener las solicitudes',
      data: [],
      details: err.message,
    });
  }
};

export const createPago = async (req, res) => {
  const { monto, fk_tasa, fk_metodo, com_codigo } = req.body;

  // Validación de entrada
  if (!monto || !fk_tasa || !fk_metodo || !com_codigo) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: monto, fk_tasa, fk_metodo, com_codigo'
    });
  }

  try {
    const response = await registarPago_SC(monto, fk_tasa, fk_metodo, com_codigo);
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al registrar el pago',
      data: [],
      details: err.message,
    });
  }
};