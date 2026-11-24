-- ============================================================
-- IbaiMove - 01_pruebas_restricciones.sql
-- Solución de referencia de la fase 5: pruebas de restricciones.
-- Ejecútalas después de 01_creacion.sql, 02_datos_base.sql y
-- 03_datos.sql.
--
-- Las pruebas R-01 a R-12 DEBEN FALLAR: cada una incumple una
-- restricción distinta. Ejecútalas de una en una y comprueba que el
-- error es el esperado. Si alguna no falla, falta esa restricción
-- en 01_creacion.sql.
-- Las pruebas D-01 y D-02 DEBEN FUNCIONAR: comprueban los valores por
-- defecto. Al final se deshacen, para dejar los datos como estaban.
-- ============================================================

USE ibaimove;

-- PRUEBA R-01. Clave primaria de tarifas (tipo, electrico).
-- Qué pruebo: no puede haber dos tarifas para la misma clase de vehículo.
-- Resultado esperado: error 1062 (Duplicate entry 'bici-0' for key 'tarifas.PRIMARY').
INSERT INTO tarifas (tipo, electrico, precio_desbloqueo, precio_minuto)
VALUES ('bici', 0, 0.30, 0.06);

-- PRUEBA R-02. Clave ajena viajes -> clientes.
-- Qué pruebo: no se puede registrar un viaje de un cliente que no existe.
-- Resultado esperado: error 1452 (Cannot add or update a child row),
-- con la restricción fk_viajes_clientes en el mensaje.
INSERT INTO viajes (id_cliente, id_vehiculo, id_estacion_origen, fecha_hora_inicio)
VALUES (999, 1, 1, '2026-11-24 12:00:00');

-- PRUEBA R-03. Clave ajena compuesta vehiculos -> tarifas.
-- Qué pruebo: no se puede dar de alta un patinete no eléctrico, porque
-- esa tarifa no existe (RN-03).
-- Resultado esperado: error 1452, con la restricción fk_vehiculos_tarifas.
INSERT INTO vehiculos (codigo, tipo, electrico, bateria, id_estacion)
VALUES ('P-006', 'patinete', 0, NULL, 1);

-- PRUEBA R-04. NOT NULL en clientes.correo.
-- Qué pruebo: el correo es obligatorio.
-- Resultado esperado: error 1048 (Column 'correo' cannot be null).
INSERT INTO clientes (nombre, apellidos, correo, fecha_alta)
VALUES ('Ainhoa', 'Bilbao Arrieta', NULL, '2026-11-24');

-- PRUEBA R-05. UNIQUE en clientes.correo (uq_clientes_correo).
-- Qué pruebo: dos clientes no pueden tener el mismo correo.
-- Resultado esperado: error 1062 (Duplicate entry 'leire.arana@gmail.com'
-- for key 'clientes.uq_clientes_correo').
INSERT INTO clientes (nombre, apellidos, correo, fecha_alta)
VALUES ('Leire', 'Arana Uribe', 'leire.arana@gmail.com', '2026-11-24');

-- PRUEBA R-06. UNIQUE en incidencias.id_viaje (uq_incidencias_id_viaje).
-- Qué pruebo: un viaje produce como máximo una incidencia (relación 1:1, S-03).
-- El viaje 3 ya tiene una incidencia.
-- Resultado esperado: error 1062 (Duplicate entry '3' for key
-- 'incidencias.uq_incidencias_id_viaje').
INSERT INTO incidencias (id_vehiculo, id_cliente, id_viaje, fecha_hora, tipo, descripcion)
VALUES (7, 2, 3, '2026-10-10 10:40:00', 'otro', 'Segundo aviso del mismo viaje');

-- PRUEBA R-07. CHECK ck_recargas_importe (RN-09).
-- Qué pruebo: una recarga no puede ser de menos de 5 €.
-- Resultado esperado: error 3819 (Check constraint 'ck_recargas_importe'
-- is violated).
INSERT INTO recargas (id_cliente, fecha_hora, importe, tipo_pago)
VALUES (1, '2026-11-24 12:00:00', 3.00, 'bizum');

