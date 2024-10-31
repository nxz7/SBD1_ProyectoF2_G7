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


----------------------------------------------------
4. Consultar Rutas
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