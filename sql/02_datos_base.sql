-- ============================================================
-- IbaiMove - 02_datos_base.sql
-- Datos base que da el docente: estaciones, tarifas y vehículos.
-- No modifiques este archivo. Ejecútalo después de 01_creacion.sql,
-- sobre la base de datos vacía.
-- ============================================================

USE ibaimove;

-- ------------------------------------------------------------
-- Estaciones
-- El identificador lo genera AUTO_INCREMENT, en el orden de
-- inserción: Moyua es la 1, Arriaga la 2… hasta Zorrotzaurre, la 6.
-- ------------------------------------------------------------
INSERT INTO estaciones (nombre, barrio, calle, numero, cp, localidad, capacidad) VALUES
  ('Moyua',        'Abando',       'Plaza Moyua',                  '2',  '48009', 'Bilbao', 12),
  ('Arriaga',      'Casco Viejo',  'Plaza Arriaga',                '1',  '48005', 'Bilbao', 10),
  ('Deusto',       'Deusto',       'Avenida Lehendakari Aguirre',  '20', '48014', 'Bilbao', 10),
  ('Indautxu',     'Indautxu',     'Plaza Indautxu',               '3',  '48010', 'Bilbao', 8),
  ('Santutxu',     'Santutxu',     'Calle Santutxu',               '25', '48004', 'Bilbao', 8),
  ('Zorrotzaurre', 'Zorrotzaurre', 'Ribera de Deusto',             '70', '48014', 'Bilbao', 8);

-- ------------------------------------------------------------
-- Tarifas: una por cada clase de vehículo (tipo + eléctrico)
-- ------------------------------------------------------------
INSERT INTO tarifas (tipo, electrico, precio_desbloqueo, precio_minuto) VALUES
  ('bici',     0, 0.25, 0.05),
  ('bici',     1, 0.50, 0.12),
  ('patinete', 1, 0.50, 0.20);

-- ------------------------------------------------------------
-- Vehículos
-- id_vehiculo 1 a 8:   bicis normales   (B-001 a B-008)
-- id_vehiculo 9 a 13:  bicis eléctricas (B-009 a B-013)
-- id_vehiculo 14 a 18: patinetes        (P-001 a P-005)
-- Los vehículos en uso o retirados no están en ninguna estación.
-- Hay 2 vehículos en uso (B-004 y P-002): úsalos para tus viajes en curso.
-- ------------------------------------------------------------
INSERT INTO vehiculos (codigo, tipo, electrico, bateria, estado, id_estacion) VALUES
  ('B-001', 'bici',     0, NULL, 'disponible', 1),
  ('B-002', 'bici',     0, NULL, 'disponible', 1),
  ('B-003', 'bici',     0, NULL, 'disponible', 2),
  ('B-004', 'bici',     0, NULL, 'en uso',     NULL),
  ('B-005', 'bici',     0, NULL, 'disponible', 3),
  ('B-006', 'bici',     0, NULL, 'averiado',   4),
  ('B-007', 'bici',     0, NULL, 'disponible', 5),
  ('B-008', 'bici',     0, NULL, 'retirado',   NULL),
  ('B-009', 'bici',     1, 85,   'disponible', 1),
  ('B-010', 'bici',     1, 15,   'disponible', 2),
  ('B-011', 'bici',     1, 60,   'disponible', 3),
  ('B-012', 'bici',     1, 100,  'disponible', 6),
  ('B-013', 'bici',     1, 40,   'disponible', 4),
  ('P-001', 'patinete', 1, 90,   'disponible', 2),
  ('P-002', 'patinete', 1, 55,   'en uso',     NULL),
  ('P-003', 'patinete', 1, 8,    'disponible', 5),
  ('P-004', 'patinete', 1, 70,   'disponible', 6),
  ('P-005', 'patinete', 1, 30,   'averiado',   3);
