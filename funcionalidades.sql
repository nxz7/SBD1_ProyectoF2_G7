-- FUNCIONALIDADES


-- 3. Registrar puertas de embarque

-- Registrar puertas de embarque que hay en terminales de cada aeropuerto.
-- Si no existe el aeropuerto mostrar error
-- Si la terminal no existe, se debe de crear.
-- Crear la puerta

---- CREAR SECUENCIAS

-- Secuencia para la tabla terminal
CREATE SEQUENCE terminal_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

-- Secuencia para la tabla puertaembarque
CREATE SEQUENCE puertaembarque_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

----- CREAR PROCEDIMIENTO

CREATE OR REPLACE PROCEDURE registrar_puertas_embarque (
    p_codigo_iata    IN VARCHAR2,
    p_terminal       IN VARCHAR2, -- Se recibe como VARCHAR2
    p_puertas        IN VARCHAR2  -- Lista de puertas separadas por comas
)
IS
    v_id_aeropuerto    aeropuerto.id_aeropuerto%TYPE;
    v_id_terminal      terminal.id_terminal%TYPE;
    v_puerta_list      DBMS_UTILITY.lname_array; -- Para manejar la lista de puertas
    v_count            INTEGER;
BEGIN
    -- Verificar si el aeropuerto existe
    BEGIN
        SELECT id_aeropuerto
        INTO v_id_aeropuerto
        FROM aeropuerto
        WHERE codigo_iata = p_codigo_iata;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'El aeropuerto con código IATA ' || p_codigo_iata || ' no existe.');
    END;

    -- Verificar si la terminal ya existe
    BEGIN
        SELECT id_terminal
        INTO v_id_terminal
        FROM terminal
        WHERE aeropuerto_id_aeropuerto = v_id_aeropuerto
          AND id_terminal = TO_NUMBER(p_terminal); -- Convertir p_terminal a número
    EXCEPTION
        -- Si no existe, la creamos
        WHEN NO_DATA_FOUND THEN
            INSERT INTO terminal (id_terminal, aeropuerto_id_aeropuerto)
            VALUES (terminal_seq.NEXTVAL, v_id_aeropuerto);
            
            -- Obtener el id de la terminal recién creada
            SELECT id_terminal
            INTO v_id_terminal
            FROM terminal
            WHERE aeropuerto_id_aeropuerto = v_id_aeropuerto
              AND id_terminal = (SELECT MAX(id_terminal) FROM terminal WHERE aeropuerto_id_aeropuerto = v_id_aeropuerto);
    END;

    -- Convertir la lista de puertas a un array
    DBMS_UTILITY.COMMA_TO_TABLE(p_puertas, v_count, v_puerta_list);

    -- Insertar cada puerta de embarque
    FOR i IN 1..v_count LOOP
        INSERT INTO puertaembarque (id_puerta, puerta, terminal_id_terminal)
        VALUES (puertaembarque_seq.NEXTVAL, v_puerta_list(i), v_id_terminal);
    END LOOP;

    COMMIT;
    
END;
/

--ejemplo

EXEC registrar_puertas_embarque('LAX', '1', 'A1,A2,A3');


-- 6. Registrar empleados

-- Código de Empleado Numérico Código personal del empleado
-- Nombres Cadena Validar solo letras
-- Apellidos Cadena Validar solo letras
-- Correo Cadena Validar formato valido
-- Teléfono Numérico Validar número valido
-- Dirección Cadena
-- Cargo Numérico Validar que exista
-- Fecha de Nacimiento Date Validad que sea valido
-- Salario Numérico Validar numero positivo, no mayor a 99,000
-- Id aerolínea tiene que ser númerico

--- PONER FECHA DE CONTRATACIÓN en la tabla empleado?
--- 


--- SE ACTUALIZA TABLA EMPLEADOS

ALTER TABLE empleados ADD (
    fecha_contratacion DATE
);

--- PROCEDIMIENTO

