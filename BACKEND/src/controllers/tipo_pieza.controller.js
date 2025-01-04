import {
  tipo_pieza_SR
} from '../services/tipo_pieza.service.js';

export const getTipoPieza = async (req, res) => {
  const limit = parseInt(req.query.limit, 10) || 999999;
  const page = parseInt(req.query.page, 10) || 1;
  const search = req.query.search || '';

  try {
    const response = await tipo_pieza_SR(limit, page, search);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener l@s tipo_piezas del avión',
      data: [],
      details: err.message,
    });
  }
};