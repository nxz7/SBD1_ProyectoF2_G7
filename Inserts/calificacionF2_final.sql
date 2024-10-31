-- Datos o informacion fifticia, si usan mysql usar exec en vez de call

-- 2. Registro de Aeropuerto       ********** LISTO
CALL RegistrarAeropuerto('JFK', 'John F. Kennedy International Airport', 'New York, Estados Unidos',1,1, 'New York', 'United States');
CALL RegistrarAeropuerto('ATL', 'Hartsfield-Jackson', 'Atlanta, Estados Unidos',1,1,'Atlanta', 'United States');
CALL RegistrarAeropuerto('CDG', 'Charles de Gaulle', 'Paris, FR', 0, 1, 'Paris', 'Francia');
CALL RegistrarAeropuerto('ORD', 'O’Hare International', 'Chicago, USA', 1, 1, 'Chicago', 'United States');
CALL RegistrarAeropuerto('DFW', 'Dallas/Fort Worth International', 'Dallas, USA', 1, 1, 'Dallas', 'United States');
CALL RegistrarAeropuerto('CDG', 'Los Angeles International', 'LA, USA', 1, 1, 'Los Angeles', 'United States'); -- Error iata repetido
CALL RegistrarAeropuerto('LHR', 'Heathrow', 'London, UK', 4, 1, 'London', 'England'); -- Error booleano  NO FUNCIONA
CALL RegistrarAeropuerto('LHR', 'Heathrow', 'London, UK', 1, 2, 'London', 'England'); -- Error booleano  NO FUNCIONA
-- ***********************************************************************************************

-- 1. Registro de Aerolíneas,
CALL RegistrarAerolinea('AA', 'American Airlines', 'New York');
CALL RegistrarAerolinea('DL', 'Delta Airlines', 'Atlanta');
CALL RegistrarAerolinea('UA', 'United Airlines', 'Chicago');
CALL RegistrarAerolinea('WN', 'Southwest Airlines', 'Dallas');
CALL RegistrarAerolinea('AF', 'Air France', 'Paris');
CALL RegistrarAerolinea('DL', 'British Airways', 'London');  -- Error iata repetido


-- 4. Registro de Avion
CALL RegistrarAvion('A320', 'Airbus A320', 18, 0, 1200, 'AA', 3, 5, 10);
CALL RegistrarAvion('B737', 'Boeing 737', 15, 0, 900, 'DL', 2, 3, 10);
CALL RegistrarAvion('A380', 'Airbus A380', 30, 0, 1400, 'AF', 5, 8, 17);
CALL RegistrarAvion('B787', 'Boeing 787', 20, 0, 1100, 'WN', 5, 5, 10);
CALL RegistrarAvion('B777', 'Boeing 777', 12, 0, 1300, 'AA', 2, 3, 7);
CALL RegistrarAvion('E195', 'Embraer E195', 22, 0, 700, 'DL', 5, 5, 12);
CALL RegistrarAvion('B787', 'Boeing 787 Dreamliner', 24, 0, 1250, 'AF', 5, 5, 14); -- error repetido
CALL RegistrarAvion('A350', 'Airbus A350', 30, 0, 1350, 'AF', 5, 10, 250); -- no coincide capacidad con asientos
CALL RegistrarAvion('A390', 'Airbus A390', 300, 0, 1350, 'WN', 50, 75, 150); -- no coincide capacidad con asientos
CALL RegistrarAvion('A250', 'Airbus A250', -30, 0, 1350, 'DL', 5, 10, 15); -- Capacidad negativa
CALL RegistrarAvion('A450', 'Airbus A450', 30, 0, 1350, 'AA', -5, 10, 15); -- Asientos negativos
CALL RegistrarAvion('A650', 'Airbus A650', 30, 0, 1350, 'AF', 5, -10, 15); -- alcance negativo
CALL RegistrarAvion('A750', 'Airbus A750', 30, 0, 1350, 'WN', 5, 10, -15); -- Asientos negativos
CALL RegistrarAvion('A550', 'Airbus A550', 30, 0, -1350, 'AA', 5, -10, 15); -- alcance negativo
CALL RegistrarAvion('A320', 'Airbus A320', 180, 0, 1200, 'AA', 10, 20, 150); -- Error matricula repetida
CALL RegistrarAvion('A330', 'Airbus A330', 30, 0, 1350, 'WF', 5, 10, 15); -- Error iata no existe

-- 3. Puertas de embarque
CALL registrar_puertas_embarque('JFK', 'T1', 'G1,G2,G3');
CALL registrar_puertas_embarque('JFK', 'T2', 'G4,G5,G6');
CALL registrar_puertas_embarque('CDG', 'T1', 'G7,G8');
CALL registrar_puertas_embarque('ATL', 'T3', 'G9');
CALL registrar_puertas_embarque('ORD', 'T1', 'G10,G11');
CALL registrar_puertas_embarque('DFW', 'T1', 'G12,G13');
CALL registrar_puertas_embarque('LHR', 'T1', 'G14,G15'); -- Error iata no existe
CALL registrar_puertas_embarque('JFK', 'T1', 'G4,G5,G6');

-- 5. Registro de Rutas   ********** LISTO
CALL RegistrarRuta(360, 4000,1, 4);
CALL RegistrarRuta(420, 5850, 1, 3);
CALL RegistrarRuta(270, 3120, 2, 5);
CALL RegistrarRuta(420, 5850, 3, 1);
CALL RegistrarRuta(360, 4000, 4, 1);
CALL RegistrarRuta(270, 3120, 5, 2);
CALL RegistrarRuta(420, 5850, 6, 1); -- Error origen no existe
CALL RegistrarRuta(420, 5850, 1, 6); -- Error destino no existe

