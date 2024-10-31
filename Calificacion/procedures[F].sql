
--- ********************************************************************
-- ****************** 1. Registrar aerolinea **************************
--- ********************************************************************

CREATE OR REPLACE PROCEDURE RegistrarAerolinea (
    p_codigo_oaci      VARCHAR2,
    p_nombre           VARCHAR2,
    p_nombre_ciudad    VARCHAR2
) AS
    v_id_ciudad INTEGER;
BEGIN
    SELECT id_ciudad INTO v_id_ciudad
    FROM CIUDAD
    WHERE nombre = p_nombre_ciudad;
    
    IF ValidarAerolinea(p_codigo_oaci) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Codigo OACI repetido.');
    ELSE
        INSERT INTO aerolinea (id_aerolinea, codigo_oaci, nombre, ciudad_id_ciudad)
        VALUES (
            AEROLINEA_SEQ.NEXTVAL,
            p_codigo_oaci,
            p_nombre,
            v_id_ciudad
        );
    END IF;  
    DBMS_OUTPUT.PUT_LINE('Aerolinea registrada exitosamente.');  
    COMMIT;
END;




--- ********************************************************************
-- ****************** 2. Registrar aeropuerto **************************
--- ********************************************************************


CREATE OR REPLACE PROCEDURE RegistrarAeropuerto(
    p_codigo_iata       VARCHAR2,
    p_nombre            VARCHAR2,
    p_direccion         VARCHAR2,
    p_pista_extendida   NUMBER,
    p_servicio_aduanero NUMBER,
    p_ciudad            VARCHAR2,
    p_pais              VARCHAR2
) IS
    v_id_ciudad   INTEGER;
    v_id_pais     INTEGER;
