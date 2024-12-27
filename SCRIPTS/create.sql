CREATE TABLE LUGAR (
    Lug_codigo SERIAL,
    Lug_nombre VARCHAR(50) NOT NULL,
    Lug_tipo VARCHAR(50) NOT NULL,
    Fk_lugar INTEGER,
    CONSTRAINT pk_lugar PRIMARY KEY (Lug_codigo),
    CONSTRAINT fk_divide FOREIGN KEY (Fk_lugar) REFERENCES LUGAR(Lug_codigo),
    CONSTRAINT check_tipo CHECK (Lug_tipo IN ('Pais', 'Estado', 'Municipio', 'Parroquia'))
);

CREATE TABLE PERSONA_NATURAL(
    Per_codigo SERIAL,
    Per_nombre VARCHAR(50) NOT NULL,
    Per_direccion TEXT NOT NULL,
    Per_fecha_registro DATE NOT NULL,
    Per_identificacion VARCHAR(50) UNIQUE NOT NULL,
    Pen_segundo_nombre VARCHAR(50),
    Pen_primer_apellido VARCHAR(50) NOT NULL,
    Pen_segundo_apellido VARCHAR(50),
    Pen_fecha_nac DATE NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    CONSTRAINT pk_persona_natural PRIMARY KEY (Per_codigo),
    CONSTRAINT fk_ubica_pn FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo)
);

CREATE TABLE PERSONA_JURIDICA(
    Per_codigo SERIAL NOT NULL,
    Per_nombre VARCHAR(50) NOT NULL,
    Per_direccion TEXT NOT NULL,
    Per_fecha_registro DATE NOT NULL,
    Per_identificacion VARCHAR(50) UNIQUE NOT NULL,
    Pej_pagina_web VARCHAR(60) NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    CONSTRAINT pk_persona_juridica PRIMARY KEY(Per_codigo),
    CONSTRAINT fk_ubica_pj FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo)
);

CREATE TABLE CORREO_ELECTRONICO(
    Cor_codigo SERIAL,
    Cor_direccion VARCHAR(60) NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_correo_electronico PRIMARY KEY(Cor_codigo),
    CONSTRAINT fk_asocia_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo),
    CONSTRAINT fk_asocia_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo),
    CONSTRAINT check_direccion CHECK (Cor_direccion LIKE '%@%.%')
);

CREATE TABLE TELEFONO(
    Tel_codigo SERIAL,
    Tel_codigo_area INTEGER NOT NULL,
    Tel_numero BIGINT NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_telefono PRIMARY KEY(Tel_codigo),
    CONSTRAINT fk_posee_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo),
    CONSTRAINT fk_posee_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo)
);
--TODO:Agregar TRIGGER PARA ARCO EXCLUSIVO
CREATE TABLE CLIENTE(
    Cli_codigo SERIAL,
    Cli_fecha_inicio_operaciones DATE NOT NULL,
    Cli_monto_acreditado REAL NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_cliente PRIMARY KEY(Cli_codigo),
    CONSTRAINT fk_corresponde_a_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo),
    CONSTRAINT fk_corresponde_a_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo)
);

CREATE TABLE EMPLEADO ( 
	Emp_codigo SERIAL,
	Emp_exp_profesional INTEGER NOT NULL,
	Emp_titulacion VARCHAR(60) NOT NULL,
	Fk_persona_natural INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_empleado PRIMARY KEY (Emp_codigo),
	CONSTRAINT fk_es FOREIGN KEY (Fk_persona_natural) REFERENCES PERSONA_NATURAL (Per_codigo),
	CONSTRAINT check_experiencia CHECK (Emp_exp_profesional >= 0) 
);

CREATE TABLE TIPO_MAQUINARIA ( 
    Tim_codigo SERIAL,
	Tim_nombre VARCHAR(100) NOT NULL,
	CONSTRAINT pk_tim_codigo PRIMARY KEY (Tim_codigo) 
);

CREATE TABLE MAQUINARIA ( 
    Maq_codigo SERIAL,
	Maq_modelo VARCHAR(100) NOT NULL,
	Maq_descripcion VARCHAR(200),
	Fk_tipo_maquinaria INTEGER NOT NULL,
	CONSTRAINT pk_maq_codigo PRIMARY KEY (Maq_codigo),
	CONSTRAINT fk_tim_codigo FOREIGN KEY (Fk_tipo_maquinaria) REFERENCES TIPO_MAQUINARIA (Tim_codigo) 
);

CREATE TABLE UNIDAD_MEDIDA (
    Unm_codigo SERIAL, 
    Unm_nombre VARCHAR(100) NOT NULL,
    Unm_alias VARCHAR(100) NOT NULL,  
    CONSTRAINT pk_unm_codigo PRIMARY KEY(Unm_codigo)
);

