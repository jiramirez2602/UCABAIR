--DROP DE TRIGGERS
DROP TRIGGER trigger_registrar_entrada_inventario ON PROCESO_PRUEBA;
DROP TRIGGER trigger_verificar_inventario ON INVENTARIO;

--DROP DE PROCEDIMIENTOS Y FUNCIONES
DROP FUNCTION leer_metodos_pago;
DROP FUNCTION leer_tasas_cambio;
DROP PROCEDURE registrar_pago_compra;
DROP PROCEDURE crear_modelo_avion;
DROP FUNCTION leer_modelos_avion;
DROP PROCEDURE actualizar_modelo_avion;
DROP PROCEDURE eliminar_modelo_avion;
DROP PROCEDURE crear_prueba;
DROP FUNCTION leer_pruebas;
DROP PROCEDURE actualizar_prueba;
DROP PROCEDURE eliminar_prueba;
DROP FUNCTION leer_tipos_pieza;
DROP FUNCTION filtrar_lugares;
DROP PROCEDURE crear_persona_natural;
DROP FUNCTION leer_personas_natural;
DROP PROCEDURE actualizar_persona_natural;
DROP PROCEDURE eliminar_persona_natural;
DROP PROCEDURE crear_empleado_con_usuario;
DROP FUNCTION leer_empleados_con_usuarios;
DROP PROCEDURE actualizar_empleado_con_usuario;
DROP PROCEDURE eliminar_empleado_con_usuario;
DROP PROCEDURE crear_persona_juridica;
DROP FUNCTION leer_personas_juridicas;
DROP PROCEDURE actualizar_persona_juridica;
DROP PROCEDURE eliminar_persona_juridica;
DROP FUNCTION leer_proveedor;
DROP FUNCTION obtener_privilegios_usuario;
DROP PROCEDURE RegistrarClienteNatural;
DROP PROCEDURE RegistrarClienteJuridico;
DROP PROCEDURE crear_rol;
DROP FUNCTION leer_roles;
DROP PROCEDURE actualizar_rol;
DROP PROCEDURE eliminar_rol;
DROP FUNCTION leer_usuarios_sin_cliente;
DROP PROCEDURE crear_usuario_rol;
DROP FUNCTION leer_usuario_roles;
DROP PROCEDURE actualizar_usuario_rol;
DROP PROCEDURE eliminar_usuario_rol;
DROP FUNCTION leer_privilegios;
DROP PROCEDURE crear_rol_privilegio;
DROP FUNCTION leer_rol_privilegios;
DROP PROCEDURE actualizar_rol_privilegio;
DROP PROCEDURE eliminar_rol_privilegio;
DROP PROCEDURE crear_fase_configuracion;
DROP FUNCTION leer_fase_configuracion;
DROP PROCEDURE eliminar_fase_configuracion;
DROP PROCEDURE actualizar_fase_configuracion;
DROP FUNCTION leer_tipo_pieza_fase;
DROP PROCEDURE crear_tipo_pieza_fase;
DROP PROCEDURE actualizar_tipo_pieza_fase;
DROP PROCEDURE eliminar_tipo_pieza_fase;
DROP FUNCTION leer_tipos_maquinaria;
DROP FUNCTION leer_tipo_maquinaria_fase;
DROP PROCEDURE crear_tipo_maquinaria_fase;
DROP PROCEDURE actualizar_tipo_maquinaria_fase;
DROP PROCEDURE eliminar_tipo_maquinaria_fase;
DROP FUNCTION leer_cargos;
DROP FUNCTION leer_cargo_fase;
DROP PROCEDURE crear_cargo_fase;
DROP PROCEDURE actualizar_cargo_fase;
DROP PROCEDURE eliminar_cargo_fase;
DROP FUNCTION obtener_pagos;
DROP FUNCTION registrar_entrada_inventario;
DROP FUNCTION registrar_entrada_en_inventario;
DROP PROCEDURE generar_compra_materia_prima;
DROP FUNCTION trigger_generar_compra;
DROP FUNCTION leer_compras_generadas;

--DROP TYPE
DROP TYPE IF EXISTS ucabair.usuario_rol_completo;
DROP TYPE IF EXISTS ucabair.rol_privilegio_completo;

