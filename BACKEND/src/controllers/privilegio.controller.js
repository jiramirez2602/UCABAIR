import { privilegio_SR } from '../services/privilegio.service.js';

export const getPrivilegios = async (req, res) => {
  try {
    const response = await privilegio_SR();
    res.status(response.status === 'success' ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los privilegios',
      data: [],
      details: err.message,
    });
  }
};
