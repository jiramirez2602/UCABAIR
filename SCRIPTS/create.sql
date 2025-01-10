-- ###############################################
-- CREACION DE TABLAS DE LA BASE DE DATOS 

CREATE TABLE LUGAR (
    Lug_codigo SERIAL,
    Lug_nombre VARCHAR(50) NOT NULL,
    Lug_tipo VARCHAR(50) NOT NULL,
    Fk_lugar INTEGER,
    CONSTRAINT pk_lugar PRIMARY KEY (Lug_codigo),
    CONSTRAINT fk_divide FOREIGN KEY (Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE,
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
    CONSTRAINT fk_ubica_pn FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE
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
    CONSTRAINT fk_ubica_pj FOREIGN KEY(Fk_lugar) REFERENCES LUGAR(Lug_codigo) ON DELETE CASCADE
);

CREATE TABLE CORREO_ELECTRONICO(
    Cor_codigo SERIAL,
    Cor_direccion VARCHAR(60) NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_correo_electronico PRIMARY KEY(Cor_codigo),
    CONSTRAINT fk_asocia_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_asocia_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT check_direccion CHECK (Cor_direccion LIKE '%@%.%')
);

CREATE TABLE TELEFONO(
    Tel_codigo SERIAL,
    Tel_codigo_area INTEGER NOT NULL,
    Tel_numero BIGINT NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_telefono PRIMARY KEY(Tel_codigo),
    CONSTRAINT fk_posee_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_posee_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE
);

CREATE TABLE CLIENTE(
    Cli_codigo SERIAL,
    Cli_fecha_inicio_operaciones DATE NOT NULL,
    Cli_monto_acreditado REAL NOT NULL,
    Fk_persona_natural INTEGER,
    Fk_persona_juridica INTEGER,
    CONSTRAINT pk_cliente PRIMARY KEY(Cli_codigo),
    CONSTRAINT fk_corresponde_a_pn FOREIGN KEY(Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_corresponde_a_pj FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE,
    CONSTRAINT check_arco_exclusivo CHECK (
        (Fk_persona_natural IS NOT NULL AND Fk_persona_juridica IS NULL) OR
        (Fk_persona_natural IS NULL AND Fk_persona_juridica IS NOT NULL)
    )
);

CREATE TABLE EMPLEADO ( 
	Emp_codigo SERIAL,
	Emp_exp_profesional INTEGER NOT NULL,
	Emp_titulacion VARCHAR(60) NOT NULL,
	Fk_persona_natural INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_empleado PRIMARY KEY (Emp_codigo),
	CONSTRAINT fk_es FOREIGN KEY (Fk_persona_natural) REFERENCES PERSONA_NATURAL (Per_codigo) ON DELETE CASCADE,
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
	CONSTRAINT fk_tim_codigo FOREIGN KEY (Fk_tipo_maquinaria) REFERENCES TIPO_MAQUINARIA (Tim_codigo) ON DELETE CASCADE 
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
	CONSTRAINT Fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION (Moa_codigo) ON DELETE CASCADE
);

CREATE TABLE SEDE (
    Sed_codigo SERIAL,
    Sed_nombre VARCHAR(100) NOT NULL,
    Sed_direccion VARCHAR(200) NOT NULL,
    Fk_lugar INTEGER NOT NULL,
    CONSTRAINT pk_sed_codigo PRIMARY KEY (Sed_codigo),
    CONSTRAINT fk_lugar FOREIGN KEY (Fk_lugar) REFERENCES LUGAR (Lug_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_tipo_planta FOREIGN KEY (Fk_tipo_planta) REFERENCES TIPO_PLANTA(Tip_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_sede FOREIGN KEY (Fk_sede) REFERENCES SEDE (Sed_codigo) ON DELETE CASCADE
);

CREATE TABLE AREA(
	Are_codigo SERIAL,
	Are_nombre VARCHAR(100) NOT NULL,
	Fk_planta INTEGER NOT NULL,
	CONSTRAINT pk_are_codigo PRIMARY KEY (Are_codigo),
	CONSTRAINT fk_planta FOREIGN KEY (Fk_planta) REFERENCES PLANTA(Pla_nro_planta) ON DELETE CASCADE
);

CREATE TABLE ZONA(
	Zon_codigo SERIAL,
	Zon_nombre VARCHAR(100) NOT NULL,
	Zon_actividad_principal VARCHAR(100) NOT NULL,
	Fk_area INTEGER NOT NULL,
	Fk_empleado_supervisor INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_zon_codigo PRIMARY KEY (Zon_codigo),
	CONSTRAINT fk_area FOREIGN KEY (Fk_area) REFERENCES AREA(Are_codigo) ON DELETE CASCADE, 
	CONSTRAINT fk_empleado_supervisor FOREIGN KEY (Fk_empleado_supervisor) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE
);

CREATE TABLE FASE_CONFIGURACION (
	Fac_codigo SERIAL,
	Fac_nombre VARCHAR(100) NOT NULL,
	Fac_descripcion VARCHAR(200) NOT NULL,
	Fac_duracion INTEGER NOT NULL,
	Fk_modelo_avion INTEGER NOT NULL,
	Fk_zona INTEGER NOT NULL,
	CONSTRAINT pk_fac_codigo PRIMARY KEY (Fac_codigo),
	CONSTRAINT fk_ensambla FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo) ON DELETE CASCADE
);

CREATE TABLE FASE_EJECUCION (
	Fae_codigo SERIAL,
	Fae_fecha_inicio DATE NOT NULL,
	Fae_fecha_fin_estimada DATE NOT NULL,
	Fae_fecha_fin_real DATE,
	Fk_avion INTEGER NOT NULL,
	CONSTRAINT pk_fae_codigo PRIMARY KEY (Fae_codigo),
	CONSTRAINT fk_aplica FOREIGN KEY (Fk_avion) REFERENCES AVION(Avi_codigo) ON DELETE CASCADE
);

CREATE TABLE ASIGNACION_MAQUINARIA ( 
	Asm_codigo SERIAL,
	Fk_fase_ejecucion INTEGER NOT NULL,
	Fk_maquinaria INTEGER NOT NULL,
	CONSTRAINT pk_asm_codigo PRIMARY KEY (Asm_codigo),
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION (Fae_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_maquinaria FOREIGN KEY (Fk_maquinaria) REFERENCES MAQUINARIA (Maq_codigo) ON DELETE CASCADE 
);

CREATE TABLE TIPO_PIEZA (
	Tip_codigo SERIAL,
	Tip_nombre_tipo VARCHAR(100) NOT NULL,
	Tip_descripcion VARCHAR(200),
	CONSTRAINT pk_tip_codigo PRIMARY KEY (Tip_codigo)
);

CREATE TABLE CARACTERISTICA (
    Car_codigo SERIAL,
    Car_valor DOUBLE PRECISION NOT NULL,
    Car_nombre VARCHAR(100) NOT NULL,
    Car_descripcion VARCHAR(200),
    Fk_unidad_medida INTEGER NOT NULL,
    Fk_modelo_avion INTEGER,
    Fk_tipo_pieza INTEGER,
    CONSTRAINT pk_car_codigo PRIMARY KEY (Car_codigo),
    CONSTRAINT fk_modelo_avion FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_tipo_pieza FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_se_mide_por FOREIGN KEY (Fk_unidad_medida) REFERENCES UNIDAD_MEDIDA(Unm_codigo) ON DELETE CASCADE,
    CONSTRAINT check_arco_exclusivo CHECK (
        (Fk_modelo_avion IS NOT NULL AND Fk_tipo_pieza IS NULL) OR
        (Fk_modelo_avion IS NULL AND Fk_tipo_pieza IS NOT NULL)
    )
);

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
	CONSTRAINT fk_zona FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_avion FOREIGN KEY (Fk_avion) REFERENCES AVION(Avi_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_pieza FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_tipo_pieza FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo) ON DELETE CASCADE
);

CREATE TABLE ASIGNACION_EMPLEADO(
	Ase_codigo SERIAL,
	Ase_fecha_inicio DATE NOT NULL,
	Ase_fecha_fin DATE,
	Fk_empleado INTEGER NOT NULL,
	Fk_fase_ejecucion INTEGER NOT NULL,
	CONSTRAINT pk_ase_codigo PRIMARY KEY (Ase_codigo),
	CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo) ON DELETE CASCADE
);

CREATE TABLE ALMACEN(
	Alm_codigo SERIAL,
	Alm_nombre VARCHAR(100) NOT NULL,
	Alm_descripcion VARCHAR(200),
	Fk_planta INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_alm_codigo PRIMARY KEY (Alm_codigo),
	CONSTRAINT fk_planta FOREIGN KEY (Fk_planta) REFERENCES PLANTA(pla_nro_planta) ON DELETE CASCADE
);

CREATE TABLE EMPLEADO_ZONA(
	Emz_codigo SERIAL,
 	Emz_fecha_asignacion_inicial DATE NOT NULL,
 	Emz_fecha_asignacion_final DATE,
 	Fk_empleado INTEGER NOT NULL,
	Fk_zona INTEGER NOT NULL,
	CONSTRAINT pk_emz_codigo PRIMARY KEY (Emz_codigo),
	CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_zona FOREIGN KEY (Fk_zona) REFERENCES ZONA(zon_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_estatus FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_fase_ejecucion FOREIGN KEY (Fk_fase_ejecucion) REFERENCES FASE_EJECUCION(Fae_codigo) ON DELETE CASCADE
);

CREATE TABLE PRIVILEGIO (
	Pri_codigo SERIAL,
	Pri_nombre VARCHAR(100) NOT NULL,
	Pri_descripcion VARCHAR(200),
    Pri_es_menu BOOLEAN NOT NULL,
	CONSTRAINT pk_pri_codigo PRIMARY KEY (Pri_codigo)
);

CREATE TABLE ROL(
	Rol_codigo SERIAL,
	Rol_nombre VARCHAR(100) NOT NULL,
	Rol_descripcion VARCHAR(200),
	CONSTRAINT pk_rol_codigo PRIMARY KEY (Rol_codigo), 
	CONSTRAINT uq_rol_nombre UNIQUE (Rol_nombre)
);

CREATE TABLE ROL_PRIVILEGIO(
    Rop_codigo SERIAL,
    Fk_rol INTEGER NOT NULL,
    Fk_privilegio INTEGER NOT NULL,
    CONSTRAINT pk_rop_codigo PRIMARY KEY (Rop_codigo),
    CONSTRAINT fk_rol FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_privilegio FOREIGN KEY (Fk_privilegio) REFERENCES PRIVILEGIO(Pri_codigo) ON DELETE CASCADE,
    CONSTRAINT unique_rol_privilegio UNIQUE (Fk_rol, Fk_privilegio)
);

CREATE TABLE USUARIO(
    Usu_codigo SERIAL,
    Usu_nombre VARCHAR(100) UNIQUE NOT NULL,
    Usu_contrasena VARCHAR(100) NOT NULL,
    Fk_empleado INTEGER UNIQUE,
    Fk_cliente INTEGER UNIQUE,
    CONSTRAINT pk_usu_codigo PRIMARY KEY (Usu_codigo),
    CONSTRAINT fk_empleado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo) ON DELETE CASCADE,
    CONSTRAINT fk_cliente FOREIGN KEY (Fk_cliente) REFERENCES CLIENTE(cli_codigo) ON DELETE CASCADE,
    CONSTRAINT check_arco_exclusivo CHECK (
        (Fk_empleado IS NOT NULL AND Fk_cliente IS NULL) OR
        (Fk_empleado IS NULL AND Fk_cliente IS NOT NULL)
    )
);

CREATE TABLE USUARIO_ROL(
	Usr_codigo SERIAL,
	Fk_usuario INTEGER NOT NULL,
	Fk_rol INTEGER NOT NULL,
	CONSTRAINT pk_usr_codigo PRIMARY KEY (Usr_codigo),
	CONSTRAINT fk_usuario FOREIGN KEY (Fk_usuario) REFERENCES USUARIO(Usu_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_rol FOREIGN KEY (Fk_rol) REFERENCES ROL(Rol_codigo) ON DELETE CASCADE,
	CONSTRAINT unique_rol_usuario UNIQUE (Fk_rol, Fk_usuario)
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
	CONSTRAINT fk_es_ejercido FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_ejerce FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_pertenece FOREIGN KEY (Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo) ON DELETE CASCADE
);

CREATE TABLE INVENTARIO(
	Inv_codigo SERIAL,
	Inv_cantidad_disponible INTEGER NOT NULL,
	Fk_almacen INTEGER NOT NULL,
	Fk_materia_prima INTEGER,
	Fk_pieza INTEGER,
	CONSTRAINT pk_inv_codigo PRIMARY KEY (Inv_codigo),
	CONSTRAINT fk_almacena FOREIGN KEY (Fk_almacen) REFERENCES ALMACEN(Alm_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_almacena FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_deposita FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo) ON DELETE CASCADE,
	CONSTRAINT ck_exclusividad CHECK (
        (Fk_materia_prima IS NOT NULL AND Fk_pieza IS NULL) OR
        (Fk_materia_prima IS NULL AND Fk_pieza IS NOT NULL)
    )
);

CREATE TABLE SOLICITUD(
	Sol_codigo SERIAL,
	Sol_estatus VARCHAR(50) NOT NULL,
	Sol_fecha_cambio_estatus DATE NOT NULL,
	Sol_fecha_emision DATE NOT NULL,
	Sol_cantidad INTEGER NOT NULL,
	Fk_inventario INTEGER NOT NULL,
	Fk_sede INTEGER NOT NULL,
	CONSTRAINT pk_sol_codigo PRIMARY KEY(Sol_codigo),
	CONSTRAINT fk_expide FOREIGN KEY(Fk_inventario) REFERENCES INVENTARIO(Inv_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_origina_en FOREIGN KEY (Fk_sede) REFERENCES SEDE(Sed_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_emite FOREIGN KEY(Fk_banco_tc) REFERENCES BANCO(Ban_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_emite FOREIGN KEY(Fk_banco_td) REFERENCES BANCO(Ban_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_emitido FOREIGN KEY(Fk_banco_ch) REFERENCES BANCO(Ban_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_efecua FOREIGN KEY(Fk_banco_tsf) REFERENCES BANCO(Ban_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_esta_asociado FOREIGN KEY(Fk_empleado_cargo) REFERENCES EMPLEADO_CARGO(Emc_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_paga FOREIGN KEY(Fk_metodo_pago) REFERENCES METODO_PAGO(Met_codigo) ON DELETE CASCADE
);

CREATE TABLE VENTA(
	Ven_codigo SERIAL,
	Ven_numero_factura INTEGER NOT NULL,
	Ven_fecha_hora TIMESTAMP NOT NULL,
	Ven_monto_total DOUBLE PRECISION NOT NULL,
	Ven_impuesto_total DOUBLE PRECISION NOT NULL,
	Ven_fecha_estimada DATE NOT NULL,
	Ven_fecha_real DATE,
	Fk_cliente INTEGER NOT NULL,
	Fk_avion INTEGER UNIQUE NOT NULL,
	CONSTRAINT pk_ven_codigo PRIMARY KEY(Ven_codigo),
	CONSTRAINT fk_solicita FOREIGN KEY(Fk_cliente) REFERENCES CLIENTE(Cli_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_precisa FOREIGN KEY(Fk_avion) REFERENCES AVION(Avi_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_es_facturada FOREIGN KEY(Fk_sede) REFERENCES SEDE(Sed_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_provee FOREIGN KEY(Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_se_implica FOREIGN KEY(Fk_tasa_cambio) REFERENCES TASA_CAMBIO(Tac_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_exige FOREIGN KEY(Fk_metodo_pago) REFERENCES METODO_PAGO(Met_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_conlleva FOREIGN KEY(Fk_venta) REFERENCES VENTA(Ven_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_implica FOREIGN KEY(Fk_compra) REFERENCES COMPRA(Com_codigo) ON DELETE CASCADE
);

CREATE TABLE VENTA_ESTATUS(
	Vee_codigo SERIAL NOT NULL,
	Vee_fecha_inicio DATE NOT NULL,
	Vee_fecha_fin DATE,
	Fk_venta INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_vee_codigo PRIMARY KEY(Vee_codigo),
	CONSTRAINT fk_se_encuentra FOREIGN KEY(Fk_venta) REFERENCES VENTA(Ven_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_actualiza FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE PRUEBA(
	Pru_codigo SERIAL,
	Pru_nombre VARCHAR(100) NOT NULL,
	Pru_descripcion VARCHAR(250),
	Pru_duracion_estimada INTEGER NOT NULL,
	Fk_tipo_pieza INTEGER NOT NULL,
	CONSTRAINT pk_pru_codigo PRIMARY KEY(Pru_codigo),
	CONSTRAINT fk_se_certifica FOREIGN KEY(Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_controla FOREIGN KEY(Fk_prueba) REFERENCES PRUEBA(Pru_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_somete FOREIGN KEY(Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_ejecuta FOREIGN KEY(Fk_zona) REFERENCES ZONA(Zon_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_controlada FOREIGN KEY(Fk_pieza) REFERENCES PIEZA(Pie_codigo) ON DELETE CASCADE,
	CONSTRAINT ck_arco_exclusivo CHECK (
        (Fk_materia_prima IS NOT NULL AND Fk_pieza IS NULL) OR
        (Fk_materia_prima IS NULL AND Fk_pieza IS NOT NULL)
    )
);

CREATE TABLE PRUEBA_ESTATUS_HISTORICO(
	Peh_codigo SERIAL NOT NULL,
	Peh_fecha_inicio DATE NOT NULL,
	Peh_fecha_fin DATE,
	Fk_proceso_prueba INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_peh_codigo PRIMARY KEY(Peh_codigo),
	CONSTRAINT fk_pasa_por FOREIGN KEY(Fk_proceso_prueba) REFERENCES PROCESO_PRUEBA(Prp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_define FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE ENCARGADO_PRUEBA(
	Enp_codigo SERIAL NOT NULL,
	Fk_proceso_prueba INTEGER NOT NULL,
	Fk_empleado INTEGER NOT NULL,
	CONSTRAINT pk_enp_codigo PRIMARY KEY(Enp_codigo),
	CONSTRAINT fk_se_encarga FOREIGN KEY(Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_encargado_a FOREIGN KEY(Fk_proceso_prueba) REFERENCES PROCESO_PRUEBA(Prp_codigo) ON DELETE CASCADE
);

CREATE TABLE RED_SOCIAL(
    Res_codigo SERIAL,
    Res_nombre VARCHAR(100) NOT NULL,
    Res_descripcion VARCHAR(100) NOT NULL,
    fk_empleado INTEGER NOT NULL,
    CONSTRAINT pk_red_social PRIMARY KEY (Res_codigo),
    CONSTRAINT fk_vincula FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(emp_codigo) ON DELETE CASCADE
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
    CONSTRAINT fk_asignado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE
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
	CONSTRAINT fk_se_valora FOREIGN KEY (Fk_asistencia) REFERENCES ASISTENCIA(Asi_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_cotiza FOREIGN KEY (Fk_valor_hora_extra) REFERENCES VALOR_HORA_EXTRA(Val_codigo) ON DELETE CASCADE
);

CREATE TABLE DETALLE_COMPRA(
	Dec_codigo SERIAL,
	Dec_cantidad REAL NOT NULL,
	Dec_precio_unit REAL NOT NULL,
	Fk_compra INTEGER NOT NULL,
	Fk_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_detalle_compra PRIMARY KEY (Dec_codigo),
	CONSTRAINT fk_guarda FOREIGN KEY (Fk_compra) REFERENCES COMPRA(Com_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_compra FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo) ON DELETE CASCADE
);

CREATE TABLE TIPO_MATERIA_PRIMA_TIPO_PIEZA(
	Ttp_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_tipo_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_tipo_materia_prima_tipo_pieza PRIMARY KEY (Ttp_codigo),
	CONSTRAINT fk_compuesto_por FOREIGN KEY(Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_compone FOREIGN KEY(Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo) ON DELETE CASCADE
);

CREATE TABLE EMPLEADO_HORARIO(
	Emh_codigo SERIAL,
	Fk_empleado INTEGER NOT NULL,
	Fk_horario INTEGER NOT NULL,
	CONSTRAINT pk_empleado_horario PRIMARY KEY (Emh_codigo),
	CONSTRAINT fk_asignado FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_se_asigna FOREIGN KEY (Fk_horario) REFERENCES HORARIO(Hor_codigo) ON DELETE CASCADE
);

CREATE TABLE PIEZA_ESTATUS(
	Pes_codigo SERIAL,
	Pes_fecha_inicio DATE NOT NULL,
	Pes_fecha_fin DATE,
	Fk_pieza INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_pieza_estatus PRIMARY KEY (Pes_codigo),
	CONSTRAINT fk_es_posicionada FOREIGN KEY (Fk_pieza) REFERENCES PIEZA(Pie_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_posiciona FOREIGN KEY (Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE CARGO_CONFIGURACION(
	Cac_codigo SERIAL,
	Fk_cargo INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_cargo_configuracion PRIMARY KEY (Cac_codigo),
	CONSTRAINT fk_demanda FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_demandado FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo) ON DELETE CASCADE
);

CREATE TABLE TIPO_MAQUINARIA_CONFIGURACION(
	Tmc_codigo SERIAL,
	Fk_tipo_maquinaria INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_maquinaria_configuracion PRIMARY KEY (Tmc_codigo),
	CONSTRAINT fk_pide FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_pedido FOREIGN KEY (Fk_tipo_maquinaria) REFERENCES TIPO_MAQUINARIA(Tim_codigo) ON DELETE CASCADE
);

CREATE TABLE MATERIA_PRIMA_ESTATUS(
	Mpe_codigo SERIAL,
	Fk_materia_prima INTEGER NOT NULL,
	Fk_estatus INTEGER NOT NULL,
	CONSTRAINT pk_materia_prima_estatus PRIMARY KEY(Mpe_codigo),
	CONSTRAINT fk_alberga FOREIGN KEY(Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_adapta FOREIGN KEY(Fk_estatus) REFERENCES ESTATUS(Est_codigo) ON DELETE CASCADE
);

CREATE TABLE PROVEEDOR_TIPO_MATERIA(
	Ptm_codigo SERIAL,
	Ptm_precio DOUBLE PRECISION NOT NULL,
	Fk_persona_juridica INTEGER NOT NULL,
	Fk_tipo_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_proveedor_tipo_materia PRIMARY KEY (Ptm_codigo),
	CONSTRAINT fk_ofrece FOREIGN KEY (Fk_persona_juridica) REFERENCES PERSONA_JURIDICA(Per_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_ofrecido FOREIGN KEY (Fk_tipo_materia_prima) REFERENCES TIPO_MATERIA_PRIMA(Tmp_codigo) ON DELETE CASCADE
);

CREATE TABLE MATERIA_ZONA(
	Maz_codigo SERIAL,
	Fk_zona INTEGER NOT NULL,
	Fk_materia_prima INTEGER NOT NULL,
	CONSTRAINT pk_materia_zona PRIMARY KEY (Maz_codigo),
	CONSTRAINT fk_recibe FOREIGN KEY (Fk_zona) REFERENCES ZONA(Zon_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_recibida FOREIGN KEY (Fk_materia_prima) REFERENCES MATERIA_PRIMA(Mat_codigo) ON DELETE CASCADE
);

CREATE TABLE BENEFICIARIO (
	Ben_codigo SERIAL,
	Fk_persona_natural INTEGER NOT NULL,
	Fk_empleado INTEGER NOT NULL,
	CONSTRAINT pk_beneficiario PRIMARY KEY (Ben_codigo),
	CONSTRAINT fk_beneficia FOREIGN KEY (Fk_empleado) REFERENCES EMPLEADO(Emp_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_persona_natural FOREIGN KEY (Fk_persona_natural) REFERENCES PERSONA_NATURAL(Per_codigo) ON DELETE CASCADE
);

CREATE TABLE CARGO_PRUEBA (
	Cap_codigo SERIAL,
	Fk_cargo INTEGER NOT NULL,
	Fk_prueba INTEGER NOT NULL,
	CONSTRAINT pk_cargo_prueba PRIMARY KEY (Cap_codigo),
	CONSTRAINT fk_realiza FOREIGN KEY (Fk_cargo) REFERENCES CARGO(Car_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_es_realizado FOREIGN KEY (Fk_prueba) REFERENCES PRUEBA(Pru_codigo) ON DELETE CASCADE
);

CREATE TABLE MOVIMIENTO (
	Mov_codigo SERIAL,
	Mov_tipo_transaccion VARCHAR(50) NOT NULL,
	Mov_cantidad INTEGER NOT NULL,
	Mov_fecha DATE NOT NULL,
	Fk_inventario INTEGER NOT NULL,
	CONSTRAINT check_tipo_transaccion CHECK (Mov_tipo_transaccion IN ('ENTRADA', 'SALIDA')),
	CONSTRAINT pk_mov_codigo PRIMARY KEY (Mov_codigo),
	CONSTRAINT fk_mueve FOREIGN KEY (Fk_inventario) REFERENCES INVENTARIO(Inv_codigo) ON DELETE CASCADE
);

CREATE TABLE TIPO_PIEZA_MODELO (
	Tpm_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_modelo_avion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_pieza_modelo PRIMARY KEY (Tpm_codigo),
	CONSTRAINT fk_conforma FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_esta_conformado FOREIGN KEY (Fk_modelo_avion) REFERENCES MODELO_AVION(Moa_codigo) ON DELETE CASCADE
);

CREATE TABLE TIPO_PIEZA_FASE (
	Tpf_codigo SERIAL,
	Fk_tipo_pieza INTEGER NOT NULL,
	Fk_fase_configuracion INTEGER NOT NULL,
	CONSTRAINT pk_tipo_pieza_fase PRIMARY KEY (Tpf_codigo),
	CONSTRAINT fk_es_fabricada FOREIGN KEY (Fk_tipo_pieza) REFERENCES TIPO_PIEZA(Tip_codigo) ON DELETE CASCADE,
	CONSTRAINT fk_fabrica FOREIGN KEY (Fk_fase_configuracion) REFERENCES FASE_CONFIGURACION(Fac_codigo) ON DELETE CASCADE
);

--  ###############################################################
--  CREACIÓN DE LOS PROCEDURES DE LA BASE DE DATOS

--CRUD MODELO DE AVION
--CREATE
CREATE OR REPLACE PROCEDURE crear_modelo_avion(
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR,
    IN p_longitud DOUBLE PRECISION,
    IN p_envergadura DOUBLE PRECISION,
    IN p_altura DOUBLE PRECISION,
    IN p_peso_vacio DOUBLE PRECISION
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 100 caracteres';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_descripcion) > 200 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 200 caracteres';
    END IF;

    IF p_longitud IS NULL OR p_longitud <= 0 THEN
        RAISE EXCEPTION 'La longitud no puede ser NULL o negativa';
    END IF;

    IF p_envergadura IS NULL OR p_envergadura <= 0 THEN
        RAISE EXCEPTION 'La envergadura no puede ser NULL o negativa';
    END IF;

    IF p_altura IS NULL OR p_altura <= 0 THEN
        RAISE EXCEPTION 'La altura no puede ser NULL o negativa';
    END IF;

    IF p_peso_vacio IS NULL OR p_peso_vacio <= 0 THEN
        RAISE EXCEPTION 'El peso vacío no puede ser NULL o negativo';
    END IF;

    BEGIN
        INSERT INTO MODELO_AVION (Moa_nombre, Moa_descripcion, Moa_longitud, Moa_envergadura, Moa_altura, Moa_peso_vacio)
        VALUES (p_nombre, p_descripcion, p_longitud, p_envergadura, p_altura, p_peso_vacio);
        
        RAISE NOTICE 'Inserción exitosa en la tabla MODELO_AVION';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en MODELO_AVION: %', SQLERRM;
    END;
END;
$$;
--CALL crear_modelo_avion('Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

--READ
CREATE OR REPLACE FUNCTION leer_modelos_avion(
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF MODELO_AVION
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de parámetros de entrada
    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM MODELO_AVION 
        WHERE (p_search = '' OR Moa_nombre ILIKE '%' || p_search || '%' 
                                OR Moa_descripcion ILIKE '%' || p_search || '%');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;
--SELECT * FROM leer_modelos_avion();

--UPDATE 
CREATE OR REPLACE PROCEDURE actualizar_modelo_avion(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR,
    IN p_longitud DOUBLE PRECISION,
    IN p_envergadura DOUBLE PRECISION,
    IN p_altura DOUBLE PRECISION,
    IN p_peso_vacio DOUBLE PRECISION
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 100 caracteres';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_descripcion) > 200 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 200 caracteres';
    END IF;

    IF p_longitud IS NULL OR p_longitud <= 0 THEN
        RAISE EXCEPTION 'La longitud no puede ser NULL o negativa';
    END IF;

    IF p_envergadura IS NULL OR p_envergadura <= 0 THEN
        RAISE EXCEPTION 'La envergadura no puede ser NULL o negativa';
    END IF;

    IF p_altura IS NULL OR p_altura <= 0 THEN
        RAISE EXCEPTION 'La altura no puede ser NULL o negativa';
    END IF;

    IF p_peso_vacio IS NULL OR p_peso_vacio <= 0 THEN
        RAISE EXCEPTION 'El peso vacío no puede ser NULL o negativo';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE MODELO_AVION
        SET Moa_nombre = p_nombre,
            Moa_descripcion = p_descripcion,
            Moa_longitud = p_longitud,
            Moa_envergadura = p_envergadura,
            Moa_altura = p_altura,
            Moa_peso_vacio = p_peso_vacio
        WHERE Moa_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla MODELO_AVION';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en MODELO_AVION: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_modelo_avion(1,'Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_modelo_avion(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM MODELO_AVION WHERE MODELO_AVION.Moa_codigo = codigo;
        
        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'El modelo de avión % ha sido eliminado.', codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el modelo de avión con código %: %', codigo, SQLERRM;
    END;
END;
$$;
--CALL eliminar_modelo_avion(1);  -- Reemplaza 1 con el código específico que deseas eliminar


--****************************************************************************************************************************************************************
--CRUD PRUEBA
--CREATE
CREATE OR REPLACE PROCEDURE crear_prueba(
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR,
    IN p_duracion_estimada INTEGER,
    IN p_fk_tipo_pieza INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_descripcion) > 250 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 250 caracteres';
    END IF;

    IF p_duracion_estimada IS NULL OR p_duracion_estimada <= 0 THEN
        RAISE EXCEPTION 'La duración estimada no puede ser NULL o negativa';
    END IF;

    IF p_fk_tipo_pieza IS NULL THEN
        RAISE EXCEPTION 'El código de tipo de pieza no puede ser NULL';
    END IF;

    -- Intentar ejecutar la inserción
    BEGIN
        INSERT INTO ucabair.prueba (pru_nombre, pru_descripcion, pru_duracion_estimada, fk_tipo_pieza)
        VALUES (p_nombre, p_descripcion, p_duracion_estimada, p_fk_tipo_pieza);
        
        RAISE NOTICE 'Inserción exitosa en la tabla PRUEBA';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en PRUEBA: %', SQLERRM;
    END;
END;
$$;

--CALL crear_prueba('Inspección de Fuselaje', 'Evaluación estructural del fuselaje para detectar grietas o deformaciones.', 180, 2);

--READ
CREATE OR REPLACE FUNCTION leer_pruebas(
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.prueba
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de parámetros de entrada
    IF LENGTH(p_search) > 250 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 250 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    RETURN QUERY
    SELECT * 
    FROM ucabair.prueba 
    WHERE (p_search = '' OR pru_nombre ILIKE '%' || p_search || '%' 
                           OR pru_descripcion ILIKE '%' || p_search || '%');

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
END;
$$;
--SELECT * FROM leer_pruebas();
 
--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_prueba(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR,
    IN p_duracion_estimada INT,
    IN p_fk_tipo_pieza INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_descripcion) > 250 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 250 caracteres';
    END IF;

    IF p_duracion_estimada IS NULL OR p_duracion_estimada <= 0 THEN
        RAISE EXCEPTION 'La duración estimada no puede ser NULL o negativa';
    END IF;

    IF p_fk_tipo_pieza IS NULL THEN
        RAISE EXCEPTION 'El código de tipo de pieza no puede ser NULL';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE ucabair.prueba
        SET pru_nombre = p_nombre,
            pru_descripcion = p_descripcion,
            pru_duracion_estimada = p_duracion_estimada,
            fk_tipo_pieza = p_fk_tipo_pieza
        WHERE pru_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla PRUEBA';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en PRUEBA: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_prueba(1, 'Inspección de Fuselaje Actualizada', 'Evaluación estructural actualizada del fuselaje.', 200, 2);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_prueba(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación de entrada
    IF codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM ucabair.prueba WHERE pru_codigo = codigo;

        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró una prueba con el código %', codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'La prueba con código % ha sido eliminada.', codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar la prueba con código %: %', codigo, SQLERRM;
    END;
END;
$$;
--CALL eliminar_prueba(1);  -- Reemplaza 1 con el código específico que deseas eliminar

--****************************************************************************************************************************************************************
--Tipo de Pieza
--CREATE
CREATE OR REPLACE FUNCTION leer_tipos_pieza(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF TIPO_PIEZA
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    -- Validación de los parámetros de entrada
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    -- Calculamos el OFFSET basado en la página y el límite
    p_offset := (p_page - 1) * p_limit;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM TIPO_PIEZA 
        WHERE (p_search = '' OR Tip_nombre_tipo ILIKE '%' || p_search || '%' 
                               OR Tip_descripcion ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

--SELECT * FROM leer_tipos_pieza(10, 1, 'Motor');

--****************************************************************************************************************************************************************
--CRUD LUGAR
--READ
--Leer Lugares
CREATE OR REPLACE FUNCTION filtrar_lugares(
    p_lug_tipo VARCHAR(50) DEFAULT NULL,
    p_fk_lugar INTEGER DEFAULT NULL
)
RETURNS TABLE(
    Lug_codigo INTEGER,
    Lug_nombre VARCHAR,
    Lug_tipo VARCHAR,
    Fk_lugar INTEGER
) AS $$
BEGIN
    -- Validaciones de parámetros de entrada
    IF p_lug_tipo IS NOT NULL AND LENGTH(p_lug_tipo) > 50 THEN
        RAISE EXCEPTION 'El tipo de lugar no puede tener más de 50 caracteres';
    END IF;

    IF p_lug_tipo IS NOT NULL AND p_lug_tipo NOT IN ('Pais', 'Estado', 'Municipio', 'Parroquia') THEN
        RAISE EXCEPTION 'El tipo de lugar debe ser uno de los siguientes: Pais, Estado, Municipio, Parroquia';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT
            l.Lug_codigo,
            l.Lug_nombre,
            l.Lug_tipo,
            l.Fk_lugar
        FROM
            LUGAR l
        WHERE
            (p_lug_tipo IS NULL OR l.Lug_tipo = p_lug_tipo) AND
            (p_fk_lugar IS NULL OR l.Fk_lugar = p_fk_lugar);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM filtrar_lugares('Estado', NULL);

--****************************************************************************************************************************************************************
--CRUD PERSONA_NATURAL
--CREATE
CREATE OR REPLACE PROCEDURE crear_persona_natural(
    IN p_nombre VARCHAR,
    IN p_direccion TEXT,
    IN p_fecha_registro DATE,
    IN p_identificacion VARCHAR,
    IN p_primer_apellido VARCHAR,
    IN p_fecha_nac DATE,
    IN p_fk_lugar INTEGER,
    IN p_segundo_nombre VARCHAR DEFAULT NULL,
    IN p_segundo_apellido VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_direccion IS NULL OR p_direccion = '' THEN
        RAISE EXCEPTION 'La dirección no puede ser NULL o vacía';
    END IF;

    IF p_fecha_registro IS NULL THEN
        RAISE EXCEPTION 'La fecha de registro no puede ser NULL';
    END IF;

    IF p_identificacion IS NULL OR p_identificacion = '' THEN
        RAISE EXCEPTION 'La identificación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_identificacion) > 50 THEN
        RAISE EXCEPTION 'La identificación no puede tener más de 50 caracteres';
    END IF;

    IF p_primer_apellido IS NULL OR p_primer_apellido = '' THEN
        RAISE EXCEPTION 'El primer apellido no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_primer_apellido) > 50 THEN
        RAISE EXCEPTION 'El primer apellido no puede tener más de 50 caracteres';
    END IF;

    IF p_fecha_nac IS NULL THEN
        RAISE EXCEPTION 'La fecha de nacimiento no puede ser NULL';
    END IF;

    IF p_fk_lugar IS NULL THEN
        RAISE EXCEPTION 'El código de lugar no puede ser NULL';
    END IF;

    IF p_segundo_nombre IS NOT NULL AND LENGTH(p_segundo_nombre) > 50 THEN
        RAISE EXCEPTION 'El segundo nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_segundo_apellido IS NOT NULL AND LENGTH(p_segundo_apellido) > 50 THEN
        RAISE EXCEPTION 'El segundo apellido no puede tener más de 50 caracteres';
    END IF;

    -- Intentar ejecutar la inserción
    BEGIN
        INSERT INTO PERSONA_NATURAL (
            Per_nombre, Per_direccion, Per_fecha_registro, Per_identificacion, Pen_segundo_nombre, 
            Pen_primer_apellido, Pen_segundo_apellido, Pen_fecha_nac, Fk_lugar
        )
        VALUES (
            p_nombre, p_direccion, p_fecha_registro, p_identificacion, p_segundo_nombre, 
            p_primer_apellido, p_segundo_apellido, p_fecha_nac, p_fk_lugar
        );

        RAISE NOTICE 'Inserción exitosa en la tabla PERSONA_NATURAL';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en PERSONA_NATURAL: %', SQLERRM;
    END;
END;
$$;
--CALL crear_persona_natural('Juan'::VARCHAR, 'Calle Falsa 123'::TEXT, '2023-12-27'::DATE, '123456789'::VARCHAR, 'Pérez'::VARCHAR, '1990-01-01'::DATE, 1::INTEGER, 'Carlos'::VARCHAR, 'Gómez'::VARCHAR);

--READ
CREATE OR REPLACE FUNCTION leer_personas_natural(
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE(
    Per_codigo INT,
    Per_nombre VARCHAR,
    Per_direccion TEXT,
    Per_fecha_registro DATE,
    Per_identificacion VARCHAR,
    Pen_segundo_nombre VARCHAR,
    Pen_primer_apellido VARCHAR,
    Pen_segundo_apellido VARCHAR,
    Pen_fecha_nac DATE,
    fk_lugar INT,
    Lug_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación de los parámetros de entrada
    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT P.Per_codigo, P.Per_nombre, P.Per_direccion, P.Per_fecha_registro, P.Per_identificacion,
               P.Pen_segundo_nombre, P.Pen_primer_apellido, P.Pen_segundo_apellido, P.Pen_fecha_nac, 
               P.Fk_lugar, L.Lug_nombre
        FROM PERSONA_NATURAL P
        INNER JOIN LUGAR L ON P.Fk_lugar = L.Lug_codigo
        WHERE (p_search = '' OR P.Per_nombre ILIKE '%' || p_search || '%' 
                           OR P.Pen_primer_apellido ILIKE '%' || p_search || '%'
                           OR P.Pen_segundo_apellido ILIKE '%' || p_search || '%'
                           OR P.Per_identificacion ILIKE '%' || p_search || '%'
                           OR L.Lug_nombre ILIKE '%' || p_search || '%');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;
--SELECT * FROM leer_personas_natural();

--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_persona_natural(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_direccion TEXT,
    IN p_fecha_registro DATE,
    IN p_identificacion VARCHAR,
    IN p_primer_apellido VARCHAR,
    IN p_fecha_nac DATE,
    IN p_fk_lugar INTEGER,
    IN p_segundo_nombre VARCHAR DEFAULT NULL,
    IN p_segundo_apellido VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_direccion IS NULL OR p_direccion = '' THEN
        RAISE EXCEPTION 'La dirección no puede ser NULL o vacía';
    END IF;

    IF p_fecha_registro IS NULL THEN
        RAISE EXCEPTION 'La fecha de registro no puede ser NULL';
    END IF;

    IF p_identificacion IS NULL OR p_identificacion = '' THEN
        RAISE EXCEPTION 'La identificación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_identificacion) > 50 THEN
        RAISE EXCEPTION 'La identificación no puede tener más de 50 caracteres';
    END IF;

    IF p_primer_apellido IS NULL OR p_primer_apellido = '' THEN
        RAISE EXCEPTION 'El primer apellido no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_primer_apellido) > 50 THEN
        RAISE EXCEPTION 'El primer apellido no puede tener más de 50 caracteres';
    END IF;

    IF p_fecha_nac IS NULL THEN
        RAISE EXCEPTION 'La fecha de nacimiento no puede ser NULL';
    END IF;

    IF p_fk_lugar IS NULL THEN
        RAISE EXCEPTION 'El código de lugar no puede ser NULL';
    END IF;

    IF p_segundo_nombre IS NOT NULL AND LENGTH(p_segundo_nombre) > 50 THEN
        RAISE EXCEPTION 'El segundo nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_segundo_apellido IS NOT NULL AND LENGTH(p_segundo_apellido) > 50 THEN
        RAISE EXCEPTION 'El segundo apellido no puede tener más de 50 caracteres';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE PERSONA_NATURAL
        SET Per_nombre = p_nombre,
            Per_direccion = p_direccion,
            Per_fecha_registro = p_fecha_registro,
            Per_identificacion = p_identificacion,
            Pen_segundo_nombre = p_segundo_nombre,
            Pen_primer_apellido = p_primer_apellido,
            Pen_segundo_apellido = p_segundo_apellido,
            Pen_fecha_nac = p_fecha_nac,
            Fk_lugar = p_fk_lugar
        WHERE Per_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla PERSONA_NATURAL';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en PERSONA_NATURAL: %', SQLERRM;
    END;
END;
$$;
-- CALL actualizar_persona_natural(3,'María','Calle de la Amargura 50','2023-12-27','654321987','Fernández','1978-03-22',3,'Elena',NULL);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_persona_natural(
    IN p_codigo INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Verificar existencia del registro
    IF NOT EXISTS (SELECT 1 FROM PERSONA_NATURAL WHERE Per_codigo = p_codigo) THEN
        RAISE NOTICE 'No se encontró una persona natural con el código %', p_codigo;
        RETURN;
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM correo_electronico WHERE fk_persona_natural = p_codigo;
        DELETE FROM telefono WHERE fk_persona_natural = p_codigo;
        DELETE FROM empleado WHERE fk_persona_natural = p_codigo;
        DELETE FROM beneficiario WHERE fk_persona_natural = p_codigo;
        DELETE FROM cliente WHERE fk_persona_natural = p_codigo;
        DELETE FROM PERSONA_NATURAL WHERE Per_codigo = p_codigo;
        
        RAISE NOTICE 'La persona natural con el código % ha sido eliminada.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede eliminar la persona natural con el código % porque está referenciada en otra tabla.', p_codigo;
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al eliminar la persona natural con el código %: %', p_codigo, SQLERRM;
    END;

    -- Confirmar eliminación del registro
    IF NOT EXISTS (SELECT 1 FROM PERSONA_NATURAL WHERE Per_codigo = p_codigo) THEN
        RAISE NOTICE 'Confirmación: La persona natural con el código % ha sido eliminada.', p_codigo;
    ELSE
        RAISE NOTICE 'Error: La persona natural con el código % no pudo ser eliminada.', p_codigo;
    END IF;
END;
$$;
--CALL eliminar_persona_natural(99);

--****************************************************************************************************************************************************************
--CRUD EMPLEADO
--CREATE
CREATE OR REPLACE PROCEDURE crear_empleado_con_usuario(
    IN p_exp_profesional INTEGER,
    IN p_titulacion VARCHAR,
    IN p_fk_persona_natural INTEGER,
    IN p_usu_nombre VARCHAR,
    IN p_usu_contrasena VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    emp_id INT;
BEGIN
    -- Validaciones de entrada
    IF p_exp_profesional IS NULL OR p_exp_profesional < 0 THEN
        RAISE EXCEPTION 'La experiencia profesional no puede ser NULL ni negativa';
    END IF;

    IF p_titulacion IS NULL OR p_titulacion = '' THEN
        RAISE EXCEPTION 'La titulación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_titulacion) > 60 THEN
        RAISE EXCEPTION 'La titulación no puede tener más de 60 caracteres';
    END IF;

    IF p_fk_persona_natural IS NULL THEN
        RAISE EXCEPTION 'El código de persona natural no puede ser NULL';
    END IF;

    IF p_usu_nombre IS NULL OR p_usu_nombre = '' THEN
        RAISE EXCEPTION 'El nombre de usuario no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_usu_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre de usuario no puede tener más de 100 caracteres';
    END IF;

    IF p_usu_contrasena IS NULL OR p_usu_contrasena = '' THEN
        RAISE EXCEPTION 'La contraseña no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_usu_contrasena) > 100 THEN
        RAISE EXCEPTION 'La contraseña no puede tener más de 100 caracteres';
    END IF;

    -- Intentar ejecutar la inserción
    BEGIN
        -- Insertar en la tabla EMPLEADO
        INSERT INTO EMPLEADO (
            Emp_exp_profesional, Emp_titulacion, Fk_persona_natural
        )
        VALUES (
            p_exp_profesional, p_titulacion, p_fk_persona_natural
        )
        RETURNING emp_codigo INTO emp_id;

        -- Insertar en la tabla USUARIO
        INSERT INTO USUARIO (
            usu_nombre, usu_contrasena, fk_empleado
        )
        VALUES (
            p_usu_nombre, p_usu_contrasena, emp_id
        );
        
        RAISE NOTICE 'Inserción exitosa en las tablas EMPLEADO y USUARIO';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en EMPLEADO o USUARIO: %', SQLERRM;
    END;
END;
$$;

--CALL crear_empleado_con_usuario(5, 'Ingeniero en Sistemas', 1, 'usuario_ejemplo', 'contrasena_segura');


--READ
CREATE OR REPLACE FUNCTION leer_empleados_con_usuarios(
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE (
    emp_codigo INT,
    emp_exp_profesional INT,
    emp_titulacion VARCHAR,
    fk_persona_natural INT,
    usu_nombre VARCHAR,
    usu_contrasena VARCHAR,
    persona_natural_nombre VARCHAR
) LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de los parámetros de entrada
    IF LENGTH(p_search) > 60 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 60 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    RETURN QUERY
    SELECT e.emp_codigo, e.emp_exp_profesional, e.emp_titulacion, e.fk_persona_natural,
           u.usu_nombre, u.usu_contrasena, p.per_nombre AS nombre_completo
    FROM EMPLEADO e
    JOIN USUARIO u ON e.emp_codigo = u.fk_empleado
    JOIN PERSONA_NATURAL p ON p.per_codigo =  e.fk_persona_natural
    WHERE (p_search = '' OR e.emp_titulacion ILIKE '%' || p_search || '%'
                            OR CAST(e.emp_exp_profesional AS VARCHAR) ILIKE '%' || p_search || '%'
                            OR u.usu_nombre ILIKE '%' || p_search || '%'
							OR p.per_nombre ILIKE '%' || p_search || '%');		

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
END;
$$;

--SELECT * FROM leer_empleados_con_usuarios();



--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_empleado_con_usuario(
    IN p_codigo INT,
    IN p_exp_profesional INTEGER,
    IN p_titulacion VARCHAR,
    IN p_fk_persona_natural INTEGER,
    IN p_usu_nombre VARCHAR,
    IN p_usu_contrasena VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    IF p_exp_profesional IS NULL OR p_exp_profesional < 0 THEN
        RAISE EXCEPTION 'La experiencia profesional no puede ser NULL ni negativa';
    END IF;

    IF p_titulacion IS NULL OR p_titulacion = '' THEN
        RAISE EXCEPTION 'La titulación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_titulacion) > 60 THEN
        RAISE EXCEPTION 'La titulación no puede tener más de 60 caracteres';
    END IF;

    IF p_fk_persona_natural IS NULL THEN
        RAISE EXCEPTION 'El código de persona natural no puede ser NULL';
    END IF;

    IF p_usu_nombre IS NULL OR p_usu_nombre = '' THEN
        RAISE EXCEPTION 'El nombre de usuario no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_usu_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre de usuario no puede tener más de 100 caracteres';
    END IF;

    IF p_usu_contrasena IS NULL OR p_usu_contrasena = '' THEN
        RAISE EXCEPTION 'La contraseña no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_usu_contrasena) > 100 THEN
        RAISE EXCEPTION 'La contraseña no puede tener más de 100 caracteres';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        -- Actualizar en la tabla EMPLEADO
        UPDATE EMPLEADO
        SET Emp_exp_profesional = p_exp_profesional,
            Emp_titulacion = p_titulacion,
            Fk_persona_natural = p_fk_persona_natural
        WHERE Emp_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        -- Actualizar en la tabla USUARIO
        UPDATE USUARIO
        SET usu_nombre = p_usu_nombre,
            usu_contrasena = p_usu_contrasena
        WHERE fk_empleado = p_codigo;

        RAISE NOTICE 'Actualización exitosa en las tablas EMPLEADO y USUARIO';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en EMPLEADO o USUARIO: %', SQLERRM;
    END;
END;
$$;

--CALL actualizar_empleado_con_usuario(1, 5, 'Ingeniero en Sistemas', 2, 'usuario_ejemplo', 'nueva_contrasena');


--DELETE
CREATE OR REPLACE PROCEDURE eliminar_empleado_con_usuario(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación de entrada
    IF codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Verificar existencia del empleado
    IF NOT EXISTS (SELECT 1 FROM EMPLEADO WHERE Emp_codigo = codigo) THEN
        RAISE NOTICE 'No se encontró un empleado con el código %', codigo;
        RETURN;
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        -- Eliminar el usuario asociado
        DELETE FROM USUARIO WHERE fk_empleado = codigo;
        
        -- Eliminar el empleado
        DELETE FROM EMPLEADO WHERE Emp_codigo = codigo;

        -- Confirmar eliminación
        RAISE NOTICE 'El empleado con código % y su usuario asociado han sido eliminados.', codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede eliminar el empleado con el código % porque está referenciado en otra tabla.', codigo;
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al intentar eliminar el empleado con código %: %', codigo, SQLERRM;
    END;

    -- Confirmar eliminación del registro
    IF NOT EXISTS (SELECT 1 FROM EMPLEADO WHERE Emp_codigo = codigo) THEN
        RAISE NOTICE 'Confirmación: El empleado con código % ha sido eliminado.', codigo;
    ELSE
        RAISE NOTICE 'Error: El empleado con código % no pudo ser eliminado.', codigo;
    END IF;
END;
$$;

--CALL eliminar_empleado_con_usuario(1);
--*******************************************************************************************************************************
--CRUD PERSONA JURIDICA:
--CREATE
CREATE OR REPLACE PROCEDURE crear_persona_juridica(
    IN p_nombre VARCHAR,
    IN p_direccion TEXT,
    IN p_fecha_registro DATE,
    IN p_identificacion VARCHAR,
    IN p_pagina_web VARCHAR,
    IN p_fk_lugar INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_direccion IS NULL OR p_direccion = '' THEN
        RAISE EXCEPTION 'La dirección no puede ser NULL o vacía';
    END IF;

    IF p_fecha_registro IS NULL THEN
        RAISE EXCEPTION 'La fecha de registro no puede ser NULL';
    END IF;

    IF p_identificacion IS NULL OR p_identificacion = '' THEN
        RAISE EXCEPTION 'La identificación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_identificacion) > 50 THEN
        RAISE EXCEPTION 'La identificación no puede tener más de 50 caracteres';
    END IF;

    IF p_pagina_web IS NULL OR p_pagina_web = '' THEN
        RAISE EXCEPTION 'La página web no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_pagina_web) > 60 THEN
        RAISE EXCEPTION 'La página web no puede tener más de 60 caracteres';
    END IF;

    IF p_fk_lugar IS NULL THEN
        RAISE EXCEPTION 'El código de lugar no puede ser NULL';
    END IF;

    -- Intentar ejecutar la inserción
    BEGIN
        INSERT INTO PERSONA_JURIDICA (Per_nombre, Per_direccion, Per_fecha_registro, Per_identificacion, Pej_pagina_web, Fk_lugar)
        VALUES (p_nombre, p_direccion, p_fecha_registro, p_identificacion, p_pagina_web, p_fk_lugar);
        
        RAISE NOTICE 'Inserción exitosa en la tabla PERSONA_JURIDICA';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en PERSONA_JURIDICA: %', SQLERRM;
    END;
END;
$$;
--CALL crear_persona_juridica('Nombre Empresa', 'Dirección Ejemplo', '2023-01-01', 'ID123456', 'www.ejemplo.com', 1);

--READ
CREATE OR REPLACE FUNCTION leer_personas_juridicas(
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE(
    Per_codigo INT,
    Per_nombre VARCHAR,
    Per_direccion TEXT,
    Per_fecha_registro DATE,
    Per_identificacion VARCHAR,
    Pej_pagina_web VARCHAR,
    fk_lugar INT,
    Lug_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de los parámetros de entrada
    IF LENGTH(p_search) > 50 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 50 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT P.Per_codigo, P.Per_nombre, P.Per_direccion, P.Per_fecha_registro, P.Per_identificacion,
               P.Pej_pagina_web, P.Fk_lugar, L.Lug_nombre
        FROM PERSONA_JURIDICA P
        INNER JOIN LUGAR L ON P.Fk_lugar = L.Lug_codigo
        WHERE (p_search = '' OR P.Per_nombre ILIKE '%' || p_search || '%'
                           OR P.Per_direccion ILIKE '%' || p_search || '%'
                           OR P.Per_identificacion ILIKE '%' || p_search || '%'
                           OR P.Pej_pagina_web ILIKE '%' || p_search || '%'
                           OR L.Lug_nombre ILIKE '%' || p_search || '%');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;


--SELECT * FROM leer_personas_juridicas();

--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_persona_juridica(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_direccion TEXT,
    IN p_fecha_registro DATE,
    IN p_identificacion VARCHAR,
    IN p_pagina_web VARCHAR,
    IN p_fk_lugar INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 50 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 50 caracteres';
    END IF;

    IF p_direccion IS NULL OR p_direccion = '' THEN
        RAISE EXCEPTION 'La dirección no puede ser NULL o vacía';
    END IF;

    IF p_fecha_registro IS NULL THEN
        RAISE EXCEPTION 'La fecha de registro no puede ser NULL';
    END IF;

    IF p_identificacion IS NULL OR p_identificacion = '' THEN
        RAISE EXCEPTION 'La identificación no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_identificacion) > 50 THEN
        RAISE EXCEPTION 'La identificación no puede tener más de 50 caracteres';
    END IF;

    IF p_pagina_web IS NULL OR p_pagina_web = '' THEN
        RAISE EXCEPTION 'La página web no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_pagina_web) > 60 THEN
        RAISE EXCEPTION 'La página web no puede tener más de 60 caracteres';
    END IF;

    IF p_fk_lugar IS NULL THEN
        RAISE EXCEPTION 'El código de lugar no puede ser NULL';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE PERSONA_JURIDICA
        SET Per_nombre = p_nombre,
            Per_direccion = p_direccion,
            Per_fecha_registro = p_fecha_registro,
            Per_identificacion = p_identificacion,
            Pej_pagina_web = p_pagina_web,
            Fk_lugar = p_fk_lugar
        WHERE Per_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla PERSONA_JURIDICA';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en PERSONA_JURIDICA: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_persona_juridica(1, 'Nuevo Nombre', 'Nueva Dirección', '2023-01-01', 'ID987654', 'www.nuevapagina.com', 2);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_persona_juridica(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación de entrada
    IF codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Verificar existencia del registro
    IF NOT EXISTS (SELECT 1 FROM PERSONA_JURIDICA WHERE Per_codigo = codigo) THEN
        RAISE NOTICE 'No se encontró una persona jurídica con el código %', codigo;
        RETURN;
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM PERSONA_JURIDICA WHERE Per_codigo = codigo;

        -- Confirmar eliminación
        RAISE NOTICE 'La persona jurídica con código % ha sido eliminada.', codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede eliminar la persona jurídica con el código % porque está referenciada en otra tabla.', codigo;
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al intentar eliminar la persona jurídica con código %: %', codigo, SQLERRM;
    END;

    -- Confirmar eliminación del registro
    IF NOT EXISTS (SELECT 1 FROM PERSONA_JURIDICA WHERE Per_codigo = codigo) THEN
        RAISE NOTICE 'Confirmación: La persona jurídica con el código % ha sido eliminada.', codigo;
    ELSE
        RAISE NOTICE 'Error: La persona jurídica con el código % no pudo ser eliminada.', codigo;
    END IF;
END;
$$;
--CALL eliminar_persona_juridica(1); 

--*******************************************************************************************************************************
--CRUD PROVEEDOR:
--READ
CREATE OR REPLACE FUNCTION leer_proveedor(
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE(
    Per_codigo INT,
    Per_nombre VARCHAR,
    Per_direccion TEXT,
    Per_fecha_registro DATE,
    Per_identificacion VARCHAR,
    Pej_pagina_web VARCHAR,
    fk_lugar INT,
    Lug_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de los parámetros de entrada
    IF LENGTH(p_search) > 50 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 50 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    RETURN QUERY
    SELECT pj.Per_codigo, pj.Per_nombre, pj.Per_direccion, pj.Per_fecha_registro, pj.Per_identificacion,
           pj.Pej_pagina_web, pj.Fk_lugar, l.Lug_nombre
    FROM persona_juridica pj
    INNER JOIN lugar l ON pj.Fk_lugar = l.Lug_codigo
    WHERE (p_search = '' OR pj.Per_nombre ILIKE '%' || p_search || '%'
                           OR pj.Per_direccion ILIKE '%' || p_search || '%'
                           OR pj.Per_identificacion ILIKE '%' || p_search || '%'
                           OR pj.Pej_pagina_web ILIKE '%' || p_search || '%'
                           OR l.Lug_nombre ILIKE '%' || p_search || '%')
    AND pj.Per_codigo IN (SELECT fk_persona_juridica FROM proveedor_tipo_materia);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
END;
$$;



--SELECT * FROM leer_proveedor();

--*******************************************************************************************************************************
--GET Login
CREATE OR REPLACE FUNCTION obtener_privilegios_usuario(
    p_usu_nombre VARCHAR,
    p_usu_contrasena VARCHAR
) RETURNS TABLE (
    pri_codigo INT,
    pri_nombre VARCHAR,
    pri_es_menu BOOLEAN
) LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar si el nombre de usuario y la contraseña coinciden
    IF EXISTS (
        SELECT 1
        FROM usuario u
        WHERE u.usu_nombre = p_usu_nombre
        AND u.usu_contrasena = p_usu_contrasena
    ) THEN
        -- Retornar los privilegios si las credenciales coinciden
        RETURN QUERY
        SELECT DISTINCT p.pri_codigo, p.pri_nombre, p.pri_es_menu
        FROM usuario u
        JOIN usuario_rol ur ON u.usu_codigo = ur.fk_usuario
        JOIN rol r ON ur.fk_rol = r.rol_codigo
        JOIN rol_privilegio rp ON r.rol_codigo = rp.fk_rol
        JOIN privilegio p ON rp.fk_privilegio = p.pri_codigo
        WHERE u.usu_nombre = p_usu_nombre
        AND u.usu_contrasena = p_usu_contrasena;
    ELSE
        -- Si las credenciales no coinciden, levantar una excepción
        RAISE EXCEPTION 'Nombre de usuario o contraseña incorrectos';
    END IF;
END;
$$;

--SELECT * FROM obtener_privilegios_usuario('adi', 'password456');
--*******************************************************************************************************************************

--CRUD CLIENTE
--TODO: Agregar rol de cliente 
CREATE OR REPLACE PROCEDURE RegistrarClienteNatural (
    -- Datos de Persona Natural
    p_per_nombre VARCHAR,
    p_per_direccion TEXT,
    p_per_identificacion VARCHAR,
    p_pen_segundo_nombre VARCHAR,
    p_pen_primer_apellido VARCHAR,
    p_pen_segundo_apellido VARCHAR,
    p_pen_fecha_nac DATE,
    p_fk_lugar INT,
    
    -- Datos de Usuario
    p_usu_nombre VARCHAR,
    p_usu_contrasena VARCHAR,
    
    -- Datos del Cliente
    p_cli_monto_acreditado DECIMAL(18, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_persona_natural_id INT;
    v_cliente_id INT;
    v_usuario_id INT;
BEGIN
    -- Validar que el nombre de usuario no exista ya en la base de datos
    IF EXISTS (SELECT 1 FROM usuario WHERE usu_nombre = p_usu_nombre) THEN
        RAISE EXCEPTION 'El nombre de usuario % ya está en uso', p_usu_nombre;
    END IF;

    -- Insertar Persona Natural
    INSERT INTO persona_natural (per_nombre, per_direccion, per_fecha_registro, per_identificacion, pen_segundo_nombre, pen_primer_apellido, pen_segundo_apellido, pen_fecha_nac, fk_lugar)
    VALUES (p_per_nombre, p_per_direccion, CURRENT_DATE, p_per_identificacion, p_pen_segundo_nombre, p_pen_primer_apellido, p_pen_segundo_apellido, p_pen_fecha_nac, p_fk_lugar)
    RETURNING per_codigo INTO v_persona_natural_id;

    -- Insertar Cliente
    INSERT INTO cliente (cli_fecha_inicio_operaciones, cli_monto_acreditado, fk_persona_natural)
    VALUES (CURRENT_DATE, p_cli_monto_acreditado, v_persona_natural_id)
    RETURNING cli_codigo INTO v_cliente_id;

    -- Insertar Usuario y asociar con el cliente
    INSERT INTO usuario (usu_nombre, usu_contrasena, fk_cliente)
    VALUES (p_usu_nombre, p_usu_contrasena, v_cliente_id)
    RETURNING usu_codigo INTO v_usuario_id;
    
    INSERT INTO USUARIO_ROL (Fk_usuario, Fk_rol) VALUES (v_usuario_id, 3);
EXCEPTION
    WHEN OTHERS THEN
        -- Si ocurre un error, realizar rollback y levantar la excepción
        RAISE;
END;
$$;


--CALL RegistrarClienteNatural('Juan', '123 Calle Falsa', '1234567890', 'Carlos', 'Pérez', 'Rodríguez', '1985-06-15', 1, 'juan_perez', 'securepassword', 1500.00);

--TODO: Agregar rol de cliente 
CREATE OR REPLACE PROCEDURE RegistrarClienteJuridico (
    -- Datos de Persona Jurídica
    p_per_nombre VARCHAR,
    p_per_direccion TEXT,
    p_per_identificacion VARCHAR,
    p_pej_pagina_web VARCHAR,
    p_fk_lugar INT,
    
    -- Datos de Usuario
    p_usu_nombre VARCHAR,
    p_usu_contrasena VARCHAR,
    
    -- Datos del Cliente
    p_cli_monto_acreditado DECIMAL(18, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_persona_juridica_id INT;
    v_cliente_id INT;
    v_usuario_id INT;
BEGIN
    -- Validar que el nombre de usuario no exista ya en la base de datos
    IF EXISTS (SELECT 1 FROM usuario WHERE usu_nombre = p_usu_nombre) THEN
        RAISE EXCEPTION 'El nombre de usuario % ya está en uso', p_usu_nombre;
    END IF;

    -- Insertar Persona Jurídica
    INSERT INTO persona_juridica (per_nombre, per_direccion, per_fecha_registro, per_identificacion, pej_pagina_web, fk_lugar)
    VALUES (p_per_nombre, p_per_direccion, CURRENT_DATE, p_per_identificacion, p_pej_pagina_web, p_fk_lugar)
    RETURNING per_codigo INTO v_persona_juridica_id;

    -- Insertar Cliente
    INSERT INTO cliente (cli_fecha_inicio_operaciones, cli_monto_acreditado, fk_persona_juridica)
    VALUES (CURRENT_DATE, p_cli_monto_acreditado, v_persona_juridica_id)
    RETURNING cli_codigo INTO v_cliente_id;

    -- Insertar Usuario y asociar con el cliente
    INSERT INTO usuario (usu_nombre, usu_contrasena, fk_cliente)
    VALUES (p_usu_nombre, p_usu_contrasena, v_cliente_id)
    RETURNING usu_codigo INTO v_usuario_id;
    
    INSERT INTO USUARIO_ROL (Fk_usuario, Fk_rol) VALUES (v_usuario_id, 3);
EXCEPTION
    WHEN OTHERS THEN
        -- Si ocurre un error, realizar rollback y levantar la excepción
        RAISE;
END;
$$;

--CALL RegistrarClienteJuridico('Tech Solutions S.A.', 'Av. Principal 123', 'J-12345678-9', 'www.techsolutions.com', 1, 'tech_admin', 'securepassword', 50000.00);

--*******************************************************************************************************************************
--CRUD ROL
-- CREATE
CREATE OR REPLACE PROCEDURE crear_rol(
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'Error: El nombre no puede ser NULL o vacío.';
    END IF;
    IF LENGTH(p_nombre) > 100 THEN
        RAISE EXCEPTION 'Error: El nombre no puede tener más de 100 caracteres.';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'Error: La descripción no puede ser NULL o vacía.';
    END IF;
    IF LENGTH(p_descripcion) > 200 THEN
        RAISE EXCEPTION 'Error: La descripción no puede tener más de 200 caracteres.';
    END IF;

    BEGIN
        INSERT INTO ROL (Rol_nombre, Rol_descripcion)
        VALUES (p_nombre, p_descripcion);
        
        RAISE NOTICE 'Éxito: Inserción exitosa en la tabla ROL.';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Error: El nombre del rol ya existe.';
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Error: Violación de clave foránea.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al insertar en ROL: %', SQLERRM;
    END;
END;
$$;
-- CALL crear_rol('Administrador', 'Rol con permisos de administrador');

-- READ
CREATE OR REPLACE FUNCTION leer_roles(
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ROL
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de parámetros de entrada
    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'Error: El término de búsqueda no puede tener más de 200 caracteres.';
    END IF;

    -- Intentar ejecutar la consulta
    RETURN QUERY
    SELECT * 
    FROM ROL
    WHERE (p_search = '' OR Rol_nombre ILIKE '%' || p_search || '%' 
                            OR Rol_descripcion ILIKE '%' || p_search || '%');

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al ejecutar la consulta: %', SQLERRM;
END;
$$;

-- SELECT * FROM leer_roles();

-- UPDATE
CREATE OR REPLACE PROCEDURE actualizar_rol(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'Error: El código no puede ser NULL.';
    END IF;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'Error: El nombre no puede ser NULL o vacío.';
    END IF;
    IF LENGTH(p_nombre) > 100 THEN
        RAISE EXCEPTION 'Error: El nombre no puede tener más de 100 caracteres.';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'Error: La descripción no puede ser NULL o vacía.';
    END IF;
    IF LENGTH(p_descripcion) > 200 THEN
        RAISE EXCEPTION 'Error: La descripción no puede tener más de 200 caracteres.';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE ROL
        SET Rol_nombre = p_nombre,
            Rol_descripcion = p_descripcion
        WHERE Rol_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Error: No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Éxito: Actualización exitosa en la tabla ROL.';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Error: El nombre del rol ya existe.';
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Error: Violación de clave foránea.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al actualizar en ROL: %', SQLERRM;
    END;
END;
$$;
-- CALL actualizar_rol(1, 'Administrador', 'Rol con permisos de administrador');

-- DELETE
CREATE OR REPLACE PROCEDURE eliminar_rol(
    IN p_codigo INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'Error: El código no puede ser NULL.';
    END IF;
    
    IF p_codigo = 1 THEN
        RAISE EXCEPTION 'El rol administrador no se puede eliminar';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM ROL WHERE Rol_codigo = p_codigo;
        
        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Error: No se encontró un registro con el código %', p_codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'Éxito: El rol % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Error: Violación de clave foránea.';
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el rol con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;

-- CALL eliminar_rol(1);  -- Reemplaza 1 con el código específico que deseas eliminar

--*******************************************************************************************************************************
CREATE OR REPLACE FUNCTION leer_usuarios_sin_cliente()
RETURNS SETOF ucabair.usuario
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM ucabair.usuario
    WHERE fk_cliente IS NULL;
END;
$$;

-- SELECT * FROM leer_usuarios_sin_cliente();

--*******************************************************************************************************************************
--CRUD usuario rol:
--CREATE
CREATE OR REPLACE PROCEDURE crear_usuario_rol(
    IN p_fk_usuario INT,
    IN p_fk_rol INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_fk_usuario IS NULL THEN
        RAISE EXCEPTION 'El usuario no puede ser NULL';
    END IF;
    
    IF p_fk_rol IS NULL THEN
        RAISE EXCEPTION 'El rol no puede ser NULL';
    END IF;

    BEGIN
        INSERT INTO ucabair.usuario_rol (fk_usuario, fk_rol)
        VALUES (p_fk_usuario, p_fk_rol);

        RAISE NOTICE 'Inserción exitosa en la tabla usuario_rol';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en usuario_rol: %', SQLERRM;
    END;
END;
$$;

--CALL crear_usuario_rol(1, 2);

--READ
-- Define un tipo de resultado personalizado
CREATE TYPE ucabair.usuario_rol_completo AS (
    usr_codigo INT,
    fk_usuario INT,
    fk_rol INT,
    rol_nombre VARCHAR,
    usu_nombre VARCHAR
);

-- Crea la función utilizando el nuevo tipo de resultado
CREATE OR REPLACE FUNCTION leer_usuario_roles(
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.usuario_rol_completo
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de los parámetros de entrada
    IF LENGTH(p_search) > 100 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 100 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT ur.usr_codigo, ur.fk_usuario, ur.fk_rol, r.rol_nombre, u.usu_nombre
        FROM ucabair.usuario_rol ur
        INNER JOIN ucabair.rol r ON ur.fk_rol = r.rol_codigo
        INNER JOIN ucabair.usuario u ON ur.fk_usuario = u.usu_codigo
        WHERE (p_search = '' OR ur.fk_usuario::text ILIKE '%' || p_search || '%' 
                                OR ur.fk_rol::text ILIKE '%' || p_search || '%'
                                OR r.rol_nombre ILIKE '%' || p_search || '%'
                                OR u.usu_nombre ILIKE '%' || p_search || '%');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;


--SELECT * FROM leer_usuario_roles();

--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_usuario_rol(
    IN p_codigo INT,
    IN p_fk_usuario INT,
    IN p_fk_rol INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_fk_usuario IS NULL THEN
        RAISE EXCEPTION 'El usuario no puede ser NULL';
    END IF;

    IF p_fk_rol IS NULL THEN
        RAISE EXCEPTION 'El rol no puede ser NULL';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE ucabair.usuario_rol
        SET fk_usuario = p_fk_usuario,
            fk_rol = p_fk_rol
        WHERE usr_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla usuario_rol';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en usuario_rol: %', SQLERRM;
    END;
END;
$$;

--CALL actualizar_usuario_rol(1, 2, 3);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_usuario_rol(p_codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Levantar excepción si p_codigo es igual a 1
    IF p_codigo = 1 THEN
        RAISE EXCEPTION 'No se puede eliminar el usuario_rol con código admin';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM ucabair.usuario_rol WHERE usr_codigo = p_codigo;
        
        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'El usuario_rol % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el usuario_rol con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;


--CALL eliminar_usuario_rol(1);  -- Reemplaza 1 con el código específico que deseas eliminar

--*******************************************************************************************************************************
--Privilegios
--READ
CREATE OR REPLACE FUNCTION leer_privilegios(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.privilegio
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    -- Validaciones de parámetros de entrada
    IF p_page < 1 THEN
        RAISE EXCEPTION 'Error: El número de página debe ser mayor o igual a 1.';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'Error: El límite debe ser un número positivo.';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'Error: El término de búsqueda no puede tener más de 200 caracteres.';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.privilegio
        WHERE (p_search = '' OR pri_nombre ILIKE '%' || p_search || '%' 
                                OR pri_descripcion ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

-- SELECT * FROM leer_privilegios();
--*******************************************************************************************************************************
CREATE OR REPLACE PROCEDURE crear_rol_privilegio(
    IN p_fk_rol INT,
    IN p_fk_privilegio INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_fk_rol IS NULL THEN
        RAISE EXCEPTION 'El rol no puede ser NULL';
    END IF;
    
    IF p_fk_privilegio IS NULL THEN
        RAISE EXCEPTION 'El privilegio no puede ser NULL';
    END IF;

    BEGIN
        INSERT INTO ucabair.rol_privilegio (fk_rol, fk_privilegio)
        VALUES (p_fk_rol, p_fk_privilegio);

        RAISE NOTICE 'Inserción exitosa en la tabla rol_privilegio';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en rol_privilegio: %', SQLERRM;
    END;
END;
$$;

--CALL crear_rol_privilegio(1, 2);
CREATE TYPE ucabair.rol_privilegio_completo AS (
    rp_codigo INT,
    fk_rol INT,
    fk_privilegio INT,
    rol_nombre VARCHAR,
    pri_nombre VARCHAR
);
CREATE OR REPLACE FUNCTION leer_rol_privilegios(
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.rol_privilegio_completo
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de los parámetros de entrada
    IF LENGTH(p_search) > 100 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 100 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT rp.rop_codigo, rp.fk_rol, rp.fk_privilegio, r.rol_nombre, p.pri_nombre
        FROM ucabair.rol_privilegio rp
        INNER JOIN ucabair.rol r ON rp.fk_rol = r.rol_codigo
        INNER JOIN ucabair.privilegio p ON rp.fk_privilegio = p.pri_codigo
        WHERE (p_search = '' OR rp.fk_rol::text ILIKE '%' || p_search || '%' 
                                OR rp.fk_privilegio::text ILIKE '%' || p_search || '%'
                                OR r.rol_nombre ILIKE '%' || p_search || '%'
                                OR p.pri_nombre ILIKE '%' || p_search || '%');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;


--SELECT * FROM leer_rol_privilegios();
CREATE OR REPLACE PROCEDURE actualizar_rol_privilegio(
    IN p_codigo INT,
    IN p_fk_rol INT,
    IN p_fk_privilegio INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_fk_rol IS NULL THEN
        RAISE EXCEPTION 'El rol no puede ser NULL';
    END IF;

    IF p_fk_privilegio IS NULL THEN
        RAISE EXCEPTION 'El privilegio no puede ser NULL';
    END IF;

    -- Intentar ejecutar la actualización
    BEGIN
        UPDATE ucabair.rol_privilegio
        SET fk_rol = p_fk_rol,
            fk_privilegio = p_fk_privilegio
        WHERE rop_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla rol_privilegio';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en rol_privilegio: %', SQLERRM;
    END;
END;
$$;

--CALL actualizar_rol_privilegio(1, 2, 3);
CREATE OR REPLACE PROCEDURE eliminar_rol_privilegio(p_codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM ucabair.rol_privilegio WHERE rop_codigo = p_codigo;
        
        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'El rol_privilegio % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el rol_privilegio con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;

--CALL eliminar_rol_privilegio(1);  -- Reemplaza 1 con el código específico que deseas eliminar

CREATE OR REPLACE PROCEDURE crear_fase_configuracion(
    IN Fac_nombre VARCHAR,
    IN Fac_descripcion VARCHAR,
    IN Fac_duracion INT,
    IN Fk_zona INT,
    IN Fk_modelo_avion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF Fac_nombre IS NULL OR Fac_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(Fac_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 100 caracteres';
    END IF;
    IF Fac_descripcion IS NULL OR Fac_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(Fac_descripcion) > 200 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 200 caracteres';
    END IF;
    IF Fac_duracion IS NULL OR Fac_duracion <= 0 THEN
        RAISE EXCEPTION 'La duración no puede ser NULL o negativa';
    END IF;
    IF Fac_duracion > 300 THEN
        RAISE EXCEPTION 'La duración no puede ser mayor a 300 días';
    END IF;

    BEGIN
        INSERT INTO FASE_CONFIGURACION (Fac_nombre, Fac_descripcion, Fac_duracion, Fk_modelo_avion, Fk_zona)
        VALUES (Fac_nombre, Fac_descripcion, Fac_duracion, Fk_modelo_avion, Fk_zona);
        
        RAISE NOTICE 'Inserción exitosa en la tabla MODELO_AVION';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en FASE_CONFIGURACION: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_fase_configuracion(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE (
    Fac_codigo INT,
    Fac_nombre VARCHAR,
    Fac_descripcion TEXT,
    Fac_duracion INT,
    Zon_nombre VARCHAR,
    Moa_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    RETURN QUERY
    SELECT 
        fc.Fac_codigo, 
        fc.Fac_nombre::VARCHAR, 
        fc.Fac_descripcion::TEXT, 
        fc.Fac_duracion, 
        z.Zon_nombre::VARCHAR, 
        ma.Moa_nombre::VARCHAR
    FROM FASE_CONFIGURACION fc
    JOIN ZONA z ON fc.Fk_zona = z.Zon_codigo
    JOIN MODELO_AVION ma ON fc.Fk_modelo_avion = ma.Moa_codigo
    WHERE (p_search = '' OR fc.Fac_nombre ILIKE '%' || p_search || '%' 
                            OR fc.Fac_descripcion ILIKE '%' || p_search || '%')
    ORDER BY fc.Fac_codigo ASC
    LIMIT p_limit 
    OFFSET p_offset;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_fase_configuracion(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validaciones de entrada
    IF codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM FASE_CONFIGURACION WHERE FASE_CONFIGURACION.Fac_codigo = codigo;
        
        -- Verificar si el registro fue eliminado
        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', codigo;
        END IF;

        -- Confirmar eliminación
        RAISE NOTICE 'La fase de configuracion % ha sido eliminado.', codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar la fase de configuracion con código %: %', codigo, SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_fase_configuracion(
    IN p_codigo INT,
    IN p_nombre VARCHAR,
    IN p_descripcion VARCHAR,
    IN p_duracion INT,
    IN p_modelo_avion INT,
    IN p_zona INT
)
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_nombre IS NULL OR p_nombre = '' THEN
        RAISE EXCEPTION 'El nombre no puede ser NULL o vacío';
    END IF;
    IF LENGTH(p_nombre) > 100 THEN
        RAISE EXCEPTION 'El nombre no puede tener más de 100 caracteres';
    END IF;

    IF p_descripcion IS NULL OR p_descripcion = '' THEN
        RAISE EXCEPTION 'La descripción no puede ser NULL o vacía';
    END IF;
    IF LENGTH(p_descripcion) > 200 THEN
        RAISE EXCEPTION 'La descripción no puede tener más de 200 caracteres';
    END IF;

    IF p_duracion IS NULL OR p_duracion <= 0 THEN
        RAISE EXCEPTION 'La duración no puede ser NULL o negativa';
    END IF;

    IF p_duracion > 300 THEN
        RAISE EXCEPTION 'La duración no puede ser superior a los 300 días';
    END IF;

    IF p_modelo_avion IS NULL OR p_modelo_avion <= 0 THEN
        RAISE EXCEPTION 'El codigo del modelo de avión no puede ser NULL o negativa';
    END IF;

    IF p_zona IS NULL OR p_zona <= 0 THEN
        RAISE EXCEPTION 'El codigo de la zona no puede ser NULL o negativa';
    END IF;

    BEGIN
        UPDATE FASE_CONFIGURACION
        SET Fac_nombre = p_nombre,
            Fac_descripcion = p_descripcion,
            Fac_duracion = p_duracion,
            Fk_modelo_avion = p_modelo_avion,
            Fk_zona = p_zona
        WHERE Fac_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla FASE_CONFIGURACION';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar en FASE_CONFIGURACION: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_tipo_pieza_fase(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.TIPO_PIEZA_FASE
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 100 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 100 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.TIPO_PIEZA_FASE 
        WHERE (p_search = '' OR Fk_tipo_pieza::text ILIKE '%' || p_search || '%' 
                                OR Fk_fase_configuracion::text ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE crear_tipo_pieza_fase(
    IN p_fk_tipo_pieza INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_fk_tipo_pieza IS NULL THEN
        RAISE EXCEPTION 'El tipo de pieza no puede ser NULL';
    END IF;
    
    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        INSERT INTO ucabair.TIPO_PIEZA_FASE (Fk_tipo_pieza, Fk_fase_configuracion)
        VALUES (p_fk_tipo_pieza, p_fk_fase_configuracion);

        RAISE NOTICE 'Inserción exitosa en la tabla tipo_pieza_fase';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en tipo_pieza_fase: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_tipo_pieza_fase(
    IN p_codigo INT,
    IN p_fk_tipo_pieza INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_fk_tipo_pieza IS NULL THEN
        RAISE EXCEPTION 'El tipo de pieza no puede ser NULL';
    END IF;

    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        UPDATE ucabair.TIPO_PIEZA_FASE
        SET Fk_tipo_pieza = p_fk_tipo_pieza,
            Fk_fase_configuracion = p_fk_fase_configuracion
        WHERE Tpf_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar la tabla%', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_pieza_fase(p_codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        DELETE FROM ucabair.TIPO_PIEZA_FASE WHERE Tpf_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;
        RAISE NOTICE 'El tipo_pieza_fase % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el tipo_pieza_fase con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_tipos_maquinaria(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF TIPO_MAQUINARIA
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM TIPO_MAQUINARIA 
        WHERE (p_search = '' OR Tim_nombre ILIKE '%' || p_search || '%' )
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_tipo_maquinaria_fase(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.TIPO_MAQUINARIA_CONFIGURACION
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 100 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 100 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.TIPO_MAQUINARIA_CONFIGURACION 
        WHERE (p_search = '' OR Fk_tipo_maquinaria::text ILIKE '%' || p_search || '%' 
                                OR Fk_fase_configuracion::text ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE crear_tipo_maquinaria_fase(
    IN p_fk_tipo_maquinaria INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_fk_tipo_maquinaria IS NULL THEN
        RAISE EXCEPTION 'El tipo de pieza no puede ser NULL';
    END IF;
    
    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        INSERT INTO ucabair.TIPO_MAQUINARIA_CONFIGURACION (Fk_tipo_maquinaria, Fk_fase_configuracion)
        VALUES (p_fk_tipo_maquinaria, p_fk_fase_configuracion);

        RAISE NOTICE 'Inserción exitosa en la tabla tipo_maquinaria_configuracion';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en TIPO_MAQUINARIA_CONFIGURACION: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_tipo_maquinaria_fase(
    IN p_codigo INT,
    IN p_fk_tipo_maquinaria INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_fk_tipo_maquinaria IS NULL THEN
        RAISE EXCEPTION 'El tipo de maquinaria no puede ser NULL';
    END IF;

    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        UPDATE ucabair.TIPO_MAQUINARIA_CONFIGURACION
        SET Fk_tipo_maquinaria = p_fk_tipo_maquinaria,
            Fk_fase_configuracion = p_fk_fase_configuracion
        WHERE Tmc_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar la tabla%', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_tipo_maquinaria_fase(p_codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        DELETE FROM ucabair.TIPO_MAQUINARIA_CONFIGURACION WHERE Tmc_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;
        RAISE NOTICE 'El tipo_maquinaria_configuracion % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el tipo_maquinaria_configuracion con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_cargos(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF CARGO
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM CARGO
        WHERE (p_search = '' OR Car_nombre ILIKE '%' || p_search || '%' )
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

--Cargo_configuracion CRUD

CREATE OR REPLACE FUNCTION leer_cargo_fase(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.CARGO_CONFIGURACION
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 100 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 100 caracteres';
    END IF;

    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.CARGO_CONFIGURACION 
        WHERE (p_search = '' OR Fk_cargo::text ILIKE '%' || p_search || '%' 
                                OR Fk_fase_configuracion::text ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE crear_cargo_fase(
    IN p_fk_cargo INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_fk_cargo IS NULL THEN
        RAISE EXCEPTION 'El cargo no puede ser NULL';
    END IF;
    
    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        INSERT INTO ucabair.CARGO_CONFIGURACION (Fk_cargo, Fk_fase_configuracion)
        VALUES (p_fk_cargo, p_fk_fase_configuracion);

        RAISE NOTICE 'Inserción exitosa en la tabla CARGO_CONFIGURACION';
    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al insertar en CARGO_CONFIGURACION: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE actualizar_cargo_fase(
    IN p_codigo INT,
    IN p_fk_cargo INT,
    IN p_fk_fase_configuracion INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;
    
    IF p_fk_cargo IS NULL THEN
        RAISE EXCEPTION 'El cargo no puede ser NULL';
    END IF;

    IF p_fk_fase_configuracion IS NULL THEN
        RAISE EXCEPTION 'La fase de configuración no puede ser NULL';
    END IF;

    BEGIN
        UPDATE ucabair.CARGO_CONFIGURACION
        SET Fk_cargo = p_fk_cargo,
            Fk_fase_configuracion = p_fk_fase_configuracion
        WHERE Cac_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;

        RAISE NOTICE 'Actualización exitosa en la tabla';

    EXCEPTION
        WHEN unique_violation THEN
            RAISE EXCEPTION 'Violación de clave única: %', SQLERRM;
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ha ocurrido un error al actualizar la tabla%', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE eliminar_cargo_fase(p_codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        DELETE FROM ucabair.CARGO_CONFIGURACION WHERE Cac_codigo = p_codigo;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró un registro con el código %', p_codigo;
        END IF;
        RAISE NOTICE 'El CARGO_CONFIGURACION % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Violación de clave foránea: %', SQLERRM;
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Error al intentar eliminar el CARGO_CONFIGURACION con código %: %', p_codigo, SQLERRM;
    END;
END;
$$;

--Funcion que retorna una lista de pagos realizados a proveedores por periodo de tiempo (Para el reporte 17)

CREATE OR REPLACE FUNCTION obtener_pagos(
    fecha_inicio DATE,
    fecha_fin DATE
)
RETURNS TABLE(
    "ID de pago" INTEGER,
    "Monto" DOUBLE PRECISION,
    "Fecha de pago" DATE,
    "Proveedor" VARCHAR,
    "Num de compra" INTEGER,
    "Fecha de compra" TIMESTAMP
) 
LANGUAGE plpgsql
AS $$
BEGIN
    IF fecha_inicio > fecha_fin THEN
    RAISE EXCEPTION 'La fecha de inicio no puede ser mayor que la fecha de fin.';
    END IF;

    RETURN QUERY
    SELECT 
    p.Pag_codigo,
    p.Pag_monto,
    p.pag_fecha,
    pj.Per_nombre,
    c.Com_numero_compra,
    c.Com_fecha_hora
FROM 
    pago p, 
    persona_juridica pj, 
    compra c 
WHERE 
    pj.per_codigo=c.fk_persona_juridica and 
    c.com_codigo= p.fk_compra and 
    p.Pag_fecha BETWEEN fecha_inicio AND fecha_fin
ORDER BY 
    p.Pag_fecha;
END;
$$;

CREATE OR REPLACE FUNCTION registrar_entrada_inventario()
RETURNS TRIGGER AS $$
DECLARE
    v_id_almacen INTEGER;
    v_id_inventario INTEGER;

BEGIN
    --Obtengo el ID del almacén de la sede "Catia La Mar" donde el tipo de planta es "Planta de Almacenamiento"
    SELECT a.alm_codigo INTO v_id_almacen
    FROM almacen a, planta p, tipo_planta tp, sede s 
    WHERE 
        a.fk_planta=p.pla_nro_planta and 
        p.fk_tipo_planta=tp.tip_codigo and 
        p.fk_sede=s.sed_codigo and 
        s.sed_nombre='Sede Central' and 
        tp.tip_nombre_tipo='Planta de Almacenamiento';

    --Verifico si se encontró un almacen
    IF v_id_almacen IS NOT NULL THEN

        -- Verifico si el material ya existe en el inventario
        SELECT Inv_codigo INTO v_id_inventario
        FROM INVENTARIO
        WHERE Fk_almacen = v_id_almacen AND Fk_materia_prima = NEW.Fk_materia_prima
        LIMIT 1;

        IF v_id_inventario IS NOT NULL THEN
            -- Si el material ya existe, actualizo la cantidad disponible
            UPDATE INVENTARIO
            SET Inv_cantidad_disponible = Inv_cantidad_disponible + 150
            WHERE Inv_codigo = v_id_invenatario;

            -- Inserto en la tabla MOVIMIENTO
            INSERT INTO MOVIMIENTO (Mov_tipo_transaccion, Mov_cantidad, Mov_fecha, Fk_inventario)
            VALUES ('ENTRADA', 150, NOW(), v_id_inventario); 

        ELSE
            -- Si el material no existe, inserto un nuevo registro en INVENTARIO
            INSERT INTO INVENTARIO (Inv_cantidad_disponible, Fk_almacen, Fk_materia_prima)
            VALUES (150, v_id_almacen, NEW.Fk_materia_prima);

            -- Obtengo el ID del inventario recién creado
            SELECT currval(pg_get_serial_sequence('INVENTARIO', 'inv_codigo')) INTO v_id_inventario;

            -- Inserto en la tabla MOVIMIENTO
            INSERT INTO MOVIMIENTO (Mov_tipo_transaccion, Mov_cantidad, Mov_fecha, Fk_inventario)
            VALUES ('ENTRADA', 150, NOW(), v_id_inventario); 
        END IF;   
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_entrada_en_inventario()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Fk_zona IN (SELECT Z.Zon_codigo 
                       FROM ZONA Z 
                       JOIN AREA A ON Z.Fk_area = A.Are_codigo
                       JOIN PLANTA P ON A.Fk_planta = P.Pla_nro_planta
                       WHERE Z.Fk_area = 29 AND A.Fk_planta = 23 AND P.Fk_sede = 1) THEN
        PERFORM registrar_entrada_inventario();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE generar_compra_materia_prima(p_fk_materia_prima INTEGER, p_fk_almacen INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_proveedor_id INTEGER;
    v_precio DOUBLE PRECISION;
    v_cantidad INTEGER;
    v_total DOUBLE PRECISION;
    v_num_compra INTEGER;
    v_fk_tipo_materia INTEGER;
    v_fk_sede INTEGER;
BEGIN
    v_cantidad := 150;
    v_num_compra := floor(random() * 100 + 1);

    SELECT Sed_codigo INTO v_fk_sede
    FROM SEDE S, PLANTA P, ALMACEN A
    WHERE A.Alm_codigo = p_fk_almacen AND P.Pla_nro_planta = A.Fk_planta AND S.Sed_codigo = P.Fk_sede;

    SELECT Fk_tipo_materia_prima INTO v_fk_tipo_materia
    FROM MATERIA_PRIMA
    WHERE Mat_codigo = p_fk_materia_prima;

    -- Buscar el proveedor y el precio de la materia prima
    SELECT Fk_persona_juridica, Ptm_precio
    INTO v_proveedor_id, v_precio
    FROM PROVEEDOR_TIPO_MATERIA
    WHERE Fk_tipo_materia_prima = v_fk_tipo_materia
    LIMIT 1;

    -- Verificar si se encontró un proveedor
    IF v_proveedor_id IS NOT NULL THEN
        -- Calcular el total de la compra
        v_total := v_precio * v_cantidad;

        -- Insertar la compra en la tabla COMPRA
        INSERT INTO COMPRA (Com_fecha_hora, Com_monto_total, Com_numero_compra, Fk_persona_juridica, Fk_sede)
        VALUES (NOW(), v_total, v_num_compra, v_proveedor_id, v_fk_sede);

        RAISE NOTICE 'Compra insertada en COMPRA';

        -- Insertar el detalle de la compra en la tabla DETALLE_COMPRA
        INSERT INTO DETALLE_COMPRA (Dec_cantidad, Dec_precio_unit, Fk_compra, Fk_materia_prima)
        VALUES (v_cantidad, v_precio, LASTVAL(), p_fk_materia_prima);

        RAISE NOTICE 'Detalle de compra insertado en DETALLE_COMPRA';

        RAISE NOTICE 'Compra generada exitosamente para la materia prima %', p_fk_materia_prima;
    ELSE
        RAISE EXCEPTION 'No se encontró un proveedor para la materia prima %', p_fk_materia_prima;
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION trigger_generar_compra()
RETURNS TRIGGER AS $$
BEGIN
    CALL generar_compra_materia_prima(NEW.Fk_materia_prima, NEW.Fk_almacen);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION leer_compras_generadas(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE (
    com_codigo INTEGER,
    com_fecha_hora TIMESTAMP,
    com_monto_total DOUBLE PRECISION,
    com_numero_compra INTEGER,
    per_nombre VARCHAR,
    mat_nombre VARCHAR,
    dec_cantidad REAL,
    dec_precio_unit REAL,
    sed_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    p_offset := (p_page - 1) * p_limit;

    RETURN QUERY
    SELECT 
        c.Com_codigo,
        c.Com_fecha_hora, 
        c.Com_monto_total, 
        c.Com_numero_compra, 
        p.Per_nombre, 
        m.Mat_nombre, 
        dc.Dec_cantidad, 
        dc.Dec_precio_unit, 
        s.Sed_nombre
    FROM COMPRA c
    JOIN DETALLE_COMPRA dc ON c.Com_codigo = dc.Fk_compra
    JOIN MATERIA_PRIMA m ON dc.Fk_materia_prima = m.Mat_codigo
    JOIN PERSONA_JURIDICA p ON c.Fk_persona_juridica = p.Per_codigo
    JOIN SEDE s ON c.Fk_sede = s.Sed_codigo
    WHERE (p_search = '' OR p.Per_nombre ILIKE '%' || p_search || '%'
                       OR m.Mat_nombre ILIKE '%' || p_search || '%')
    ORDER BY c.Com_fecha_hora DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$;

CREATE OR REPLACE PROCEDURE registrar_pago_compra(
    p_monto DOUBLE PRECISION,
    p_fk_tasa_cambio INTEGER,
    p_fk_metodo_pago INTEGER,
    p_fk_compra INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_monto_total DOUBLE PRECISION;
    v_monto_pagado DOUBLE PRECISION;
BEGIN
    -- Obtengo el monto total de la compra
    SELECT Com_monto_total INTO v_monto_total
    FROM COMPRA
    WHERE Com_codigo = p_fk_compra;

    -- Obtengo la suma de los montos pagados hasta el momento para esta compra
    SELECT COALESCE(SUM(Pag_monto), 0) INTO v_monto_pagado
    FROM PAGO
    WHERE Fk_compra = p_fk_compra;

    -- Verifico que el monto del pago sea mayor a 0
    IF p_monto <= 0 THEN
        RAISE EXCEPTION 'El monto del pago debe ser mayor que 0.';
    END IF;

    -- Verifico que el monto del pago no supere el monto restante de la compra
    IF (v_monto_pagado + p_monto) > v_monto_total THEN
        RAISE EXCEPTION 'El monto total pagado no puede ser mayor al monto restante de la compra.';
    END IF;

    -- Inserto el pago con la fecha actual del sistema
    INSERT INTO PAGO (Pag_monto, Pag_fecha, Fk_tasa_cambio, Fk_metodo_pago, Fk_compra)
    VALUES (p_monto, CURRENT_DATE, p_fk_tasa_cambio, p_fk_metodo_pago, p_fk_compra);
END;
$$;

CREATE OR REPLACE FUNCTION leer_metodos_pago(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF METODO_PAGO
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;
    p_offset := (p_page - 1) * p_limit;
    BEGIN
        RETURN QUERY
        SELECT *
        FROM METODO_PAGO
        WHERE (p_search = '' OR Met_tipo ILIKE '%' || p_search || '%'
                               OR Efe_denominacion ILIKE '%' || p_search || '%')
        LIMIT p_limit
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

CREATE OR REPLACE FUNCTION leer_tasas_cambio(
    p_search VARCHAR DEFAULT ''
) RETURNS TABLE (
    tac_codigo INTEGER,
    tac_nombre VARCHAR,
    tac_valor DOUBLE PRECISION,
    tac_fecha DATE,
    tac_fecha_final DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validación del parámetro de entrada
    IF LENGTH(p_search) > 200 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 200 caracteres';
    END IF;

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT
            tc.Tac_codigo, 
            tc.Tac_nombre, 
            tc.Tac_valor, 
            tc.Tac_fecha, 
            tc.Tac_fecha_final
        FROM TASA_CAMBIO tc
        WHERE (p_search = '' OR tc.Tac_nombre ILIKE '%' || p_search || '%')
        ORDER BY tc.Tac_fecha DESC
        LIMIT 2;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;

-- ########################################################################################
-- CREACIÓN DE LOS TRIGGERS DE LA BASE DE DATOS

CREATE TRIGGER trigger_registrar_entrada_inventario
AFTER UPDATE OF prp_aceptado ON PROCESO_PRUEBA
FOR EACH ROW
WHEN (NEW.prp_aceptado = TRUE)
EXECUTE FUNCTION registrar_entrada_inventario();

CREATE TRIGGER trigger_verificar_inventario
AFTER UPDATE OF Inv_cantidad_disponible ON INVENTARIO
FOR EACH ROW
WHEN (NEW.Inv_cantidad_disponible >= 100 AND NEW.Inv_cantidad_disponible <= 150)
EXECUTE FUNCTION trigger_generar_compra();