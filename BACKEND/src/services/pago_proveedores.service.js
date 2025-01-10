import { pool } from '../db.js';

export const leerSolicitudes = async (limit, page, search) => {
  try {
    const result = await pool.query(
      "SELECT * FROM leer_compras_generadas($1, $2, $3)",
      [limit, page, search]
    );
    return {
      status: 'success',
      message: "Solicitudes obtenidas con éxito",
      data: result.rows,
      details: "",
    };
  } catch (error) {
    return {
      status: 'error',
      message: 'Error al obtener las solicitudes',
      data: [],
      details: error.message
    };
  }
};

export const registarPago_SC = async (
  monto, 
  fk_tasa_cambio,
  fk_metodo_pago,
  fk_compra
  ) => {
    try {
      const { rows } = await pool.query(
        "CALL registrar_pago_compra($1, $2, $3, $4)",
        [
        monto, 
        fk_tasa_cambio,
        fk_metodo_pago,   
        fk_compra,
        ]
      );
      return {
        status: "success",
        message: "Pago registrado exitosamente",
        data: rows[0],
        details: "",
      };
    } catch (error) {
      return {
        status: "error",
        message: "Error al registrar el pago",
        data: [],
        details: error.message
      };
    }
  };