CREATE TABLE MODELO_AVION (
    Moa_codigo SERIAL,
    Moa_nombre VARCHAR(100) NOT NULL,
    Moa_descripcion VARCHAR(200) NOT NULL,
    Moa_longitud DOUBLE PRECISION NOT NULL,
    Moa_envergadura DOUBLE PRECISION NOT NULL,
    Moa_altura DOUBLE PRECISION NOT NULL,
    Moa_peso_vacio DOUBLE PRECISION NOT NULL,
    CONSTRAINT pk_moa_codigo PRIMARY KEY(Moa_codigo)
);

CREATE TABLE AVION(
	Avi_codigo SERIAL,
	Avi_matricula VARCHAR(100) NOT NULL,
	Avi_fecha_fabricacion DATE NOT NULL,
	Fk_modelo_avion INTEGER NOT NULL,
	CONSTRAINT pk_avi_codigo PRIMARY KEY (Avi_codigo),
	CONSTRAINT Fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION (Moa_codigo)
);

CREATE TABLE SEDE (
    Sed_codigo SERIAL,
    Sed_nombre VARCHAR(100) NOT NULL,
    Sed_direccion VARCHAR(200) NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    CONSTRAINT pk_sed_codigo PRIMARY KEY (Sed_codigo),
    CONSTRAINT fk_lugar FOREIGN KEY (Fk_lugar) REFERENCES LUGAR (Lug_codigo)
);

CREATE TABLE TIPO_PLANTA (
	Tip_codigo SERIAL,
	Tip_nombre_tipo VARCHAR(100) NOT NULL,
	CONSTRAINT pk_tip_cod PRIMARY KEY (Tip_codigo)
);

CREATE TABLE PLANTA (
	Pla_nro_planta SERIAL,
	Pla_nombre VARCHAR(100) NOT NULL,
	Fk_tipo_planta INTEGER NOT NULL,
	Fk_sede INTEGER NOT NULL,
	CONSTRAINT pk_pla_nro_planta PRIMARY KEY (Pla_nro_planta),
	CONSTRAINT fk_tipo_planta FOREIGN KEY (Fk_tipo_planta) REFERENCES TIPO_PLANTA(Tip_codigo),
	CONSTRAINT fk_sede FOREIGN KEY (Fk_sede) REFERENCES SEDE (Sed_codigo)
);

CREATE TABLE AREA(
	Are_codigo SERIAL,
	Are_nombre VARCHAR(100) NOT NULL,
	Fk_planta INTEGER NOT NULL,
	CONSTRAINT pk_are_codigo PRIMARY KEY (Are_codigo),
	CONSTRAINT fk_planta FOREIGN KEY (Fk_planta) REFERENCES PLANTA(Pla_nro_planta)
);

CREATE TABLE ZONA(
	Zon_codigo SERIAL,
	Zon_nombre VARCHAR(100) NOT NULL,
	Zon_actividad_principal VARCHAR(100) NOT NULL,
	Fk_area INTEGER NOT NULL,
	Fk_empleado_supervisor INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_zon_codigo PRIMARY KEY (Zon_codigo),
	CONSTRAINT fk_area FOREIGN KEY (Fk_area) REFERENCES AREA(Are_codigo), 
	CONSTRAINT fk_empleado_supervisor FOREIGN KEY (Fk_empleado_supervisor) REFERENCES EMPLEADO(Emp_codigo)
);

CREATE TABLE FASE_CONFIGURACION (
	Fac_codigo SERIAL,
	Fac_nombre VARCHAR(100) NOT NULL,
	Fac_descripcion VARCHAR(200) NOT NULL,
	Fac_duracion INTEGER NOT NULL,
	Fk_modelo_avion INTEGER NOT NULL,
	Fk_zona INTEGER NOT NULL,
	CONSTRAINT pk_fac_codigo PRIMARY KEY (Fac_codigo),
	CONSTRAINT fk_ensambla FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo),
	CONSTRAINT fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo)
);

CREATE TABLE FASE_EJECUCION (
	Fae_codigo SERIAL,
	Fae_fecha_inicio DATE NOT NULL,
	Fae_fecha_fin_estimada DATE NOT NULL,
	Fae_fecha_fin_real DATE,
	Fk_avion INTEGER NOT NULL,
	CONSTRAINT pk_fae_codigo PRIMARY KEY (Fae_codigo),
	CONSTRAINT fk_aplica FOREIGN KEY (Fk_avion) REFERENCES AVION(Avi_codigo)
);

