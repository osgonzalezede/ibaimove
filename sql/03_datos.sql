USE ibaimove;

-- Una estación más en Deusto, para que haya un barrio con más de una
-- estación (consulta A-11 de la fase 6). Será la estación 7.
INSERT INTO estaciones (nombre, barrio, calle, numero, cp, localidad, capacidad) VALUES
  ('Unibertsitatea', 'Deusto', 'Avenida de las Universidades', '24', '48007', 'Bilbao', 6);

-- ------------------------------------------------------------
-- Clientes (8). Unai y Maite no tienen teléfono. Mikel acaba de
-- darse de alta: no ha recargado ni ha hecho ningún viaje.
-- Amaia tiene saldo negativo (RN-07).
-- ------------------------------------------------------------
INSERT INTO clientes (nombre, apellidos, correo, telefono, fecha_alta, saldo) VALUES
  ('Leire', 'Arana Goikoetxea', 'leire.arana@gmail.com', '600111222', '2026-10-01', 17.28),
  ('Unai', 'Gil Barrenetxea', 'unai.gil@hotmail.com', NULL, '2026-10-03', 7.45),
  ('Nerea', 'Ibarra Uriarte', 'nerea.ibarra@gmail.com', '611222333', '2026-10-05', 7.96),
  ('Jon', 'Zubiri Mendieta', 'jon.zubiri@ehu.eus', '622333444', '2026-10-12', 9.98),
  ('Maite', 'Ortiz de Zarate', 'maite.ortiz@outlook.com', NULL, '2026-10-20', 1.70),
  ('Iker', 'Larrea Sasia', 'iker.larrea@gmail.com', '633444555', '2026-11-02', 8.66),
  ('Amaia', 'Etxebarria Olabe', 'amaia.etxebarria@yahoo.es', '644555666', '2026-11-05', -3.20),
  ('Mikel', 'Agirre Lasa', 'mikel.agirre@gmail.com', '655666777', '2026-11-15', 0.00);

-- ------------------------------------------------------------
-- Recargas (10), con los dos tipos de pago. Leire ha recargado tres
-- veces y Mikel ninguna.
-- ------------------------------------------------------------
INSERT INTO recargas (id_cliente, fecha_hora, importe, tipo_pago) VALUES
  (1, '2026-10-02 19:12:00', 20.00, 'tarjeta'),
  (2, '2026-10-05 08:30:00', 10.00, 'bizum'),
  (3, '2026-10-06 21:05:00', 15.00, 'tarjeta'),
  (4, '2026-10-13 07:50:00', 10.00, 'tarjeta'),
  (5, '2026-10-21 18:40:00', 5.00, 'bizum'),
  (1, '2026-11-01 10:15:00', 10.00, 'bizum'),
  (4, '2026-11-01 12:00:00', 5.00, 'bizum'),
  (6, '2026-11-03 09:00:00', 10.00, 'bizum'),
  (7, '2026-11-06 20:30:00', 5.00, 'tarjeta'),
  (1, '2026-11-16 22:45:00', 10.00, 'tarjeta');