CREATE OR REPLACE PROCEDURE registrar_empleado(
    p_cod_empleado  IN INTEGER,
    p_nombres       IN VARCHAR2,
    p_apellidos     IN VARCHAR2,
    p_correo        IN VARCHAR2,
    p_telefono      IN INTEGER,
    p_direccion     IN VARCHAR2,
    p_cargo         IN INTEGER,
    p_nacimiento    IN DATE,
    p_id_aerolinea  IN INTEGER
)
IS
    v_id_cargo       cargo.id_cargo%TYPE;
    v_id_aerolinea   aerolinea.id_aerolinea%TYPE;
    v_fecha_contratacion DATE := SYSDATE; -- Fecha de contratación automática
    

    invalid_nombre EXCEPTION;
    invalid_apellido EXCEPTION;
    invalid_correo EXCEPTION;
    invalid_cargo EXCEPTION;
    invalid_aerolinea EXCEPTION;

    -- Patrón regex para validar el formato del correo
    v_email_pattern CONSTANT VARCHAR2(255) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
BEGIN
    -- Validar que el campo nombres contenga solo letras
    IF NOT REGEXP_LIKE(p_nombres, '^[A-Za-z ]+$') THEN
        RAISE invalid_nombre;
    END IF;

    -- Validar que el campo apellidos contenga solo letras
    IF NOT REGEXP_LIKE(p_apellidos, '^[A-Za-z ]+$') THEN
        RAISE invalid_apellido;
    END IF;

    -- Validar el formato del correo electrónico
    IF NOT REGEXP_LIKE(p_correo, v_email_pattern) THEN
        RAISE invalid_correo;
    END IF;

    -- Verificar que el cargo exista
    BEGIN
        SELECT id_cargo
        INTO v_id_cargo
        FROM cargo
        WHERE id_cargo = p_cargo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE invalid_cargo;
    END;

    -- Verificar que la aerolínea exista
    BEGIN
        SELECT id_aerolinea
        INTO v_id_aerolinea
        FROM aerolinea
        WHERE id_aerolinea = p_id_aerolinea;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE invalid_aerolinea;
    END;

    -- Insertar el nuevo empleado, incluyendo la fecha de contratación
    INSERT INTO empleados (
        id_empleado, nombres, apellidos, correo, telefono, direccion, 
        nacimiento, aerolinea_id_aerolinea, cargo_id_cargo, fecha_contratacion
    ) 
    VALUES (
        p_cod_empleado, p_nombres, p_apellidos, p_correo, p_telefono, p_direccion, 
        p_nacimiento, p_id_aerolinea, p_cargo, v_fecha_contratacion
    );

    COMMIT;