-- PRUEBA R-08. CHECK ck_vehiculos_bateria (RN-03).
-- Qué pruebo: una bici que no es eléctrica no puede tener batería.
-- Resultado esperado: error 3819 (Check constraint 'ck_vehiculos_bateria'
-- is violated).
INSERT INTO vehiculos (codigo, tipo, electrico, bateria, id_estacion)
VALUES ('B-014', 'bici', 0, 50, 1);

-- PRUEBA R-09. CHECK ck_estaciones_localidad.
-- Qué pruebo: todas las estaciones están en Bilbao.
-- Resultado esperado: error 3819 (Check constraint 'ck_estaciones_localidad'
-- is violated).
INSERT INTO estaciones (nombre, barrio, calle, numero, cp, localidad, capacidad)
VALUES ('Algorta', 'Algorta', 'Calle Mayor', '1', '48990', 'Getxo', 6);

-- PRUEBA R-10. CHECK ck_vehiculos_estado.
-- Qué pruebo: el estado de un vehículo solo puede ser uno de los cuatro
-- de la lista (disponible, en uso, averiado o retirado).
-- Resultado esperado: error 3819 (Check constraint 'ck_vehiculos_estado'
-- is violated).
UPDATE vehiculos SET estado = 'roto' WHERE id_vehiculo = 6;

-- PRUEBA R-11. CHECK ck_tarifas_tipo.
-- Qué pruebo: el tipo de vehículo de una tarifa solo puede ser 'bici' o
-- 'patinete'. (En vehiculos no hace falta otro CHECK: la clave ajena
-- compuesta hacia tarifas ya rechaza un tipo que no existe.)
-- Resultado esperado: error 3819 (Check constraint 'ck_tarifas_tipo'
-- is violated).
INSERT INTO tarifas (tipo, electrico, precio_desbloqueo, precio_minuto)
VALUES ('moto', 1, 1.00, 0.30);

-- PRUEBA R-12. Borrado que impide una clave ajena (ON DELETE RESTRICT).
-- Qué pruebo: no se puede borrar la tarifa de los patinetes mientras haya
-- patinetes que la usan.
-- Resultado esperado: error 1451 (Cannot delete or update a parent row),
-- con la restricción fk_vehiculos_tarifas en el mensaje.
DELETE FROM tarifas WHERE tipo = 'patinete' AND electrico = 1;

-- ------------------------------------------------------------
-- Pruebas que deben funcionar: valores por defecto
-- ------------------------------------------------------------

-- PRUEBA D-01. DEFAULT de clientes.saldo.
-- Qué pruebo: si no se indica el saldo, un cliente nuevo empieza con 0.
-- Resultado esperado: se inserta la fila y el SELECT muestra saldo = 0.00.
INSERT INTO clientes (nombre, apellidos, correo, fecha_alta)
VALUES ('Prueba', 'Valor Por Defecto', 'prueba.defecto@example.com', '2026-11-24');

SELECT nombre, saldo FROM clientes WHERE correo = 'prueba.defecto@example.com';

-- Deshacer la prueba (se borra por correo, que es UNIQUE).
DELETE FROM clientes WHERE correo = 'prueba.defecto@example.com';

-- PRUEBA D-02. DEFAULT de incidencias.estado (RN-14).
-- Qué pruebo: si no se indica el estado, una incidencia nueva empieza abierta.
-- Resultado esperado: se inserta la fila y el SELECT muestra estado = 'abierta'.
INSERT INTO incidencias (id_vehiculo, fecha_hora, tipo, descripcion)
VALUES (1, '2026-11-24 12:00:00', 'otro', 'Prueba de valor por defecto');

-- LAST_INSERT_ID() devuelve el identificador que acaba de generar
-- AUTO_INCREMENT en esta conexión.
SELECT id_incidencia, estado FROM incidencias WHERE id_incidencia = LAST_INSERT_ID();

-- Deshacer la prueba.
DELETE FROM incidencias WHERE id_incidencia = LAST_INSERT_ID();
