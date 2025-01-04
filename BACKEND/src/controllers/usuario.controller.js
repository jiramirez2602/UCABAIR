// userController.js
import { obtenerUsuariosSinCliente } from '../services/usuario.service.js';

export const getUsuariosSinCliente = async (req, res) => {
  try {
    const response = await obtenerUsuariosSinCliente();
    res.status(200).json(response);
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener los usuarios sin cliente',
      details: error.message,
    });
  }
};
