--- paises

INSERT INTO pais (id_pais, nombre)
VALUES (1, 'United States');

INSERT INTO pais (id_pais, nombre)
VALUES (2, 'Francia');

INSERT INTO pais (id_pais, nombre)
VALUES (3, 'England');

--- ciudades

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (1, 'New York', 1);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (2, 'Atlanta', 1);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (3, 'Chicago', 1);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (4, 'Dallas', 1);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (5, 'Paris', 2);

INSERT INTO ciudad (id_ciudad, nombre, pais_id_pais)
VALUES (6, 'London', 3);

