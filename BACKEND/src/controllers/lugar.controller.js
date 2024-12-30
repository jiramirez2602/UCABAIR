import {
  filtrarLugares_SR
} from '../services/lugar.service.js';

export const getLugares = async (req, res) => {
  const lug_tipo = req.query.tipoLugar || null;
  const fk_lugar = req.query.idLugarPadre || null;

  try {
    const response = await filtrarLugares_SR(lug_tipo, fk_lugar);
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los lugares',
      data: [],
      details: err.message,
    });
  }
};
