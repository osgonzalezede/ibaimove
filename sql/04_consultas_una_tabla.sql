USE ibaimove;
-- A02 - Vehículos eléctricos con menos del 20% de batería
SELECT codigo, tipo, electrico, bateria 
FROM vehiculos
WHERE 
	electrico = TRUE AND bateria < 20;

-- A03 - Clientes que se dieron de alta 
-- en un mes concreto. Octubre de 2026
SELECT id_cliente, nombre, 
apellidos, fecha_alta
FROM clientes
WHERE fecha_alta 
BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY fecha_alta;

-- A07 - ¿Cuáles son los 5 viajes más caros?
SELECT 
	id_viaje, 
	fecha_hora_inicio, 
	fecha_hora_fin, 
	importe
FROM viajes
ORDER BY importe DESC;
LIMIT 5;

-- A04 - ¿Qué clientes no tienen teléfono registrado?

SELECT nombre, apellidos
FROM clientes
WHERE telefono IS NULL;

-- A-05 - Viajes en curso
SELECT 
	id_viaje, 
	id_estacion_origen, 
	fecha_hora_inicio 
FROM viajes
WHERE id_estacion_destino IS NULL;

-- A-01 - Lista de estaciones con su barrio, su capacidad y su dirección completa en una sola columna
-- (por ejemplo, "Gran Vía 45, 48011 Bilbao"), ordenadas por barrio y, dentro de cada barrio, por nombre.
SELECT 
	barrio,
	nombre,
	capacidad,
	CONCAT(calle, ' ', numero, ', ', cp,' ', localidad)
FROM estaciones
ORDER BY barrio, nombre;

-- A-08 - Lista de clientes con su nombre completo 
-- en mayúsculas y el dominio de su correo (lo que va
-- después de la @).
SELECT 
	UPPER(CONCAT(nombre, ' ', apellidos)) AS nombre_completo,
	correo,
	SUBSTRING_INDEX(correo, '@', -1)
FROM clientes;

-- A-06 - ¿Cuántos minutos duró cada viaje terminado?

SELECT 
	id_viaje, 
	fecha_hora_inicio, 
	fecha_hora_fin,
	CEIL(TIMESTAMPDIFF(SECOND, 
		fecha_hora_inicio, 
		fecha_hora_fin) / 60) 
	AS minutos 
FROM viajes
WHERE fecha_hora_fin IS NOT NULL;