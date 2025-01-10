import {
  leer_tasas_cambio
} from '../services/tasa_cambio.service.js';

export const getTasasCambio = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 999999;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const response = await leer_tasas_cambio(limit, page, search);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener las tasas de cambio',
      data: [],
      details: err.message,
    });
  }
};