CREATE TABLE ASIGNACION_MAQUINARIA ( 
	Asm_codigo SERIAL,
	Fk_fase_ejecucion INTEGER NOT NULL,
	Fk_maquinaria INTEGER NOT NULL,
	CONSTRAINT pk_asm_codigo PRIMARY KEY (Asm_codigo),
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION (Fae_codigo),
	CONSTRAINT fk_maquinaria FOREIGN KEY (Fk_maquinaria) REFERENCES MAQUINARIA (Maq_codigo) 
);

CREATE TABLE TIPO_PIEZA (
	Tip_codigo SERIAL,
	Tip_nombre_tipo VARCHAR(100) NOT NULL,
	Tip_descripcion VARCHAR(200),
	CONSTRAINT pk_tip_codigo PRIMARY KEY (Tip_codigo)
);

--TODO: Agregar TRIGGER para arco exclusivo
CREATE TABLE CARACTERISTICA (
	Car_codigo SERIAL,
	Car_valor DOUBLE PRECISION NOT NULL,
	Car_nombre VARCHAR(100) NOT NULL,
	Car_descripcion VARCHAR(200),
	Fk_unidad_medida INTEGER NOT NULL,
	Fk_modelo_avion INTEGER,
	Fk_tipo_pieza INTEGER,
	CONSTRAINT pk_car_codigo PRIMARY KEY (Car_codigo),
	CONSTRAINT fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo),
	CONSTRAINT fk_tipo_pieza FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo),
	CONSTRAINT fk_se_mide_por FOREIGN KEY (Fk_unidad_medida) REFERENCES UNIDAD_MEDIDA(Unm_codigo)
);

--TODO: VERIFICAR SI EL CONSTRAINT DE CHECK APLICA PARA EL ATRIBUTO ESTATUS
CREATE TABLE PIEZA(
	Pie_codigo SERIAL,
	Pie_nombre VARCHAR(100) NOT NULL,
	Pie_descripcion VARCHAR(200),
	Fk_zona INTEGER NOT NULL,
	Fk_avion INTEGER,
	Fk_pieza INTEGER,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_fase_ejecucion INTEGER NOT NULL,
	CONSTRAINT pk_pie_codigo PRIMARY KEY (Pie_codigo),
	CONSTRAINT fk_zona FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo),
	CONSTRAINT fk_avion FOREIGN KEY (Fk_avion) REFERENCES AVION(Avi_codigo),
	CONSTRAINT fk_pieza FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo),
	CONSTRAINT fk_tipo_pieza FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo),
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo)
);

CREATE TABLE ASIGNACION_EMPLEADO(
	Ase_codigo SERIAL,
	Ase_fecha_inicio DATE NOT NULL,
	Ase_fecha_fin DATE,
	Fk_empleado INTEGER NOT NULL,
	Fk_fase_ejecucion INTEGER NOT NULL,
	CONSTRAINT pk_ase_codigo PRIMARY KEY (Ase_codigo),
	CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo),
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo)
);

CREATE TABLE ALMACEN(
	Alm_codigo SERIAL,
	Alm_nombre VARCHAR(100) NOT NULL,
	Alm_descripcion VARCHAR(200),
	Fk_planta INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_alm_codigo PRIMARY KEY (Alm_codigo),
	CONSTRAINT fk_planta FOREIGN KEY (Fk_planta) REFERENCES PLANTA(pla_nro_planta)
);

CREATE TABLE EMPLEADO_ZONA(
	Emz_codigo SERIAL,
 	Emz_fecha_asignacion_inicial DATE NOT NULL,
 	Emz_fecha_asignacion_final DATE,
 	Fk_empleado INTEGER NOT NULL,
	Fk_zona INTEGER NOT NULL,
	CONSTRAINT pk_emz_codigo PRIMARY KEY (Emz_codigo),
	CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo),
	CONSTRAINT fk_zona FOREIGN KEY (Fk_zona) REFERENCES ZONA(zon_codigo)
);

CREATE TABLE ESTATUS(
	Est_codigo SERIAL,
	Est_nombre_estado VARCHAR(100) NOT NULL,
	CONSTRAINT pk_est_codigo PRIMARY KEY (Est_codigo)
);

CREATE TABLE FASE_EJECUCION_ESTATUS(
	Fee_codigo SERIAL,
	Fee_fecha_inicio DATE NOT NULL,
	Fee_fecha_fin DATE,
	Fk_fase_ejecucion INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_fee_codigo PRIMARY KEY (Fee_codigo),
	CONSTRAINT fk_estatus FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo),
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo)
);

