-- --------------------------------------------------
1. Registrar aerolinea
-- --------------------------------------------------
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

-- --------------------------------------------------
4. Registrar avion
-- --------------------------------------------------
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
        VALUES (asiento_seq.NEXTVAL, i, 'Primera', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_ejecutiva LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera, 'Ejecutiva', (SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;

    FOR i IN 1..p_asientos_economica LOOP
        INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
        VALUES (asiento_seq.NEXTVAL, i + p_asientos_primera + p_asientos_ejecutiva,'Economica',(SELECT id_avion FROM avion WHERE matricula = p_matricula));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Avion registrado exitosamente.');
    COMMIT;
END;

----------------------------------------------------
7. Registrar pasajero
----------------------------------------------------
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


----------------------------------------------------
10. Comprar boleto
----------------------------------------------------
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
    WHERE vuelo_id_vuelo = p_vuelo_id_vuelo;

    IF v_boletos_emitidos >= v_capacidad_avion THEN
        RAISE_APPLICATION_ERROR(-20003, 'No hay asientos disponibles en este vuelo');
    END IF;

    -- Verificar si el asiento está disponible
    SELECT COUNT(*) INTO v_asiento_disponible
    FROM boleto
    WHERE vuelo_id_vuelo = p_vuelo_id_vuelo AND asientos_id_asiento = p_asientos_id_asiento;

    IF v_asiento_disponible > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El asiento ya está ocupado');
    END IF;

    
    IF p_reserva_id_reserva IS NULL OR p_reserva_id_reserva = 0 THEN
        o
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