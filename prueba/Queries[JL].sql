-- --------------------------------------------------
1. Consultar Vuelo
-- --------------------------------------------------
SELECT 
    v.id_vuelo AS "Código Vuelo",
    av.modelo AS "Modelo del Avión",
    COUNT(CASE WHEN b.id_boleto IS NOT NULL THEN 1 END) AS "Asientos Ocupados",
    COUNT(CASE WHEN b.id_boleto IS NULL THEN 1 END) AS "Asientos Disponibles",
    a.clase AS "Clase",
    e.nombres || ' ' || e.apellidos AS "Piloto",
    SUM(t.precio) AS "Monto Ganado"
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
    empleados e ON e.id_empleado = tr.empleados_id_empleado AND e.cargo_id_cargo = (SELECT id_cargo FROM cargo WHERE nombre = 'Piloto')
WHERE 
    v.id_vuelo = :codigo_vuelo
GROUP BY 
    v.id_vuelo, av.modelo, a.clase, e.nombres, e.apellidos;

----------------------------------------------------
4. Consultar Rutas
----------------------------------------------------
SELECT 
    r.id_ruta AS "Id Ruta",
    origen.nombre AS "Origen",
    destino.nombre AS "Destino",
    COUNT(v.id_vuelo) AS "Total de Vuelos"
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
    "Total de Vuelos" DESC
FETCH FIRST 5 ROWS ONLY;