CREATE TABLE PRIVILEGIO (
	Pri_codigo SERIAL,
	Pri_nombre VARCHAR(100) NOT NULL,
	Pri_descripcion VARCHAR(200),
	CONSTRAINT pk_pri_codigo PRIMARY KEY (Pri_codigo)
);

CREATE TABLE ROL(
	Rol_codigo SERIAL,
	Rol_nombre VARCHAR(100) NOT NULL,
	Rol_descripcion VARCHAR(200),
	CONSTRAINT pk_rol_codigo PRIMARY KEY (Rol_codigo)
);

CREATE TABLE ROL_PRIVILEGIO(
	Rop_codigo SERIAL,
	Fk_rol INTEGER NOT NULL,
	Fk_privilegio INTEGER NOT NULL,
	CONSTRAINT pk_rop_codigo PRIMARY KEY (Rop_codigo),
	CONSTRAINT fk_rol FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo),
	CONSTRAINT fk_privilegio FOREIGN KEY (Fk_privilegio) REFERENCES PRIVILEGIO(Pri_codigo)
);

--TODO: chequear si este arc exclusivo se hace con trigger
CREATE TABLE USUARIO(
    Usu_codigo SERIAL,
    Usu_nombre VARCHAR(100) UNIQUE NOT NULL,
    Usu_contrasena VARCHAR(100) NOT NULL,
    Fk_empleado INTEGER UNIQUE,
    Fk_cliente INTEGER UNIQUE,
    CONSTRAINT pk_usu_codigo PRIMARY KEY (Usu_codigo),
    CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo),
    CONSTRAINT fk_cliente FOREIGN KEY (Fk_cliente) REFERENCES CLIENTE(cli_codigo),
    CONSTRAINT check_arco_exclusivo CHECK (
        (Fk_empleado IS NOT NULL AND Fk_cliente IS NULL) OR
        (Fk_empleado IS NULL AND Fk_cliente IS NOT NULL)-- El arco exclusivo es entre Empleado y Cliente
    )
);

CREATE TABLE USUARIO_ROL(
	Usr_codigo SERIAL,
	Fk_usuario INTEGER NOT NULL,
	Fk_rol INTEGER NOT NULL,
	CONSTRAINT pk_usr_codigo PRIMARY KEY (Usr_codigo),
	CONSTRAINT fk_usuario FOREIGN KEY (Fk_usuario) REFERENCES USUARIO(Usu_codigo),
	CONSTRAINT fk_rol FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo)
);

CREATE TABLE CARGO(
	Car_codigo SERIAL,
	Car_nombre VARCHAR(50) NOT NULL,
	Car_descripcion VARCHAR(250),
	CONSTRAINT pk_cargo PRIMARY KEY (car_codigo)
);

CREATE TABLE EMPLEADO_CARGO(
	Emc_codigo SERIAL,
	Emc_fecha_inicio_cargo DATE NOT NULL,
	Emc_fecha_final_cargo DATE,
	Emc_sueldo INTEGER NOT NULL,
	Fk_empleado INTEGER NOT NULL,
	Fk_cargo INTEGER NOT NULL,
	CONSTRAINT pk_emc_codigo PRIMARY KEY (Emc_codigo),
	CONSTRAINT fk_es_ejercido FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo),
	CONSTRAINT fk_ejerce FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo)
);

CREATE TABLE TIPO_MATERIA_PRIMA(
	Tmp_codigo SERIAL,
	Tmp_nombre VARCHAR(50) NOT NULL,
	Tmp_descripcion VARCHAR(250),
	CONSTRAINT pk_tmp_codigo PRIMARY KEY(Tmp_codigo)
);

CREATE TABLE MATERIA_PRIMA(
	Mat_codigo SERIAL,
	Mat_nombre VARCHAR(100) NOT NULL,
	Fk_tipo_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_mat_codigo PRIMARY KEY (Mat_codigo),
	CONSTRAINT fk_pertenece FOREIGN KEY (Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo)
);

CREATE TABLE INVENTARIO(
--TODO: AGREGAR EL ARCO EXCLUSIVO
	Inv_codigo SERIAL,
	Inv_cantidad_disponible INTEGER NOT NULL,
	Fk_almacen INTEGER NOT NULL,
	Fk_materia_prima INTEGER,
	Fk_pieza INTEGER,
	CONSTRAINT pk_inv_codigo PRIMARY KEY (Inv_codigo),
	CONSTRAINT fk_almacena FOREIGN KEY (Fk_almacen) REFERENCES ALMACEN(Alm_codigo),
	CONSTRAINT fk_se_almacena FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo),
	CONSTRAINT fk_se_deposita FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo)
);

