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
--Ejemplo de llamadas (exitosa/fallida) DESCOMENTAR PARA PROBAR
--CALL crear_modelo_avion('Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);
--CALL crear_modelo_avion(NULL, 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

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
--Llamado con Parámetros por Defecto:
--SELECT * FROM leer_modelos_avion();
--Llamado con Límite 10 y Página 2
--SELECT * FROM leer_modelos_avion(10, 2);
--Página 1, con Búsqueda y Límite 10:
--SELECT * FROM leer_modelos_avion(10, 1,'Boeing');

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
    -- Verificar si p_codigo es NULL
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
--Ejemplo de llamadas (exitosa/fallida) DESCOMENTAR PARA PROBAR
--CALL actualizar_modelo_avion(1,'Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);
--CALL actualizar_modelo_avion(NULL,'Boeing 747', 'Avión de pasajeros', 70.66, 64.44, 19.41, 183500);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_modelo_avion(
    IN p_codigo INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificación de la existencia del registro
    IF NOT EXISTS (SELECT 1 FROM MODELO_AVION WHERE Moa_codigo = p_codigo) THEN
        RAISE NOTICE 'No se encontró un modelo de avión con el código %', p_codigo;
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM MODELO_AVION WHERE Moa_codigo = p_codigo;
        RAISE NOTICE 'El modelo de avión con el código % ha sido eliminado.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede eliminar el modelo de avión con el código % porque está referenciado en la tabla AVION.', p_codigo;
    END;
END;
$$;
--CALL eliminar_modelo_avion(34);

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
--Ejemplo de llamadas (exitosa/fallida):
--CALL crear_prueba('Inspección de Fuselaje', 'Evaluación estructural del fuselaje para detectar grietas o deformaciones.', 180, 2);
--CALL crear_prueba(NULL, 'Evaluación estructural del fuselaje para detectar grietas o deformaciones.', 180, 2);

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
--Llamado con Parámetros por Defecto:
--SELECT * FROM leer_pruebas();
--Llamado con Límite 10 y Página 2
--SELECT * FROM leer_pruebas(10, 2);
--Página 1, con Búsqueda y Límite 10:
 
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
    -- Verificar si p_codigo es NULL
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
-- Ejemplo de llamada exitosa
--CALL actualizar_prueba(1, 'Inspección de Fuselaje Actualizada', 'Evaluación estructural actualizada del fuselaje.', 200, 2);
-- Ejemplo de llamada fallida
-- CALL actualizar_prueba(NULL, 'Inspección de Fuselaje Actualizada', 'Evaluación estructural actualizada del fuselaje.', 200, 2);

--DELETE
CREATE OR REPLACE PROCEDURE eliminar_prueba(
    IN p_codigo INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificación de la existencia del registro
    IF NOT EXISTS (SELECT 1 FROM ucabair.prueba WHERE pru_codigo = p_codigo) THEN
        RAISE NOTICE 'No se encontró una prueba con el código %', p_codigo;
    END IF;

    -- Intentar eliminar el registro
    BEGIN
        DELETE FROM ucabair.prueba WHERE pru_codigo = p_codigo;
        RAISE NOTICE 'La prueba con el código % ha sido eliminada.', p_codigo;
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'No se puede eliminar la prueba con el código % porque está referenciada en otra tabla.', p_codigo;
    END;
END;
$$;
-- Ejemplo de llamada exitosa
--CALL eliminar_prueba(1);
-- Ejemplo de llamada fallida (si la prueba no existe o tiene una restricción de clave foránea)
-- CALL eliminar_prueba(100);
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

--Ejemplo:
--SELECT * FROM leer_tipos_pieza(10, 1, 'Motor');
--SELECT * FROM leer_tipos_pieza();