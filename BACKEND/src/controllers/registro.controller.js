import { registrarClienteNatural_SC, registrarClienteJuridico_SC} from '../services/registro.service.js';

export const registrarClienteNatural = async (req, res) => {
  const {
    per_nombre, per_direccion, per_identificacion, pen_segundo_nombre,
    pen_primer_apellido, pen_segundo_apellido, pen_fecha_nac, fk_lugar,
    usu_nombre, usu_contrasena, cli_monto_acreditado
  } = req.body;

  // Validación de entrada
  if (!per_nombre || !per_direccion || !per_identificacion || !pen_primer_apellido || !pen_fecha_nac || !fk_lugar || !usu_nombre || !usu_contrasena || !cli_monto_acreditado) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: per_nombre, per_direccion, per_identificacion, pen_primer_apellido, pen_fecha_nac, fk_lugar, usu_nombre, usu_contrasena, cli_monto_acreditado'
    });
  }

  try {
    const response = await registrarClienteNatural_SC(
      per_nombre, per_direccion, per_identificacion, pen_segundo_nombre,
      pen_primer_apellido, pen_segundo_apellido, pen_fecha_nac, fk_lugar,
      usu_nombre, usu_contrasena, cli_monto_acreditado
    );
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al registrar cliente natural',
      data: [],
      details: err.message,
    });
  }
};


export const registrarClienteJuridico = async (req, res) => {
  const {
    per_nombre, per_direccion, per_identificacion, pej_pagina_web, fk_lugar,
    usu_nombre, usu_contrasena, cli_monto_acreditado
  } = req.body;

  // Validación de entrada
  if (!per_nombre || !per_direccion || !per_identificacion || !pej_pagina_web || !fk_lugar || !usu_nombre || !usu_contrasena || !cli_monto_acreditado) {
    return res.status(400).json({
      status: 'error',
      message: 'Faltan datos obligatorios',
      data: [],
      details: 'Todos los campos son obligatorios: per_nombre, per_direccion, per_identificacion, pej_pagina_web, fk_lugar, usu_nombre, usu_contrasena, cli_monto_acreditado'
    });
  }

  try {
    const response = await registrarClienteJuridico_SC(
      per_nombre, per_direccion, per_identificacion, pej_pagina_web, fk_lugar,
      usu_nombre, usu_contrasena, cli_monto_acreditado
    );
    res.status(response.status === 'success' ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al registrar cliente jurídico',
      data: [],
      details: err.message,
    });
  }
};