-- Manejo de excepciones personalizadas
EXCEPTION
    WHEN invalid_nombre THEN
        RAISE_APPLICATION_ERROR(-20001, 'El campo de nombres solo debe contener letras.');
    WHEN invalid_apellido THEN
        RAISE_APPLICATION_ERROR(-20002, 'El campo de apellidos solo debe contener letras.');
    WHEN invalid_correo THEN
        RAISE_APPLICATION_ERROR(-20003, 'El formato del correo es inválido.');
    WHEN invalid_cargo THEN
        RAISE_APPLICATION_ERROR(-20004, 'El cargo con id ' || p_cargo || ' no existe.');
    WHEN invalid_aerolinea THEN
        RAISE_APPLICATION_ERROR(-20005, 'La aerolínea con id ' || p_id_aerolinea || ' no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20006, 'Ha ocurrido un error inesperado: ' || SQLERRM);
END registrar_empleado;
/

--- EJEMPLO

EXEC registrar_empleado(1001, 'Juan', 'Perez', 'juan.perez@example.com', 555123456, 'Av. Siempre Viva 742', 1, TO_DATE('1990-05-15', 'YYYY-MM-DD'), 1);


-- 9. Asignar tripulación

--- Se deberá poder asignar a los empleados que van a estar en cada vuelo, la aerolínea debe 
--- coincidir, el empleado no debe estar ya asignado a otro vuelo. Y debe de haber un recuento 
--- mínimo de 2 pilotos (Piloto y Copiloto) y 3 empleados (como servidores). No se podrán 
--- asignar empleados de ventanilla a los vuelos.

-- Codigo de Empleados.
--- Codigo de Vuelo.


--- SECUENCIA


CREATE SEQUENCE seq_tripulacion_id
START WITH 1 -- Valor inicial de la secuencia
INCREMENT BY 1; -- Incremento en cada inserción


--- PROCEDIMIENTO

CREATE OR REPLACE PROCEDURE asignar_tripulacion ( 
    p_codigo_empleado IN NUMBER,
    p_codigo_vuelo    IN NUMBER
) 
IS
    v_aerolinea_empleado   INTEGER;
    v_aerolinea_vuelo      INTEGER;
    v_cargo_empleado       VARCHAR2(50);
    v_empleado_asignado    INTEGER;
    v_pilotos_actuales     INTEGER;
    v_servidores_actuales  INTEGER;
    v_piloto_minimo        CONSTANT INTEGER := 2;
    v_servidor_minimo      CONSTANT INTEGER := 3;
    v_new_tripulacion_id   INTEGER;
    v_estado_vuelo         VARCHAR2(25);
BEGIN
    -- se valida que el vuelo existe
    SELECT COUNT(*)
    INTO v_empleado_asignado
    FROM vuelo
    WHERE id_vuelo = p_codigo_vuelo;

    IF v_empleado_asignado = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El vuelo no existe.');
    END IF;

    -- se valida que el empleado existe
    SELECT COUNT(*)
    INTO v_empleado_asignado
    FROM empleados
    WHERE id_empleado = p_codigo_empleado;

    IF v_empleado_asignado = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El empleado no existe.');
    END IF;

    -- Se eliminan asignaciones del empleado en vuelos finalizados
    DELETE FROM tripulacion
    WHERE empleados_id_empleado = p_codigo_empleado
    AND vuelo_id_vuelo IN (
        SELECT id_vuelo 
        FROM vuelo
        WHERE estado = 'Finalizado'
    );

    -- Se valida que el empleado no esté asignado a otro vuelo no finalizado
    SELECT COUNT(*)
    INTO v_empleado_asignado
    FROM tripulacion t
    JOIN vuelo v ON t.vuelo_id_vuelo = v.id_vuelo
    WHERE t.empleados_id_empleado = p_codigo_empleado
    AND v.estado != 'Finalizado';

    IF v_empleado_asignado > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El empleado ya está asignado a un vuelo en curso.');
    END IF;

    -- Se valida que la aerolínea del empleado coincida con la del vuelo
    SELECT e.aerolinea_id_aerolinea, c.nombre
    INTO v_aerolinea_empleado, v_cargo_empleado
    FROM empleados e
    JOIN cargo c ON e.cargo_id_cargo = c.id_cargo
    WHERE e.id_empleado = p_codigo_empleado;

    SELECT aerolinea_id_aerolinea
    INTO v_aerolinea_vuelo
    FROM vuelo
    WHERE id_vuelo = p_codigo_vuelo;

    IF v_aerolinea_empleado != v_aerolinea_vuelo THEN
        RAISE_APPLICATION_ERROR(-20004, 'El empleado pertenece a una aerolínea diferente.');
    END IF;

    -- Se verifica que no se asignen empleados de ventanilla
    IF v_cargo_empleado = 'Ventanilla' THEN
        RAISE_APPLICATION_ERROR(-20005, 'Los empleados de ventanilla no pueden ser asignados a vuelos.');
    END IF;

    -- Se valida que se cumplan las restricciones de número mínimo de pilotos y servidores
    -- Contar los pilotos y copilotos actuales
    SELECT COUNT(*)
    INTO v_pilotos_actuales
    FROM tripulacion t
    JOIN empleados e ON t.empleados_id_empleado = e.id_empleado
    JOIN cargo c ON e.cargo_id_cargo = c.id_cargo
    WHERE t.vuelo_id_vuelo = p_codigo_vuelo
    AND (c.nombre = 'Piloto' OR c.nombre = 'Copiloto');

    -- Contar los servidores actuales
    SELECT COUNT(*)
    INTO v_servidores_actuales
    FROM tripulacion t
    JOIN empleados e ON t.empleados_id_empleado = e.id_empleado
    JOIN cargo c ON e.cargo_id_cargo = c.id_cargo
    WHERE t.vuelo_id_vuelo = p_codigo_vuelo
    AND c.nombre = 'Servidor';

    -- Se valida que no se supere el número mínimo de pilotos
    IF v_cargo_empleado = 'Piloto' OR v_cargo_empleado = 'Copiloto' THEN
        IF v_pilotos_actuales >= v_piloto_minimo THEN
            RAISE_APPLICATION_ERROR(-20006, 'Ya hay suficientes pilotos asignados al vuelo.');
        END IF;
    END IF;

    -- Se valida que no se supere el número mínimo de servidores
    IF v_cargo_empleado = 'Servidor' THEN
        IF v_servidores_actuales >= v_servidor_minimo THEN
            RAISE_APPLICATION_ERROR(-20007, 'Ya hay suficientes servidores asignados al vuelo.');
        END IF;
    END IF;

    -- Se obtiene el siguiente id de la secuencia para la tripulación
    SELECT seq_tripulacion_id.NEXTVAL
    INTO v_new_tripulacion_id
    FROM dual;

    -- Se inserta la asignación de la tripulación
    INSERT INTO tripulacion (id_tripulacion, empleados_id_empleado, vuelo_id_vuelo)
    VALUES (v_new_tripulacion_id, p_codigo_empleado, p_codigo_vuelo);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Empleado asignado exitosamente al vuelo con ID de tripulación: ' || v_new_tripulacion_id);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20008, 'Error al asignar la tripulación: ' || SQLERRM);
END;


-- 12. Cancelar Reservación

---Verificar si existe Id Reserva, dentro de la TABLA RESERVA., si no existe mandar error. Que no existen reservas con ese id.
-- ESTADO BOLETO CAMBIARLO A CANCELADO.

CREATE OR REPLACE PROCEDURE cancelar_reservacion (
    p_codigo_reserva IN NUMBER
)
IS
    v_reserva_existente INTEGER;
BEGIN
    --Verificar si la reserva existe
    SELECT COUNT(*)
    INTO v_reserva_existente
    FROM reserva
    WHERE id_reserva = p_codigo_reserva;
    
    IF v_reserva_existente = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No existen reservas con el ID especificado.');
    END IF;

    -- Se actualiza el estado de los boletos asociados a la reserva
    UPDATE boleto
    SET estado = 'Cancelado'
    WHERE reserva_id_reserva = p_codigo_reserva;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('La reservación y los boletos asociados han sido cancelados exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Error al cancelar la reservación: ' || SQLERRM);
END;


-- REPORTES


-- 3. Consultar Empleados

create or replace PROCEDURE consultar_empleados (
    p_id_aerolinea IN NUMBER
)
IS
    -- Cursor para seleccionar empleados de la aerolínea
    CURSOR empleados_cursor IS
        SELECT e.id_empleado AS codigo,
               e.nombres || ' ' || e.apellidos AS nombre_completo,
               e.nacimiento AS fecha_nacimiento,
               e.correo,
               e.telefono,
               e.direccion,
               CASE 
                   WHEN EXISTS (
                       SELECT 1
                       FROM tripulacion t
                       JOIN vuelo v ON t.vuelo_id_vuelo = v.id_vuelo
                       WHERE t.empleados_id_empleado = e.id_empleado
                       AND v.estado != 'Finalizado'
                   ) THEN 'Sí'
                   ELSE 'No'
               END AS estado
        FROM empleados e
        WHERE e.aerolinea_id_aerolinea = p_id_aerolinea;

BEGIN
    -- Encabezado
    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('Código | Nombre Completo        | Fecha Nacimiento | Correo              | Teléfono        | Dirección         | En vuelo');
    DBMS_OUTPUT.PUT_LINE('************************************************************');

    -- Recorrer los resultados del cursor
    FOR empleado_rec IN empleados_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(empleado_rec.codigo, 6) || ' | ' ||
            RPAD(empleado_rec.nombre_completo, 22) || ' | ' ||
            RPAD(TO_CHAR(empleado_rec.fecha_nacimiento, 'DD-MM-YYYY'), 15) || ' | ' ||
            RPAD(empleado_rec.correo, 20) || ' | ' ||
            RPAD(empleado_rec.telefono, 15) || ' | ' ||
            RPAD(empleado_rec.direccion, 18) || ' | ' ||
            empleado_rec.estado
        );
    END LOOP;

    -- Pie de tabla
    DBMS_OUTPUT.PUT_LINE('************************************************************');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;





