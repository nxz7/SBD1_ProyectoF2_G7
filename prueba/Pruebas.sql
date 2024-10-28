--------------------------------
--Probar registro de aerolínea--
--------------------------------
BEGIN
    registrarAerolinea(
        p_codigo_oaci => 'EEF453',
        p_nombre => 'Aerolinea Ejemplo3',
        p_ciudad_id_ciudad => 1  -- Reemplazar con id existente en la base
    );
    DBMS_OUTPUT.PUT_LINE('Aerolínea registrada con éxito.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al registrar la aerolínea.');
END;

----------------------------
--Probar registro de avion--
----------------------------
BEGIN
    RegistrarAvion(
        p_matricula => 'XYZ456',           
        p_modelo => 'Airbus A320',           
        p_capacidad => 180,                  
        p_estado => '0',                      
        p_alcance => 6000,                   
        p_aerolinea_id_aerolinea => 2,   -- Reemplazar con id existente en la base
        p_asientos_primera => 12,            
        p_asientos_economica => 144,         
        p_asientos_ejecutiva => 24           
    );
END;


--------------------------------
--Probar registro de pasajero--
--------------------------------

BEGIN
    RegistrarPasajero(
        p_numero_pasaporte => 987654321,
        p_nombres => 'Carlos',
        p_apellidos => 'López',
        p_nacimiento => TO_DATE('1985-10-20', 'YYYY-MM-DD'),
        p_correo => 'carlos.lopez@example.com',
        p_telefono => 551295426
    );
END;

--------------------------------
--Probar comprar boleto--
--------------------------------

BEGIN
    CompraBoleto(
        p_fecha                 => SYSDATE,  
        p_vuelo_id_vuelo        => 1,                                    -- Reemplazar con id existente en la base de vuelo
        p_asientos_id_asiento   => 15,                                   -- Reemplazar con id existente en la base de asiento
        p_empleados_id_empleado => 1,                                    -- Reemplazar con id existente en la base de empleado
        p_pasajero_numero_pasaporte => 123456789,                        -- Reemplazar con numero pasaporte existente en la base de pasajero
        p_reserva_id_reserva    => 1                                     -- Reemplazar con id existente en la base de reserva
    );
END;
