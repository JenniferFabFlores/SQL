use cotillon_db;

-- CATEGORIAS

INSERT INTO Categoria (nombre_categoria) VALUES
('globos'),('decoraciones'),('confites'),('velas'),
('tarjetas'),('globos metalizados'),('serpentinas'),('souvenirs'),
('globos con helio'),('piñatas'),('papel de regalo'),('mascaras'),('banners');


-- PRODUCTOS

INSERT INTO Producto (nombre, descripcion, id_categoria, precio_unitario, stock_actual) VALUES
('Globo latex 12"', 'globo rojo', 1, 10.00, 100),
('Guirnalda papel', 'guirnalda x3m', 2, 250.00, 20),
('Confites surtidos 500g', 'bolsa 500g', 3, 150.00, 50),
('Vela pastel', 'vela numerica', 4, 30.00, 200),
('Tarjeta cumpleaños', 'tarjeta con sobre', 5, 50.00, 100),
('Globo metalizado estrella', 'globo plateado 18"', 6, 30.00, 150),
('Serpentina multicolor', 'paquete 10m', 7, 40.00, 200),
('Souvenir llavero', 'llavero personalizado', 8, 80.00, 50),
('Globo helio 36"', 'globo grande con helio', 9, 120.00, 50),
('Piñata unicornio', 'piñata rellena', 10, 500.00, 20),
('Rollo papel regalo', 'papel con estampado', 11, 60.00, 100),
('Mascara carnaval', 'mascara colorida', 12, 35.00, 150),
('Banner personalizado', 'banner 2x1m', 13, 300.00, 25);

-- CLIENTES

INSERT INTO Cliente (nombre, apellido, telefono, email, direccion) VALUES
('Jenn','Flores','1122334455','maria@gmail.com','Av. Pueyrredon 2223'),
('Carlos','Perez','1166677788','carlos@gmail.com','Av. Jujuy 133'),
('Mariano','Martinez','1166677788','cmartine@gmail.com','Av. Sta fe 742'),
('Lucia','Gomez','1133322211','lucia@gmail.com','Av. Corrientes 1010'),
('Federico','Lopez','1144455599','fede@gmail.com','Av. Callao 2020'),
('Sofia','Diaz','1161122334','sofia@gmail.com','Av. Rivadavia 3030'),
('Ana','Ruiz','1122445566','ana@gmail.com','Calle Falsa 123'),
('Diego','Fernandez','1133556677','diego@gmail.com','Av. Libertador 456'),
('Mariana','Lopez','1144667788','mariana@gmail.com','Av. Mitre 789'),
('Pablo','Gonzalez','1155778899','pablo@gmail.com','Calle Corrientes 321'),
('Claudia','Martinez','1166889900','claudia@gmail.com','Av. Santa Fe 987');


-- PROVEEDORES

INSERT INTO Proveedor (nombre_proveedor, telefono, email, direccion) VALUES
('Distribuidora A','1144455566','ventas@gmailA.com','Av. Juan B Justo 1111'),
('Mayorista B','1155566677','contacto@mayoristaB.com','Av. Independencia 1114'),
('Mayorista C','1167788990','ventasC@gmail.com','Av. Belgrano 555'),
('Distribuidora D','1178899001','contactoD@gmail.com','Av. San Juan 789'),
('Distribuidora E','1177001122','ventasE@gmail.com','Av. Callao 111'),
('Mayorista F','1188112233','contactoF@gmail.com','Av. Rivadavia 222'),
('Mayorista G','1199223344','ventasG@gmail.com','Calle San Juan 333'),
('Distribuidora H','1166334455','contactoH@gmail.com','Av. Belgrano 444'),
('Mayorista I','1155445566','ventasI@gmail.com','Calle Florida 555');

-- COMPRAS DE EJEMPLO (JSON)

SET @items_compra = JSON_ARRAY(
    JSON_OBJECT('id_producto',1,'cantidad',50,'precio_unitario',8.00),
    JSON_OBJECT('id_producto',3,'cantidad',30,'precio_unitario',120.00)
);
CALL registrar_compra_json(1, '2025-08-01', @items_compra);

SET @items_compra2 = JSON_ARRAY(
    JSON_OBJECT('id_producto',5,'cantidad',20,'precio_unitario',45.00),
    JSON_OBJECT('id_producto',6,'cantidad',100,'precio_unitario',25.00)
);
CALL registrar_compra_json(2, '2025-08-05', @items_compra2);