CREATE TABLE SOLICITUD(
	Sol_codigo SERIAL,
	Sol_estatus VARCHAR(50) NOT NULL,
	Sol_fecha_cambio_estatus DATE NOT NULL,
	Sol_fecha_emision DATE NOT NULL,
	Sol_cantidad INTEGER NOT NULL,
	Fk_inventario_1 INTEGER NOT NULL,
	Fk_inventario_2 INTEGER NOT NULL,
	Fk_sede INTEGER NOT NULL,
	CONSTRAINT pk_sol_codigo PRIMARY KEY(Sol_codigo),
	CONSTRAINT fk_expide_1 FOREIGN KEY(Fk_inventario_1) REFERENCES INVENTARIO(Inv_codigo),
	CONSTRAINT fk_expide_2 FOREIGN KEY(Fk_inventario_2) REFERENCES INVENTARIO(Inv_codigo),
	CONSTRAINT fk_se_origina_en FOREIGN KEY (Fk_sede) REFERENCES SEDE(Sed_codigo)
);

CREATE TABLE BANCO(
	Ban_codigo SERIAL,
	Ban_nombre VARCHAR(50) NOT NULL,
	CONSTRAINT pk_ban_codigo PRIMARY KEY(Ban_codigo)
);

CREATE TABLE METODO_PAGO(
	Met_codigo SERIAL,
	Cre_numero INTEGER,
	Cre_fecha_venc DATE,
	Cre_cvv INTEGER,
	Deb_numero INTEGER,
	Deb_tipo_cuenta VARCHAR(50),
	Deb_cvv INTEGER,
	Tra_numero INTEGER,
	Efe_denominacion VARCHAR(50),
	Che_numero INTEGER,
	Met_tipo VARCHAR(50) NOT NULL,
	Fk_banco_tc INTEGER,
	Fk_banco_td INTEGER,
	Fk_banco_tsf INTEGER,
	Fk_banco_ch INTEGER,
	CONSTRAINT pk_met_codigo PRIMARY KEY(Met_codigo),
	CONSTRAINT check_met_tipo CHECK (Met_tipo IN ('T-CREDITO', 'T-DEBITO', 'TRANSFERENCIA', 'EFECTIVO', 'CHEQUE')),
	CONSTRAINT fk_emite FOREIGN KEY(Fk_banco_tc) REFERENCES BANCO(Ban_codigo),
	CONSTRAINT fk_se_emite FOREIGN KEY(Fk_banco_td) REFERENCES BANCO(Ban_codigo),
	CONSTRAINT fk_es_emitido FOREIGN KEY(Fk_banco_ch) REFERENCES BANCO(Ban_codigo),
	CONSTRAINT fk_efecua FOREIGN KEY(Fk_banco_tsf) REFERENCES BANCO(Ban_codigo)
);

CREATE TABLE PAGO_EMPLEADO(
	Pae_codigo SERIAL,
	Pae_fecha DATE NOT NULL,
	Pae_monto DOUBLE PRECISION NOT NULL,
	Pae_horas_regulares INTEGER NOT NULL,
	Pae_horas_extras INTEGER,
	Pae_descripcion VARCHAR(250),
	Fk_empleado_cargo INTEGER NOT NULL,
	Fk_metodo_pago INTEGER NOT NULL,
	CONSTRAINT pk_pae_codigo PRIMARY KEY(Pae_codigo),
	CONSTRAINT fk_esta_asociado FOREIGN KEY(Fk_empleado_cargo) REFERENCES EMPLEADO_CARGO(Emc_codigo),
	CONSTRAINT fk_se_paga FOREIGN KEY(Fk_metodo_pago) REFERENCES METODO_PAGO(Met_codigo)
);

CREATE TABLE VENTA(
	Ven_codigo SERIAL,
	Ven_numero_factura INTEGER NOT NULL,
	Ven_fecha_hora TIMESTAMP NOT NULL,
	Ven_monto_total DOUBLE PRECISION NOT NULL,
	Ven_impuesto_total DOUBLE PRECISION NOT NULL,
	Ved_fecha_estimada DATE NOT NULL,
	Ved_fecha_real DATE,
	Fk_cliente INTEGER NOT NULL,
	Fk_avion INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_ven_codigo PRIMARY KEY(Ven_codigo),
	CONSTRAINT fk_solicita FOREIGN KEY(Fk_cliente) REFERENCES CLIENTE(Cli_codigo),
	CONSTRAINT fk_precisa FOREIGN KEY(Fk_avion) REFERENCES AVION(Avi_codigo)
);

