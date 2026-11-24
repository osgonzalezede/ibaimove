DROP DATABASE IF EXISTS ibaimove;
CREATE DATABASE ibaimove 
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_0900_ai_ci;
USE ibaimove;

-- Primero las tablas a las que apuntan otras: estaciones,
-- tarifas y clientes. Después, el resto, en orden.

CREATE TABLE estaciones (
  id_estacion INT          NOT NULL AUTO_INCREMENT,
  nombre      VARCHAR(60)  NOT NULL,
  barrio      VARCHAR(40)  NOT NULL,
  calle       VARCHAR(100) NOT NULL,
  numero      VARCHAR(10)  NOT NULL,   -- texto: puede ser '12 bis' o 's/n'
  cp          CHAR(5)      NOT NULL,   -- texto de longitud fija
  localidad   VARCHAR(40)  NOT NULL,
  capacidad   TINYINT      NOT NULL,
  CONSTRAINT pk_estaciones 
  	PRIMARY KEY (id_estacion),
  CONSTRAINT uq_estaciones_nombre 
  	UNIQUE (nombre),
  -- Desnormalización consciente (fase 3): todas las estaciones están en Bilbao
  CONSTRAINT ck_estaciones_localidad 
  	CHECK (localidad = 'Bilbao'),
  -- RN-02
  CONSTRAINT ck_estaciones_capacidad 
  	CHECK (capacidad > 0)
);

CREATE TABLE tarifas (
  tipo              VARCHAR(10)  NOT NULL,
  electrico         TINYINT   	 NOT NULL,
  precio_desbloqueo DECIMAL(4,2) NOT NULL,
  precio_minuto     DECIMAL(4,2) NOT NULL,
  CONSTRAINT pk_tarifas 
  	PRIMARY KEY (tipo, electrico),
  CONSTRAINT ck_tarifas_tipo 
  	CHECK (tipo IN ('bici', 'patinete')),
  CONSTRAINT ck_tarifas_precios 
  	CHECK (precio_desbloqueo >= 0 AND precio_minuto >= 0),
  -- RN-03: un patinete siempre es eléctrico.
  -- Se lee así: o es una bici (eléctrica o no), o es un patinete eléctrico.
  CONSTRAINT ck_tarifas_patinete 
  	CHECK (tipo = 'bici' OR (tipo = 'patinete' AND electrico = TRUE))
);

CREATE TABLE clientes (
  id_cliente INT          NOT NULL AUTO_INCREMENT,
  nombre     VARCHAR(50)  NOT NULL,
  apellidos  VARCHAR(100) NOT NULL,
  correo     VARCHAR(100) NOT NULL,
  telefono   VARCHAR(15),                        -- opcional
  fecha_alta DATE         NOT NULL,              -- obligatoria y sin valor por defecto
  saldo      DECIMAL(7,2) NOT NULL DEFAULT 0.00, -- puede ser negativo (RN-07)
  CONSTRAINT pk_clientes 
  	PRIMARY KEY (id_cliente),
  CONSTRAINT uq_clientes_correo 
  	UNIQUE (correo)
);

CREATE TABLE vehiculos (
  id_vehiculo INT          NOT NULL AUTO_INCREMENT,
  codigo      VARCHAR(10)  NOT NULL,
  tipo        VARCHAR(10)  NOT NULL,   -- mismo tipo que en tarifas
  electrico   TINYINT(1)   NOT NULL,
  bateria     TINYINT,                          -- las bicis normales no tienen batería
  estado      VARCHAR(20)  NOT NULL DEFAULT 'disponible',
  id_estacion INT,                              -- NULL mientras está en uso o retirado
  CONSTRAINT pk_vehiculos 
  	PRIMARY KEY (id_vehiculo),
  CONSTRAINT uq_vehiculos_codigo 
  	UNIQUE (codigo),
  -- Clave ajena compuesta: tipo y electrico son datos del vehículo
  -- y, a la vez, la clave de su tarifa. Impide un patinete no eléctrico
  -- y un tipo que no sea bici o patinete, porque esas tarifas no existen.
  -- Por eso vehiculos no necesita su propio CHECK sobre el tipo.
  CONSTRAINT fk_vehiculos_tarifas 
  	FOREIGN KEY (tipo, electrico)
    REFERENCES tarifas (tipo, electrico)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT fk_vehiculos_estaciones 
  	FOREIGN KEY (id_estacion)
    REFERENCES estaciones (id_estacion)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT ck_vehiculos_estado
    CHECK (estado IN ('disponible', 'en uso', 'averiado', 'retirado')),
  -- RN-03: batería de 0 a 100 en los eléctricos y sin batería en los demás
  CONSTRAINT ck_vehiculos_bateria 
  	CHECK (
    	(electrico = 1 AND bateria BETWEEN 0 AND 100) OR 
    	(electrico = 0 AND bateria IS NULL))
);