SET @items_compra3 = JSON_ARRAY(
    JSON_OBJECT('id_producto',7,'cantidad',50,'precio_unitario',35.00),
    JSON_OBJECT('id_producto',8,'cantidad',10,'precio_unitario',70.00)
);
CALL registrar_compra_json(1, '2025-08-06', @items_compra3);

SET @items_compra4 = JSON_ARRAY(
    JSON_OBJECT('id_producto',9,'cantidad',20,'precio_unitario',110.00),
    JSON_OBJECT('id_producto',10,'cantidad',5,'precio_unitario',480.00),
    JSON_OBJECT('id_producto',11,'cantidad',30,'precio_unitario',55.00),
    JSON_OBJECT('id_producto',12,'cantidad',50,'precio_unitario',30.00),
    JSON_OBJECT('id_producto',13,'cantidad',10,'precio_unitario',280.00)
);
CALL registrar_compra_json(3, '2025-08-11', @items_compra4);

-- VENTAS DE EJEMPLO (JSON)

SET @items_venta = JSON_ARRAY(
    JSON_OBJECT('id_producto',1,'cantidad',5,'precio_unitario',10.00),
    JSON_OBJECT('id_producto',4,'cantidad',2,'precio_unitario',30.00)
);
CALL registrar_venta_json(1, '2025-08-02', @items_venta);

SET @items_venta2 = JSON_ARRAY(
    JSON_OBJECT('id_producto',5,'cantidad',2,'precio_unitario',50.00),
    JSON_OBJECT('id_producto',6,'cantidad',5,'precio_unitario',30.00)
);
CALL registrar_venta_json(3, '2025-08-07', @items_venta2);

SET @items_venta3 = JSON_ARRAY(
    JSON_OBJECT('id_producto',7,'cantidad',10,'precio_unitario',40.00),
    JSON_OBJECT('id_producto',8,'cantidad',1,'precio_unitario',80.00)
);
CALL registrar_venta_json(2, '2025-08-08', @items_venta3);

SET @items_venta4 = JSON_ARRAY(
    JSON_OBJECT('id_producto',9,'cantidad',2,'precio_unitario',120.00),
    JSON_OBJECT('id_producto',10,'cantidad',1,'precio_unitario',500.00),
    JSON_OBJECT('id_producto',11,'cantidad',5,'precio_unitario',60.00),
    JSON_OBJECT('id_producto',12,'cantidad',3,'precio_unitario',35.00),
    JSON_OBJECT('id_producto',13,'cantidad',1,'precio_unitario',300.00)
);
CALL registrar_venta_json(4, '2025-08-12', @items_venta4);

-- INSERTS DIRECTAS DE VENTAS

INSERT INTO Venta (fecha_venta, id_cliente, total, estado) VALUES 
('2025-08-03', 2, 0.00, 'pendiente'),
('2025-08-09', 1, 0.00, 'pendiente'),
('2025-08-13', 5, 0.00, 'pendiente');

SET @lastv = LAST_INSERT_ID();
INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(@lastv, 2, 1, 250.00),
(@lastv, 3, 2, 150.00);

-- otras ventas directas
SET @lastv2 = @lastv + 1;
INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(@lastv2, 1, 3, 10.00),
(@lastv2, 5, 1, 50.00);

SET @lastv3 = @lastv + 2;
INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(@lastv3, 9, 1, 120.00),
(@lastv3, 10, 1, 500.00),
(@lastv3, 11, 2, 60.00),
(@lastv3, 12, 2, 35.00),
(@lastv3, 13, 1, 300.00);

-- INSERTS DIRECTAS DE COMPRAS

INSERT INTO Compra (id_proveedor, fecha_compra, total_compra, estado) VALUES 
(2,'2025-08-04',0.00,'pendiente'),
(1,'2025-08-10',0.00,'pendiente'),
(4,'2025-08-14',0.00,'pendiente');

SET @lastc = LAST_INSERT_ID();
INSERT INTO Detalle_Compra (id_compra, id_producto, cantidad, precio_unitario) VALUES
(@lastc, 9, 15, 110.00),
(@lastc, 10, 3, 480.00),
(@lastc, 11, 25, 55.00),
(@lastc, 12, 40, 30.00),
(@lastc, 13, 8, 280.00);

SET @lastc2 = @lastc - 1;
INSERT INTO Detalle_Compra (id_compra, id_producto, cantidad, precio_unitario) VALUES
(@lastc2, 1, 100, 8.00),
(@lastc2, 5, 10, 45.00);
