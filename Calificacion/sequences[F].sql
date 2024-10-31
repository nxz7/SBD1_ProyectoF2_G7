-- AutoIncrementando 'pais' table
CREATE SEQUENCE pais_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementando 'ciudad' table
CREATE SEQUENCE ciudad_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementando 'aeropuerto' table
CREATE SEQUENCE aeropuerto_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementando 'ruta' table
CREATE SEQUENCE ruta_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementando 'vuelo' table
CREATE SEQUENCE vuelo_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementando 'tarifa' table
CREATE SEQUENCE tarifa_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


-- AutoIncrementando 'historial' table
CREATE SEQUENCE historial_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- AutoIncrementado 'aerolinea' table    
CREATE SEQUENCE aerolinea_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- AutoIncrementado 'avion' table    
CREATE SEQUENCE avion_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- AutoIncrementado 'asientos' table    
CREATE SEQUENCE asiento_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- AutoIncrementado 'boleto' table    
CREATE SEQUENCE boleto_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- AutoIncrementado 'pago' table 
CREATE SEQUENCE pago_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


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

CREATE SEQUENCE seq_tripulacion_id
START WITH 1 -- Valor inicial de la secuencia
INCREMENT BY 1; -- Incremento en cada inserción