-- ------------------------------------------------------------
-- Viajes (21): 19 terminados y 2 en curso.
-- Los viajes en curso usan los vehículos que están en uso en los datos
-- base (B-004 y P-002): no tienen estación de llegada, fecha y hora de
-- fin ni importe. El 10/11 y el 17/11 hay más de 2 viajes (A-12).
-- Vehículos: 4 = B-004, 15 = P-002, 16 = P-003...
-- ------------------------------------------------------------
INSERT INTO viajes (id_cliente, id_vehiculo, id_estacion_origen, id_estacion_destino,
                    fecha_hora_inicio, fecha_hora_fin, importe) VALUES
  (1,  1, 2,    1, '2026-10-06 08:10:00', '2026-10-06 08:22:30',  0.90),   -- viaje 1: B-001
  (3,  2, 1,    3, '2026-10-08 18:00:00', '2026-10-08 18:15:00',  1.00),   -- viaje 2: B-002
  (2,  7, 2,    5, '2026-10-10 10:00:00', '2026-10-10 10:19:00',  1.20),   -- viaje 3: B-007
  (4,  2, 3,    1, '2026-10-15 09:05:00', '2026-10-15 09:21:10',  1.10),   -- viaje 4: B-002
  (1,  3, 1,    2, '2026-10-20 08:30:00', '2026-10-20 08:39:00',  0.70),   -- viaje 5: B-003
  (3, 15, 2,    4, '2026-10-25 11:00:00', '2026-10-25 11:18:00',  4.10),   -- viaje 6: P-002
  (1, 17, 5,    6, '2026-10-30 18:40:00', '2026-10-30 19:15:00',  7.50),   -- viaje 7: P-004
  (1,  9, 4,    1, '2026-11-03 08:00:00', '2026-11-03 08:11:00',  1.82),   -- viaje 8: B-009
  (4,  6, 5,    4, '2026-11-03 19:20:00', '2026-11-03 19:33:00',  0.90),   -- viaje 9: B-006
  (3, 12, 3,    6, '2026-11-10 08:20:00', '2026-11-10 08:32:00',  1.94),   -- viaje 10: B-012
  (2,  4, 3,    5, '2026-11-10 17:45:00', '2026-11-10 18:07:00',  1.35),   -- viaje 11: B-004
  (5,  5, 2,    3, '2026-11-10 19:00:00', '2026-11-10 19:14:20',  1.00),   -- viaje 12: B-005
  (7, 10, 1,    2, '2026-11-12 08:15:00', '2026-11-12 08:25:00',  1.70),   -- viaje 13: B-010
  (6, 13, 1,    4, '2026-11-12 13:00:00', '2026-11-12 13:07:00',  1.34),   -- viaje 14: B-013
  (1, 14, 6,    2, '2026-11-17 09:00:00', '2026-11-17 09:28:00',  6.10),   -- viaje 15: P-001
  (5, 18, 1,    3, '2026-11-17 12:10:00', '2026-11-17 12:19:00',  2.30),   -- viaje 16: P-005
  (7, 16, 6,    5, '2026-11-17 17:30:00', '2026-11-17 18:00:00',  6.50),   -- viaje 17: P-003
  (4, 11, 2,    3, '2026-11-17 18:30:00', '2026-11-17 18:50:40',  3.02),   -- viaje 18: B-011
  (1, 15, 4,    2, '2026-11-20 19:10:00', '2026-11-20 19:35:15',  5.70),   -- viaje 19: P-002
  (6,  4, 5, NULL, '2026-11-24 09:40:00', NULL                 ,  NULL),   -- viaje 20: B-004
  (2, 15, 2, NULL, '2026-11-24 10:05:00', NULL                 ,  NULL);   -- viaje 21: P-002

-- ------------------------------------------------------------
-- Incidencias (6), de los cuatro tipos y los tres estados.
-- Cuatro están ligadas a un viaje (como mucho una por viaje) y dos las
-- abrió el personal, sin cliente. La de B-008 es de hace más de un año
-- y está resuelta (consulta A-15 de la fase 6). La avería de B-011 está
-- abierta, pero el vehículo sigue disponible (consulta B-13).
-- ------------------------------------------------------------
INSERT INTO incidencias (id_vehiculo, id_cliente, id_viaje, fecha_hora, tipo, descripcion, estado) VALUES
  (8, NULL, NULL, '2025-09-15 10:00:00', 'otro', 'Revisión general antes de retirarla del servicio', 'resuelta'),
  (7, 2, 3, '2026-10-10 10:25:00', 'daño', 'La cesta delantera está doblada', 'resuelta'),
  (6, 4, 9, '2026-11-03 19:40:00', 'avería', 'Pinchazo en la rueda delantera', 'abierta'),
  (16, NULL, NULL, '2026-11-17 18:20:00', 'batería', 'La batería no carga por encima del 10 %', 'abierta'),
  (18, 5, 16, '2026-11-17 12:25:00', 'avería', 'El freno trasero no frena bien', 'en curso'),
  (11, 4, 18, '2026-11-17 18:55:00', 'avería', 'La cadena se sale al cambiar de marcha', 'abierta');