-- 6. Insertar Columna


--AGREGAR Una nueva columna en empleado con el salario en letras
ALTER TABLE empleados ADD salario_letras VARCHAR2(500);

--- FUNCION Para convertir numeros a letras, creando tablas auxiliares.

create or replace FUNCTION fnNumeroALetras (p_Numero IN NUMBER)
RETURN VARCHAR2
IS
    TYPE t_MenoresDe20 IS TABLE OF VARCHAR2(32) INDEX BY PLS_INTEGER;
    TYPE t_Decenas IS TABLE OF VARCHAR2(32) INDEX BY PLS_INTEGER;
    TYPE t_Centenas IS TABLE OF VARCHAR2(32) INDEX BY PLS_INTEGER;

    v_MenoresDe20 t_MenoresDe20;
    v_Decenas     t_Decenas;
    v_Centenas    t_Centenas;

    v_EnLetras VARCHAR2(1024);

BEGIN
    -- Inicializar las tablas
    v_MenoresDe20(0) := 'cero'; 
    v_MenoresDe20(1) := 'uno'; 
    v_MenoresDe20(2) := 'dos'; 
    v_MenoresDe20(3) := 'tres'; 
    v_MenoresDe20(4) := 'cuatro'; 
    v_MenoresDe20(5) := 'cinco'; 
    v_MenoresDe20(6) := 'seis'; 
    v_MenoresDe20(7) := 'siete'; 
    v_MenoresDe20(8) := 'ocho'; 
    v_MenoresDe20(9) := 'nueve'; 
    v_MenoresDe20(10) := 'diez'; 
    v_MenoresDe20(11) := 'once'; 
    v_MenoresDe20(12) := 'doce'; 
    v_MenoresDe20(13) := 'trece'; 
    v_MenoresDe20(14) := 'catorce'; 
    v_MenoresDe20(15) := 'quince'; 
    v_MenoresDe20(16) := 'dieciséis'; 
    v_MenoresDe20(17) := 'diecisiete'; 
    v_MenoresDe20(18) := 'dieciocho'; 
    v_MenoresDe20(19) := 'diecinueve';

    v_Decenas(2) := 'veinte'; 
    v_Decenas(3) := 'treinta'; 
    v_Decenas(4) := 'cuarenta'; 
    v_Decenas(5) := 'cincuenta'; 
    v_Decenas(6) := 'sesenta'; 
    v_Decenas(7) := 'setenta'; 
    v_Decenas(8) := 'ochenta'; 
    v_Decenas(9) := 'noventa';

    v_Centenas(1) := 'cien'; 
    v_Centenas(2) := 'doscientos'; 
    v_Centenas(3) := 'trescientos'; 
    v_Centenas(4) := 'cuatrocientos'; 
    v_Centenas(5) := 'quinientos'; 
    v_Centenas(6) := 'seiscientos'; 
    v_Centenas(7) := 'setecientos'; 
    v_Centenas(8) := 'ochocientos'; 
    v_Centenas(9) := 'novecientos';

    -- Comienza la conversión
    IF p_Numero = 0 THEN
        v_EnLetras := 'cero';
    ELSIF p_Numero BETWEEN 1 AND 19 THEN
        v_EnLetras := v_MenoresDe20(p_Numero);
    ELSIF p_Numero BETWEEN 20 AND 99 THEN
        v_EnLetras := v_Decenas(TRUNC(p_Numero / 10)) 
            || CASE WHEN MOD(p_Numero, 10) > 0 THEN ' y ' || v_MenoresDe20(MOD(p_Numero, 10)) ELSE '' END;
    ELSIF p_Numero BETWEEN 100 AND 999 THEN
        v_EnLetras := CASE 
            WHEN TRUNC(p_Numero / 100) = 1 AND MOD(p_Numero, 100) = 0 THEN 'cien' 
            ELSE v_Centenas(TRUNC(p_Numero / 100)) 
        END 
        || CASE WHEN MOD(p_Numero, 100) > 0 THEN ' ' || fnNumeroALetras(MOD(p_Numero, 100)) ELSE '' END;
    ELSIF p_Numero BETWEEN 1000 AND 999999 THEN
        v_EnLetras := CASE 
            WHEN TRUNC(p_Numero / 1000) = 1 THEN 'mil' 
            ELSE fnNumeroALetras(TRUNC(p_Numero / 1000)) || ' mil' 
        END 
        || CASE WHEN MOD(p_Numero, 1000) > 0 THEN ' ' || fnNumeroALetras(MOD(p_Numero, 1000)) ELSE '' END;
    ELSIF p_Numero BETWEEN 1000000 AND 999999999 THEN
        v_EnLetras := fnNumeroALetras(TRUNC(p_Numero / 1000000)) || ' millón' 
            || CASE WHEN MOD(p_Numero, 1000000) > 0 THEN ' ' || fnNumeroALetras(MOD(p_Numero, 1000000)) ELSE '' END;
    ELSIF p_Numero BETWEEN 1000000000 AND 999999999999 THEN
        v_EnLetras := fnNumeroALetras(TRUNC(p_Numero / 1000000000)) || ' mil millones' 
            || CASE WHEN MOD(p_Numero, 1000000000) > 0 THEN ' ' || fnNumeroALetras(MOD(p_Numero, 1000000000)) ELSE '' END;
    ELSE
        v_EnLetras := 'Valor fuera de rango';
    END IF;

    RETURN v_EnLetras;
