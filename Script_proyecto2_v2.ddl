-- Generado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   en:        2024-10-17 21:17:50 CST
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE aerolinea (
    id_aerolinea     INTEGER NOT NULL,
    codigo_oaci      VARCHAR2(10) NOT NULL,
    nombre           VARCHAR2(100) NOT NULL,
    ciudad_id_ciudad INTEGER NOT NULL
);

ALTER TABLE aerolinea ADD CONSTRAINT aerolinea_pk PRIMARY KEY ( id_aerolinea );

CREATE TABLE aeropuerto (
    id_aeropuerto     INTEGER NOT NULL,
    codigo_iata       VARCHAR2(10) NOT NULL,
    nombre            VARCHAR2(250) NOT NULL,
    direccion         VARCHAR2(250) NOT NULL,
    pista_extendida   NUMBER NOT NULL,
    servicio_aduanero NUMBER NOT NULL,
    ciudad_id_ciudad  INTEGER NOT NULL
);

ALTER TABLE aeropuerto ADD CONSTRAINT aeropuerto_pk PRIMARY KEY ( id_aeropuerto );

CREATE TABLE asientos (
    id_asiento     INTEGER NOT NULL,
    numero_asiento INTEGER NOT NULL,
    clase          VARCHAR2(25) NOT NULL,
    avion_id_avion INTEGER NOT NULL
);

ALTER TABLE asientos ADD CONSTRAINT asientos_pk PRIMARY KEY ( id_asiento );

CREATE TABLE avion (
    id_avion               INTEGER NOT NULL,
    matricula              VARCHAR2(15) NOT NULL,
    modelo                 VARCHAR2(25) NOT NULL,
    capacidad              INTEGER NOT NULL,
    estado                 NUMBER NOT NULL,
    alcance                INTEGER,
    aerolinea_id_aerolinea INTEGER NOT NULL
);

ALTER TABLE avion ADD CONSTRAINT avion_pk PRIMARY KEY ( id_avion );

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

ALTER TABLE boleto ADD CONSTRAINT boleto_pk PRIMARY KEY ( id_boleto );

CREATE TABLE cargo (
    id_cargo     INTEGER NOT NULL,
    nombre       VARCHAR2(50),
    salario_base NUMBER(10, 2) NOT NULL
);

ALTER TABLE cargo ADD CONSTRAINT cargo_pk PRIMARY KEY ( id_cargo );

CREATE TABLE ciudad (
    id_ciudad    INTEGER NOT NULL,
    nombre       VARCHAR2(50) NOT NULL,
    pais_id_pais INTEGER NOT NULL
);

ALTER TABLE ciudad ADD CONSTRAINT ciudad_pk PRIMARY KEY ( id_ciudad );

CREATE TABLE empleados (
    id_empleado            INTEGER NOT NULL,
    nombres                VARCHAR2(100) NOT NULL,
    apellidos              VARCHAR2(100) NOT NULL,
    correo                 VARCHAR2(100),
    telefono               INTEGER NOT NULL,
    direccion              VARCHAR2(100),
    nacimiento             DATE NOT NULL,
    aerolinea_id_aerolinea INTEGER NOT NULL,
    cargo_id_cargo         INTEGER NOT NULL
);

ALTER TABLE empleados ADD CONSTRAINT empleados_pk PRIMARY KEY ( id_empleado );

CREATE TABLE equipaje (
    id_equipaje               INTEGER NOT NULL,
    peso                      INTEGER,
    largo                     INTEGER,
    ancho                     INTEGER,
    alto                      INTEGER,
    estado                    VARCHAR2(20),
    pasajero_numero_pasaporte INTEGER NOT NULL,
    vuelo_id_vuelo            INTEGER NOT NULL
);

ALTER TABLE equipaje ADD CONSTRAINT equipaje_pk PRIMARY KEY ( id_equipaje );

CREATE TABLE historial (
    id_transaccion INTEGER NOT NULL,
    fecha          DATE NOT NULL,
    descripcion    VARCHAR2(250) NOT NULL,
    tipo           VARCHAR2(25) NOT NULL
);

ALTER TABLE historial ADD CONSTRAINT historial_pk PRIMARY KEY ( id_transaccion );

CREATE TABLE mantenimiento (
    id_mantenimiento INTEGER NOT NULL,
    fecha_inicio     DATE NOT NULL,
    fecha_fin        DATE NOT NULL,
    tipo             VARCHAR2(40),
    avion_id_avion   INTEGER NOT NULL
);

