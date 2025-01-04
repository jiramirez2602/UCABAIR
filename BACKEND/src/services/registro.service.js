import { pool } from '../db.js';

export const registrarClienteNatural_SC = async (
    per_nombre, per_direccion, per_identificacion, pen_segundo_nombre,
    pen_primer_apellido, pen_segundo_apellido, pen_fecha_nac, fk_lugar,
    usu_nombre, usu_contrasena, cli_monto_acreditado
) => {
  try {
    const { rows } = await pool.query(
      "CALL RegistrarClienteNatural($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)",
      [
        per_nombre, per_direccion, per_identificacion, pen_segundo_nombre,
        pen_primer_apellido, pen_segundo_apellido, pen_fecha_nac, fk_lugar,
        usu_nombre, usu_contrasena, cli_monto_acreditado
      ]
    );
    return {
      status: 'success',
      message: "Cliente natural registrado exitosamente",
      data: rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al registrar cliente natural',
      data: [],
      details: error.message
    };
  }
};

export const registrarClienteJuridico_SC = async (
  per_nombre, per_direccion, per_identificacion, pej_pagina_web, fk_lugar,
  usu_nombre, usu_contrasena, cli_monto_acreditado
) => {
  try {
    const { rows } = await pool.query(
      "CALL RegistrarClienteJuridico($1, $2, $3, $4, $5, $6, $7, $8)",
      [
        per_nombre, per_direccion, per_identificacion, pej_pagina_web, fk_lugar,
        usu_nombre, usu_contrasena, cli_monto_acreditado
      ]
    );
    return {
      status: 'success',
      message: "Cliente jurídico registrado exitosamente",
      data: rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al registrar cliente jurídico',
      data: [],
      details: error.message
    };
  }
};
