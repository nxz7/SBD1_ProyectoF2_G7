INSERT INTO pais (id_pais, nombre)
VALUES (1, 'United States');

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (1, 'Los Angeles', 1);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (2, 'New York', 1);

INSERT INTO aeropuerto (id_aeropuerto, codigo_iata, nombre, direccion, pista_extendida, servicio_aduanero, ciudad_id_ciudad)
VALUES (1,'LAX', 'Los Angeles International', 'USA, California', 1, 1, 1);



INSERT INTO aerolinea (id_aerolinea, codigo_oaci, nombre, ciudad_id_ciudad)
VALUES (1, 'AA', 'American Airlines', 1);


-- Insert into cargo

INSERT INTO cargo (id_cargo, nombre, salario_base)
VALUES (1, 'Piloto', 9000);

INSERT INTO cargo (id_cargo, nombre, salario_base)
VALUES (2, 'Copiloto', 6000);

INSERT INTO cargo (id_cargo, nombre, salario_base)
VALUES (3, 'Asistente', 3000);


-- Insert into empleado
INSERT INTO empleado (id_empleado, nombres, apellidos, correo, telefono, direccion, nacimiento, aerolinea_id_aerolinea, cargo_id_cargo)
VALUES (1, 'John', 'Doe', 'john.doe@example.com', 5551234, 'Zona 1', 22-05-2002, 1, 2);


INSERT INTO vuelo (id_vuelo, fecha_salida, fecha_llegada, estado, aerolinea_id_aerolinea, ruta_id_ruta, puertaembarque_id_puerta, avion_id_avion)
VALUES (1, TO_DATE('2024-10-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-10-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 1, 1, 1, 1)

INSERT INTO pasajero (numero_pasaporte, nombres, apellidos, correo, telefono, nacimiento)
VALUES (1203, 'Jane', 'Smith', 'jane.smith@example.com', 5554321, TO_DATE('2000-04-15', 'YYYY-MM-DD'));

INSERT INTO pago (id_pago, fecha, metodo)
VALUES (1, TO_DATE('2024-02-01', 'YYYY-MM-DD'), 'Tarjeta Credito');

INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
VALUES (1, 105, 'Primera Clase', 1);

-- EJEMPLOS

--- Registrar empleado
EXEC registrar_empleado(
    1001, 'Juan', 'Perez', 'juan.perez@example.com', 555123456, 
    'Av. Siempre Viva 742', 1, TO_DATE('1990-05-15', 'YYYY-MM-DD'), 1
);

--- Se inserta id empleado y id_vuelo
EXEC asignar_tripulacion(1001,1);

--- Se inserta codigo Aeropuerto, Terminal y Lista de puertas de embarque
EXEC registrar_puertas_embarque('LAX', '1', 'A1,A2,A3');

-- Cancelar reservacion, con id_reserva, para cambiar estado de boletos.
EXEC cancelar_reservacion(1);

-- Consulta con id_aerolinea como parametro
EXEC consultar_empleados(1);

-- Mostrar información de salarios de empleados, en numeros y letras.
EXEC insertar_columna;












---- 
INSERT INTO reserva (id_reserva, fecha)
VALUES (1, TO_DATE('2024-02-01', 'YYYY-MM-DD'));



CREATE TABLE reserva (
    id_reserva INTEGER NOT NULL,
    fecha      DATE NOT NULL
);

CREATE TABLE boleto (
    id_boleto                 INTEGER NOT NULL,
    estado                    VARCHAR2(25) NOT NULL,
    fecha                     DATE NOT NULL,
    vuelo_id_vuelo            INTEGER NOT NULL,
    pasajero_numero_pasaporte INTEGER NOT NULL,
    pago_id_pago              INTEGER NOT NULL,
    reserva_id_reserva        INTEGER NOT NULL,
    asientos_id_asiento       INTEGER NOT NULL,
    empleados_id_empleado     INTEGER NOT NULL
);

INSERT INTO boleto (id_boleto, estado, fecha, vuelo_id_vuelo, pasajero_numero_pasaporte, pago_id_pago, reserva_id_reserva, asientos_id_asiento, empleados_id_empleado)
VALUES (1, 'Pagado', TO_DATE('2024-02-01', 'YYYY-MM-DD'), 1, 1203, 1, 1, 1, 1001);

CREATE TABLE asientos (
    id_asiento     INTEGER NOT NULL,
    numero_asiento INTEGER NOT NULL,
    clase          VARCHAR2(25) NOT NULL,
    avion_id_avion INTEGER NOT NULL
);

INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion)
VALUES (1, 105, 'Primera Clase', 1);