-- insertar unos cargos
INSERT INTO cargo (id_cargo, nombre, salario_base) VALUES (1,'Piloto', 30000);
INSERT INTO cargo (id_cargo, nombre, salario_base) VALUES (2,'Copiloto', 25000);
INSERT INTO cargo (id_cargo, nombre, salario_base) VALUES (3,'Servidor', 12000);
INSERT INTO cargo (id_cargo, nombre, salario_base) VALUES (4,'Ventanilla', 8000);

-- 6. Registro de Empleados, si tienen el salario debe ser el mismo del cargo que tienen, deben agregarlo como parametro
-- Se agrega parametro aerolinea, para asociar un empleado a una aerolinea.
CALL registrar_empleado(1001, 'John', 'Doe', 'john.doe@airline.com', 1234567890, 'NY, USA', 1, '1985-10-15',1);
CALL registrar_empleado(1002, 'Jane', 'Smith', 'jane.smith@airline.com', 0987654321, 'LA, USA', 2, '1990-05-21',1);
CALL registrar_empleado(1003, 'Carlos', 'Perez', 'carlos.perez@airline.com', 1112223334, 'Paris, FR', 3, '1988-07-30',1);
CALL registrar_empleado(1004, 'Maria', 'Gomez', 'maria.gomez@airline.com', 3334445556, 'Atlanta, USA', 3, '1992-02-10',1);
CALL registrar_empleado(1005, 'Alice', 'Brown', 'alice.brown@airline.com', 5556667778, 'LA, USA', 3, '1989-09-22',1);
CALL registrar_empleado(1006, 'Bob', 'Williams', 'bob.williams@airline.com', 7778889990, 'NY, USA', 4, '1991-03-15',1);
CALL registrar_empleado(1007, 'David', 'Johnson', 'david.johnson@airline.com', 2223334445, 'Chicago, USA', 1, '1987-04-11',2);
CALL registrar_empleado(1008, 'Emma', 'Taylor', 'emma.taylor@airline.com', 4445556667, 'Houston, USA', 2, '1993-08-19',2);
CALL registrar_empleado(1009, 'Luis', 'Martinez', 'luis.martinez@airline.com', 6667778889, 'Madrid, ES', 3, '1984-06-17',2);
CALL registrar_empleado(1010, 'Sophia', 'Wilson', 'sophia.wilson@airline.com', 8889990001, 'Sydney, AU', 3, '1994-01-24',2);
CALL registrar_empleado(1011, 'James', 'Anderson', 'james.anderson@airline.com', 1112223335, 'Miami, USA', 3, '1995-11-03',2);
CALL registrar_empleado(1012, 'Olivia', 'Thomas', 'olivia.thomas@airline.com', 3334445557, 'London, UK', 4, '1992-12-14',5);
CALL registrar_empleado(1013, 'Ethan', 'Moore', 'ethan.moore@airline.com', 5556667779, 'Boston, USA', 1, '1985-02-23',5);
CALL registrar_empleado(1014, 'Liam', 'Jackson', 'liam.jackson@airline.com', 7778889991, 'Toronto, CA', 2, '1990-07-09',5);
CALL registrar_empleado(1015, 'Noah', 'Garcia', 'noah.garcia@airline.com', 9990001112, 'Mexico City, MX', 3, '1983-03-29',5);
CALL registrar_empleado(1016, 'Ava', 'Rodriguez', 'ava.rodriguez@airline.com', 1112223336, 'Barcelona, ES', 3, '1989-05-13',5);
CALL registrar_empleado(1017, 'Isabella', 'Martinez', 'isabella.martinez@airline.com', 2223334446, 'Berlin, DE', 3, '1996-10-06',2);
CALL registrar_empleado(1018, 'Mason', 'Lee', 'mason.lee@airline.com', 4445556668, 'Beijing, CN', 4, '1987-04-30',3);
CALL registrar_empleado(1019, 'Elijah', 'Walker', 'elijah.walker@airline.com', 6667778880, 'Dubai, UAE', 1, '1991-06-18',4);
CALL registrar_empleado(1020, 'Charlotte', 'Young', 'charlotte.young@airline.com', 8889990002, 'Tokyo, JP', 2, '1986-12-01',5);
CALL registrar_empleado(1021, 'Aiden', 'Hernandez', 'aiden.hernandez@airline.com', 9990001113, 'Amsterdam, NL', 3, '1984-09-10',1);
CALL registrar_empleado(1022, 'Ella', 'King', 'ella.king@airline.com', 1112223337, 'Singapore', 3, '1993-02-22',2);
CALL registrar_empleado(1023, 'Benjamin', 'Scott', 'benjamin.scott@airline.com', 3334445559, 'Seoul, KR', 3, '1982-05-20',3);
CALL registrar_empleado(1024, 'Grace', 'Lopez', 'grace.lopez@airline.com', 5556667770, 'San Francisco, USA', 4, '1995-08-11',4); 
CALL registrar_empleado(1025, 'Daniel5', 'Adams', 'daniel.adams@airline.com', 7778889992, 'Rome, IT', 1, '1988-10-16',5); -- error solo se permiten letras en nombre
CALL registrar_empleado(1026, 'Scarlett', 'Baker*', 'scarlett.baker@airline.com', 9990001114, 'Munich, DE', 2, '1986-03-19',6); -- error solo se permiten letras en nombre
CALL registrar_empleado(1027, 'Lucas', 'Nelson', 'lucas.nelson.airline.com', 2223334447, 'Vienna, AT', 3, '1981-07-12',1); -- error en email
CALL registrar_empleado(1028, 'Mila', 'Carter', 'mila.carter@airline.com', -4445556669, 'Moscow, RU', 3, '1990-11-27',2); -- error en telefono
CALL registrar_empleado(1029, 'Henry', 'Mitchell', 'henry.mitchell@airline.com', 6667778881, 'Cape Town, ZA', 5, '1989-12-07',3); -- error en cargo
CALL registrar_empleado(1030, 'Aria', 'Perez', 'aria.perez@airline.com', 8889990003, 'Mexico City, MX', 4, '2025-04-14',4); -- error en fecha
CALL registrar_empleado(1024, 'Daniel', 'Adams', 'daniel.adams@airline.com', 7778889992, 'Rome, IT', 1, '1988-10-16',5); -- error en id repetido

