-- AEROPUERTO

CREATE OR REPLACE TRIGGER historial_insert_aeropuerto
AFTER INSERT ON aeropuerto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aeropuerto', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_aeropuerto
AFTER UPDATE ON aeropuerto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aeropuerto', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_aeropuerto
AFTER DELETE ON aeropuerto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aeropuerto', 'delete');
END;


-- CIUDAD

CREATE OR REPLACE TRIGGER historial_insert_ciudad
AFTER INSERT ON ciudad
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ciudad', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_ciudad
AFTER UPDATE ON ciudad
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ciudad', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_ciudad
AFTER DELETE ON ciudad
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ciudad', 'delete');
END;

-- PAIS

CREATE OR REPLACE TRIGGER historial_insert_pais
AFTER INSERT ON pais
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pais', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_pais
AFTER UPDATE ON pais
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pais', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_pais
AFTER DELETE ON pais
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pais', 'delete');
END;



-- RUTA

CREATE OR REPLACE TRIGGER historial_insert_ruta
AFTER INSERT ON ruta
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ruta', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_ruta
AFTER UPDATE ON ruta
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ruta', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_ruta
AFTER DELETE ON ruta
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'ruta', 'delete');
END;


-- VUELO

CREATE OR REPLACE TRIGGER historial_insert_vuelo
AFTER INSERT ON vuelo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'vuelo', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_vuelo
AFTER UPDATE ON vuelo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'vuelo', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_vuelo
AFTER DELETE ON vuelo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'vuelo', 'delete');
END;



-- TARIFA

CREATE OR REPLACE TRIGGER historial_insert_tarifa
AFTER INSERT ON tarifa
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tarifa', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_tarifa
AFTER UPDATE ON tarifa
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tarifa', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_tarifa
AFTER DELETE ON tarifa
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tarifa', 'delete');
END;

-- Cargo

CREATE OR REPLACE TRIGGER historial_insert_cargo
AFTER INSERT ON cargo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'cargo', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_cargo
AFTER UPDATE ON cargo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'cargo', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_cargo
AFTER DELETE ON cargo
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'cargo', 'delete');
END;

--AEROLINEA

CREATE OR REPLACE TRIGGER historial_insert_aerolinea
AFTER INSERT ON aerolinea
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aerolinea', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_aerolinea
AFTER UPDATE ON aerolinea
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aerolinea', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_aerolinea
AFTER DELETE ON aerolinea
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'aerolinea', 'delete');
END;


--AVION
CREATE OR REPLACE TRIGGER historial_insert_avion
AFTER INSERT ON avion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'avion', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_avion
AFTER UPDATE ON avion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'avion', 'update');
END;

CREATE OR REPLACE TRIGGER historial_delete_avion
AFTER DELETE ON avion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'avion', 'delete');
END;

--PASAJERO
CREATE OR REPLACE TRIGGER historial_insert_pasajero
AFTER INSERT ON pasajero
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pasajero', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_pasajero
AFTER UPDATE ON pasajero
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pasajero', 'update');
END;

CREATE OR REPLACE TRIGGER historial_delete_pasajero
AFTER DELETE ON pasajero
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pasajero', 'delete');
END;

--BOLETO
CREATE OR REPLACE TRIGGER historial_insert_boleto
AFTER INSERT ON boleto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'compra boleto', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_boleto
AFTER UPDATE ON boleto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'compra boleto', 'update');
END;

CREATE OR REPLACE TRIGGER historial_delete_boleto
AFTER DELETE ON boleto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'compra boleto', 'delete');
END;

--PAGO
CREATE OR REPLACE TRIGGER historial_insert_pago
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pago', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_pago
AFTER UPDATE ON pago
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pago', 'update');
END;

CREATE OR REPLACE TRIGGER historial_delete_pago
AFTER DELETE ON pago
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'pago', 'delete');
END;


--- PUERTA EMBARQUE

CREATE OR REPLACE TRIGGER historial_insert_puertaembarque
AFTER INSERT ON puertaembarque
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'puertaembarque', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_puertaembarque
AFTER UPDATE ON puertaembarque
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'puertaembarque', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_puertaembarque
AFTER DELETE ON puertaembarque
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'puertaembarque', 'delete');
END;



--- TERMINAL


CREATE OR REPLACE TRIGGER historial_insert_terminal
AFTER INSERT ON terminal
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'terminal', 'insert');
END;

CREATE OR REPLACE TRIGGER historial_update_terminal
AFTER UPDATE ON terminal
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'terminal', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_terminal
AFTER DELETE ON terminal
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'terminal', 'delete');
END;




--- EMPLEADO



CREATE OR REPLACE TRIGGER historial_insert_empleado
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'empleados', 'insert');
END;


CREATE OR REPLACE TRIGGER historial_update_empleado
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'empleados', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_empleado
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'empleados', 'delete');
END;


-- TRIPULACIÓN


CREATE OR REPLACE TRIGGER historial_insert_tripulacion
AFTER INSERT ON tripulacion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tripulacion', 'insert');
END;


CREATE OR REPLACE TRIGGER historial_update_tripulacion
AFTER UPDATE ON tripulacion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tripulacion', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_tripulacion
AFTER DELETE ON tripulacion
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'tripulacion', 'delete');
END;

--- RESERVA

CREATE OR REPLACE TRIGGER historial_insert_reserva
AFTER INSERT ON reserva
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'reserva', 'insert');
END;


CREATE OR REPLACE TRIGGER historial_update_reserva
AFTER UPDATE ON reserva
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'reserva', 'update');
END;


CREATE OR REPLACE TRIGGER historial_delete_reserva
AFTER DELETE ON reserva
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'reserva', 'delete');
END;


--- 