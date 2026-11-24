USE ibaimove;
-- A02 - Vehículos eléctricos con menos del 20% de batería
SELECT codigo, tipo, bateria 
FROM vehiculos
WHERE 
	electrico = TRUE AND 
	bateria < 20;

-- A03 - Clientes que se dieron de alta 
-- en un mes concreto. Octubre de 2026
SELECT id_cliente, nombre, apellidos, fecha_alta
FROM clientes
WHERE fecha_alta BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY fecha_alta;

