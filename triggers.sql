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

--- BOLETO

CREATE OR REPLACE TRIGGER historial_update_boleto
AFTER UPDATE ON boleto
FOR EACH ROW
BEGIN
    INSERT INTO historial (id_transaccion, fecha, descripcion, tipo)
    VALUES (historial_seq.NEXTVAL, SYSDATE, 'boleto', 'update');
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