use cotillon_db;

-- categorias adicionales
INSERT INTO Categoria (nombre_categoria) VALUES
('globos con helio'),('piñatas'),('papel de regalo'),('mascaras'),('banners');

-- productos adicionales
INSERT INTO Producto (nombre, descripcion, id_categoria, precio_unitario, stock_actual) VALUES
('Globo helio 36"', 'globo grande con helio', 9, 120.00, 50),
('Piñata unicornio', 'piñata rellena', 10, 500.00, 20),
('Rollo papel regalo', 'papel con estampado', 11, 60.00, 100),
('Mascara carnaval', 'mascara colorida', 12, 35.00, 150),
('Banner personalizado', 'banner 2x1m', 13, 300.00, 25);

-- clientes adicionales
INSERT INTO Cliente (nombre, apellido, telefono, email, direccion) VALUES
('Ana','Ruiz','1122445566','ana@gmail.com','Calle Falsa 123'),
('Diego','Fernandez','1133556677','diego@gmail.com','Av. Libertador 456'),
('Mariana','Lopez','1144667788','mariana@gmail.com','Av. Mitre 789'),
('Pablo','Gonzalez','1155778899','pablo@gmail.com','Calle Corrientes 321'),
('Claudia','Martinez','1166889900','claudia@gmail.com','Av. Santa Fe 987');

-- proveedores adicionales
INSERT INTO Proveedor (nombre_proveedor, telefono, email, direccion) VALUES
('Distribuidora E','1177001122','ventasE@gmail.com','Av. Callao 111'),
('Mayorista F','1188112233','contactoF@gmail.com','Av. Rivadavia 222'),
('Mayorista G','1199223344','ventasG@gmail.com','Calle San Juan 333'),
('Distribuidora H','1166334455','contactoH@gmail.com','Av. Belgrano 444'),
('Mayorista I','1155445566','ventasI@gmail.com','Calle Florida 555');

-- compras de ejemplo
SET @items_compra4 = JSON_ARRAY(
    JSON_OBJECT('id_producto',9,'cantidad',20,'precio_unitario',110.00),
    JSON_OBJECT('id_producto',10,'cantidad',5,'precio_unitario',480.00),
    JSON_OBJECT('id_producto',11,'cantidad',30,'precio_unitario',55.00),
    JSON_OBJECT('id_producto',12,'cantidad',50,'precio_unitario',30.00),
    JSON_OBJECT('id_producto',13,'cantidad',10,'precio_unitario',280.00)
);
CALL registrar_compra_json(3, '2025-08-11', @items_compra4);

-- ventas de ejemplo
SET @items_venta4 = JSON_ARRAY(
    JSON_OBJECT('id_producto',9,'cantidad',2,'precio_unitario',120.00),
    JSON_OBJECT('id_producto',10,'cantidad',1,'precio_unitario',500.00),
    JSON_OBJECT('id_producto',11,'cantidad',5,'precio_unitario',60.00),
    JSON_OBJECT('id_producto',12,'cantidad',3,'precio_unitario',35.00),
    JSON_OBJECT('id_producto',13,'cantidad',1,'precio_unitario',300.00)
);
CALL registrar_venta_json(4, '2025-08-12', @items_venta4);

-- inserciones directas de ventas
INSERT INTO Venta (fecha_venta, id_cliente, total, estado) VALUES ('2025-08-13', 5, 0.00, 'pendiente');
SET @lastv3 = LAST_INSERT_ID();
INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(@lastv3, 9, 1, 120.00),
(@lastv3, 10, 1, 500.00),
(@lastv3, 11, 2, 60.00),
(@lastv3, 12, 2, 35.00),
(@lastv3, 13, 1, 300.00);

-- inserciones directas de compras
INSERT INTO Compra (id_proveedor, fecha_compra, total_compra, estado) VALUES (4,'2025-08-14',0.00,'pendiente');
SET @lastc3 = LAST_INSERT_ID();
INSERT INTO Detalle_Compra (id_compra, id_producto, cantidad, precio_unitario) VALUES
(@lastc3, 9, 15, 110.00),
(@lastc3, 10, 3, 480.00),
(@lastc3, 11, 25, 55.00),
(@lastc3, 12, 40, 30.00),
(@lastc3, 13, 8, 280.00);