CREATE TABLE TASA_CAMBIO(
	Tac_codigo SERIAL,
	Tac_nombre VARCHAR(50) NOT NULL,
	Tac_valor DOUBLE PRECISION NOT NULL,
	Tac_fecha DATE NOT NULL,
	Tac_fecha_final DATE,
	CONSTRAINT pk_tac_codigo PRIMARY KEY(Tac_codigo)
);

CREATE TABLE COMPRA(
	Com_codigo SERIAL,
	Com_fecha_hora TIMESTAMP NOT NULL,
	Com_monto_total DOUBLE PRECISION NOT NULL,
	Com_numero_compra INTEGER NOT NULL,
	Fk_persona_juridica INTEGER NOT NULL,
	Fk_sede INTEGER NOT NULL,
	CONSTRAINT pk_com_codigo PRIMARY KEY(Com_codigo),
	CONSTRAINT fk_es_facturada FOREIGN KEY(Fk_sede) REFERENCES SEDE(Sed_codigo),
	CONSTRAINT fk_provee FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo)
);

CREATE TABLE PAGO(
	Pag_codigo SERIAL NOT NULL,
	Pag_monto DOUBLE PRECISION NOT NULL,
	Pag_fecha DATE NOT NULL,
	Fk_tasa_cambio INTEGER NOT NULL,
	Fk_metodo_pago INTEGER NOT NULL,
	Fk_venta INTEGER,
	Fk_compra INTEGER,
	CONSTRAINT pk_pag_codigo PRIMARY KEY(Pag_codigo),
	CONSTRAINT fk_se_implica FOREIGN KEY(Fk_tasa_cambio) REFERENCES TASA_CAMBIO(Tac_codigo),
	CONSTRAINT fk_exige FOREIGN KEY(Fk_metodo_pago) REFERENCES METODO_PAGO(Met_codigo),
	CONSTRAINT fk_conlleva FOREIGN KEY(Fk_venta) REFERENCES VENTA(Ven_codigo),
	CONSTRAINT fk_implica FOREIGN KEY(Fk_compra) REFERENCES COMPRA(Com_codigo)
);

CREATE TABLE VENTA_ESTATUS(
	Vee_codigo SERIAL NOT NULL,
	Vee_fecha_inicio DATE NOT NULL,
	Vee_fecha_fin DATE,
	Fk_venta INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_vee_codigo PRIMARY KEY(Vee_codigo),
	CONSTRAINT fk_se_encuentra FOREIGN KEY(Fk_venta) REFERENCES VENTA(Ven_codigo),
	CONSTRAINT fk_actualiza FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo)
);

CREATE TABLE PRUEBA(
	Pru_codigo SERIAL,
	Pru_nombre VARCHAR(50) NOT NULL,
	Pru_descripcion VARCHAR(250),
	Pru_duracion_estimada INTEGER NOT NULL,
	Fk_tipo_pieza INTEGER NOT NULL,
	CONSTRAINT pk_pru_codigo PRIMARY KEY(Pru_codigo),
	CONSTRAINT fk_se_certifica FOREIGN KEY(Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo)
);

CREATE TABLE PROCESO_PRUEBA(
	Prp_codigo SERIAL,
	Prp_fecha_inicio_periodo DATE NOT NULL,
	Prp_fecha_final_periodo DATE,
	Prp_aceptado BOOLEAN,
	Fk_prueba INTEGER NOT NULL,
	Fk_zona INTEGER NOT NULL,
	Fk_materia_prima INTEGER,
	Fk_pieza INTEGER,
	CONSTRAINT pk_prp_codigo PRIMARY KEY(Prp_codigo),
	CONSTRAINT fk_controla FOREIGN KEY(Fk_prueba) REFERENCES PRUEBA(Pru_codigo),
	CONSTRAINT fk_se_somete FOREIGN KEY(Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo),
	CONSTRAINT fk_ejecuta FOREIGN KEY(Fk_zona) REFERENCES ZONA(Zon_codigo),
	CONSTRAINT fk_es_controlada FOREIGN KEY(Fk_pieza) REFERENCES PIEZA(Pie_codigo)
);

CREATE TABLE PRUEBA_ESTATUS_HISTORICO(
	Peh_codigo SERIAL NOT NULL,
	Peh_fecha_inicio DATE NOT NULL,
	Peh_fecha_fin DATE,
	Fk_proceso_prueba_1 INTEGER NOT NULL,
	Fk_proceso_prueba_2 INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_peh_codigo PRIMARY KEY(Peh_codigo),
	CONSTRAINT fk_pasa_por_1 FOREIGN KEY(Fk_proceso_prueba_1) REFERENCES PROCESO_PRUEBA(Prp_codigo),
	CONSTRAINT fk_pasa_por_2 FOREIGN KEY(Fk_proceso_prueba_2) REFERENCES PROCESO_PRUEBA(Prp_codigo),
	CONSTRAINT fk_define FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo)
);