-- 7. Registro de Pasajeros
CALL RegistrarPasajero(2001, 'Alice', 'Johnson', TO_DATE('1992-06-30', 'YYYY-MM-DD'), 'alice.johnson@domain.com', 1234567890);
CALL RegistrarPasajero(2002, 'Bob', 'Smith', TO_DATE('1985-12-25', 'YYYY-MM-DD'), 'bob.smith@domain.com', 2345678901);
CALL RegistrarPasajero(2003, 'Charlie', 'Garcia', TO_DATE('1995-03-18', 'YYYY-MM-DD'), 'charlie.garcia@domain.com', 3456789012);
CALL RegistrarPasajero(2004, 'Alice', 'Smith', TO_DATE('1991-02-14', 'YYYY-MM-DD'), 'alice.smith@domain.com', 2345678901);
CALL RegistrarPasajero(2005, 'Bob', 'Brown', TO_DATE('1987-06-28', 'YYYY-MM-DD'), 'bob.brown@domain.com', 3456789012);
CALL RegistrarPasajero(2006, 'Clara', 'Johnson', TO_DATE('1993-05-11', 'YYYY-MM-DD'), 'clara.johnson@domain.com', 4567890123);
CALL RegistrarPasajero(2007, 'David', 'Williams', TO_DATE('1985-10-30', 'YYYY-MM-DD'), 'david.williams@domain.com', 5678901234);
CALL RegistrarPasajero(2008, 'Emma', 'Jones', TO_DATE('1992-09-15', 'YYYY-MM-DD'), 'emma.jones@domain.com', 6789012345);
CALL RegistrarPasajero(2009, 'Frank', 'Miller', TO_DATE('1988-04-25', 'YYYY-MM-DD'), 'frank.miller@domain.com', 7890123456);
CALL RegistrarPasajero(2010, 'Grace', 'Wilson', TO_DATE('1994-12-01', 'YYYY-MM-DD'), 'grace.wilson@domain.com', 8901234567);
CALL RegistrarPasajero(2011, 'Harry', 'Moore', TO_DATE('1990-07-22', 'YYYY-MM-DD'), 'harry.moore@domain.com', 9012345678);
CALL RegistrarPasajero(2012, 'Ivy', 'Taylor', TO_DATE('1989-03-17', 'YYYY-MM-DD'), 'ivy.taylor@domain.com', 1234567891);
CALL RegistrarPasajero(2013, 'Jack', 'Anderson', TO_DATE('1996-05-27', 'YYYY-MM-DD'), 'jack.anderson@domain.com', 2345678902);
CALL RegistrarPasajero(2014, 'Karen', 'Thomas', TO_DATE('1986-11-03', 'YYYY-MM-DD'), 'karen.thomas@domain.com', 3456789013);
CALL RegistrarPasajero(2015, 'Leo', 'Jackson', TO_DATE('1991-01-11', 'YYYY-MM-DD'), 'leo.jackson@domain.com', 4567890124);
CALL RegistrarPasajero(2016, 'Mia', 'White', TO_DATE('1994-06-16', 'YYYY-MM-DD'), 'mia.white@domain.com', 5678901235);
CALL RegistrarPasajero(2017, 'Nina', 'Harris', TO_DATE('1987-09-09', 'YYYY-MM-DD'), 'nina.harris@domain.com', 6789012346);
CALL RegistrarPasajero(2018, 'Oscar', 'Clark', TO_DATE('1993-03-23', 'YYYY-MM-DD'), 'oscar.clark@domain.com', 7890123457);
CALL RegistrarPasajero(2019, 'Paula', 'Lewis', TO_DATE('1990-08-05', 'YYYY-MM-DD'), 'paula.lewis@domain.com', 8901234568);
CALL RegistrarPasajero(2020, 'Quinn', 'Robinson', TO_DATE('1985-02-21', 'YYYY-MM-DD'), 'quinn.robinson@domain.com', 9012345679);
CALL RegistrarPasajero(2021, 'Rita', 'Walker', TO_DATE('1992-04-14', 'YYYY-MM-DD'), 'rita.walker@domain.com', 1234567892);
CALL RegistrarPasajero(2022, 'Sam', 'Young', TO_DATE('1988-10-19', 'YYYY-MM-DD'), 'sam.young@domain.com', 2345678903);
CALL RegistrarPasajero(2023, 'Tina', 'Hall', TO_DATE('1996-01-29', 'YYYY-MM-DD'), 'tina.hall@domain.com', 3456789014);
CALL RegistrarPasajero(2024, 'Umar', 'Allen', TO_DATE('1995-12-17', 'YYYY-MM-DD'), 'umar.allen@domain.com', 4567890125);
CALL RegistrarPasajero(2025, 'Vera', 'King', TO_DATE('1986-05-09', 'YYYY-MM-DD'), 'vera.king@domain.com', 5678901236);
CALL RegistrarPasajero(2026, 'Will', 'Scott', TO_DATE('1994-03-06', 'YYYY-MM-DD'), 'will.scott@domain.com', 6789012347);
CALL RegistrarPasajero(2027, 'Xena', 'Green', TO_DATE('1991-11-30', 'YYYY-MM-DD'), 'xena.green@domain.com', 7890123458);
CALL RegistrarPasajero(2028, 'Yara', 'Adams', TO_DATE('1989-07-20', 'YYYY-MM-DD'), 'yara.adams@domain.com', 8901234569);
CALL RegistrarPasajero(2029, 'Zane', 'Baker', TO_DATE('1993-06-13', 'YYYY-MM-DD'), 'zane.baker@domain.com', 9012345670);
CALL RegistrarPasajero(2030, 'Amelia', 'Carter', TO_DATE('1987-08-26', 'YYYY-MM-DD'), 'amelia.carter@domain.com', 1234567893);
CALL RegistrarPasajero(2031, 'Brandon', 'Diaz', TO_DATE('1990-09-01', 'YYYY-MM-DD'), 'brandon.diaz@domain.com', 2345678904);
CALL RegistrarPasajero(2032, 'Carmen', 'Evans', TO_DATE('1992-12-09', 'YYYY-MM-DD'), 'carmen.evans@domain.com', 3456789015);
CALL RegistrarPasajero(2033, 'Daniel', 'Garcia', TO_DATE('1995-11-25', 'YYYY-MM-DD'), 'daniel.garcia@domain.com', 4567890126);
CALL RegistrarPasajero(2034, 'Evelyn', 'Hernandez', TO_DATE('1985-04-18', 'YYYY-MM-DD'), 'evelyn.hernandez@domain.com', 5678901237);
CALL RegistrarPasajero(2035, 'Finn', 'Martinez', TO_DATE('1988-10-31', 'YYYY-MM-DD'), 'finn.martinez@domain.com', 6789012348);
CALL RegistrarPasajero(2036, 'Gina', 'Lopez', TO_DATE('1994-02-23', 'YYYY-MM-DD'), 'gina.lopez@domain.com', 7890123459);
CALL RegistrarPasajero(2037, 'Hank', 'Gonzalez', TO_DATE('1989-07-04', 'YYYY-MM-DD'), 'hank.gonzalez@domain.com', 8901234570);
CALL RegistrarPasajero(2038, 'Isabel', 'Hill', TO_DATE('1993-05-15', 'YYYY-MM-DD'), 'isabel.hill@domain.com', 9012345671);
CALL RegistrarPasajero(2039, 'Jake', 'Torres', TO_DATE('1990-12-21', 'YYYY-MM-DD'), 'jake.torres@domain.com', 1234567894);
CALL RegistrarPasajero(2040, 'Laura', 'Ramirez', TO_DATE('1986-03-18', 'YYYY-MM-DD'), 'laura.ramirez@domain.com', 2345678905);
CALL RegistrarPasajero(2041, 'Mark', 'Sanchez', TO_DATE('1987-11-11', 'YYYY-MM-DD'), 'mark.sanchez@domain.com', 3456789016);
CALL RegistrarPasajero(2042, 'Nora', 'Gomez', TO_DATE('1994-06-30', 'YYYY-MM-DD'), 'nora.gomez@domain.com', 4567890127);
CALL RegistrarPasajero(2043, 'Oscar', 'Morgan', TO_DATE('1991-09-17', 'YYYY-MM-DD'), 'oscar.morgan@domain.com', 5678901238);
CALL RegistrarPasajero(2044, 'Paula', 'Bell', TO_DATE('1995-02-07', 'YYYY-MM-DD'), 'paula.bell@domain.com', 6789012349);
CALL RegistrarPasajero(2045, 'Quincy', 'Cooper', TO_DATE('1993-01-25', 'YYYY-MM-DD'), 'quincy.cooper@domain.com', 7890123460);
CALL RegistrarPasajero(2046, 'Ruth', 'Gray', TO_DATE('1988-11-29', 'YYYY-MM-DD'), 'ruth.gray@domain.com', 8901234571);
CALL RegistrarPasajero(2047, 'Steve', 'Price', TO_DATE('1985-06-06', 'YYYY-MM-DD'), 'steve.price@domain.com', 9012345672);
CALL RegistrarPasajero(2048, 'Tara', 'Reed', TO_DATE('1996-08-04', 'YYYY-MM-DD'), 'tara.reed@domain.com', 1234567895);
CALL RegistrarPasajero(2049, 'Uriel', 'Hughes', TO_DATE('1992-09-02', 'YYYY-MM-DD'), 'uriel.hughes@domain.com', 2345678906);
CALL RegistrarPasajero(2050, 'Val', 'Perry', TO_DATE('1991-03-12', 'YYYY-MM-DD'), 'val.perry@domain.com', 3456789017);
CALL RegistrarPasajero(2051, 'Wanda', 'Foster', TO_DATE('1990-07-27', 'YYYY-MM-DD'), 'wanda.foster@domain.com', 4567890128);
CALL RegistrarPasajero(2052, 'Alex', 'Turner', TO_DATE('2025-05-10', 'YYYY-MM-DD'), 'alex.turner@domain.com', 1234567899); -- Fecha futura
CALL RegistrarPasajero(2053, 'Bella', 'Collins', TO_DATE('1992-02-14', 'YYYY-MM-DD'), 'bella.collins@domain.com', '12345abcde'); -- Teléfono no numérico
CALL RegistrarPasajero(2054, 'Chris', 'Parker', TO_DATE('1986-07-19', 'YYYY-MM-DD'), 'chris.parker@domain.com', -6789012345); -- Teléfono negativo
CALL RegistrarPasajero(2054, 'Chris', 'Parker', TO_DATE('1986-07-19', 'YYYY-MM-DD'), 'chris.parker.domain.com', 6789012345); -- Correo no válido
CALL RegistrarPasajero(2046, 'Eli', 'Perez', TO_DATE('1993-11-11', 'YYYY-MM-DD'), 'eli@domain.com', 8901234572); -- repetido
CALL RegistrarPasajero(2055, 'Anna2', 'Martin', TO_DATE('1987-09-30', 'YYYY-MM-DD'), 'anna.martin@domain.com', 7890123456); -- Nombre con números
CALL RegistrarPasajero(2056, 'Eli', 'Pere5', TO_DATE('1993-11-11', 'YYYY-MM-DD'), 'eli@domain.com', 8901234572); -- Apellido erroneo

