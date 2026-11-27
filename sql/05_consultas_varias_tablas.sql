USE ibaimove;
-- B-05 - ¿Desde qué barrio salen más viajes?

SELECT 	
	e.barrio,
	COUNT(*)
FROM estaciones AS e
JOIN viajes AS v
ON e.id_estacion = v.id_estacion_origen
GROUP BY barrio;