CREATE TABLE ENCARGADO_PRUEBA(
	Enp_codigo SERIAL NOT NULL,
	Fk_proceso_prueba_1 INTEGER NOT NULL,
	Fk_proceso_prueba_2 INTEGER NOT NULL,
	Fk_empleado INTEGER NOT NULL,
	CONSTRAINT pk_enp_codigo PRIMARY KEY(Enp_codigo),
	CONSTRAINT fk_se_encarga FOREIGN KEY(Fk_empleado) REFERENCES EMPLEADO(Emp_codigo),
	CONSTRAINT fk_es_encargado_a_1 FOREIGN KEY(Fk_proceso_prueba_1) REFERENCES PROCESO_PRUEBA(Prp_codigo),
	CONSTRAINT fk_es_encargado_a_2 FOREIGN KEY(Fk_proceso_prueba_2) REFERENCES PROCESO_PRUEBA(Prp_codigo)
);

CREATE TABLE RED_SOCIAL(
    Res_codigo SERIAL,
    Res_nombre VARCHAR(100) NOT NULL,
    Res_descripcion VARCHAR(100) NOT NULL,
    fk_empleado INTEGER NOT NULL,
    CONSTRAINT pk_red_social PRIMARY KEY (Res_codigo),
    CONSTRAINT fk_vincula FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo)
);

CREATE TABLE HORARIO(
    Hor_codigo SERIAL,
    Hor_dia VARCHAR(9) NOT NULL,
    Hor_hora_inicio TIME NOT NULL,
    Hor_hora_fin TIME NOT NULL,
    CONSTRAINT pk_horario PRIMARY KEY (Hor_codigo),
    CONSTRAINT check_dia CHECK (Hor_dia IN ('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO','DOMINGO'))
);

CREATE TABLE ASISTENCIA(
	Asi_codigo SERIAL,
    Asi_fecha_hora_inicio TIMESTAMP NOT NULL,
    Asi_fecha_hora_fin TIMESTAMP NOT NULL,
    Fk_empleado INTEGER NOT NULL,
    CONSTRAINT pk_asistencia PRIMARY KEY (Asi_codigo),
    CONSTRAINT fk_asignado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo)
);

CREATE TABLE VALOR_HORA_EXTRA(
	Val_codigo SERIAL,
	Val_valor REAL NOT NULL,
	Val_fecha DATE NOT NULL,
	Val_fecha_final DATE,
	CONSTRAINT pk_valor_hora_extra PRIMARY KEY (Val_codigo)
);

CREATE TABLE HORA_EXTRA(
	Hoe_codigo SERIAL,
	Hoe_fecha_hora_inicio TIMESTAMP NOT NULL,
	Hoe_fecha_hora_fin TIMESTAMP NOT NULL,
	Fk_asistencia INTEGER NOT NULL,
	Fk_valor_hora_extra INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_hora_extra PRIMARY KEY (Hoe_codigo),
	CONSTRAINT fk_se_valora FOREIGN KEY (Fk_asistencia) REFERENCES ASISTENCIA(Asi_codigo),
	CONSTRAINT fk_se_cotiza FOREIGN KEY (Fk_valor_hora_extra) REFERENCES VALOR_HORA_EXTRA(Val_codigo)
);

CREATE TABLE DETALLE_COMPRA(
	Dec_codigo SERIAL,
	Dec_cantidad REAL NOT NULL,
	Dec_precio_unit REAL NOT NULL,
	Fk_compra INTEGER NOT NULL,
	Fk_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_detalle_compra PRIMARY KEY (Dec_codigo),
	CONSTRAINT fk_guarda FOREIGN KEY (Fk_compra) REFERENCES COMPRA(Com_codigo),
	CONSTRAINT fk_es_compra FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo)
);

CREATE TABLE TIPO_MATERIA_PRIMA_TIPO_PIEZA(
	Ttp_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_tipo_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_tipo_materia_prima_tipo_pieza PRIMARY KEY (Ttp_codigo),
	CONSTRAINT fk_compuesto_por FOREIGN KEY(Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo),
	CONSTRAINT fk_compone FOREIGN KEY(Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo)
);

CREATE TABLE EMPLEADO_HORARIO(
	Emh_codigo SERIAL,
	Fk_empleado INTEGER NOT NULL,
	Fk_horario INTEGER NOT NULL,
	CONSTRAINT pk_empleado_horario PRIMARY KEY (Emh_codigo),
	CONSTRAINT fk_asignado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo),
	CONSTRAINT fk_se_asigna FOREIGN KEY (Fk_horario) REFERENCES HORARIO(Hor_codigo)
);