-- insertar estados, estado por defecto sera programado, al habilitar un vuelo sera programado o disponible
-- si utilizan tabla estado asignar el id de programado, lo importante es saber cuando tiene el estado Finalizado para liberar el avion y tripulacion.
INSERT INTO Estado (estado) VALUES ('Programado');
INSERT INTO Estado (estado) VALUES ('Disponible');
INSERT INTO Estado (estado) VALUES ('En Transito'); -- ya no se podra vender
INSERT INTO Estado (estado) VALUES ('Finalizado'); -- tampoco se podra vender
INSERT INTO Estado (estado) VALUES ('Cancelado'); -- no se podra vender

-- 8. Registro de Vuelos, cambiar la puerta segun id en tabla, validar con  el origen para la puerta  ************** LISTO 

CALL RegistrarVuelo( TO_DATE('2024-11-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 1,  1, 1,1, 300, 200, 150);
CALL RegistrarVuelo( TO_DATE('2024-11-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 2,  3,9, 2, 280, 180, 130);
CALL RegistrarVuelo( TO_DATE('2024-11-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-03 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 3,  2,2, 5, 350, 250, 200);
CALL RegistrarVuelo( TO_DATE('2024-11-04 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 4, 1,3, 4, 320, 220, 170);
CALL RegistrarVuelo( TO_DATE('2024-11-05 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-05 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 5, 4,7, 1, 300, 200, 150);
CALL RegistrarVuelo( TO_DATE('2024-11-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-11-06 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 6, 5,10, 2, 280, 180, 130); -- error llegada antes de salida
CALL RegistrarVuelo( TO_DATE('2024-11-07 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-07 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 4, 1,15, 5, 320, 220, 170); -- error puerta no existe
CALL RegistrarVuelo( TO_DATE('2024-11-08 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-09 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 1, 3,9, 5, 350, 250, 200); -- error avion ya asignado
CALL RegistrarVuelo( TO_DATE('2024-11-09 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-09 04:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 9, 1,1, 5, 320, 220, 170); -- error avion no existe
CALL RegistrarVuelo( TO_DATE('2024-11-10 02:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-10 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 6, 1,1, 22, 320, 220, 170); -- error aerolinea no existe
CALL RegistrarVuelo( TO_DATE('2024-11-11 04:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-11 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 6, 11,1, 1, 320, 220, 170); -- error ruta no existe
CALL RegistrarVuelo( TO_DATE('2024-11-12 06:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-11-12 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Programado', 6, 1,1, 1, 320, 220, 170); -- error id repetido
--CALL RegistrarVuelo(TO_DATE( '2024-11-11 04:00:00', TO_DATE('2024-11-11 08:00:00', 'Programado', 6, 11,1, 1, -320, 220, 170) -- error tarifa negativa

-- *********************************************************************************8

-- 9. Asignar Tripulacion, olvide la aerolinea en el empleado asi que ya no hay que validar que el empleado y la aerolinea sean la misma
CALL asignar_tripulacion(1001, 1);
CALL asignar_tripulacion(1002, 1);
CALL asignar_tripulacion(1003, 1);
CALL asignar_tripulacion(1004, 1);
CALL asignar_tripulacion(1005, 1);
CALL asignar_tripulacion(1007, 3);
CALL asignar_tripulacion(1008, 3);
CALL asignar_tripulacion(1009, 3);
CALL asignar_tripulacion(1010, 3);
CALL asignar_tripulacion(1011, 3);
CALL asignar_tripulacion(1012, 4); -- error empleado con cargo no permitido
CALL asignar_tripulacion(1001, 2); -- error empleado ya asignado
CALL asignar_tripulacion(1013, 4);
CALL asignar_tripulacion(1015, 4);
CALL asignar_tripulacion(1031, 4); -- error empleado no existe
CALL asignar_tripulacion(1016, 10); -- error vuelo no existe
CALL asignar_tripulacion(1017, 11); -- error vuelo no existe

-- para este punto deben de tener los asientos registrados, tomarlos del avion, se tomaran en orden 
-- primer avion 3, 5, 10, total de ids 18, y continuar con los demas
-- ejemplo para la tabla asientos con atributos (avion_id_avion, clase, numero_asiento, disponible (1 o 0))  sino tienen el disponible eliminarlo, esto para saber si ya esta ocupado


-- Asientos para Airbus A320 (3 Primera Clase, 5 Ejecutiva, 10 Económica)
-- id_avion:1
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'A320'),
(2, 2, 'Primera Clase', 'A320'),
(3, 3, 'Primera Clase', 'A320'),
(4, 4, 'Ejecutiva', 'A320'),
(5, 5, 'Ejecutiva', 'A320'),
(6, 6, 'Ejecutiva', 'A320'),
(7, 7, 'Ejecutiva', 'A320'),
(8, 8, 'Ejecutiva', 'A320'),
(9, 9, 'Economica', 'A320'),
(10, 10, 'Economica', 'A320'),
(11, 11, 'Economica', 'A320'),
(12, 12, 'Economica', 'A320'),
(13, 13, 'Economica', 'A320'),
(14, 14, 'Economica', 'A320'),
(15, 15, 'Economica', 'A320'),
(16, 16, 'Economica', 'A320'),
(17, 17, 'Economica', 'A320'),
(18, 18, 'Economica', 'A320');


-- Asientos para Boeing 737 (2 Primera Clase, 3 Ejecutiva, 10 Económica)
-- id_avion:2
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'B737'),
(2, 2, 'Primera Clase', 'B737'),
(3, 3, 'Ejecutiva', 'B737'),
(4, 4, 'Ejecutiva', 'B737'),
(5, 5, 'Ejecutiva', 'B737'),
(6, 6, 'Economica', 'B737'),
(7, 7, 'Economica', 'B737'),
(8, 8, 'Economica', 'B737'),
(9, 9, 'Economica', 'B737'),
(10, 10, 'Economica', 'B737'),
(11, 11, 'Economica', 'B737'),
(12, 12, 'Economica', 'B737'),
(13, 13, 'Economica', 'B737'),
(14, 14, 'Economica', 'B737'),
(15, 15, 'Economica', 'B737');


-- Asientos para Airbus A380 (5 Primera Clase, 8 Ejecutiva, 17 Económica)
-- id_avion:3
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'A380'),
(2, 2, 'Primera Clase', 'A380'),
(3, 3, 'Primera Clase', 'A380'),
(4, 4, 'Primera Clase', 'A380'),
(5, 5, 'Primera Clase', 'A380'),
(6, 6, 'Ejecutiva', 'A380'),
(7, 7, 'Ejecutiva', 'A380'),
(8, 8, 'Ejecutiva', 'A380'),
(9, 9, 'Ejecutiva', 'A380'),
(10, 10, 'Ejecutiva', 'A380'),
(11, 11, 'Ejecutiva', 'A380'),
(12, 12, 'Ejecutiva', 'A380'),
(13, 13, 'Ejecutiva', 'A380'),
(14, 14, 'Economica', 'A380'),
(15, 15, 'Economica', 'A380'),
(16, 16, 'Economica', 'A380'),
(17, 17, 'Economica', 'A380'),
(18, 18, 'Economica', 'A380'),
(19, 19, 'Economica', 'A380'),
(20, 20, 'Economica', 'A380'),
(21, 21, 'Economica', 'A380'),
(22, 22, 'Economica', 'A380'),
(23, 23, 'Economica', 'A380'),
(24, 24, 'Economica', 'A380'),
(25, 25, 'Economica', 'A380'),
(26, 26, 'Economica', 'A380'),
(27, 27, 'Economica', 'A380'),
(28, 28, 'Economica', 'A380'),
(29, 29, 'Economica', 'A380'),
(30, 30, 'Economica', 'A380');


-- Asientos para Boeing 787 (5 Primera Clase, 5 Ejecutiva, 10 Económica)
-- id_avion:4
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'B787'),
(2, 2, 'Primera Clase', 'B787'),
(3, 3, 'Primera Clase', 'B787'),
(4, 4, 'Primera Clase', 'B787'),
(5, 5, 'Primera Clase', 'B787'),
(6, 6, 'Ejecutiva', 'B787'),
(7, 7, 'Ejecutiva', 'B787'),
(8, 8, 'Ejecutiva', 'B787'),
(9, 9, 'Ejecutiva', 'B787'),
(10, 10, 'Ejecutiva', 'B787'),
(11, 11, 'Economica', 'B787'),
(12, 12, 'Economica', 'B787'),
(13, 13, 'Economica', 'B787'),
(14, 14, 'Economica', 'B787'),
(15, 15, 'Economica', 'B787'),
(16, 16, 'Economica', 'B787'),
(17, 17, 'Economica', 'B787'),
(18, 18, 'Economica', 'B787'),
(19, 19, 'Economica', 'B787'),
(20, 20, 'Economica', 'B787');


-- Asientos para Boeing 777 (2 Primera Clase, 3 Ejecutiva, 7 Económica)
-- id_avion:5
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'B777'),
(2, 2, 'Primera Clase', 'B777'),
(3, 3, 'Ejecutiva', 'B777'),
(4, 4, 'Ejecutiva', 'B777'),
(5, 5, 'Ejecutiva', 'B777'),
(6, 6, 'Economica', 'B777'),
(7, 7, 'Economica', 'B777'),
(8, 8, 'Economica', 'B777'),
(9, 9, 'Economica', 'B777'),
(10, 10, 'Economica', 'B777'),
(11, 11, 'Economica', 'B777'),
(12, 12, 'Economica', 'B777');


-- Asientos para Embraer E195 (5 Primera Clase, 5 Ejecutiva, 12 Económica)
-- id_avion:6
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'E195'),
(2, 2, 'Primera Clase', 'E195'),
(3, 3, 'Primera Clase', 'E195'),
(4, 4, 'Primera Clase', 'E195'),
(5, 5, 'Primera Clase', 'E195'),
(6, 6, 'Ejecutiva', 'E195'),
(7, 7, 'Ejecutiva', 'E195'),
(8, 8, 'Ejecutiva', 'E195'),
(9, 9, 'Ejecutiva', 'E195'),
(10, 10, 'Ejecutiva', 'E195'),
(11, 11, 'Economica', 'E195'),
(12, 12, 'Economica', 'E195'),
(13, 13, 'Economica', 'E195'),
(14, 14, 'Economica', 'E195'),
(15, 15, 'Economica', 'E195'),
(16, 16, 'Economica', 'E195'),
(17, 17, 'Economica', 'E195'),
(18, 18, 'Economica', 'E195'),
(19, 19, 'Economica', 'E195'),
(20, 20, 'Economica', 'E195'),
(21, 21, 'Economica', 'E195'),
(22, 22, 'Economica', 'E195');


-- Asientos para Boeing 787 Dreamliner (5 Primera Clase, 5 Ejecutiva, 14 Económica)
INSERT INTO asientos (id_asiento, numero_asiento, clase, avion_id_avion) VALUES
(1, 1, 'Primera Clase', 'B787'),
(2, 2, 'Primera Clase', 'B787'),
(3, 3, 'Primera Clase', 'B787'),
(4, 4, 'Primera Clase', 'B787'),
(5, 5, 'Primera Clase', 'B787'),
(6, 6, 'Ejecutiva', 'B787'),
(7, 7, 'Ejecutiva', 'B787'),
(8, 8, 'Ejecutiva', 'B787'),
(9, 9, 'Ejecutiva', 'B787'),
(10, 10, 'Ejecutiva', 'B787'),
(11, 11, 'Economica', 'B787'),
(12, 12, 'Economica', 'B787'),
(13, 13, 'Economica', 'B787'),
(14, 14, 'Economica', 'B787'),
(15, 15, 'Economica', 'B787'),
(16, 16, 'Economica', 'B787'),
(17, 17, 'Economica', 'B787'),
(18, 18, 'Economica', 'B787'),
(19, 19, 'Economica', 'B787'),
(20, 20, 'Economica', 'B787'),
(21, 21, 'Economica', 'B787'),
(22, 22, 'Economica', 'B787'),
(23, 23, 'Economica', 'B787'),
(24, 24, 'Economica', 'B787');

-- si lo manejaron por cantidad y no por numero de asiento

-- Asientos para Airbus A320 (3 Primera Clase, 5 Ejecutiva, 10 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('A320', 'Primera Clase', 3, 1), -- cantidad de asientos, no numero de asientos
('A320', 'Ejecutiva', 5, 1),
('A320', 'Economica', 10, 1);

-- Asientos para Boeing 737 (2 Primera Clase, 3 Ejecutiva, 10 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('B737', 'Primera Clase', 2, 1),
('B737', 'Ejecutiva', 3, 1),
('B737', 'Economica', 10, 1);

-- Asientos para Airbus A380 (5 Primera Clase, 8 Ejecutiva, 17 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('A380', 'Primera Clase', 5, 1),
('A380', 'Ejecutiva', 8, 1),
('A380', 'Economica', 17, 1);


-- Asientos para Boeing 787 (5 Primera Clase, 5 Ejecutiva, 10 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('B787', 'Primera Clase', 5, 1),
('B787', 'Ejecutiva', 5, 1),
('B787', 'Economica', 10, 1);

-- Asientos para Boeing 777 (2 Primera Clase, 3 Ejecutiva, 7 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES 
('B777', 'Primera Clase', 2, 1),
('B777', 'Ejecutiva', 3, 1),
('B777', 'Economica', 7, 1);

-- Asientos para Embraer E195 (5 Primera Clase, 5 Ejecutiva, 12 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('E195', 'Primera Clase', 5, 1),
('E195', 'Ejecutiva', 5, 1),
('E195', 'Economica', 12, 1);

-- Asientos para Boeing 787 Dreamliner (5 Primera Clase, 5 Ejecutiva, 14 Económica)
INSERT INTO Asientos (avion_id_avion, clase, numero_asiento, disponible) VALUES
('B787', 'Primera Clase', 5, 1),
('B787', 'Ejecutiva', 5, 1),
('B787', 'Economica', 14, 1);

-- 10. Compra de Boleto, fecha obtenerla del servidor o pc vuelo, asiento, empleado, pasajero, reserva
CALL CompradeBoleto(1, 1, 1006, 2001, 0); -- si manejan con cantidad en asiento deberia ir P->Primera Clase, la inicial y el numero de asiento.. seria una cadena no un entero, recomiendo la primera opcion
CALL CompradeBoleto(1, 2, 1012, 2002, 0);
CALL CompradeBoleto(1, 3, 1018, 2003, 0);
CALL CompradeBoleto(1, 4, 1024, 2004, 0);
CALL CompradeBoleto(1, 5, 1006, 2005, 0);
CALL CompradeBoleto(1, 6, 1006, 2006, 0);
CALL CompradeBoleto(1, 7, 1006, 2007, 0);
CALL CompradeBoleto(1, 8, 1012, 2008, 0);
CALL CompradeBoleto(1, 9, 1012, 2009, 0);
CALL CompradeBoleto(1, 10, 1012, 2010, 0);
CALL CompradeBoleto(1, 11, 1012, 2011, 0);
CALL CompradeBoleto(1, 12, 1018, 2012, 0);
CALL CompradeBoleto(1, 13, 1018, 2013, 0);
CALL CompradeBoleto(1, 14, 1018, 2014, 0);
CALL CompradeBoleto(1, 15, 1018, 2015, 0);
CALL CompradeBoleto(1, 16, 1024, 2016, 0);
CALL CompradeBoleto(1, 17, 1024, 2017, 0);
CALL CompradeBoleto(1, 18, 1024, 2018, 0); 
CALL CompradeBoleto(1, 19, 1024, 2019, 0); -- vuelo lleno

CALL CompradeBoleto(2, 1, 1024, 2020, 0);
CALL CompradeBoleto(2, 2, 1016, 2021, 0);
CALL CompradeBoleto(2, 3, 1016, 2022, 0);
CALL CompradeBoleto(2, 4, 1016, 2023, 0);
CALL CompradeBoleto(2, 5, 1024, 2024, 0);
CALL CompradeBoleto(2, 6, 1024, 2025, 0);
CALL CompradeBoleto(2, 7, 1006, 2026, 0);
CALL CompradeBoleto(2, 8, 1012, 2027, 0);
CALL CompradeBoleto(2, 9, 1024, 2060, 0); -- error pasajero no existe
CALL CompradeBoleto(2, 10, 1016, 2021, 0); -- error empleado no es de ventanilla
CALL CompradeBoleto(10, 3, 1016, 2022, 0); -- error vuelo no existe
CALL CompradeBoleto(2, 8, 1016, 2028, 0); -- error asiento ya ocupado
CALL CompradeBoleto(2, 10, 1016, 2028, 1); -- error reserva no existe

-- insertar reservas
INSERT INTO reserva (id_reserva, fecha) VALUES (1, SYSDATE);
INSERT INTO reserva (id_reserva, fecha) VALUES (2, SYSDATE);
INSERT INTO reserva (id_reserva, fecha) VALUES (3, SYSDATE);
INSERT INTO reserva (id_reserva, fecha) VALUES (4, SYSDATE);

CALL CompradeBoleto(5, 1, 1006, 2028, 1); 
CALL CompradeBoleto(5, 2, 1012, 2028, 1);
CALL CompradeBoleto(5, 3, 1018, 2028, 1);
CALL CompradeBoleto(5, 4, 1024, 2029, 2);
CALL CompradeBoleto(5, 5, 1024, 2029, 2);
CALL CompradeBoleto(5, 6, 1024, 2029, 2);
CALL CompradeBoleto(5, 7, 1006, 2030, 3);
CALL CompradeBoleto(5, 8, 1006, 2030, 3);
CALL CompradeBoleto(5, 9, 1006, 2030, 3);
CALL CompradeBoleto(5, 10, 1006, 2030, 3);
CALL CompradeBoleto(5, 11, 1006, 2031, 0);
CALL CompradeBoleto(5, 2, 1012, 2032, 0); -- error asiento ocupado
CALL CompradeBoleto(2, 9, 1018, 2033, 4);
CALL CompradeBoleto(2, 10, 1018, 2033, 4);
CALL CompradeBoleto(2, 11, 1018, 2033, 4);

-- 12. Cancelar Reservacion
CALL cancelar_reservacion(1); -- se liberan los asientos
CALL cancelar_reservacion(5); -- reserva no existe
CALL cancelar_reservacion(1); -- ya fue cancelada antes
CALL cancelar_reservacion(4); 
CALL CompradeBoleto(5, 2, 1012, 2032, 0); -- se puede volver a comprar
CALL CompradeBoleto(5, 3, 1018, 2033, 0);

-- 11. Aumento de Salario   ******************** LISTO
CALL AumentoSalario(1001, 25000); -- error salario menor al actual
CALL AumentoSalario(1001, 40000); 
CALL AumentoSalario(1002, 30000);
CALL AumentoSalario(1003, 25000);
CALL AumentoSalario(1031, 30000); -- error empleado no existe
CALL AumentoSalario(1007, 100000); -- error salario mayor al maximo

-- en este punto se va a dar por finalizado un vuelo y se debe de mostrar que el avion y la tripulacion 
-- asignada esta nuevamente disponible

CALL CompradeBoleto(5, 12, 1006, 2034, 0); -- no se puede vender porque el vuelo ya no esta programado o disponible

--- REPORTES ---
-- 1. Consultar Vuelo 
CALL ConsultarVuelo(1);
CALL ConsultarVuelo(10); -- error vuelo no existe
CALL ConsultarVuelo(2);

-- 2. Consultar Aviones  ************* LISTO
CALL ConsultarAviones();

-- 3. Consultar Empleados, no puse aerolinea listen todos los empleados
CALL consultar_empleados(4);

-- 4. Consultar Rutas
CALL ConsultarRutas();

-- 5. Consultar Cancelaciones
CALL ConsultarCancelaciones();

-- 6. Insertar Columna
CALL insertar_columna();

-- ver historial de transacicones
SELECT * FROM Historial;