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
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
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
        SELECT P.Per_codigo, P.Per_nombre, P.Per_direccion, P.Per_fecha_registro, P.Per_identificacion,
               P.Pen_segundo_nombre, P.Pen_primer_apellido, P.Pen_segundo_apellido, P.Pen_fecha_nac, 
               P.Fk_lugar, L.Lug_nombre
        FROM PERSONA_NATURAL P
        INNER JOIN LUGAR L ON P.Fk_lugar = L.Lug_codigo
        WHERE (p_search = '' OR P.Per_nombre ILIKE '%' || p_search || '%' 
                           OR P.Pen_primer_apellido ILIKE '%' || p_search || '%'
                           OR P.Pen_segundo_apellido ILIKE '%' || p_search || '%'
                           OR P.Per_identificacion ILIKE '%' || p_search || '%'
                           OR L.Lug_nombre ILIKE '%' || p_search || '%')
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
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
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
DECLARE
    p_offset INT;
BEGIN
    -- Validaciones de los parámetros de entrada
    IF p_page < 1 THEN
        RAISE EXCEPTION 'El número de página debe ser mayor o igual a 1';
    END IF;

    IF p_limit <= 0 THEN
        RAISE EXCEPTION 'El límite debe ser un número positivo';
    END IF;

    IF LENGTH(p_search) > 50 THEN
        RAISE EXCEPTION 'El término de búsqueda no puede tener más de 50 caracteres';
    END IF;

    -- Calculamos el OFFSET basado en la página y el límite
    p_offset := (p_page - 1) * p_limit;

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
                           OR L.Lug_nombre ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
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
    pri_nombre VARCHAR
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
        SELECT DISTINCT p.pri_codigo, p.pri_nombre
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
CREATE OR REPLACE FUNCTION leer_usuario_roles(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.usuario_rol
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    -- Validaciones de parámetros de entrada
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

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.usuario_rol 
        WHERE (p_search = '' OR fk_usuario::text ILIKE '%' || p_search || '%' 
                                OR fk_rol::text ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
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
CREATE OR REPLACE FUNCTION leer_rol_privilegios(
    p_limit INT DEFAULT 10,
    p_page INT DEFAULT 1,
    p_search VARCHAR DEFAULT ''
) RETURNS SETOF ucabair.rol_privilegio
LANGUAGE plpgsql
AS $$
DECLARE
    p_offset INT;
BEGIN
    -- Validaciones de parámetros de entrada
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

    -- Intentar ejecutar la consulta
    BEGIN
        RETURN QUERY
        SELECT * 
        FROM ucabair.rol_privilegio 
        WHERE (p_search = '' OR fk_rol::text ILIKE '%' || p_search || '%' 
                                OR fk_privilegio::text ILIKE '%' || p_search || '%')
        LIMIT p_limit 
        OFFSET p_offset;
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