CREATE TABLE PIEZA_ESTATUS(
	Pes_codigo SERIAL,
	Pes_fecha_inicio DATE NOT NULL,
	Pes_fecha_fin DATE,
	Fk_pieza INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_pieza_estatus PRIMARY KEY (Pes_codigo),
	CONSTRAINT fk_es_posicionada FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo),
	CONSTRAINT fk_posiciona FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo)
);

CREATE TABLE CARGO_CONFIGURACION(
	Cac_codigo SERIAL,
	Fk_cargo INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_cargo_configuracion PRIMARY KEY (Cac_codigo),
	CONSTRAINT fk_demanda FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo),
	CONSTRAINT fk_es_demandado FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo)
);

CREATE TABLE TIPO_MAQUINARIA_CONFIGURACION(
	Tmc_codigo SERIAL,
	Fk_tipo_maquinaria INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_maquinaria_configuracion PRIMARY KEY (Tmc_codigo),
	CONSTRAINT fk_pide FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo),
	CONSTRAINT fk_es_pedido FOREIGN KEY (Fk_tipo_maquinaria) REFERENCES TIPO_MAQUINARIA(Tim_codigo)
);

CREATE TABLE MATERIA_PRIMA_ESTATUS(
	Mpe_codigo SERIAL,
	Fk_materia_prima INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_materia_prima_estatus PRIMARY KEY(Mpe_codigo),
	CONSTRAINT fk_alberga FOREIGN KEY(Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo),
	CONSTRAINT fk_adapta FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo)
);

CREATE TABLE PROVEEDOR_TIPO_MATERIA(
	Ptm_codigo SERIAL,
	Ptm_precio DOUBLE PRECISION NOT NULL,
	Fk_persona_juridica INTEGER NOT NULL,
	Fk_tipo_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_proveedor_tipo_materia PRIMARY KEY (Ptm_codigo),
	CONSTRAINT fk_ofrece FOREIGN KEY (Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo),
	CONSTRAINT fk_es_ofrecido FOREIGN KEY (Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo)
);

CREATE TABLE MATERIA_ZONA(
	Maz_codigo SERIAL,
	Fk_zona INTEGER NOT NULL,
	Fk_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_materia_zona PRIMARY KEY (Maz_codigo),
	CONSTRAINT fk_recibe FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo),
	CONSTRAINT fk_es_recibida FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo)
);

CREATE TABLE BENEFICIARIO (
	Ben_codigo SERIAL,
	Fk_persona_natural INTEGER NOT NULL,
	Fk_empleado INTEGER NOT NULL,
	CONSTRAINT pk_beneficiario PRIMARY KEY (Ben_codigo),
	CONSTRAINT fk_beneficia FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo),
	CONSTRAINT fk_persona_natural FOREIGN KEY (Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo)
);

CREATE TABLE CARGO_PRUEBA (
	Cap_codigo SERIAL,
	Fk_cargo INTEGER NOT NULL,
	Fk_prueba INTEGER NOT NULL,
	CONSTRAINT pk_cargo_prueba PRIMARY KEY (Cap_codigo),
	CONSTRAINT fk_realiza FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo),
	CONSTRAINT fk_es_realizado FOREIGN KEY (Fk_prueba) REFERENCES PRUEBA(Pru_codigo)
);

CREATE TABLE MOVIMIENTO (
	Mov_codigo SERIAL,
	Mov_tipo_transaccion VARCHAR(50) NOT NULL,
	Mov_cantidad INTEGER NOT NULL,
	Mov_fecha DATE NOT NULL,
	Fk_inventario INTEGER NOT NULL,
	CONSTRAINT check_tipo_transaccion CHECK (Mov_tipo_transaccion IN ('ENTRADA', 'SALIDA')),
	CONSTRAINT pk_mov_codigo PRIMARY KEY (Mov_codigo),
	CONSTRAINT fk_mueve FOREIGN KEY (Fk_inventario) REFERENCES INVENTARIO(Inv_codigo)
);

CREATE TABLE TIPO_PIEZA_MODELO (
	Tpm_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_modelo_avion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_pieza_modelo PRIMARY KEY (Tpm_codigo),
	CONSTRAINT fk_conforma FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo),
	CONSTRAINT fk_esta_conformado FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo)
);

CREATE TABLE TIPO_PIEZA_FASE (
	Tpf_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_pieza_fase PRIMARY KEY (Tpf_codigo),
	CONSTRAINT fk_es_fabricada FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo),
	CONSTRAINT fk_fabrica FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo)
);