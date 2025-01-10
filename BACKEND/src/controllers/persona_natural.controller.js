import { leerPersonasNaturales_SR } from "../services/persona_natural.service.js";

export const getPersonasNaturales = async (req, res) => {
  const search = req.query.search || '';
  const limit = parseInt(req.query.limit, 10) || 10; // Valor predeterminado 10
  const page = parseInt(req.query.page, 10) || 1; // Valor predeterminado 1

  try {
    const allPersonas = await leerPersonasNaturales_SR(search);
    
    // Paginar los resultados
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedPersonas = allPersonas.data.slice(startIndex, endIndex);

    const convertDateFormat = (dateString) => {
      const date = new Date(dateString);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      return `${year}-${month}-${day}`;
    };

    const formattedPersonas = paginatedPersonas.map((persona) => {
      return {
        ...persona,
        per_fecha_registro: convertDateFormat(persona.per_fecha_registro),
        pen_fecha_nac: convertDateFormat(persona.pen_fecha_nac),
      };
    });

    const totalElements = allPersonas.data.length; // Cantidad de elementos de la consulta
    const totalPages = Math.ceil(totalElements / limit); // Número de páginas

    res.status(allPersonas.status === 'success' ? 200 : 500).json({
      ...allPersonas,
      data: formattedPersonas,
      totalElements,
      totalPages,
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Error al obtener las personas naturales',
      data: [],
      details: err.message,
    });
  }
};

import { crearPersonaNatural_SC } from "../services/persona_natural.service.js";

export const createPersonaNatural = async (req, res) => {
  const {
    nombre,
    direccion,
    fecha_registro,
    identificacion,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    fecha_nac,
    fk_lugar,
  } = req.body;

  // Validación de entrada
  if (
    !nombre ||
    !direccion ||
    !fecha_registro ||
    !identificacion ||
    !primer_apellido ||
    !fecha_nac ||
    !fk_lugar
  ) {
    return res.status(400).json({
      status: "error",
      message: "Faltan datos obligatorios",
      data: [],
      details:
        "Todos los campos son obligatorios: nombre, direccion, fecha_registro, identificacion, primer_apellido, fecha_nac, fk_lugar",
    });
  }

  try {
    const response = await crearPersonaNatural_SC(
      nombre,
      direccion,
      fecha_registro,
      identificacion,
      segundo_nombre,
      primer_apellido,
      segundo_apellido,
      fecha_nac,
      fk_lugar
    );
    res.status(response.status === "success" ? 201 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: "error",
      message: "Error al crear la persona natural",
      data: [],
      details: err.message,
    });
  }
};
import { actualizarPersonaNatural_SU } from "../services/persona_natural.service.js";

export const updatePersonaNatural = async (req, res) => {
  const {
    codigo,
    nombre,
    direccion,
    fecha_registro,
    identificacion,
    segundo_nombre,
    primer_apellido,
    segundo_apellido,
    fecha_nac,
    fk_lugar,
  } = req.body;

  // Validación de entrada
  if (
    !codigo ||
    !nombre ||
    !direccion ||
    !fecha_registro ||
    !identificacion ||
    !primer_apellido ||
    !fecha_nac ||
    !fk_lugar
  ) {
    return res.status(400).json({
      status: "error",
      message: "Faltan datos obligatorios",
      data: [],
      details:
        "Todos los campos son obligatorios: codigo, nombre, direccion, fecha_registro, identificacion, primer_apellido, fecha_nac, fk_lugar",
    });
  }

  try {
    const response = await actualizarPersonaNatural_SU(
      codigo,
      nombre,
      direccion,
      fecha_registro,
      identificacion,
      segundo_nombre,
      primer_apellido,
      segundo_apellido,
      fecha_nac,
      fk_lugar
    );
    res.status(response.status === "success" ? 200 : 500).json(response);
  } catch (err) {
    res.status(500).json({
      status: "error",
      message: "Error al actualizar la persona natural",
      data: [],
      details: err.message,
    });
  }
};
import { eliminarPersonaNatural_SD } from "../services/persona_natural.service.js";

export const deletePersonaNatural = async (req, res) => {
  const id = parseInt(req.query.id, 10);

  if (isNaN(id)) {
    return res.status(400).json({
      status: "error",
      message: "ID inválido",
      data: [],
      details: "El ID proporcionado no es un número válido",
    });
  }

  try {
    const response = await eliminarPersonaNatural_SD(id);
    res.status(response.status === "success" ? 200 : 404).json(response);
  } catch (err) {
    res.status(500).json({
      status: "error",
      message: "Error al eliminar la persona natural",
      data: [],
      details: err.message,
    });
  }
};
