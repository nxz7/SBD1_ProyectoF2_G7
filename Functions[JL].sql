-----------------------------------------------
--Validar si una aerolinea ya está registrada--
-----------------------------------------------
CREATE OR REPLACE FUNCTION ValidarAerolinea (
    p_codigo_oaci VARCHAR2
) RETURN BOOLEAN IS
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM aerolinea
    WHERE codigo_oaci = p_codigo_oaci;

    RETURN v_count > 0;
END;
--------------------------------------
---Validacion para registrar aviones--
--------------------------------------

--Validacion Matricula
CREATE OR REPLACE FUNCTION ValidarMatricula(
    p_matricula VARCHAR2
) RETURN BOOLEAN IS
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM avion
    WHERE matricula = p_matricula;

    RETURN v_count = 0;
END;

--Validacion Modelo
CREATE OR REPLACE FUNCTION ModeloUnico(
    p_modelo VARCHAR2
) RETURN BOOLEAN IS
    v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM avion
    WHERE modelo = p_modelo;

    RETURN v_count = 0;
END;

--Validacion de numero valido para capacidad, alcance y los asientos de cada clase
CREATE OR REPLACE FUNCTION NumeroPositivo(
    p_numero INTEGER
) RETURN BOOLEAN IS
BEGIN
    RETURN p_numero > 0;
END;

--Validacion de que los asientos coincidan con la capacidad
CREATE OR REPLACE FUNCTION AsientosCapacidad(
    p_asientos_primera INTEGER,
    p_asientos_economica INTEGER,
    p_asientos_ejecutiva INTEGER,
    p_capacidad INTEGER
)RETURN BOOLEAN IS
BEGIN
    RETURN p_asientos_primera + p_asientos_economica + p_asientos_ejecutiva = p_capacidad;
END;

--Validar el estado del avion
CREATE OR REPLACE FUNCTION ValidarEstado(
    p_estado CHAR
) RETURN BOOLEAN IS
BEGIN
    RETURN p_estado IN ('0', '1');
END;

--Validar ID de aerolinea
CREATE OR REPLACE FUNCTION ValidarIdAerolinea(
    p_aerolinea_id_aerolinea INTEGER
) RETURN BOOLEAN IS
	v_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM aerolinea
    WHERE id_aerolinea = p_aerolinea_id_aerolinea;

    RETURN v_count > 0;
END;

--Validar asientos 0 o mayores
CREATE OR REPLACE FUNCTION AsientosValidos(
    p_asientos_primera   INTEGER,
    p_asientos_ejecutiva INTEGER,
    p_asientos_economica INTEGER
) RETURN BOOLEAN IS
BEGIN
    RETURN p_asientos_primera >= 0 AND p_asientos_ejecutiva >= 0 AND p_asientos_economica >= 0;
END AsientosValidos;


--------------------------------------------------------
---Validacion para registrar a los pasajeros (Formato)--
--------------------------------------------------------
CREATE OR REPLACE Function ValidarFormato(
    p_nombres VARCHAR2,
    p_apellidos VARCHAR2,
    p_correo VARCHAR2
) RETURN VARCHAR2  AS
    v_patron_nombres_apellidos VARCHAR2(100) := '^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$';
    v_patron_correo VARCHAR2(100) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
BEGIN
    IF NOT REGEXP_LIKE(p_nombres, v_patron_nombres_apellidos) THEN
        RETURN 'Nombre inválido';
    END IF;

    IF NOT REGEXP_LIKE(p_apellidos, v_patron_nombres_apellidos) THEN
        RETURN 'Apellido inválido';
    END IF;

    IF NOT REGEXP_LIKE(p_correo, v_patron_correo) THEN
        RETURN 'Correo inválido';
    END IF;

    RETURN 'OK';
END;

