-- =========================================================
-- BASE DE DATOS
-- =========================================================

DROP DATABASE IF EXISTS gestion_cargas;

CREATE DATABASE gestion_cargas;

USE gestion_cargas;


-- =========================================================
-- 1. VEHÍCULOS
-- =========================================================

CREATE TABLE vehiculos (
    id_vehiculo INT NOT NULL AUTO_INCREMENT,
    matricula VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_vehiculo),

    UNIQUE (matricula)
);


-- =========================================================
-- 2. RUTAS
-- =========================================================

CREATE TABLE rutas (
    id_ruta INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),

    PRIMARY KEY (id_ruta)
);


-- =========================================================
-- 3. ZONAS
-- =========================================================

CREATE TABLE zonas (
    id_zona INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_zona)
);


-- =========================================================
-- 4. ZONAS QUE PERTENECEN A CADA RUTA
-- =========================================================

CREATE TABLE ruta_zona (
    id_ruta INT NOT NULL,
    id_zona INT NOT NULL,
    orden INT NOT NULL,

    PRIMARY KEY (id_ruta, id_zona),

    CONSTRAINT fk_ruta_zona_ruta
        FOREIGN KEY (id_ruta)
        REFERENCES rutas(id_ruta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_ruta_zona_zona
        FOREIGN KEY (id_zona)
        REFERENCES zonas(id_zona)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- =========================================================
-- 5. CLIENTES
-- =========================================================

CREATE TABLE clientes (
    id_cliente INT NOT NULL AUTO_INCREMENT,
    nombre_empresa VARCHAR(150) NOT NULL,

    PRIMARY KEY (id_cliente)
);


-- =========================================================
-- 6. DIRECCIONES DE ENTREGA
-- =========================================================

CREATE TABLE direcciones_entrega (
    id_direccion INT NOT NULL AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    codigo_postal VARCHAR(10),
    poblacion VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    id_zona INT NOT NULL,

    PRIMARY KEY (id_direccion),

    CONSTRAINT fk_direccion_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_direccion_zona
        FOREIGN KEY (id_zona)
        REFERENCES zonas(id_zona)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =========================================================
-- 7. CARGAS
--
-- Una carga representa un servicio concreto de un vehículo.
--
-- Ejemplo:
--
-- Camión 1
--   08:00 -> Ruta Madrid
--   14:00 -> Ruta Ciudad Real
--   18:00 -> Ruta Albacete
--
-- =========================================================

CREATE TABLE cargas (
    id_carga INT NOT NULL AUTO_INCREMENT,
    id_vehiculo INT NOT NULL,
    id_ruta INT NOT NULL,
    fecha DATE NOT NULL,
    hora_salida TIME,
    hora_fin TIME,
    estado ENUM(
        'pendiente',
        'en preparacion',
        'cargada',
        'finalizada'
    ) NOT NULL DEFAULT 'pendiente',

    PRIMARY KEY (id_carga),

    CONSTRAINT fk_carga_vehiculo
        FOREIGN KEY (id_vehiculo)
        REFERENCES vehiculos(id_vehiculo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_carga_ruta
        FOREIGN KEY (id_ruta)
        REFERENCES rutas(id_ruta)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =========================================================
-- 8. PALETS
--
-- El palé es la unidad que se escanea/carga.
--
-- Un palé puede contener varios pedidos.
--
-- =========================================================

CREATE TABLE palets (
    id_palet INT NOT NULL AUTO_INCREMENT,
    id_carga INT NOT NULL,
    id_cliente INT NOT NULL,
    id_direccion INT NOT NULL,
    cod_escaneo VARCHAR(50) NOT NULL,
    estado ENUM(
        'cargado',
        'no cargado'
    ) NOT NULL DEFAULT 'no cargado',

    PRIMARY KEY (id_palet),

    UNIQUE (cod_escaneo),

    CONSTRAINT fk_palet_carga
        FOREIGN KEY (id_carga)
        REFERENCES cargas(id_carga)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_palet_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_palet_direccion
        FOREIGN KEY (id_direccion)
        REFERENCES direcciones_entrega(id_direccion)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =========================================================
-- 9. ARTÍCULOS
-- =========================================================

CREATE TABLE articulos (
    id_articulo INT NOT NULL AUTO_INCREMENT,
    nom_articulo VARCHAR(150) NOT NULL,

    PRIMARY KEY (id_articulo)
);


-- =========================================================
-- 10. PEDIDOS
--
-- Un palé puede tener varios pedidos.
--
-- El cliente y la dirección se obtienen a través del palé.
--
-- =========================================================

CREATE TABLE pedidos (
    id_pedido INT NOT NULL AUTO_INCREMENT,
    id_palet INT NOT NULL,
    id_articulo INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,

    PRIMARY KEY (id_pedido),

    CONSTRAINT fk_pedido_palet
        FOREIGN KEY (id_palet)
        REFERENCES palets(id_palet)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_pedido_articulo
        FOREIGN KEY (id_articulo)
        REFERENCES articulos(id_articulo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

USE gestion_cargas;


-- ============================================================
-- 1. VEHÍCULOS
-- ============================================================

INSERT INTO vehiculos (id_vehiculo, matricula, nombre) VALUES
(1, '1234-ABC', 'Camión 1'),
(2, '5678-DEF', 'Camión 2'),
(3, '9012-GHI', 'Camión 3'),
(4, '3456-JKL', 'Camión 4'),
(5, '7890-MNO', 'Furgoneta');


-- ============================================================
-- 2. RUTAS
-- ============================================================

INSERT INTO rutas (id_ruta, nombre, descripcion) VALUES
(1, 'Ruta Centro', 'Ciudad Real - Toledo - Guadalajara - Madrid'),
(2, 'Ruta Levante', 'Albacete - Valencia - Castellón'),
(3, 'Ruta Andalucía', 'Jaén - Córdoba - Sevilla - Cádiz'),
(4, 'Ruta Norte', 'Burgos - Álava - Bizkaia - Cantabria'),
(5, 'Ruta Galicia', 'León - Lugo - A Coruña - Pontevedra'),
(6, 'Ruta Cataluña', 'Lleida - Tarragona - Barcelona - Girona'),
(7, 'Ruta Aragón', 'Teruel - Zaragoza - Huesca'),
(8, 'Ruta Extremadura', 'Cáceres - Badajoz'),
(9, 'Ruta Murcia', 'Albacete - Murcia - Almería'),
(10, 'Ruta Castilla y León', 'Valladolid - Palencia - Salamanca - Zamora'),
(11, 'Internacional', 'Transporte internacional');


-- ============================================================
-- 3. ZONAS - 50 PROVINCIAS
-- ============================================================

INSERT INTO zonas (id_zona, nombre, provincia) VALUES
(1, 'Álava', 'Álava'),
(2, 'Albacete', 'Albacete'),
(3, 'Alicante', 'Alicante'),
(4, 'Almería', 'Almería'),
(5, 'Asturias', 'Asturias'),
(6, 'Ávila', 'Ávila'),
(7, 'Badajoz', 'Badajoz'),
(8, 'Barcelona', 'Barcelona'),
(9, 'Bizkaia', 'Bizkaia'),
(10, 'Burgos', 'Burgos'),
(11, 'Cáceres', 'Cáceres'),
(12, 'Cádiz', 'Cádiz'),
(13, 'Cantabria', 'Cantabria'),
(14, 'Castellón', 'Castellón'),
(15, 'Ciudad Real', 'Ciudad Real'),
(16, 'Córdoba', 'Córdoba'),
(17, 'Cuenca', 'Cuenca'),
(18, 'Girona', 'Girona'),
(19, 'Granada', 'Granada'),
(20, 'Guadalajara', 'Guadalajara'),
(21, 'Gipuzkoa', 'Gipuzkoa'),
(22, 'Huelva', 'Huelva'),
(23, 'Huesca', 'Huesca'),
(24, 'Illes Balears', 'Illes Balears'),
(25, 'Jaén', 'Jaén'),
(26, 'A Coruña', 'A Coruña'),
(27, 'La Rioja', 'La Rioja'),
(28, 'Las Palmas', 'Las Palmas'),
(29, 'León', 'León'),
(30, 'Lleida', 'Lleida'),
(31, 'Lugo', 'Lugo'),
(32, 'Madrid', 'Madrid'),
(33, 'Málaga', 'Málaga'),
(34, 'Murcia', 'Murcia'),
(35, 'Navarra', 'Navarra'),
(36, 'Ourense', 'Ourense'),
(37, 'Palencia', 'Palencia'),
(38, 'Pontevedra', 'Pontevedra'),
(39, 'Salamanca', 'Salamanca'),
(40, 'Santa Cruz de Tenerife', 'Santa Cruz de Tenerife'),
(41, 'Segovia', 'Segovia'),
(42, 'Sevilla', 'Sevilla'),
(43, 'Soria', 'Soria'),
(44, 'Tarragona', 'Tarragona'),
(45, 'Teruel', 'Teruel'),
(46, 'Toledo', 'Toledo'),
(47, 'Valencia', 'Valencia'),
(48, 'Valladolid', 'Valladolid'),
(49, 'Zamora', 'Zamora'),
(50, 'Zaragoza', 'Zaragoza');


-- ============================================================
-- 4. RUTA_ZONA
-- ============================================================

INSERT INTO ruta_zona (id_ruta, id_zona, orden) VALUES

-- Ruta Centro
(1, 15, 1),
(1, 46, 2),
(1, 20, 3),
(1, 32, 4),

-- Ruta Levante
(2, 2, 1),
(2, 47, 2),
(2, 14, 3),

-- Ruta Andalucía
(3, 25, 1),
(3, 16, 2),
(3, 42, 3),
(3, 12, 4),

-- Ruta Norte
(4, 10, 1),
(4, 1, 2),
(4, 9, 3),
(4, 13, 4),

-- Ruta Galicia
(5, 29, 1),
(5, 31, 2),
(5, 26, 3),
(5, 38, 4),

-- Ruta Cataluña
(6, 30, 1),
(6, 44, 2),
(6, 8, 3),
(6, 18, 4),

-- Ruta Aragón
(7, 45, 1),
(7, 50, 2),
(7, 23, 3),

-- Ruta Extremadura
(8, 11, 1),
(8, 7, 2),

-- Ruta Murcia
(9, 2, 1),
(9, 34, 2),
(9, 4, 3),

-- Ruta Castilla y León
(10, 48, 1),
(10, 37, 2),
(10, 39, 3),
(10, 49, 4);


-- ============================================================
-- 5. CLIENTES
-- 100 CLIENTES
-- ============================================================

INSERT INTO clientes (id_cliente, nombre_empresa) VALUES
(1, 'Muebles García'),
(2, 'Muebles López'),
(3, 'Muebles Sánchez'),
(4, 'Muebles Martínez'),
(5, 'Muebles Rodríguez'),
(6, 'Muebles Fernández'),
(7, 'Muebles González'),
(8, 'Muebles Pérez'),
(9, 'Muebles Gómez'),
(10, 'Muebles Martín'),
(11, 'Decoraciones Ruiz'),
(12, 'Decoraciones Díaz'),
(13, 'Decoraciones Moreno'),
(14, 'Decoraciones Muñoz'),
(15, 'Decoraciones Álvarez'),
(16, 'Decoraciones Romero'),
(17, 'Decoraciones Alonso'),
(18, 'Decoraciones Navarro'),
(19, 'Decoraciones Gutiérrez'),
(20, 'Decoraciones Domínguez'),
(21, 'Hogar Moderno'),
(22, 'Hogar Actual'),
(23, 'Hogar Ideal'),
(24, 'Hogar Confort'),
(25, 'Hogar 2000'),
(26, 'Hogar Plus'),
(27, 'Hogar Diseño'),
(28, 'Hogar Selecto'),
(29, 'Hogar Mediterráneo'),
(30, 'Hogar Castilla'),
(31, 'Interiorismo Ruiz'),
(32, 'Interiorismo Díaz'),
(33, 'Interiorismo López'),
(34, 'Interiorismo García'),
(35, 'Interiorismo Norte'),
(36, 'Interiorismo Sur'),
(37, 'Interiorismo Centro'),
(38, 'Interiorismo Levante'),
(39, 'Interiorismo Galicia'),
(40, 'Interiorismo Andalucía'),
(41, 'Grupo Mobiliario 1'),
(42, 'Grupo Mobiliario 2'),
(43, 'Grupo Mobiliario 3'),
(44, 'Grupo Mobiliario 4'),
(45, 'Grupo Mobiliario 5'),
(46, 'Grupo Mobiliario 6'),
(47, 'Grupo Mobiliario 7'),
(48, 'Grupo Mobiliario 8'),
(49, 'Grupo Mobiliario 9'),
(50, 'Grupo Mobiliario 10'),
(51, 'Muebles El Roble'),
(52, 'Muebles La Encina'),
(53, 'Muebles El Olivo'),
(54, 'Muebles La Casa'),
(55, 'Muebles Castilla'),
(56, 'Muebles Levante'),
(57, 'Muebles Norte'),
(58, 'Muebles Sur'),
(59, 'Muebles Centro'),
(60, 'Muebles España'),
(61, 'Casa y Diseño'),
(62, 'Casa Moderna'),
(63, 'Casa Elegante'),
(64, 'Casa Confort'),
(65, 'Casa Selecta'),
(66, 'Casa Mediterránea'),
(67, 'Casa Urbana'),
(68, 'Casa Rural'),
(69, 'Casa Premium'),
(70, 'Casa Interior'),
(71, 'Espacios Modernos'),
(72, 'Espacios Diseño'),
(73, 'Espacios Hogar'),
(74, 'Espacios Confort'),
(75, 'Espacios Premium'),
(76, 'Mobiliario Profesional'),
(77, 'Mobiliario Comercial'),
(78, 'Mobiliario Hogar'),
(79, 'Mobiliario Oficina'),
(80, 'Mobiliario Hotel'),
(81, 'Distribuciones García'),
(82, 'Distribuciones López'),
(83, 'Distribuciones Sánchez'),
(84, 'Distribuciones Pérez'),
(85, 'Distribuciones Martín'),
(86, 'Distribuciones Ruiz'),
(87, 'Distribuciones Díaz'),
(88, 'Distribuciones Moreno'),
(89, 'Distribuciones Alonso'),
(90, 'Distribuciones Navarro'),
(91, 'Almacenes Mobiliario'),
(92, 'Almacenes Hogar'),
(93, 'Almacenes Diseño'),
(94, 'Almacenes Centro'),
(95, 'Almacenes Norte'),
(96, 'Almacenes Sur'),
(97, 'Almacenes Levante'),
(98, 'Almacenes Andalucía'),
(99, 'Almacenes Galicia'),
(100, 'Almacenes Cataluña');


-- ============================================================
-- 6. DIRECCIONES DE ENTREGA
--
-- Cada cliente tiene una dirección.
-- Las provincias se distribuyen entre los 50 registros de zonas.
-- ============================================================

INSERT INTO direcciones_entrega
(id_direccion, id_cliente, direccion, codigo_postal, poblacion, provincia, id_zona)
SELECT
    id_cliente,
    id_cliente,
    CONCAT('Calle Principal ', id_cliente),
    CONCAT(
        LPAD(
            CASE
                WHEN ((id_cliente - 1) % 50) + 1 = 15 THEN 13
                WHEN ((id_cliente - 1) % 50) + 1 = 46 THEN 45
                WHEN ((id_cliente - 1) % 50) + 1 = 32 THEN 28
                ELSE 1
            END,
            2,
            '0'
        ),
        '000'
    ),
    z.nombre,
    z.provincia,
    z.id_zona
FROM clientes c
JOIN zonas z
    ON z.id_zona = ((c.id_cliente - 1) % 50) + 1;


-- ============================================================
-- 7. ARTÍCULOS
-- 100 ARTÍCULOS
-- ============================================================

INSERT INTO articulos (id_articulo, nom_articulo) VALUES
(1, 'Mesa comedor Roma'),
(2, 'Mesa comedor París'),
(3, 'Mesa comedor Madrid'),
(4, 'Mesa comedor Lisboa'),
(5, 'Mesa comedor Oslo'),
(6, 'Mesa comedor Berlín'),
(7, 'Mesa comedor Milán'),
(8, 'Mesa comedor Viena'),
(9, 'Mesa comedor Londres'),
(10, 'Mesa comedor Atenas'),
(11, 'Silla Roma'),
(12, 'Silla París'),
(13, 'Silla Madrid'),
(14, 'Silla Lisboa'),
(15, 'Silla Oslo'),
(16, 'Silla Berlín'),
(17, 'Silla Milán'),
(18, 'Silla Viena'),
(19, 'Silla Londres'),
(20, 'Silla Atenas'),
(21, 'Armario Roma'),
(22, 'Armario París'),
(23, 'Armario Madrid'),
(24, 'Armario Lisboa'),
(25, 'Armario Oslo'),
(26, 'Armario Berlín'),
(27, 'Armario Milán'),
(28, 'Armario Viena'),
(29, 'Armario Londres'),
(30, 'Armario Atenas'),
(31, 'Cómoda Roma'),
(32, 'Cómoda París'),
(33, 'Cómoda Madrid'),
(34, 'Cómoda Lisboa'),
(35, 'Cómoda Oslo'),
(36, 'Cómoda Berlín'),
(37, 'Cómoda Milán'),
(38, 'Cómoda Viena'),
(39, 'Cómoda Londres'),
(40, 'Cómoda Atenas'),
(41, 'Mesita Roma'),
(42, 'Mesita París'),
(43, 'Mesita Madrid'),
(44, 'Mesita Lisboa'),
(45, 'Mesita Oslo'),
(46, 'Mesita Berlín'),
(47, 'Mesita Milán'),
(48, 'Mesita Viena'),
(49, 'Mesita Londres'),
(50, 'Mesita Atenas'),
(51, 'Mueble TV Roma'),
(52, 'Mueble TV París'),
(53, 'Mueble TV Madrid'),
(54, 'Mueble TV Lisboa'),
(55, 'Mueble TV Oslo'),
(56, 'Mueble TV Berlín'),
(57, 'Mueble TV Milán'),
(58, 'Mueble TV Viena'),
(59, 'Mueble TV Londres'),
(60, 'Mueble TV Atenas'),
(61, 'Estantería Roma'),
(62, 'Estantería París'),
(63, 'Estantería Madrid'),
(64, 'Estantería Lisboa'),
(65, 'Estantería Oslo'),
(66, 'Estantería Berlín'),
(67, 'Estantería Milán'),
(68, 'Estantería Viena'),
(69, 'Estantería Londres'),
(70, 'Estantería Atenas'),
(71, 'Aparador Roma'),
(72, 'Aparador París'),
(73, 'Aparador Madrid'),
(74, 'Aparador Lisboa'),
(75, 'Aparador Oslo'),
(76, 'Aparador Berlín'),
(77, 'Aparador Milán'),
(78, 'Aparador Viena'),
(79, 'Aparador Londres'),
(80, 'Aparador Atenas'),
(81, 'Cabecero Roma'),
(82, 'Cabecero París'),
(83, 'Cabecero Madrid'),
(84, 'Cabecero Lisboa'),
(85, 'Cabecero Oslo'),
(86, 'Cabecero Berlín'),
(87, 'Cabecero Milán'),
(88, 'Cabecero Viena'),
(89, 'Cabecero Londres'),
(90, 'Cabecero Atenas'),
(91, 'Mueble auxiliar Roma'),
(92, 'Mueble auxiliar París'),
(93, 'Mueble auxiliar Madrid'),
(94, 'Mueble auxiliar Lisboa'),
(95, 'Mueble auxiliar Oslo'),
(96, 'Mueble auxiliar Berlín'),
(97, 'Mueble auxiliar Milán'),
(98, 'Mueble auxiliar Viena'),
(99, 'Mueble auxiliar Londres'),
(100, 'Mueble auxiliar Atenas');


-- ============================================================
-- 8. CARGAS
--
-- 100 cargas.
--
-- Las fechas van desde 25 días atrás hasta 24 días adelante.
--
-- Los vehículos pueden tener varias cargas el mismo día.
--
-- La carga 100 es INTERNACIONAL y ese día el Camión 2
-- no tiene ninguna otra carga.
-- ============================================================

INSERT INTO cargas
(id_carga, id_vehiculo, id_ruta, fecha, hora_salida, hora_fin, estado)
VALUES

(1, 1, 1, DATE_SUB(CURDATE(), INTERVAL 25 DAY), '07:00:00', '13:00:00', 'finalizada'),
(2, 2, 2, DATE_SUB(CURDATE(), INTERVAL 25 DAY), '08:00:00', '14:00:00', 'finalizada'),

(3, 3, 3, DATE_SUB(CURDATE(), INTERVAL 24 DAY), '06:30:00', '14:00:00', 'finalizada'),
(4, 4, 4, DATE_SUB(CURDATE(), INTERVAL 24 DAY), '07:00:00', '15:00:00', 'finalizada'),

(5, 5, 5, DATE_SUB(CURDATE(), INTERVAL 23 DAY), '06:00:00', '15:00:00', 'finalizada'),
(6, 1, 6, DATE_SUB(CURDATE(), INTERVAL 23 DAY), '07:30:00', '16:00:00', 'finalizada'),

(7, 2, 7, DATE_SUB(CURDATE(), INTERVAL 22 DAY), '07:00:00', '14:00:00', 'finalizada'),
(8, 3, 8, DATE_SUB(CURDATE(), INTERVAL 22 DAY), '08:00:00', '14:00:00', 'finalizada'),

(9, 4, 9, DATE_SUB(CURDATE(), INTERVAL 21 DAY), '07:00:00', '15:00:00', 'finalizada'),
(10, 5, 10, DATE_SUB(CURDATE(), INTERVAL 21 DAY), '08:00:00', '14:00:00', 'finalizada'),

(11, 1, 2, DATE_SUB(CURDATE(), INTERVAL 20 DAY), '07:00:00', '13:00:00', 'finalizada'),
(12, 1, 1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), '15:00:00', '20:00:00', 'finalizada'),

(13, 2, 3, DATE_SUB(CURDATE(), INTERVAL 19 DAY), '06:30:00', '14:00:00', 'finalizada'),
(14, 3, 4, DATE_SUB(CURDATE(), INTERVAL 19 DAY), '07:00:00', '15:00:00', 'finalizada'),

(15, 4, 5, DATE_SUB(CURDATE(), INTERVAL 18 DAY), '06:00:00', '15:00:00', 'finalizada'),
(16, 5, 6, DATE_SUB(CURDATE(), INTERVAL 18 DAY), '08:00:00', '16:00:00', 'finalizada'),

(17, 1, 7, DATE_SUB(CURDATE(), INTERVAL 17 DAY), '07:00:00', '14:00:00', 'finalizada'),
(18, 2, 8, DATE_SUB(CURDATE(), INTERVAL 17 DAY), '08:00:00', '14:00:00', 'finalizada'),

(19, 3, 9, DATE_SUB(CURDATE(), INTERVAL 16 DAY), '07:00:00', '15:00:00', 'finalizada'),
(20, 4, 10, DATE_SUB(CURDATE(), INTERVAL 16 DAY), '07:00:00', '14:00:00', 'finalizada'),

(21, 5, 1, DATE_SUB(CURDATE(), INTERVAL 15 DAY), '08:00:00', '14:00:00', 'finalizada'),
(22, 1, 3, DATE_SUB(CURDATE(), INTERVAL 15 DAY), '15:00:00', '21:00:00', 'finalizada'),

(23, 2, 4, DATE_SUB(CURDATE(), INTERVAL 14 DAY), '07:00:00', '15:00:00', 'finalizada'),
(24, 3, 5, DATE_SUB(CURDATE(), INTERVAL 14 DAY), '06:00:00', '15:00:00', 'finalizada'),

(25, 4, 6, DATE_SUB(CURDATE(), INTERVAL 13 DAY), '07:00:00', '16:00:00', 'finalizada'),
(26, 5, 7, DATE_SUB(CURDATE(), INTERVAL 13 DAY), '08:00:00', '15:00:00', 'finalizada'),

(27, 1, 8, DATE_SUB(CURDATE(), INTERVAL 12 DAY), '07:00:00', '14:00:00', 'finalizada'),
(28, 2, 9, DATE_SUB(CURDATE(), INTERVAL 12 DAY), '07:00:00', '15:00:00', 'finalizada'),

(29, 3, 10, DATE_SUB(CURDATE(), INTERVAL 11 DAY), '07:00:00', '14:00:00', 'finalizada'),
(30, 4, 1, DATE_SUB(CURDATE(), INTERVAL 11 DAY), '08:00:00', '15:00:00', 'finalizada'),

(31, 5, 2, DATE_SUB(CURDATE(), INTERVAL 10 DAY), '08:00:00', '14:00:00', 'finalizada'),
(32, 1, 4, DATE_SUB(CURDATE(), INTERVAL 10 DAY), '15:00:00', '21:00:00', 'finalizada'),

(33, 2, 5, DATE_SUB(CURDATE(), INTERVAL 9 DAY), '06:00:00', '15:00:00', 'finalizada'),
(34, 3, 6, DATE_SUB(CURDATE(), INTERVAL 9 DAY), '07:00:00', '16:00:00', 'finalizada'),

(35, 4, 7, DATE_SUB(CURDATE(), INTERVAL 8 DAY), '07:00:00', '14:00:00', 'finalizada'),
(36, 5, 8, DATE_SUB(CURDATE(), INTERVAL 8 DAY), '08:00:00', '14:00:00', 'finalizada'),

(37, 1, 9, DATE_SUB(CURDATE(), INTERVAL 7 DAY), '07:00:00', '15:00:00', 'finalizada'),
(38, 2, 10, DATE_SUB(CURDATE(), INTERVAL 7 DAY), '07:00:00', '14:00:00', 'finalizada'),

(39, 3, 1, DATE_SUB(CURDATE(), INTERVAL 6 DAY), '07:00:00', '14:00:00', 'finalizada'),
(40, 4, 2, DATE_SUB(CURDATE(), INTERVAL 6 DAY), '08:00:00', '15:00:00', 'finalizada'),

(41, 5, 3, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '06:30:00', '14:00:00', 'finalizada'),
(42, 1, 5, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '15:00:00', '21:00:00', 'finalizada'),

(43, 2, 6, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '07:00:00', '16:00:00', 'finalizada'),
(44, 3, 7, DATE_SUB(CURDATE(), INTERVAL 4 DAY), '07:00:00', '14:00:00', 'finalizada'),

(45, 4, 8, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:00:00', '14:00:00', 'finalizada'),
(46, 5, 9, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '08:00:00', '15:00:00', 'finalizada'),

(47, 1, 10, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '07:00:00', '14:00:00', 'finalizada'),
(48, 2, 1, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '07:00:00', '14:00:00', 'finalizada'),

(49, 3, 2, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '07:00:00', '14:00:00', 'finalizada'),
(50, 4, 3, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '06:30:00', '14:00:00', 'finalizada'),

-- ==========================================================
-- HOY
-- ==========================================================

(51, 1, 1, CURDATE(), '07:00:00', NULL, 'en preparacion'),
(52, 1, 2, CURDATE(), '15:00:00', NULL, 'pendiente'),

(53, 2, 3, CURDATE(), '06:30:00', NULL, 'en preparacion'),

(54, 3, 4, CURDATE(), '07:00:00', NULL, 'en preparacion'),
(55, 3, 7, CURDATE(), '16:00:00', NULL, 'pendiente'),

(56, 4, 5, CURDATE(), '06:00:00', NULL, 'en preparacion'),

(57, 5, 1, CURDATE(), '09:00:00', NULL, 'pendiente'),
(58, 5, 9, CURDATE(), '16:00:00', NULL, 'pendiente'),

-- ==========================================================
-- FUTURAS
-- ==========================================================

(59, 1, 6, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '07:00:00', NULL, 'pendiente'),
(60, 2, 7, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '07:00:00', NULL, 'pendiente'),

(61, 3, 8, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '08:00:00', NULL, 'pendiente'),
(62, 4, 9, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '07:00:00', NULL, 'pendiente'),

(63, 5, 10, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '08:00:00', NULL, 'pendiente'),
(64, 1, 3, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '15:00:00', NULL, 'pendiente'),

(65, 2, 4, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '07:00:00', NULL, 'pendiente'),
(66, 3, 5, DATE_ADD(CURDATE(), INTERVAL 4 DAY), '06:00:00', NULL, 'pendiente'),

(67, 4, 6, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '07:00:00', NULL, 'pendiente'),
(68, 5, 7, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '08:00:00', NULL, 'pendiente'),

(69, 1, 8, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '07:00:00', NULL, 'pendiente'),
(70, 2, 9, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '07:00:00', NULL, 'pendiente'),

(71, 3, 10, DATE_ADD(CURDATE(), INTERVAL 7 DAY), '07:00:00', NULL, 'pendiente'),
(72, 4, 1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), '08:00:00', NULL, 'pendiente'),

(73, 5, 2, DATE_ADD(CURDATE(), INTERVAL 8 DAY), '08:00:00', NULL, 'pendiente'),
(74, 1, 4, DATE_ADD(CURDATE(), INTERVAL 8 DAY), '15:00:00', NULL, 'pendiente'),

(75, 2, 5, DATE_ADD(CURDATE(), INTERVAL 9 DAY), '06:00:00', NULL, 'pendiente'),
(76, 3, 6, DATE_ADD(CURDATE(), INTERVAL 9 DAY), '07:00:00', NULL, 'pendiente'),

(77, 4, 7, DATE_ADD(CURDATE(), INTERVAL 10 DAY), '07:00:00', NULL, 'pendiente'),
(78, 5, 8, DATE_ADD(CURDATE(), INTERVAL 10 DAY), '08:00:00', NULL, 'pendiente'),

(79, 1, 9, DATE_ADD(CURDATE(), INTERVAL 11 DAY), '07:00:00', NULL, 'pendiente'),
(80, 2, 10, DATE_ADD(CURDATE(), INTERVAL 11 DAY), '07:00:00', NULL, 'pendiente'),

(81, 3, 1, DATE_ADD(CURDATE(), INTERVAL 12 DAY), '07:00:00', NULL, 'pendiente'),
(82, 4, 2, DATE_ADD(CURDATE(), INTERVAL 12 DAY), '08:00:00', NULL, 'pendiente'),

(83, 5, 3, DATE_ADD(CURDATE(), INTERVAL 13 DAY), '06:30:00', NULL, 'pendiente'),
(84, 1, 5, DATE_ADD(CURDATE(), INTERVAL 13 DAY), '15:00:00', NULL, 'pendiente'),

(85, 2, 6, DATE_ADD(CURDATE(), INTERVAL 14 DAY), '07:00:00', NULL, 'pendiente'),
(86, 3, 7, DATE_ADD(CURDATE(), INTERVAL 14 DAY), '07:00:00', NULL, 'pendiente'),

(87, 4, 8, DATE_ADD(CURDATE(), INTERVAL 15 DAY), '08:00:00', NULL, 'pendiente'),
(88, 5, 9, DATE_ADD(CURDATE(), INTERVAL 15 DAY), '08:00:00', NULL, 'pendiente'),

(89, 1, 10, DATE_ADD(CURDATE(), INTERVAL 16 DAY), '07:00:00', NULL, 'pendiente'),
(90, 2, 1, DATE_ADD(CURDATE(), INTERVAL 16 DAY), '07:00:00', NULL, 'pendiente'),

(91, 3, 2, DATE_ADD(CURDATE(), INTERVAL 17 DAY), '07:00:00', NULL, 'pendiente'),
(92, 4, 3, DATE_ADD(CURDATE(), INTERVAL 18 DAY), '06:30:00', NULL, 'pendiente'),

(93, 5, 4, DATE_ADD(CURDATE(), INTERVAL 19 DAY), '07:00:00', NULL, 'pendiente'),
(94, 1, 6, DATE_ADD(CURDATE(), INTERVAL 20 DAY), '07:00:00', NULL, 'pendiente'),

(95, 2, 7, DATE_ADD(CURDATE(), INTERVAL 21 DAY), '07:00:00', NULL, 'pendiente'),
(96, 3, 8, DATE_ADD(CURDATE(), INTERVAL 22 DAY), '08:00:00', NULL, 'pendiente'),

(97, 4, 9, DATE_ADD(CURDATE(), INTERVAL 23 DAY), '07:00:00', NULL, 'pendiente'),
(98, 5, 10, DATE_ADD(CURDATE(), INTERVAL 23 DAY), '08:00:00', NULL, 'pendiente'),

(99, 4, 6, DATE_ADD(CURDATE(), INTERVAL 24 DAY), '07:00:00', NULL, 'pendiente'),

-- INTERNACIONAL
(100, 2, 11, DATE_ADD(CURDATE(), INTERVAL 24 DAY), '05:00:00', NULL, 'pendiente');


-- ============================================================
-- 9. PALETS
--
-- 2 PALETS POR CADA CARGA = 200 PALETS
--
-- Los clientes/direcciones se seleccionan automáticamente.
-- ============================================================

INSERT INTO palets
(id_palet, id_carga, id_cliente, id_direccion, cod_escaneo, estado)

SELECT
    p.id_palet,
    p.id_carga,
    c.id_cliente,
    c.id_cliente,
    CONCAT('PAL-', LPAD(p.id_palet, 5, '0')),
    CASE
        WHEN ca.fecha < CURDATE() THEN 'cargado'
        ELSE 'no cargado'
    END
FROM
(
    SELECT
        n AS id_palet,
        CEIL(n / 2) AS id_carga
    FROM
    (
        SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL
        SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
        SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL
        SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
        SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL
        SELECT 19 UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL
        SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL
        SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL
        SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30 UNION ALL
        SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL
        SELECT 34 UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL
        SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL
        SELECT 40 UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL
        SELECT 43 UNION ALL SELECT 44 UNION ALL SELECT 45 UNION ALL
        SELECT 46 UNION ALL SELECT 47 UNION ALL SELECT 48 UNION ALL
        SELECT 49 UNION ALL SELECT 50 UNION ALL SELECT 51 UNION ALL
        SELECT 52 UNION ALL SELECT 53 UNION ALL SELECT 54 UNION ALL
        SELECT 55 UNION ALL SELECT 56 UNION ALL SELECT 57 UNION ALL
        SELECT 58 UNION ALL SELECT 59 UNION ALL SELECT 60 UNION ALL
        SELECT 61 UNION ALL SELECT 62 UNION ALL SELECT 63 UNION ALL
        SELECT 64 UNION ALL SELECT 65 UNION ALL SELECT 66 UNION ALL
        SELECT 67 UNION ALL SELECT 68 UNION ALL SELECT 69 UNION ALL
        SELECT 70 UNION ALL SELECT 71 UNION ALL SELECT 72 UNION ALL
        SELECT 73 UNION ALL SELECT 74 UNION ALL SELECT 75 UNION ALL
        SELECT 76 UNION ALL SELECT 77 UNION ALL SELECT 78 UNION ALL
        SELECT 79 UNION ALL SELECT 80 UNION ALL SELECT 81 UNION ALL
        SELECT 82 UNION ALL SELECT 83 UNION ALL SELECT 84 UNION ALL
        SELECT 85 UNION ALL SELECT 86 UNION ALL SELECT 87 UNION ALL
        SELECT 88 UNION ALL SELECT 89 UNION ALL SELECT 90 UNION ALL
        SELECT 91 UNION ALL SELECT 92 UNION ALL SELECT 93 UNION ALL
        SELECT 94 UNION ALL SELECT 95 UNION ALL SELECT 96 UNION ALL
        SELECT 97 UNION ALL SELECT 98 UNION ALL SELECT 99 UNION ALL
        SELECT 100 UNION ALL SELECT 101 UNION ALL SELECT 102 UNION ALL
        SELECT 103 UNION ALL SELECT 104 UNION ALL SELECT 105 UNION ALL
        SELECT 106 UNION ALL SELECT 107 UNION ALL SELECT 108 UNION ALL
        SELECT 109 UNION ALL SELECT 110 UNION ALL SELECT 111 UNION ALL
        SELECT 112 UNION ALL SELECT 113 UNION ALL SELECT 114 UNION ALL
        SELECT 115 UNION ALL SELECT 116 UNION ALL SELECT 117 UNION ALL
        SELECT 118 UNION ALL SELECT 119 UNION ALL SELECT 120 UNION ALL
        SELECT 121 UNION ALL SELECT 122 UNION ALL SELECT 123 UNION ALL
        SELECT 124 UNION ALL SELECT 125 UNION ALL SELECT 126 UNION ALL
        SELECT 127 UNION ALL SELECT 128 UNION ALL SELECT 129 UNION ALL
        SELECT 130 UNION ALL SELECT 131 UNION ALL SELECT 132 UNION ALL
        SELECT 133 UNION ALL SELECT 134 UNION ALL SELECT 135 UNION ALL
        SELECT 136 UNION ALL SELECT 137 UNION ALL SELECT 138 UNION ALL
        SELECT 139 UNION ALL SELECT 140 UNION ALL SELECT 141 UNION ALL
        SELECT 142 UNION ALL SELECT 143 UNION ALL SELECT 144 UNION ALL
        SELECT 145 UNION ALL SELECT 146 UNION ALL SELECT 147 UNION ALL
        SELECT 148 UNION ALL SELECT 149 UNION ALL SELECT 150 UNION ALL
        SELECT 151 UNION ALL SELECT 152 UNION ALL SELECT 153 UNION ALL
        SELECT 154 UNION ALL SELECT 155 UNION ALL SELECT 156 UNION ALL
        SELECT 157 UNION ALL SELECT 158 UNION ALL SELECT 159 UNION ALL
        SELECT 160 UNION ALL SELECT 161 UNION ALL SELECT 162 UNION ALL
        SELECT 163 UNION ALL SELECT 164 UNION ALL SELECT 165 UNION ALL
        SELECT 166 UNION ALL SELECT 167 UNION ALL SELECT 168 UNION ALL
        SELECT 169 UNION ALL SELECT 170 UNION ALL SELECT 171 UNION ALL
        SELECT 172 UNION ALL SELECT 173 UNION ALL SELECT 174 UNION ALL
        SELECT 175 UNION ALL SELECT 176 UNION ALL SELECT 177 UNION ALL
        SELECT 178 UNION ALL SELECT 179 UNION ALL SELECT 180 UNION ALL
        SELECT 181 UNION ALL SELECT 182 UNION ALL SELECT 183 UNION ALL
        SELECT 184 UNION ALL SELECT 185 UNION ALL SELECT 186 UNION ALL
        SELECT 187 UNION ALL SELECT 188 UNION ALL SELECT 189 UNION ALL
        SELECT 190 UNION ALL SELECT 191 UNION ALL SELECT 192 UNION ALL
        SELECT 193 UNION ALL SELECT 194 UNION ALL SELECT 195 UNION ALL
        SELECT 196 UNION ALL SELECT 197 UNION ALL SELECT 198 UNION ALL
        SELECT 199 UNION ALL SELECT 200
    ) numeros
) p
JOIN cargas ca
    ON ca.id_carga = p.id_carga
JOIN clientes c
    ON c.id_cliente = ((p.id_palet - 1) % 100) + 1;


-- ============================================================
-- 10. PEDIDOS
--
-- 300 PEDIDOS
-- Cada palé tiene entre 1 y 2 pedidos.
-- ============================================================

INSERT INTO pedidos (id_pedido, id_palet, id_articulo, cantidad)

SELECT
    n.id_pedido,
    CEIL(n.id_pedido / 1.5),
    ((n.id_pedido - 1) % 100) + 1,
    ((n.id_pedido - 1) % 5) + 1
FROM
(
    SELECT 1 AS id_pedido UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
    SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL
    SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15 UNION ALL
    SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL
    SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL
    SELECT 24 UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL
    SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL
    SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34 UNION ALL SELECT 35 UNION ALL
    SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39 UNION ALL
    SELECT 40 UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL
    SELECT 44 UNION ALL SELECT 45 UNION ALL SELECT 46 UNION ALL SELECT 47 UNION ALL
    SELECT 48 UNION ALL SELECT 49 UNION ALL SELECT 50 UNION ALL SELECT 51 UNION ALL
    SELECT 52 UNION ALL SELECT 53 UNION ALL SELECT 54 UNION ALL SELECT 55 UNION ALL
    SELECT 56 UNION ALL SELECT 57 UNION ALL SELECT 58 UNION ALL SELECT 59 UNION ALL
    SELECT 60 UNION ALL SELECT 61 UNION ALL SELECT 62 UNION ALL SELECT 63 UNION ALL
    SELECT 64 UNION ALL SELECT 65 UNION ALL SELECT 66 UNION ALL SELECT 67 UNION ALL
    SELECT 68 UNION ALL SELECT 69 UNION ALL SELECT 70 UNION ALL SELECT 71 UNION ALL
    SELECT 72 UNION ALL SELECT 73 UNION ALL SELECT 74 UNION ALL SELECT 75 UNION ALL
    SELECT 76 UNION ALL SELECT 77 UNION ALL SELECT 78 UNION ALL SELECT 79 UNION ALL
    SELECT 80 UNION ALL SELECT 81 UNION ALL SELECT 82 UNION ALL SELECT 83 UNION ALL
    SELECT 84 UNION ALL SELECT 85 UNION ALL SELECT 86 UNION ALL SELECT 87 UNION ALL
    SELECT 88 UNION ALL SELECT 89 UNION ALL SELECT 90 UNION ALL SELECT 91 UNION ALL
    SELECT 92 UNION ALL SELECT 93 UNION ALL SELECT 94 UNION ALL SELECT 95 UNION ALL
    SELECT 96 UNION ALL SELECT 97 UNION ALL SELECT 98 UNION ALL SELECT 99 UNION ALL
    SELECT 100 UNION ALL SELECT 101 UNION ALL SELECT 102 UNION ALL SELECT 103 UNION ALL
    SELECT 104 UNION ALL SELECT 105 UNION ALL SELECT 106 UNION ALL SELECT 107 UNION ALL
    SELECT 108 UNION ALL SELECT 109 UNION ALL SELECT 110 UNION ALL SELECT 111 UNION ALL
    SELECT 112 UNION ALL SELECT 113 UNION ALL SELECT 114 UNION ALL SELECT 115 UNION ALL
    SELECT 116 UNION ALL SELECT 117 UNION ALL SELECT 118 UNION ALL SELECT 119 UNION ALL
    SELECT 120 UNION ALL SELECT 121 UNION ALL SELECT 122 UNION ALL SELECT 123 UNION ALL
    SELECT 124 UNION ALL SELECT 125 UNION ALL SELECT 126 UNION ALL SELECT 127 UNION ALL
    SELECT 128 UNION ALL SELECT 129 UNION ALL SELECT 130 UNION ALL SELECT 131 UNION ALL
    SELECT 132 UNION ALL SELECT 133 UNION ALL SELECT 134 UNION ALL SELECT 135 UNION ALL
    SELECT 136 UNION ALL SELECT 137 UNION ALL SELECT 138 UNION ALL SELECT 139 UNION ALL
    SELECT 140 UNION ALL SELECT 141 UNION ALL SELECT 142 UNION ALL SELECT 143 UNION ALL
    SELECT 144 UNION ALL SELECT 145 UNION ALL SELECT 146 UNION ALL SELECT 147 UNION ALL
    SELECT 148 UNION ALL SELECT 149 UNION ALL SELECT 150 UNION ALL SELECT 151 UNION ALL
    SELECT 152 UNION ALL SELECT 153 UNION ALL SELECT 154 UNION ALL SELECT 155 UNION ALL
    SELECT 156 UNION ALL SELECT 157 UNION ALL SELECT 158 UNION ALL SELECT 159 UNION ALL
    SELECT 160 UNION ALL SELECT 161 UNION ALL SELECT 162 UNION ALL SELECT 163 UNION ALL
    SELECT 164 UNION ALL SELECT 165 UNION ALL SELECT 166 UNION ALL SELECT 167 UNION ALL
    SELECT 168 UNION ALL SELECT 169 UNION ALL SELECT 170 UNION ALL SELECT 171 UNION ALL
    SELECT 172 UNION ALL SELECT 173 UNION ALL SELECT 174 UNION ALL SELECT 175 UNION ALL
    SELECT 176 UNION ALL SELECT 177 UNION ALL SELECT 178 UNION ALL SELECT 179 UNION ALL
    SELECT 180 UNION ALL SELECT 181 UNION ALL SELECT 182 UNION ALL SELECT 183 UNION ALL
    SELECT 184 UNION ALL SELECT 185 UNION ALL SELECT 186 UNION ALL SELECT 187 UNION ALL
    SELECT 188 UNION ALL SELECT 189 UNION ALL SELECT 190 UNION ALL SELECT 191 UNION ALL
    SELECT 192 UNION ALL SELECT 193 UNION ALL SELECT 194 UNION ALL SELECT 195 UNION ALL
    SELECT 196 UNION ALL SELECT 197 UNION ALL SELECT 198 UNION ALL SELECT 199 UNION ALL
    SELECT 200 UNION ALL SELECT 201 UNION ALL SELECT 202 UNION ALL SELECT 203 UNION ALL
    SELECT 204 UNION ALL SELECT 205 UNION ALL SELECT 206 UNION ALL SELECT 207 UNION ALL
    SELECT 208 UNION ALL SELECT 209 UNION ALL SELECT 210 UNION ALL SELECT 211 UNION ALL
    SELECT 212 UNION ALL SELECT 213 UNION ALL SELECT 214 UNION ALL SELECT 215 UNION ALL
    SELECT 216 UNION ALL SELECT 217 UNION ALL SELECT 218 UNION ALL SELECT 219 UNION ALL
    SELECT 220 UNION ALL SELECT 221 UNION ALL SELECT 222 UNION ALL SELECT 223 UNION ALL
    SELECT 224 UNION ALL SELECT 225 UNION ALL SELECT 226 UNION ALL SELECT 227 UNION ALL
    SELECT 228 UNION ALL SELECT 229 UNION ALL SELECT 230 UNION ALL SELECT 231 UNION ALL
    SELECT 232 UNION ALL SELECT 233 UNION ALL SELECT 234 UNION ALL SELECT 235 UNION ALL
    SELECT 236 UNION ALL SELECT 237 UNION ALL SELECT 238 UNION ALL SELECT 239 UNION ALL
    SELECT 240 UNION ALL SELECT 241 UNION ALL SELECT 242 UNION ALL SELECT 243 UNION ALL
    SELECT 244 UNION ALL SELECT 245 UNION ALL SELECT 246 UNION ALL SELECT 247 UNION ALL
    SELECT 248 UNION ALL SELECT 249 UNION ALL SELECT 250 UNION ALL SELECT 251 UNION ALL
    SELECT 252 UNION ALL SELECT 253 UNION ALL SELECT 254 UNION ALL SELECT 255 UNION ALL
    SELECT 256 UNION ALL SELECT 257 UNION ALL SELECT 258 UNION ALL SELECT 259 UNION ALL
    SELECT 260 UNION ALL SELECT 261 UNION ALL SELECT 262 UNION ALL SELECT 263 UNION ALL
    SELECT 264 UNION ALL SELECT 265 UNION ALL SELECT 266 UNION ALL SELECT 267 UNION ALL
    SELECT 268 UNION ALL SELECT 269 UNION ALL SELECT 270 UNION ALL SELECT 271 UNION ALL
    SELECT 272 UNION ALL SELECT 273 UNION ALL SELECT 274 UNION ALL SELECT 275 UNION ALL
    SELECT 276 UNION ALL SELECT 277 UNION ALL SELECT 278 UNION ALL SELECT 279 UNION ALL
    SELECT 280 UNION ALL SELECT 281 UNION ALL SELECT 282 UNION ALL SELECT 283 UNION ALL
    SELECT 284 UNION ALL SELECT 285 UNION ALL SELECT 286 UNION ALL SELECT 287 UNION ALL
    SELECT 288 UNION ALL SELECT 289 UNION ALL SELECT 290 UNION ALL SELECT 291 UNION ALL
    SELECT 292 UNION ALL SELECT 293 UNION ALL SELECT 294 UNION ALL SELECT 295 UNION ALL
    SELECT 296 UNION ALL SELECT 297 UNION ALL SELECT 298 UNION ALL SELECT 299 UNION ALL
    SELECT 300
) n;


-- ============================================================
-- 11. ASEGURAR ESTADO DE LOS PALETS SEGÚN LA FECHA
-- ============================================================

UPDATE palets p
JOIN cargas c
    ON p.id_carga = c.id_carga
SET p.estado =
    CASE
        WHEN c.fecha < CURDATE() THEN 'cargado'
        ELSE 'no cargado'
    END;


