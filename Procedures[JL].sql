-- --------------------------------------------------
1. Registrar aerolinea
-- --------------------------------------------------
CREATE OR REPLACE PROCEDURE RegistrarAerolínea (
    p_codigo_oaci      VARCHAR2,
    p_nombre           VARCHAR2,
    p_ciudad_id_ciudad INTEGER
) AS
BEGIN
    IF ValidarAerolínea(p_codigo_oaci) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La aerolínea ya está registrada.');
    ELSE
        INSERT INTO aerolinea (id_aerolinea, codigo_oaci, nombre, ciudad_id_ciudad)
        VALUES (
            aerolinea_seq.NEXTVAL,
            p_codigo_oaci,
            p_nombre,
            p_ciudad_id_ciudad
        );
        COMMIT;
    END IF;
END;

-- --------------------------------------------------
4. Registrar avion
-- --------------------------------------------------
CREATE OR REPLACE PROCEDURE RegistrarAvion(
    p_matricula                 VARCHAR2,
    p_modelo                    VARCHAR2,
    p_capacidad                 INTEGER,
    p_estado                    CHAR,
    p_alcance                   NUMBER,
    p_aerolinea_id_aerolinea    INTEGER,
    p_asientos_primera          INTEGER,
    p_asientos_economica        INTEGER,
    p_asientos_ejecutiva        INTEGER
) AS
BEGIN
    IF NOT ValidarIdAerolinea(p_aerolinea_id_aerolinea) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La aerolínea no existe.');
    END IF;

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
    VALUES (avion_seq.NEXTVAL, p_matricula, p_modelo, p_capacidad, p_estado, p_alcance, p_aerolinea_id_aerolinea);
        
    FOR i IN 1..p_asientos_primera LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i, 'Primera', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_economica LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera, 'Economica', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_ejecutiva LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera + p_asientos_economica,'Ejecutiva',(SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;
    COMMIT;
END;

-- --------------------------------------------------
7. Registrar pasajeros
-- --------------------------------------------------
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
        COMMIT;
    END IF;
END;


----------------------------------------------------
10. Comprar boleto
----------------------------------------------------
CREATE OR REPLACE PROCEDURE CompraBoleto(
    p_fecha                 DATE,
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

BEGIN
    -- Validacion de estado y fecha de salida validos
    SELECT estado, fecha_salida INTO v_vuelo_estado, v_vuelo_fecha_salida
    FROM vuelo
    WHERE id_vuelo = p_vuelo_id_vuelo;

    IF v_vuelo_estado != 'Programado' OR v_vuelo_fecha_salida < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'El vuelo ya ha partido o no está programado');
    END IF;

    -- Verificar si el asiento está disponible
    SELECT COUNT(*) INTO v_asiento_disponible
    FROM boleto
    WHERE vuelo_id_vuelo = p_vuelo_id_vuelo AND asientos_id_asiento = p_asientos_id_asiento;

    IF v_asiento_disponible > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El asiento ya está ocupado');
    END IF;

    -- Crear el pago asociado
    INSERT INTO pago (id_pago, fecha, metodo) 
    VALUES (pago_seq.NEXTVAL, SYSDATE, 'Efectivo'); 
    SELECT pago_seq.CURRVAL INTO v_pago_id FROM dual;

    INSERT INTO boleto (id_boleto, estado, fecha, vuelo_id_vuelo, pasajero_numero_pasaporte, pago_id_pago, reserva_id_reserva, asientos_id_asiento, empleados_id_empleado)
    VALUES (boleto_seq.NEXTVAL, 'Emitido', p_fecha, p_vuelo_id_vuelo, p_pasajero_numero_pasaporte, v_pago_id, p_reserva_id_reserva, p_asientos_id_asiento, p_empleados_id_empleado);

    DBMS_OUTPUT.PUT_LINE('Boleto emitido exitosamente.');
    COMMIT;
END;