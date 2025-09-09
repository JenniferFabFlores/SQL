use cotillon_db;

-- categorias
INSERT INTO Categoria (nombre_categoria) VALUES
('globos'),('decoraciones'),('confites'),('velas');

-- productos (nota: id_categoria de ejemplo)
INSERT INTO Producto (nombre, descripcion, id_categoria, precio_unitario, stock_actual) VALUES
('Globo latex 12"', 'globo rojo', 1, 10.00, 100),
('Guirnalda papel', 'guirnalda x3m', 2, 250.00, 20),
('Confites surtidos 500g', 'bolsa 500g', 3, 150.00, 50),
('Vela pastel', 'vela numerica', 4, 30.00, 200);

-- clientes
INSERT INTO Cliente (nombre, apellido, telefono, email, direccion) VALUES
('Jenn','Flores','1122334455','maria@gmail.com','Av. Pueyrredon 2223'),
('Carlos','Perez','1166677788','carlos@gmail.com','Av. Jujuy 133');
('Mariano','Martinez','1166677788','cmartine@gmail.com','Av. Sta fe 742');
-- proveedores
INSERT INTO Proveedor (nombre_proveedor, telefono, email, direccion) VALUES
('Distribuidora A','1144455566','ventas@gmailA.com','Av. Juan B Justo 1111'),
('Mayorista B','1155566677','contacto@mayoristaB.com','Av. Independencia 1114');

-- una compra de ejemplo (usando el procedure)
SET @items_compra = JSON_ARRAY(JSON_OBJECT('id_producto',1,'cantidad',50,'precio_unitario',8.00),
                               JSON_OBJECT('id_producto',3,'cantidad',30,'precio_unitario',120.00));
CALL registrar_compra_json(1, '2025-08-01', @items_compra);

-- una venta de ejemplo (usando el procedure)
SET @items_venta = JSON_ARRAY(JSON_OBJECT('id_producto',1,'cantidad',5,'precio_unitario',10.00),
                             JSON_OBJECT('id_producto',4,'cantidad',2,'precio_unitario',30.00));
CALL registrar_venta_json(1, '2025-08-02', @items_venta);

-- inserciones directas adicionales (opcional)
INSERT INTO Venta (fecha_venta, id_cliente, total, estado) VALUES ('2025-08-03', 2, 0.00, 'pendiente');
SET @lastv = LAST_INSERT_ID();
INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(@lastv, 2, 1, 250.00),
(@lastv, 3, 2, 150.00);
-- totals se actualizan por triggers / funciones

-- ejemplo de compra
INSERT INTO Compra (id_proveedor, fecha_compra, total_compra, estado) VALUES (2,'2025-08-04',0.00,'pendiente');
SET @lastc = LAST_INSERT_ID();
INSERT INTO Detalle_Compra (id_compra, id_producto, cantidad, precio_unitario) VALUES
(@lastc, 2, 10, 230.00),
(@lastc, 4, 50, 25.00);