CREATE TABLE recargas (
  id_recarga INT          NOT NULL AUTO_INCREMENT,
  id_cliente INT          NOT NULL,
  fecha_hora DATETIME     NOT NULL,
  importe    DECIMAL(6,2) NOT NULL,
  tipo_pago  VARCHAR(10)  NOT NULL,
  CONSTRAINT pk_recargas 
  	PRIMARY KEY (id_recarga),
  CONSTRAINT fk_recargas_clientes 
  	FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  -- RN-09
  CONSTRAINT ck_recargas_importe 
  	CHECK (importe >= 5.00),
  -- S-01
  CONSTRAINT ck_recargas_tipo_pago 
  	CHECK (tipo_pago IN ('tarjeta', 'bizum'))
);

CREATE TABLE viajes (
  id_viaje            INT          NOT NULL AUTO_INCREMENT,
  id_cliente          INT          NOT NULL,
  id_vehiculo         INT          NOT NULL,
  id_estacion_origen  INT          NOT NULL,
  id_estacion_destino INT,                 -- NULL mientras el viaje está en curso
  fecha_hora_inicio   DATETIME     NOT NULL,
  fecha_hora_fin      DATETIME,            -- NULL mientras el viaje está en curso (S-02)
  importe             DECIMAL(6,2),        -- se anota al terminar el viaje (RN-06)
  CONSTRAINT pk_viajes 
  	PRIMARY KEY (id_viaje),
  CONSTRAINT fk_viajes_clientes 
  	FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT fk_viajes_vehiculos 
  	FOREIGN KEY (id_vehiculo)
    REFERENCES vehiculos (id_vehiculo)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  -- Dos claves ajenas hacia estaciones, con sufijo de papel
  CONSTRAINT fk_viajes_estaciones_origen 
  	FOREIGN KEY (id_estacion_origen)
    REFERENCES estaciones (id_estacion)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT fk_viajes_estaciones_destino 
  	FOREIGN KEY (id_estacion_destino)
    REFERENCES estaciones (id_estacion)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  -- Un viaje no puede terminar antes de empezar
  CONSTRAINT ck_viajes_fechas
    CHECK (fecha_hora_fin IS NULL OR 
    	fecha_hora_fin >= fecha_hora_inicio)
);

CREATE TABLE incidencias (
  id_incidencia INT          NOT NULL AUTO_INCREMENT,
  id_vehiculo   INT          NOT NULL,
  id_cliente    INT,                 -- la puede abrir el personal, sin cliente
  id_viaje      INT,                 -- opcional: se produce durante un viaje
  fecha_hora    DATETIME     NOT NULL,
  tipo          VARCHAR(10)  NOT NULL,
  descripcion   VARCHAR(255) NOT NULL,
  estado        VARCHAR(10)  NOT NULL DEFAULT 'abierta',   -- RN-14
  CONSTRAINT pk_incidencias 
  	PRIMARY KEY (id_incidencia),
  -- UNIQUE mantiene la relación 1:1: un viaje produce como máximo una incidencia (S-03)
  CONSTRAINT uq_incidencias_id_viaje 
  	UNIQUE (id_viaje),
  CONSTRAINT fk_incidencias_vehiculos 
  	FOREIGN KEY (id_vehiculo)
    REFERENCES vehiculos (id_vehiculo)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT fk_incidencias_clientes 
  	FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT fk_incidencias_viajes 
  	FOREIGN KEY (id_viaje)
    REFERENCES viajes (id_viaje)
    	ON DELETE RESTRICT 
    	ON UPDATE RESTRICT,
  CONSTRAINT ck_incidencias_tipo
    CHECK (tipo IN ('avería', 'daño', 'batería', 'otro')),
  CONSTRAINT ck_incidencias_estado
    CHECK (estado IN ('abierta', 'en curso', 'resuelta'))
);