--DROP DE TABLAS
DROP TABLE IF EXISTS BENEFICIARIO;
DROP TABLE IF EXISTS TIPO_PIEZA_MODELO;
DROP TABLE IF EXISTS TIPO_PIEZA_FASE;
DROP TABLE IF EXISTS CARGO_PRUEBA;
DROP TABLE IF EXISTS MOVIMIENTO;
DROP TABLE IF EXISTS MATERIA_PRIMA_ESTATUS;
DROP TABLE IF EXISTS PROVEEDOR_TIPO_MATERIA;
DROP TABLE IF EXISTS MATERIA_ZONA;
DROP TABLE IF EXISTS TIPO_MAQUINARIA_CONFIGURACION;
DROP TABLE IF EXISTS CARGO_CONFIGURACION;
DROP TABLE IF EXISTS PIEZA_ESTATUS;
DROP TABLE IF EXISTS EMPLEADO_HORARIO;
DROP TABLE IF EXISTS TIPO_MATERIA_PRIMA_TIPO_PIEZA;
DROP TABLE IF EXISTS DETALLE_COMPRA;
DROP TABLE IF EXISTS HORA_EXTRA;
DROP TABLE IF EXISTS VALOR_HORA_EXTRA;
DROP TABLE IF EXISTS ASISTENCIA;
DROP TABLE IF EXISTS HORARIO;
DROP TABLE IF EXISTS RED_SOCIAL;
DROP TABLE IF EXISTS ENCARGADO_PRUEBA;
DROP TABLE IF EXISTS PRUEBA_ESTATUS_HISTORICO;
DROP TABLE IF EXISTS PROCESO_PRUEBA;
DROP TABLE IF EXISTS PRUEBA;
DROP TABLE IF EXISTS VENTA_ESTATUS;
DROP TABLE IF EXISTS PAGO;
DROP TABLE IF EXISTS COMPRA;
DROP TABLE IF EXISTS TASA_CAMBIO;
DROP TABLE IF EXISTS VENTA;
DROP TABLE IF EXISTS PAGO_EMPLEADO;
DROP TABLE IF EXISTS METODO_PAGO;
DROP TABLE IF EXISTS BANCO;
DROP TABLE IF EXISTS SOLICITUD;
DROP TABLE IF EXISTS INVENTARIO;
DROP TABLE IF EXISTS MATERIA_PRIMA;
DROP TABLE IF EXISTS TIPO_MATERIA_PRIMA;
DROP TABLE IF EXISTS EMPLEADO_CARGO;
DROP TABLE IF EXISTS CARGO;
DROP TABLE IF EXISTS USUARIO_ROL;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS ROL_PRIVILEGIO;
DROP TABLE IF EXISTS ROL;
DROP TABLE IF EXISTS PRIVILEGIO;
DROP TABLE IF EXISTS FASE_EJECUCION_ESTATUS;
DROP TABLE IF EXISTS ESTATUS;
DROP TABLE IF EXISTS EMPLEADO_ZONA;
DROP TABLE IF EXISTS ALMACEN;
DROP TABLE IF EXISTS ASIGNACION_EMPLEADO;
DROP TABLE IF EXISTS PIEZA;
DROP TABLE IF EXISTS CARACTERISTICA;
DROP TABLE IF EXISTS TIPO_PIEZA;
DROP TABLE IF EXISTS ASIGNACION_MAQUINARIA;
DROP TABLE IF EXISTS FASE_EJECUCION;
DROP TABLE IF EXISTS FASE_CONFIGURACION;
DROP TABLE IF EXISTS ZONA;
DROP TABLE IF EXISTS AREA;
DROP TABLE IF EXISTS PLANTA;
DROP TABLE IF EXISTS TIPO_PLANTA;
DROP TABLE IF EXISTS SEDE;
DROP TABLE IF EXISTS AVION;
DROP TABLE IF EXISTS MODELO_AVION;
DROP TABLE IF EXISTS UNIDAD_MEDIDA;
DROP TABLE IF EXISTS MAQUINARIA;
DROP TABLE IF EXISTS TIPO_MAQUINARIA;
DROP TABLE IF EXISTS EMPLEADO;
DROP TABLE IF EXISTS CLIENTE;
DROP TABLE IF EXISTS TELEFONO;
DROP TABLE IF EXISTS CORREO_ELECTRONICO;
DROP TABLE IF EXISTS PERSONA_JURIDICA;
DROP TABLE IF EXISTS PERSONA_NATURAL;
DROP TABLE IF EXISTS LUGAR;