BEGIN
    -- Validación de que el codigo_iata no exista en la tabla aeropuerto
    DECLARE
        v_existente INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_existente
        FROM aeropuerto
        WHERE codigo_iata = p_codigo_iata;

        IF v_existente > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Error: Ya existe un aeropuerto con el mismo código IATA.');
        END IF;
    END;

    -- Validación de valores booleanos para pista_extendida y servicio_aduanero
    IF p_pista_extendida NOT IN (0, 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: El valor de pista_extendida debe ser 0 o 1.');
    END IF;

    IF p_servicio_aduanero NOT IN (0, 1) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: El valor de servicio_aduanero debe ser 0 o 1.');
    END IF;

    -- Verificar si el país existe, si no, insertarlo
    BEGIN
        SELECT id_pais INTO v_id_pais
        FROM pais
        WHERE nombre = p_pais;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO pais (id_pais, nombre)
            VALUES (pais_seq.NEXTVAL, p_pais)
            RETURNING id_pais INTO v_id_pais;
    END;

    -- Verificar si la ciudad existe, si no, insertarla
    BEGIN
        SELECT id_ciudad INTO v_id_ciudad
        FROM ciudad
        WHERE nombre = p_ciudad AND pais_id_pais = v_id_pais;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
            VALUES (ciudad_seq.NEXTVAL, p_ciudad, v_id_pais)
            RETURNING id_ciudad INTO v_id_ciudad;
    END;

    -- Insertar el aeropuerto con un id autoincremental
    INSERT INTO aeropuerto (id_aeropuerto, codigo_iata, nombre, direccion, pista_extendida, servicio_aduanero, ciudad_id_ciudad)
    VALUES (aeropuerto_seq.NEXTVAL, p_codigo_iata, p_nombre, p_direccion, p_pista_extendida, p_servicio_aduanero, v_id_ciudad);

    COMMIT;
END;



--- ********************************************************************
-- ********************** 3. Registrar puertas de embarque  **************************
--- ********************************************************************

ALTER TABLE terminal 
ADD nombre_terminal VARCHAR2(10);

CREATE OR REPLACE PROCEDURE registrar_puertas_embarque (
    p_codigo_iata    IN VARCHAR2,
    p_terminal       IN VARCHAR2, -- Se recibe como VARCHAR2 para el nombre de la terminal
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
          AND nombre_terminal = p_terminal; -- Comparación usando nombre_terminal
    EXCEPTION
        -- Si no existe, la creamos
        WHEN NO_DATA_FOUND THEN
            INSERT INTO terminal (id_terminal, aeropuerto_id_aeropuerto, nombre_terminal)
            VALUES (terminal_seq.NEXTVAL, v_id_aeropuerto, p_terminal);
            
            -- Obtener el id de la terminal recién creada
            SELECT id_terminal
            INTO v_id_terminal
            FROM terminal
            WHERE aeropuerto_id_aeropuerto = v_id_aeropuerto
              AND nombre_terminal = p_terminal;
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



--- ********************************************************************
-- ********************** 4. Registrar avion **************************
--- ********************************************************************

CREATE OR REPLACE PROCEDURE RegistrarAvion(
    p_matricula                 VARCHAR2,
    p_modelo                    VARCHAR2,
    p_capacidad                 INTEGER,
    p_estado                    CHAR,
    p_alcance                   NUMBER,
    p_codigo_oaci     			VARCHAR2,
    p_asientos_primera          INTEGER,
    p_asientos_ejecutiva        INTEGER,
    p_asientos_economica        INTEGER
) AS
	v_id_aerolinea   			INTEGER;
BEGIN
	BEGIN
		SELECT id_aerolinea INTO v_id_aerolinea
		FROM aerolinea
		WHERE codigo_oaci = p_codigo_oaci;
	
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			RAISE_APPLICATION_ERROR(-20002, 'Codigo OACI no existe.');
	END;

    IF NOT ValidarMatricula(p_matricula) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La matrícula ya está registrada.');
    END IF;

    IF NOT ModeloUnico(p_modelo) THEN
        RAISE_APPLICATION_ERROR(-20003, 'El modelo ya está registrado.');
    END IF;

    IF NOT NumeroPositivo(p_capacidad) THEN
        RAISE_APPLICATION_ERROR(-20004, 'La capacidad debe ser un número positivo.');
    END IF;

    IF NOT NumeroPositivo(p_alcance) THEN
        RAISE_APPLICATION_ERROR(-20005, 'El alcance debe ser un número positivo.');
    END IF;

    IF NOT ValidarEstado(p_estado) THEN
        RAISE_APPLICATION_ERROR(-20006, 'El estado debe ser 0 o 1.');
    END IF;

    IF NOT AsientosValidos(p_asientos_primera, p_asientos_ejecutiva, p_asientos_economica) THEN
        RAISE_APPLICATION_ERROR(-20008, 'Los asientos deben ser un número positivo.');
    END IF;

    IF NOT AsientosCapacidad(p_asientos_primera, p_asientos_economica, p_asientos_ejecutiva, p_capacidad) THEN
        RAISE_APPLICATION_ERROR(-20007, 'La suma de los asientos no coincide con la capacidad.');
    END IF;
    
    INSERT INTO avion (id_avion, matricula, modelo, capacidad, estado, alcance, aerolinea_id_aerolinea)
    VALUES (avion_seq.NEXTVAL, p_matricula, p_modelo, p_capacidad, p_estado, p_alcance, v_id_aerolinea);
        
    FOR i IN 1..p_asientos_primera LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i, 'Primera Clase', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_ejecutiva LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera, 'Clase Ejecutiva', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_economica LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera + p_asientos_ejecutiva,'Clase Económica',(SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Avion registrado exitosamente.');
    COMMIT;
END;

--- ********************************************************************
-- ********************** 5. Registrar Rutas **************************
--- ********************************************************************


CREATE OR REPLACE PROCEDURE RegistrarRuta(
    p_tiempo_vuelo INTEGER,
    p_distancia    INTEGER,
    p_origen       INTEGER,
    p_destino      INTEGER
) IS
    v_id_ruta INTEGER;
        v_origen   INTEGER;  -- Declare variable for origen
    v_destino  INTEGER; 
BEGIN

    BEGIN
    -- Verificar que el aeropuerto de origen existe
    SELECT id_aeropuerto INTO v_origen
    FROM aeropuerto
    WHERE id_aeropuerto = p_origen;
    END;

    BEGIN
    -- Verificar que el aeropuerto de destino existe
    SELECT id_aeropuerto INTO v_destino
    FROM aeropuerto
    WHERE id_aeropuerto = p_destino;
    END;

    -- Insertar la nueva ruta
    INSERT INTO ruta (id_ruta, tiempo_de_vuelo, distancia, origen, destino)
    VALUES (ruta_seq.NEXTVAL, p_tiempo_vuelo, p_distancia, p_origen, p_destino);
    
    COMMIT;
END;




--- ********************************************************************
-- **********************6. Registrar empleados**************************
--- ********************************************************************

ALTER TABLE empleados ADD (
    fecha_contratacion DATE
);

CREATE OR REPLACE PROCEDURE registrar_empleado(
    p_cod_empleado    IN INTEGER,
    p_nombres         IN VARCHAR2,
    p_apellidos       IN VARCHAR2,
    p_correo          IN VARCHAR2,
    p_telefono        IN INTEGER,
    p_direccion       IN VARCHAR2,
    p_cargo           IN INTEGER,
    p_nacimiento      IN VARCHAR2, -- Cambiado a VARCHAR2 para admitir cadenas
    p_id_aerolinea    IN INTEGER
)
IS
    v_id_cargo         cargo.id_cargo%TYPE;
    v_id_aerolinea     aerolinea.id_aerolinea%TYPE;
    v_fecha_contratacion DATE := SYSDATE; -- Fecha de contratación automática
    v_nacimiento_date  DATE;

    invalid_nombre EXCEPTION;
    invalid_apellido EXCEPTION;
    invalid_correo EXCEPTION;
    invalid_cargo EXCEPTION;
    invalid_aerolinea EXCEPTION;
    invalid_date EXCEPTION;
    invalid_telefono EXCEPTION;
    underage_employee EXCEPTION;
    duplicate_employee EXCEPTION;

    -- Patrón regex para validar el formato del correo
    v_email_pattern CONSTANT VARCHAR2(255) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
BEGIN
    -- Verificar si el empleado ya existe
    BEGIN
        SELECT 1
        INTO v_id_cargo
        FROM empleados
        WHERE id_empleado = p_cod_empleado;
        -- Si el SELECT devuelve un resultado, significa que ya existe el empleado
        RAISE duplicate_employee;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- No existe el empleado, se puede continuar
    END;

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

    -- Validar que el teléfono sea positivo
    IF p_telefono <= 0 THEN
        RAISE invalid_telefono;
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

    -- Intentar convertir p_nacimiento a DATE
    BEGIN
        v_nacimiento_date := TO_DATE(p_nacimiento, 'YYYY-MM-DD');
    EXCEPTION
        WHEN OTHERS THEN
            RAISE invalid_date;
    END;

    -- Validar que el empleado tenga al menos 18 años
    IF v_nacimiento_date > ADD_MONTHS(SYSDATE, -18 * 12) THEN
        RAISE underage_employee;
    END IF;

    -- Insertar el nuevo empleado, incluyendo la fecha de contratación
    INSERT INTO empleados (
        id_empleado, nombres, apellidos, correo, telefono, direccion, 
        nacimiento, aerolinea_id_aerolinea, cargo_id_cargo, fecha_contratacion
    ) 
    VALUES (
        p_cod_empleado, p_nombres, p_apellidos, p_correo, p_telefono, p_direccion, 
        v_nacimiento_date, p_id_aerolinea, p_cargo, v_fecha_contratacion
    );

    COMMIT;

-- Manejo de excepciones personalizadas
EXCEPTION
    WHEN duplicate_employee THEN
        RAISE_APPLICATION_ERROR(-20010, 'El empleado con el ID ' || p_cod_empleado || ' ya existe.');
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
    WHEN invalid_date THEN
        RAISE_APPLICATION_ERROR(-20006, 'La fecha de nacimiento debe estar en formato YYYY-MM-DD.');
    WHEN invalid_telefono THEN
        RAISE_APPLICATION_ERROR(-20007, 'El número de teléfono debe ser positivo.');
    WHEN underage_employee THEN
        RAISE_APPLICATION_ERROR(-20008, 'El empleado debe tener al menos 18 años.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20009, 'Ha ocurrido un error inesperado: ' || SQLERRM);
END registrar_empleado;




--- ********************************************************************
-- ********************** 7. Registrar pasajero **************************
--- ********************************************************************

CREATE OR REPLACE PROCEDURE RegistrarPasajero (
    p_numero_pasaporte  INTEGER,
    p_nombres           VARCHAR2,
    p_apellidos         VARCHAR2,
    p_nacimiento        DATE,
    p_correo            VARCHAR2,
    p_telefono          INTEGER
) AS
    v_formato VARCHAR2(50);
BEGIN
    v_formato := ValidarFormato(p_nombres, p_apellidos, p_correo);
    
    IF v_formato != 'OK' THEN
        RAISE_APPLICATION_ERROR(-20001, v_formato);
    ELSIF ValidarPasajero(p_numero_pasaporte) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Numero de pasaporte repetido.');
    ELSIF p_nacimiento > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20003, 'La fecha de nacimiento no puede ser una fecha futura.');
    ELSIF p_telefono < 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El número de teléfono no puede ser negativo.');
    ELSE
        INSERT INTO pasajero (numero_pasaporte, nombres, apellidos, nacimiento, correo, telefono)
        VALUES (
            p_numero_pasaporte,
            p_nombres,
            p_apellidos,
            p_nacimiento,
            p_correo,
            p_telefono
        );
    END IF;
    DBMS_OUTPUT.PUT_LINE('Pasajero registrado exitosamente.');
    COMMIT;
END;

--- ********************************************************************
-- ********************** 8. Registrar Vuelo **************************
--- ********************************************************************


CREATE OR REPLACE PROCEDURE RegistrarVuelo(
    p_fecha_salida        DATE,
    p_fecha_llegada       DATE,
    p_estado              VARCHAR2,
    p_avion_id            INTEGER,
    p_ruta_id             INTEGER,
    p_puertaembarque_id   INTEGER,
    p_aerolinea_id        INTEGER,
    p_primeraclase_tarifa NUMBER,
    p_ejecutiva_tarifa    NUMBER,
    p_economica_tarifa    NUMBER
) IS
    v_id_vuelo INTEGER;
    v_id_puerta INTEGER; 
    v_id_ruta INTEGER;   
    v_id_aerolinea INTEGER; 
BEGIN
    -- QUE EXISTA EL AVION Y ESTE DISPONIBLE 0
    BEGIN
        SELECT id_avion INTO v_id_vuelo
        FROM avion
        WHERE id_avion = p_avion_id AND estado = 0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, '[error] El avión con ID ' || p_avion_id || ' no existe o no está disponible.');
    END;

    -- PUERTA EXISTE
    BEGIN
        SELECT id_puerta INTO v_id_puerta
        FROM puertaembarque
        WHERE id_puerta = p_puertaembarque_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, '[error] La puerta de embarque con ID ' || p_puertaembarque_id || ' no existe.');
    END;

    -- RUTA EXISTE
    BEGIN
        SELECT id_ruta INTO v_id_ruta
        FROM ruta
        WHERE id_ruta = p_ruta_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, '[error] La ruta con ID ' || p_ruta_id || ' no existe.');
    END;

    -- AEROLINEA EXISTE
    BEGIN
        SELECT id_aerolinea INTO v_id_aerolinea
        FROM aerolinea
        WHERE id_aerolinea = p_aerolinea_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20004, '[error] La aerolínea con ID ' || p_aerolinea_id || ' no existe.');
    END;

    -- Verificar que la fecha de llegada es posterior a la fecha de salida
    IF p_fecha_llegada <= p_fecha_salida THEN
        RAISE_APPLICATION_ERROR(-20005, '[error] La fecha de llegada debe ser después de la fecha de salida.');
    END IF;

    -- Insertar vuelo
    INSERT INTO vuelo (
        id_vuelo,
        fecha_salida,
        fecha_llegada,
        estado,
        avion_id_avion,
        ruta_id_ruta,
        puertaembarque_id_puerta,
        aerolinea_id_aerolinea
    )
    VALUES (
        vuelo_seq.NEXTVAL,
        p_fecha_salida,
        p_fecha_llegada,
        p_estado,
        p_avion_id,
        v_id_ruta,           
        v_id_puerta,         
        v_id_aerolinea       
    )
    RETURNING id_vuelo INTO v_id_vuelo;

    -- Insertar tarifas
    INSERT INTO tarifa (id_tarifa, clase, precio, vuelo_id_vuelo)
    VALUES (tarifa_seq.NEXTVAL, 'Primera Clase', p_primeraclase_tarifa, v_id_vuelo);
    
    INSERT INTO tarifa (id_tarifa, clase, precio, vuelo_id_vuelo)
    VALUES (tarifa_seq.NEXTVAL, 'Clase Ejecutiva', p_ejecutiva_tarifa, v_id_vuelo);
    
    INSERT INTO tarifa (id_tarifa, clase, precio, vuelo_id_vuelo)
    VALUES (tarifa_seq.NEXTVAL, 'Clase Económica', p_economica_tarifa, v_id_vuelo);
    
    COMMIT;
