-- REPORTES

-- --------------------------------------------------
---- 1. Consultar Vuelo
-- --------------------------------------------------

-- --------------------------------------------------
1. Consultar Vuelo
-- --------------------------------------------------

CREATE OR REPLACE PROCEDURE ConsultarVuelo (codigo_vuelo IN NUMBER) IS
BEGIN
    -- Encabezado
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Código Vuelo | Modelo del Avión | Asientos Ocupados | Asientos Disponibles | Clase   | Piloto               | Monto Ganado');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------');

    FOR vuelo_rec IN (
        SELECT 
            v.id_vuelo AS "Código Vuelo",
            av.modelo AS "Modelo del Avión",
            COUNT(CASE WHEN b.id_boleto IS NOT NULL THEN 1 END) AS "Asientos Ocupados",
            COUNT(CASE WHEN b.id_boleto IS NULL THEN 1 END) AS "Asientos Disponibles",
            a.clase AS "Clase",
            e.nombres || ' ' || e.apellidos AS "Piloto",
            SUM(CASE WHEN b.id_boleto IS NOT NULL THEN t.precio ELSE 0 END) AS "Monto Ganado"
        FROM 
            vuelo v
        JOIN 
            avion av ON v.avion_id_avion = av.id_avion
        LEFT JOIN 
            asientos a ON a.avion_id_avion = av.id_avion
        LEFT JOIN 
            boleto b ON b.asientos_id_asiento = a.id_asiento AND b.vuelo_id_vuelo = v.id_vuelo
        LEFT JOIN 
            tarifa t ON t.vuelo_id_vuelo = v.id_vuelo AND t.clase = a.clase
        JOIN 
            tripulacion tr ON tr.vuelo_id_vuelo = v.id_vuelo
        JOIN 
            empleados e ON e.id_empleado = tr.empleados_id_empleado AND e.cargo_id_cargo = (
                SELECT id_cargo FROM cargo WHERE nombre = 'Piloto'
            )
        WHERE 
            v.id_vuelo = codigo_vuelo
        GROUP BY 
            v.id_vuelo, av.modelo, a.clase, e.nombres, e.apellidos
    ) LOOP
       
        DBMS_OUTPUT.PUT_LINE(
            RPAD(vuelo_rec."Código Vuelo", 13) || ' | ' ||
            RPAD(vuelo_rec."Modelo del Avión", 15) || ' | ' ||
            RPAD(vuelo_rec."Asientos Ocupados", 17) || ' | ' ||
            RPAD(vuelo_rec."Asientos Disponibles", 20) || ' | ' ||
            RPAD(vuelo_rec."Clase", 8) || ' | ' ||
            RPAD(vuelo_rec."Piloto", 20) || ' | ' ||
            vuelo_rec."Monto Ganado"
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;



---- 2. Consultar Aviones 


CREATE OR REPLACE PROCEDURE ConsultarAviones IS
BEGIN
    -- HEADER
    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('Modelo                | Matrícula         | Aerolínea               | Estado');
    DBMS_OUTPUT.PUT_LINE('************************************************************');

    -- CURSOR DEC
    FOR avion_rec IN (
        SELECT a.modelo, a.matricula, al.nombre AS aerolinea_nombre, a.estado
        FROM avion a
        JOIN aerolinea al ON a.aerolinea_id_aerolinea = al.id_aerolinea
    ) LOOP
        -- FROMATO
        DBMS_OUTPUT.PUT_LINE(
            RPAD(avion_rec.modelo, 20) || ' | ' ||
            RPAD(avion_rec.matricula, 17) || ' | ' ||
            RPAD(avion_rec.aerolinea_nombre, 27) || ' | ' ||
            avion_rec.estado
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('************************************************************');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

SET SERVEROUTPUT ON;




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




----------------------------------------------------
---- 4. Consultar Rutas
----------------------------------------------------
CREATE OR REPLACE PROCEDURE ConsultarRutas IS
BEGIN
    -- Encabezado
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('ID Ruta | Origen               | Destino              | Total de Vuelos');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');

    FOR ruta_rec IN (
        SELECT 
            r.id_ruta AS id_ruta,
            origen.nombre AS origen,
            destino.nombre AS destino,
            COUNT(v.id_vuelo) AS total_vuelos
        FROM 
            ruta r
        JOIN 
            aeropuerto origen ON r.origen = origen.id_aeropuerto
        JOIN 
            aeropuerto destino ON r.destino = destino.id_aeropuerto
        JOIN 
            vuelo v ON v.ruta_id_ruta = r.id_ruta
        GROUP BY 
            r.id_ruta, origen.nombre, destino.nombre
        ORDER BY 
            total_vuelos DESC
        FETCH FIRST 5 ROWS ONLY
    ) LOOP
        
        DBMS_OUTPUT.PUT_LINE(
            RPAD(ruta_rec.id_ruta, 8) || ' | ' ||
            RPAD(ruta_rec.origen, 20) || ' | ' ||
            RPAD(ruta_rec.destino, 20) || ' | ' ||
            ruta_rec.total_vuelos
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;


----- 5. Consultar Cancelaciones 

CREATE OR REPLACE PROCEDURE ConsultarCancelaciones IS
BEGIN
    -- Print header
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('ID Boleto | ID Vuelo | ID Asiento | Clase   | Pasajero');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');

    -- iterar
    FOR boleto_rec IN (
        SELECT 
            b.id_boleto,
            b.vuelo_id_vuelo,
            b.asientos_id_asiento,
            a.clase,
            p.nombres || ' ' || p.apellidos AS pasajero
        FROM 
            boleto b
        JOIN 
            asientos a ON b.asientos_id_asiento = a.id_asiento
        JOIN 
            pasajero p ON b.pasajero_numero_pasaporte = p.numero_pasaporte
        WHERE 
            b.estado = 'Cancelado'
    ) LOOP
        -- formato tabla
        DBMS_OUTPUT.PUT_LINE(
            RPAD(boleto_rec.id_boleto, 10) || ' | ' ||
            RPAD(boleto_rec.vuelo_id_vuelo, 9) || ' | ' ||
            RPAD(boleto_rec.asientos_id_asiento, 11) || ' | ' ||
            RPAD(boleto_rec.clase, 8) || ' | ' ||
            boleto_rec.pasajero
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;





---- -- 6. Insertar Columna


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