ALTER TABLE mantenimiento ADD CONSTRAINT mantenimiento_pk PRIMARY KEY ( id_mantenimiento );

CREATE TABLE pago (
    id_pago INTEGER NOT NULL,
    fecha   DATE NOT NULL,
    metodo  VARCHAR2(20) NOT NULL
);

ALTER TABLE pago ADD CONSTRAINT pago_pk PRIMARY KEY ( id_pago );

CREATE TABLE pais (
    id_pais INTEGER NOT NULL,
    nombre  VARCHAR2(50) NOT NULL
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( id_pais );

CREATE TABLE pasajero (
    numero_pasaporte INTEGER NOT NULL,
    nombres          VARCHAR2(100) NOT NULL,
    apellidos        VARCHAR2(100) NOT NULL,
    correo           VARCHAR2(100),
    telefono         INTEGER NOT NULL,
    nacimiento       DATE NOT NULL
);

ALTER TABLE pasajero ADD CONSTRAINT pasajero_pk PRIMARY KEY ( numero_pasaporte );

CREATE TABLE puertaembarque (
    id_puerta            INTEGER NOT NULL,
    puerta               VARCHAR2(10) NOT NULL,
    terminal_id_terminal INTEGER NOT NULL
);

ALTER TABLE puertaembarque ADD CONSTRAINT puertaembarque_pk PRIMARY KEY ( id_puerta );

CREATE TABLE reserva (
    id_reserva INTEGER NOT NULL,
    fecha      DATE NOT NULL
);

ALTER TABLE reserva ADD CONSTRAINT reserva_pk PRIMARY KEY ( id_reserva );

CREATE TABLE ruta (
    id_ruta         INTEGER NOT NULL,
    tiempo_de_vuelo INTEGER,
    distancia       INTEGER,
    origen          INTEGER NOT NULL,
    destino         INTEGER NOT NULL
);

ALTER TABLE ruta ADD CONSTRAINT ruta_pk PRIMARY KEY ( id_ruta );

CREATE TABLE tarifa (
    id_tarifa      INTEGER NOT NULL,
    clase          VARCHAR2(25) NOT NULL,
    precio         NUMBER(10, 2) NOT NULL,
    vuelo_id_vuelo INTEGER NOT NULL
);

ALTER TABLE tarifa ADD CONSTRAINT tarifa_pk PRIMARY KEY ( id_tarifa );

CREATE TABLE terminal (
    id_terminal              INTEGER NOT NULL,
    aeropuerto_id_aeropuerto INTEGER NOT NULL
);

ALTER TABLE terminal ADD CONSTRAINT terminal_pk PRIMARY KEY ( id_terminal );

CREATE TABLE tripulacion (
    id_tripulacion        INTEGER NOT NULL,
    empleados_id_empleado INTEGER NOT NULL,
    vuelo_id_vuelo        INTEGER NOT NULL
);

ALTER TABLE tripulacion ADD CONSTRAINT tripulacion_pk PRIMARY KEY ( id_tripulacion );

CREATE TABLE vuelo (
    id_vuelo                 INTEGER NOT NULL,
    fecha_salida             DATE NOT NULL,
    fecha_llegada            DATE NOT NULL,
    estado                   VARCHAR2(25) NOT NULL,
    aerolinea_id_aerolinea   INTEGER NOT NULL,
    ruta_id_ruta             INTEGER NOT NULL,
    puertaembarque_id_puerta INTEGER NOT NULL,
    avion_id_avion           INTEGER NOT NULL
);

ALTER TABLE vuelo ADD CONSTRAINT vuelo_pk PRIMARY KEY ( id_vuelo );

ALTER TABLE aerolinea
    ADD CONSTRAINT aerolinea_ciudad_fk FOREIGN KEY ( ciudad_id_ciudad )
        REFERENCES ciudad ( id_ciudad );

ALTER TABLE aeropuerto
    ADD CONSTRAINT aeropuerto_ciudad_fk FOREIGN KEY ( ciudad_id_ciudad )
        REFERENCES ciudad ( id_ciudad );

ALTER TABLE asientos
    ADD CONSTRAINT asientos_avion_fk FOREIGN KEY ( avion_id_avion )
        REFERENCES avion ( id_avion );

ALTER TABLE avion
    ADD CONSTRAINT avion_aerolinea_fk FOREIGN KEY ( aerolinea_id_aerolinea )
        REFERENCES aerolinea ( id_aerolinea );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_asientos_fk FOREIGN KEY ( asientos_id_asiento )
        REFERENCES asientos ( id_asiento );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_empleados_fk FOREIGN KEY ( empleados_id_empleado )
        REFERENCES empleados ( id_empleado );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_pago_fk FOREIGN KEY ( pago_id_pago )
        REFERENCES pago ( id_pago );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_pasajero_fk FOREIGN KEY ( pasajero_numero_pasaporte )
        REFERENCES pasajero ( numero_pasaporte );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_reserva_fk FOREIGN KEY ( reserva_id_reserva )
        REFERENCES reserva ( id_reserva );

ALTER TABLE boleto
    ADD CONSTRAINT boleto_vuelo_fk FOREIGN KEY ( vuelo_id_vuelo )
        REFERENCES vuelo ( id_vuelo );

ALTER TABLE ciudad
    ADD CONSTRAINT ciudad_pais_fk FOREIGN KEY ( pais_id_pais )
        REFERENCES pais ( id_pais );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_aerolinea_fk FOREIGN KEY ( aerolinea_id_aerolinea )
        REFERENCES aerolinea ( id_aerolinea );

ALTER TABLE empleados
    ADD CONSTRAINT empleados_cargo_fk FOREIGN KEY ( cargo_id_cargo )
        REFERENCES cargo ( id_cargo );

ALTER TABLE equipaje
    ADD CONSTRAINT equipaje_pasajero_fk FOREIGN KEY ( pasajero_numero_pasaporte )
        REFERENCES pasajero ( numero_pasaporte );

ALTER TABLE equipaje
    ADD CONSTRAINT equipaje_vuelo_fk FOREIGN KEY ( vuelo_id_vuelo )
        REFERENCES vuelo ( id_vuelo );

ALTER TABLE mantenimiento
    ADD CONSTRAINT mantenimiento_avion_fk FOREIGN KEY ( avion_id_avion )
        REFERENCES avion ( id_avion );

ALTER TABLE puertaembarque
    ADD CONSTRAINT puertaembarque_terminal_fk FOREIGN KEY ( terminal_id_terminal )
        REFERENCES terminal ( id_terminal );

ALTER TABLE ruta
    ADD CONSTRAINT ruta_aeropuerto_fk FOREIGN KEY ( origen )
        REFERENCES aeropuerto ( id_aeropuerto );

ALTER TABLE ruta
    ADD CONSTRAINT ruta_aeropuerto_fkv2 FOREIGN KEY ( destino )
        REFERENCES aeropuerto ( id_aeropuerto );

ALTER TABLE tarifa
    ADD CONSTRAINT tarifa_vuelo_fk FOREIGN KEY ( vuelo_id_vuelo )
        REFERENCES vuelo ( id_vuelo );

ALTER TABLE terminal
    ADD CONSTRAINT terminal_aeropuerto_fk FOREIGN KEY ( aeropuerto_id_aeropuerto )
        REFERENCES aeropuerto ( id_aeropuerto );

ALTER TABLE tripulacion
    ADD CONSTRAINT tripulacion_empleados_fk FOREIGN KEY ( empleados_id_empleado )
        REFERENCES empleados ( id_empleado );

ALTER TABLE tripulacion
    ADD CONSTRAINT tripulacion_vuelo_fk FOREIGN KEY ( vuelo_id_vuelo )
        REFERENCES vuelo ( id_vuelo );

ALTER TABLE vuelo
    ADD CONSTRAINT vuelo_aerolinea_fk FOREIGN KEY ( aerolinea_id_aerolinea )
        REFERENCES aerolinea ( id_aerolinea );

ALTER TABLE vuelo
    ADD CONSTRAINT vuelo_avion_fk FOREIGN KEY ( avion_id_avion )
        REFERENCES avion ( id_avion );

ALTER TABLE vuelo
    ADD CONSTRAINT vuelo_puertaembarque_fk FOREIGN KEY ( puertaembarque_id_puerta )
        REFERENCES puertaembarque ( id_puerta );

ALTER TABLE vuelo
    ADD CONSTRAINT vuelo_ruta_fk FOREIGN KEY ( ruta_id_ruta )
        REFERENCES ruta ( id_ruta );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            21
-- CREATE INDEX                             0
-- ALTER TABLE                             48
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