END;




--- ********************************************************************
-- ********************** 9. Asignar tripulación  **************************
--- ********************************************************************

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


--- ********************************************************************
-- ********************** 10. Comprar boleto  **************************
--- ********************************************************************


--Es necesario para cuando se compre un boleto sin reserva
ALTER TABLE boleto MODIFY reserva_id_reserva NULL;

CREATE OR REPLACE PROCEDURE CompradeBoleto(
    p_vuelo_id_vuelo        INTEGER,
    p_asientos_id_asiento   INTEGER,
    p_empleados_id_empleado INTEGER,
    p_pasajero_numero_pasaporte INTEGER,
    p_reserva_id_reserva    INTEGER
) AS 
    v_vuelo_estado VARCHAR2(20);
    v_asiento_disponible INTEGER;
    v_vuelo_fecha_salida DATE;
    v_pago_id INTEGER;
    v_capacidad_avion INTEGER;
    v_boletos_emitidos INTEGER;
    v_vuelo_existe INTEGER;
    v_pasajero_existe INTEGER;
    v_reserva_existe INTEGER;
    v_cargo_nombre VARCHAR2(50);

BEGIN
    -- Validación de existencia del vuelo
    SELECT COUNT(*) INTO v_vuelo_existe
    FROM vuelo
    WHERE id_vuelo = p_vuelo_id_vuelo;

    IF v_vuelo_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El vuelo no existe');
    END IF;

    -- Validación de existencia del pasajero
    SELECT COUNT(*) INTO v_pasajero_existe
    FROM pasajero
    WHERE numero_pasaporte = p_pasajero_numero_pasaporte;

    IF v_pasajero_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El pasajero no existe');
    END IF;

    -- Validación de existencia de la reserva
    IF p_reserva_id_reserva IS NOT NULL AND p_reserva_id_reserva != 0 THEN
        SELECT COUNT(*) INTO v_reserva_existe
        FROM reserva
        WHERE id_reserva = p_reserva_id_reserva;

        IF v_reserva_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20008, 'La reserva no existe');
        END IF;
    END IF;

    -- Validación del cargo del empleado
    BEGIN
        SELECT c.nombre INTO v_cargo_nombre
        FROM empleados e
        JOIN cargo c ON e.cargo_id_cargo = c.id_cargo
        WHERE e.id_empleado = p_empleados_id_empleado;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Empleado no encontrado');
    END;

    IF v_cargo_nombre != 'Ventanilla' THEN
        RAISE_APPLICATION_ERROR(-20006, 'El empleado no es de ventanilla');
    END IF;

    -- Validación de estado y fecha de salida 
    SELECT estado, fecha_salida INTO v_vuelo_estado, v_vuelo_fecha_salida
    FROM vuelo
    WHERE id_vuelo = p_vuelo_id_vuelo;

    IF v_vuelo_estado NOT IN ('Programado', 'Disponible') OR v_vuelo_fecha_salida < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'El vuelo no está en un estado válido para vender boletos o ya ha partido');
    END IF;

    -- Verificar la capacidad del avión asignado al vuelo
    SELECT a.capacidad INTO v_capacidad_avion
    FROM avion a
    JOIN vuelo v ON a.id_avion = v.avion_id_avion
    WHERE v.id_vuelo = p_vuelo_id_vuelo;

    SELECT COUNT(*) INTO v_boletos_emitidos
    FROM boleto
    WHERE vuelo_id_vuelo = p_vuelo_id_vuelo AND estado = 'Emitido';

    IF v_boletos_emitidos >= v_capacidad_avion THEN
        RAISE_APPLICATION_ERROR(-20003, 'No hay asientos disponibles en este vuelo');
    END IF;

    -- Verificar si el asiento está disponible (solo los boletos con estado 'Emitido' ocupan el asiento)
    SELECT COUNT(*) INTO v_asiento_disponible
    FROM boleto
    WHERE vuelo_id_vuelo = p_vuelo_id_vuelo 
      AND asientos_id_asiento = p_asientos_id_asiento
      AND estado = 'Emitido';

    IF v_asiento_disponible > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El asiento ya está ocupado');
    END IF;

    -- Proceso de pago y emisión de boleto
    IF p_reserva_id_reserva IS NULL OR p_reserva_id_reserva = 0 THEN
        INSERT INTO pago (id_pago, fecha, metodo) 
        VALUES (pago_seq.NEXTVAL, SYSDATE, 'Ventanilla'); 
        SELECT pago_seq.CURRVAL INTO v_pago_id FROM dual;

        -- Insertar boleto sin reserva
        INSERT INTO boleto (
            id_boleto, estado, fecha, vuelo_id_vuelo, pasajero_numero_pasaporte, 
            pago_id_pago, asientos_id_asiento, empleados_id_empleado
        )
        VALUES (
            boleto_seq.NEXTVAL, 'Emitido', SYSDATE, p_vuelo_id_vuelo, 
            p_pasajero_numero_pasaporte, v_pago_id, 
            p_asientos_id_asiento, p_empleados_id_empleado
        );
    ELSE
        INSERT INTO pago (id_pago, fecha, metodo) 
        VALUES (pago_seq.NEXTVAL, SYSDATE, 'Reservado'); 
        SELECT pago_seq.CURRVAL INTO v_pago_id FROM dual;

        -- Insertar boleto con reserva
        INSERT INTO boleto (
            id_boleto, estado, fecha, vuelo_id_vuelo, pasajero_numero_pasaporte, 
            pago_id_pago, reserva_id_reserva, asientos_id_asiento, empleados_id_empleado
        )
        VALUES (
            boleto_seq.NEXTVAL, 'Emitido', SYSDATE, p_vuelo_id_vuelo, 
            p_pasajero_numero_pasaporte, v_pago_id, 
            p_reserva_id_reserva, p_asientos_id_asiento, p_empleados_id_empleado
        );
    END IF;

    DBMS_OUTPUT.PUT_LINE('Boleto emitido exitosamente.');
    COMMIT;
