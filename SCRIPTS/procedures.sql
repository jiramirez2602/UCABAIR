--****************************************************************************************************************************************************************
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
    BEGIN
        INSERT INTO MODELO_AVION (Moa_nombre, Moa_descripcion, Moa_longitud, Moa_envergadura, Moa_altura, Moa_peso_vacio)
        VALUES (p_nombre, p_descripcion, p_longitud, p_envergadura, p_altura, p_peso_vacio);
        RAISE NOTICE 'Inserción exitosa en la tabla MODELO_AVION';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al insertar en MODELO_AVION: %', SQLERRM;
    END;
END;
$$;
--CALL crear_modelo_avion('Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

--READ
CREATE OR REPLACE FUNCTION leer_modelos_avion(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF MODELO_AVION
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
    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM MODELO_AVION 
        WHERE (p_search = '' OR Moa_nombre ILIKE '%' || p_search || '%' 
                                OR Moa_descripcion ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
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
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        UPDATE MODELO_AVION
        SET Moa_nombre = p_nombre,
            Moa_descripcion = p_descripcion,
            Moa_longitud = p_longitud,
            Moa_envergadura = p_envergadura,
            Moa_altura = p_altura,
            Moa_peso_vacio = p_peso_vacio
        WHERE Moa_codigo = p_codigo;

        RAISE NOTICE 'Actualización exitosa en la tabla MODELO_AVION';

    EXCEPTION
        WHEN OTHERS THEN
            INSERT INTO error_logs (error_message) VALUES (SQLERRM);
            RAISE NOTICE 'Ha ocurrido un error al actualizar en MODELO_AVION: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_modelo_avion(1,'Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_modelo_avion(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intentar eliminar el registro
    DELETE FROM MODELO_AVION WHERE MODELO_AVION.Moa_codigo = codigo;
    
    -- Confirmar eliminación
    RAISE NOTICE 'El modelo de avión % ha sido eliminado.', codigo;
EXCEPTION
    -- Manejo de errores
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al intentar eliminar el modelo de avión con código %: %', codigo, SQLERRM;
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
    BEGIN
        INSERT INTO ucabair.prueba (pru_nombre, pru_descripcion, pru_duracion_estimada, fk_tipo_pieza)
        VALUES (p_nombre, p_descripcion, p_duracion_estimada, p_fk_tipo_pieza);
        RAISE NOTICE 'Inserción exitosa en la tabla PRUEBA';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al insertar en PRUEBA: %', SQLERRM;
    END;
END;
$$;
--CALL crear_prueba('Inspección de Fuselaje', 'Evaluación estructural del fuselaje para detectar grietas o deformaciones.', 180, 2);

--READ
CREATE OR REPLACE FUNCTION leer_pruebas(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.prueba
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
    p_offset := (p_page - 1) * p_limit;
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.prueba 
        WHERE (p_search = '' OR pru_nombre ILIKE '%' || p_search || '%' 
                               OR pru_descripcion ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
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
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        UPDATE ucabair.prueba
        SET pru_nombre = p_nombre,
            pru_descripcion = p_descripcion,
            pru_duracion_estimada = p_duracion_estimada,
            fk_tipo_pieza = p_fk_tipo_pieza
        WHERE pru_codigo = p_codigo;

        RAISE NOTICE 'Actualización exitosa en la tabla PRUEBA';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al actualizar en PRUEBA: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_prueba(1, 'Inspección de Fuselaje Actualizada', 'Evaluación estructural actualizada del fuselaje.', 200, 2);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_prueba(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM PRUEBA WHERE PRUEBA.Pru_codigo = codigo;
    RAISE NOTICE 'La prueba con código % ha sido eliminada.', codigo;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al intentar eliminar la prueba con código %: %', codigo, SQLERRM;
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
    -- Validación de los parámetros
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;
    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    -- Calculamos el OFFSET basado en la página y el límite
    p_offset := (p_page - 1) * p_limit;

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
END;
$$ LANGUAGE plpgsql;


--Ejemplos
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
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al insertar en PERSONA_NATURAL: %', SQLERRM;
    END;
END;
$$;
--CALL crear_persona_natural('Juan'::VARCHAR, 'Calle Falsa 123'::TEXT, '2023-12-27'::DATE, '123456789'::VARCHAR, 'Pérez'::VARCHAR, '1990-01-01'::DATE, 1::INTEGER, 'Carlos'::VARCHAR, 'Gómez'::VARCHAR);

--READ
CREATE OR REPLACE FUNCTION leer_personas_natural(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF PERSONA_NATURAL
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
    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT *
        FROM PERSONA_NATURAL
        WHERE (p_search = '' OR Per_nombre ILIKE '%' || p_search || '%' 
                           OR Pen_primer_apellido ILIKE '%' || p_search || '%'
                           OR Pen_segundo_apellido ILIKE '%' || p_search || '%'
                           OR Per_identificacion ILIKE '%' || p_search || '%')
        LIMIT p_limit
        OFFSET p_offset;
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
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

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

        RAISE NOTICE 'Actualización exitosa en la tabla PERSONA_NATURAL';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al actualizar en PERSONA_NATURAL: %', SQLERRM;
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
    IF NOT EXISTS (SELECT 1 FROM PERSONA_NATURAL WHERE Per_codigo = p_codigo) THEN
        RAISE NOTICE 'No se encontró una persona natural con el código %', p_codigo;
        RETURN;
    END IF;

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
            RAISE NOTICE 'Ha ocurrido un error al eliminar la persona natural: %', SQLERRM;
    END;

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
CREATE OR REPLACE PROCEDURE crear_empleado(
    IN p_exp_profesional INTEGER,
    IN p_titulacion VARCHAR,
    IN p_fk_persona_natural INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        INSERT INTO EMPLEADO (
            Emp_exp_profesional, Emp_titulacion, Fk_persona_natural
        )
        VALUES (
            p_exp_profesional, p_titulacion, p_fk_persona_natural
        );
        RAISE NOTICE 'Inserción exitosa en la tabla EMPLEADO';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al insertar en EMPLEADO: %', SQLERRM;
    END;
END;
$$;
--CALL crear_empleado(5, 'Ingeniero en Sistemas', 1);

--READ
CREATE OR REPLACE FUNCTION leer_empleados(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF EMPLEADO
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
    p_offset := (p_page - 1) * p_limit;

    BEGIN
        RETURN QUERY
        SELECT * 
        FROM EMPLEADO 
        WHERE (p_search = '' OR Emp_titulacion ILIKE '%' || p_search || '%' 
                                OR CAST(Emp_exp_profesional AS VARCHAR) ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Ocurrió un error al ejecutar la consulta: %', SQLERRM;
    END;
END;
$$;
--SELECT * FROM leer_empleados(10, 1, 'Ingeniero');

--UPDATE
CREATE OR REPLACE PROCEDURE actualizar_empleado(
    IN p_codigo INT,
    IN p_exp_profesional INTEGER,
    IN p_titulacion VARCHAR,
    IN p_fk_persona_natural INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_codigo IS NULL THEN
        RAISE EXCEPTION 'El código no puede ser NULL';
    END IF;

    BEGIN
        UPDATE EMPLEADO
        SET Emp_exp_profesional = p_exp_profesional,
            Emp_titulacion = p_titulacion,
            Fk_persona_natural = p_fk_persona_natural
        WHERE Emp_codigo = p_codigo;

        RAISE NOTICE 'Actualización exitosa en la tabla EMPLEADO';

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede actualizar el empleado con el código % porque está referenciado en otra tabla.', p_codigo;
        WHEN OTHERS THEN
            RAISE NOTICE 'Ha ocurrido un error al actualizar en EMPLEADO: %', SQLERRM;
    END;
END;
$$;
--CALL actualizar_empleado(1, 5, 'Ingeniero en Sistemas', 2);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_empleado(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM EMPLEADO WHERE EMPLEADO.Emp_codigo = codigo;
    RAISE NOTICE 'El empleado con código % ha sido eliminado.', codigo;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al intentar eliminar el empleado con código %: %', codigo, SQLERRM;
END;
$$;

CALL eliminar_empleado(1);


--*******************************************************************************************************************************
--CRUD PROVEEDOR
--DELETE
CREATE OR REPLACE PROCEDURE eliminar_persona_juridica(codigo INT)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM PERSONA_JURIDICA WHERE PERSONA_JURIDICA.Per_codigo = codigo;
    RAISE NOTICE 'La persona jurídica con código % ha sido eliminada.', codigo;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al intentar eliminar la persona jurídica con código %: %', codigo, SQLERRM;
END;
$$;
--CALL eliminar_persona_juridica(1); 
