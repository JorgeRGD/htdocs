DROP DATABASE dcleaner;
CREATE DATABASE dcleaner;
USE dcleaner;

CREATE TABLE clientes (
    id smallint NOT NULL AUTO_INCREMENT,
    nombre character(55) NOT NULL,
    email  character(55) NOT NULL,
	passwd character(20) NOT NULL,
    codigo_postal numeric(5) NOT NULL,
    direccion character(95) NOT NULL,
    ciudad character(35) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE provedores (
    id smallint NOT NULL AUTO_INCREMENT,
    nombre character(55) NOT NULL,
	email character(55) NOT NULL,
    telefono character(10) NOT NULL, 
    codigo_postal numeric(5) NOT NULL,
    direccion character(95) NOT NULL,
    ciudad character(35) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE categoria  (
    id smallint NOT NULL AUTO_INCREMENT,
    nombre character(55) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE productos (
    id smallint NOT NULL AUTO_INCREMENT,
    nombre character(55) NOT NULL,
	descripcion character(255) NOT NULL,
    categoria_id smallint NOT NULL,
    provedor_id smallint NOT NULL,
    stock smallint NOT NULL,
    imag character(100) NOT NULL,
    precio_unitario numeric(8,3),
    PRIMARY KEY (id),
    FOREIGN KEY (categoria_id) REFERENCES categoria(id),
    FOREIGN KEY (provedor_id) REFERENCES provedores(id)
);

CREATE TABLE transacciones (
    id smallint NOT NULL AUTO_INCREMENT,
    producto_id smallint NOT NULL,
    cliente_id smallint NOT NULL,
    cantidad numeric(7) NOT NULL,
    total numeric(9,3) NOT NULL,
    tipo_pago character(95) NOT NULL,
    fecha timestamp NOT NULL,
    ciudad character(35) NOT NULL,
    estatus character(12) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (producto_id) REFERENCES productos(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

USE dcleaner;

INSERT INTO provedores(nombre, email, telefono, codigo_postal, direccion, ciudad) VALUES
						('3M', '', '5511224466', 10231, '', ''),
                        ('Schiller Group',  '', '5612371232', 92321, '', ''),
                        ('Rohan Inc', '','2323234511',23452, '',''); 


INSERT INTO categoria (nombre) VALUES ('Mascarillas'), ('Gel Antibacterial'), ('Desinfectante'), ('Caretas'); 

INSERT INTO clientes (nombre, email, passwd, codigo_postal, direccion, ciudad) VALUES
						('Flora Tulio Bullock', 'flora@gmail.com', 'Pakes23', 21765, 'Av. La Paz 3636', 'Guadalajara'),
                        ('Lulu Clark Stidolph', 'luluc@gmail.com', 'Hasm213', 76070, 'Carlos Pellicer 120', 'Santiago de Querétaro'),
                        ('Samra Holden Bustillo', 'samra@gmail.com', '3esw3rs', 27502, 'Laurel No. 138 Col. Emiliano Zapata', 'Guadalajara'),
                        ('Codie Esmurd Adam', 'codiees@gmail.com', 'duyuds', 60212, 'Santurio 19 Jerez Centro','Jerez de García'),
                        ('Adebert Macey Griffin', 'aldb@gmail.com', 'ddwfjiwdw', 20744,  'Cuautepec No. 29 La Unión Chalma', 'Estado de México');

SELECT * FROM clientes; 

INSERT INTO productos (nombre, descripcion, categoria_id, provedor_id, stock,  imag, precio_unitario) VALUES 
					('Mascarilla KN95', 'NA', 1, 1, 2500, '1', 8.56),
                    ('Gel Antibacterial Escudo Sobre', 'NA', 2, 1, 6300, '2', 9.89),
                    ('Spray Desinfectante', 'NA', 3, 3, 700, '3', 35),
                    ('Best Trading Cubrebocas', 'NA', 1, 3, 3000, '4', 1.960),
                    ('Careta Protectora PVC', 'NA', 4, 2, 1000, '5', 34.9);
                    
SELECT * FROM productos;

INSERT INTO transacciones (producto_id, cliente_id, cantidad, total,  tipo_pago, fecha, ciudad, estatus) values
						(1, 1, 1, 0, 'transferencia', '2010-12-01 08:26:00',  'Zapopan', 'completo');
                     
DROP TRIGGER IF EXISTS `dcleaner`.`update_total`;
DELIMITER $$
USE `dcleaner`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dcleaner`.`update_total` BEFORE INSERT ON `transacciones` FOR EACH ROW
BEGIN
DECLARE total NUMERIC(9,3);
DECLARE precio NUMERIC(9,3); 
SET precio = (SELECT precio_unitario FROM productos WHERE id = NEW.producto_id);
SET NEW.total = precio * NEW.cantidad;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS `dcleaner`.`update_stock`;
DELIMITER $$
USE `dcleaner`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dcleaner`.`update_stock` AFTER INSERT ON `transacciones` FOR EACH ROW
BEGIN
DECLARE nuevo_stock smallint;
SET nuevo_stock = (SELECT stock FROM productos WHERE id = NEW.producto_id) - NEW.cantidad;
UPDATE productos SET stock = nuevo_stock WHERE id = NEW.producto_id;
END$$
DELIMITER ;