END;


--- PROCEDIMIENTO PARA MOSTRAR INFO DE EMPLEADOS.

CREATE OR REPLACE PROCEDURE insertar_columna
IS
    -- Cursor para seleccionar empleados y sus salarios
    CURSOR empleados_cursor IS
        SELECT e.id_empleado AS codigo,
               e.nombres || ' ' || e.apellidos AS nombre_completo,
               c.salario_base AS salario,
               fnNumeroALetras(c.salario_base) AS salario_en_letras
        FROM empleados e
        JOIN cargo c ON e.cargo_id_cargo = c.id_cargo;

BEGIN
    -- Encabezado
    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('Código | Nombre Completo        | Salario        | Salario en Letras');
    DBMS_OUTPUT.PUT_LINE('************************************************************');

    -- Recorrer el cursor
    FOR empleado_rec IN empleados_cursor LOOP
        -- Insertar el salario en letras en la nueva columna de la tabla empleados
        UPDATE empleados
        SET salario_letras = empleado_rec.salario_en_letras
        WHERE id_empleado = empleado_rec.codigo;

        -- Mostrar los datos
        DBMS_OUTPUT.PUT_LINE(
            RPAD(empleado_rec.codigo, 6) || ' | ' ||
            RPAD(empleado_rec.nombre_completo, 22) || ' | ' ||
            RPAD(TO_CHAR(empleado_rec.salario, '999999.99'), 15) || ' | ' ||
            empleado_rec.salario_en_letras
        );
    END LOOP;

    -- Pie de tabla
    DBMS_OUTPUT.PUT_LINE('************************************************************');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;