END;



--- ********************************************************************
-- ********************** 11.Aumento de Salario  **************************
--- ********************************************************************



CREATE OR REPLACE PROCEDURE AumentoSalario(
    p_empleado_id INTEGER,
    p_salario     NUMBER
) IS
    v_cargo_id INTEGER;
    v_salario_actual NUMBER;

BEGIN
    -- Validar que el empleado exista y obtener el cargo del empleado
    SELECT cargo_id_cargo INTO v_cargo_id
    FROM empleados
    WHERE id_empleado = p_empleado_id;

    -- Obtener el salario actual del cargo del empleado
    SELECT salario_base INTO v_salario_actual
    FROM cargo
    WHERE id_cargo = v_cargo_id;

    -- Validar que el nuevo salario no sea menor que el salario actual
    IF p_salario < v_salario_actual THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario nuevo no puede ser menor que el salario actual.');
    END IF;

    -- Validar que el salario ingresado no supere el límite de 99,000
    IF p_salario > 99000 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El salario ingresado excede el límite máximo de 99,000.');
    END IF;

    -- Validación de que el salario no sea negativo
    IF p_salario < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El salario no puede ser negativo.');
    END IF;

    -- Actualizar el salario base del cargo del empleado
    UPDATE cargo
    SET salario_base = p_salario
    WHERE id_cargo = v_cargo_id;

    DBMS_OUTPUT.PUT_LINE('Salario actualizado exitosamente.');
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'El empleado no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error mientras se aumentaba el salario: ' || SQLERRM);
END;



--- ********************************************************************
-- **********************  12. Cancelar Reservación  **************************
--- ********************************************************************


---Verificar si existe Id Reserva, dentro de la TABLA RESERVA., si no existe mandar error. Que no existen reservas con ese id.
-- ESTADO BOLETO CAMBIARLO A CANCELADO.

CREATE OR REPLACE PROCEDURE cancelar_reservacion (
    p_codigo_reserva IN NUMBER
)
IS
    v_reserva_existente INTEGER;
    v_reserva_cancelada INTEGER;
BEGIN
    --Verificar si la reserva existe
    SELECT COUNT(*)
    INTO v_reserva_existente
    FROM reserva
    WHERE id_reserva = p_codigo_reserva;
    
    IF v_reserva_existente = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No existen reservas con el ID especificado.');
    END IF;

    -- Verificar si los boletos ya están en estado 'Cancelado'
    SELECT COUNT(*) INTO v_reserva_cancelada
    FROM boleto
    WHERE reserva_id_reserva = p_codigo_reserva
      AND estado <> 'Cancelado';

    IF v_reserva_cancelada = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'La reserva ya está cancelada.');
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
