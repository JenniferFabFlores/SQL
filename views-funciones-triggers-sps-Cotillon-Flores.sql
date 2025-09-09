-- creo las vistas, funciones, stored procedures y triggers para cotillon_db
USE cotillon_db;

-- 1) VISTAS

CREATE OR REPLACE VIEW ventas_cliente AS
SELECT 
  c.id_cliente,
  c.nombre,
  c.apellido,
  v.id_venta,
  v.fecha_venta,
  dv.id_detalle,
  p.id_producto,
  p.nombre AS producto,
  dv.cantidad,
  dv.precio_unitario,
  (dv.cantidad * dv.precio_unitario) AS subtotal
FROM Cliente c
JOIN Venta v ON c.id_cliente = v.id_cliente
JOIN Detalle_Venta dv ON v.id_venta = dv.id_venta
JOIN Producto p ON dv.id_producto = p.id_producto;

CREATE OR REPLACE VIEW stock_productos AS
SELECT 
  p.id_producto,
  p.nombre,
  c.nombre_categoria,
  p.precio_unitario,
  p.stock_actual
FROM Producto p
LEFT JOIN Categoria c ON p.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW ventas_resumen_fecha AS
SELECT 
  v.fecha_venta,
  COUNT(DISTINCT v.id_venta) AS cantidad_ventas,
  COALESCE(SUM(dv.cantidad * dv.precio_unitario),0) AS total_ventas
FROM Venta v
LEFT JOIN Detalle_Venta dv ON v.id_venta = dv.id_venta
GROUP BY v.fecha_venta
ORDER BY v.fecha_venta DESC;

CREATE OR REPLACE VIEW compras_proveedor AS
SELECT
  cp.id_compra,
  pr.id_proveedor,
  pr.nombre_proveedor,
  cp.fecha_compra,
  cp.total_compra
FROM Compra cp
JOIN Proveedor pr ON cp.id_proveedor = pr.id_proveedor;

-- 2) FUNCIONES

DELIMITER $$
CREATE FUNCTION calcular_total_venta(p_id_venta INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2) DEFAULT 0;
  SELECT IFNULL(SUM(cantidad * precio_unitario),0) INTO total
  FROM Detalle_Venta
  WHERE id_venta = p_id_venta;
  RETURN total;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION calcular_total_compra(p_id_compra INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10,2) DEFAULT 0;
  SELECT IFNULL(SUM(cantidad * precio_unitario),0) INTO total
  FROM Detalle_Compra
  WHERE id_compra = p_id_compra;
  RETURN total;
END$$
DELIMITER ;

-- 3) STORED PROCEDURES

DELIMITER $$
CREATE PROCEDURE registrar_venta_json(
  IN p_id_cliente INT,
  IN p_fecha DATE,
  IN p_items JSON -- array de objetos { "id_producto":1,"cantidad":2,"precio_unitario":10.5 }
)
BEGIN
  DECLARE v_id_venta INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE n INT DEFAULT JSON_LENGTH(p_items);
  DECLARE item_id_producto INT;
  DECLARE item_cantidad INT;
  DECLARE item_precio DECIMAL(10,2);

  -- insertar venta con total 0 (se actualizará luego)
  INSERT INTO Venta (fecha_venta, id_cliente, total, estado)
  VALUES (p_fecha, p_id_cliente, 0.00, 'pendiente');
  SET v_id_venta = LAST_INSERT_ID();

  -- recorrer items y agregarlos a detalle_venta
  label_loop: WHILE i < n DO
    SET item_id_producto = JSON_EXTRACT(p_items, CONCAT('$[', i, '].id_producto'));
    SET item_cantidad   = JSON_EXTRACT(p_items, CONCAT('$[', i, '].cantidad'));
    SET item_precio     = JSON_EXTRACT(p_items, CONCAT('$[', i, '].precio_unitario'));

    INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, precio_unitario)
    VALUES (v_id_venta, item_id_producto, item_cantidad, item_precio);

    -- actualizar stock (resta)
    UPDATE Producto
    SET stock_actual = stock_actual - item_cantidad
    WHERE id_producto = item_id_producto;

    SET i = i + 1;
  END WHILE label_loop;

  -- recalcular total y actualizar venta
  UPDATE Venta
  SET total = calcular_total_venta(v_id_venta)
  WHERE id_venta = v_id_venta;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE registrar_compra_json(
  IN p_id_proveedor INT,
  IN p_fecha DATE,
  IN p_items JSON -- array similar
)
BEGIN
  DECLARE v_id_compra INT DEFAULT 0;
  DECLARE i INT DEFAULT 0;
  DECLARE n INT DEFAULT JSON_LENGTH(p_items);
  DECLARE item_id_producto INT;
  DECLARE item_cantidad INT;
  DECLARE item_precio DECIMAL(10,2);

  INSERT INTO Compra (id_proveedor, fecha_compra, total_compra, estado)
  VALUES (p_id_proveedor, p_fecha, 0.00, 'pendiente');
  SET v_id_compra = LAST_INSERT_ID();

  label_loop2: WHILE i < n DO
    SET item_id_producto = JSON_EXTRACT(p_items, CONCAT('$[', i, '].id_producto'));
    SET item_cantidad   = JSON_EXTRACT(p_items, CONCAT('$[', i, '].cantidad'));
    SET item_precio     = JSON_EXTRACT(p_items, CONCAT('$[', i, '].precio_unitario'));

    INSERT INTO Detalle_Compra (id_compra, id_producto, cantidad, precio_unitario)
    VALUES (v_id_compra, item_id_producto, item_cantidad, item_precio);

    -- actualizar stock (suma)
    UPDATE Producto
    SET stock_actual = stock_actual + item_cantidad
    WHERE id_producto = item_id_producto;

    SET i = i + 1;
  END WHILE label_loop2;

  -- recalcular total y actualizar compra
  UPDATE Compra
  SET total_compra = calcular_total_compra(v_id_compra)
  WHERE id_compra = v_id_compra;
END$$
DELIMITER ;

-- 4) TRIGGERS

DELIMITER $$
CREATE TRIGGER actualizar_stock_venta
AFTER INSERT ON Detalle_Venta
FOR EACH ROW
BEGIN
  UPDATE Producto
  SET stock_actual = stock_actual - NEW.cantidad
  WHERE id_producto = NEW.id_producto;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER refresh_total_venta
AFTER INSERT ON Detalle_Venta
FOR EACH ROW
BEGIN
  UPDATE Venta
  SET total = calcular_total_venta(NEW.id_venta)
  WHERE id_venta = NEW.id_venta;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER actualizar_stock_compra
AFTER INSERT ON Detalle_Compra
FOR EACH ROW
BEGIN
  UPDATE Producto
  SET stock_actual = stock_actual + NEW.cantidad
  WHERE id_producto = NEW.id_producto;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER refresh_total_compra
AFTER INSERT ON Detalle_Compra
FOR EACH ROW
BEGIN
  UPDATE Compra
  SET total_compra = calcular_total_compra(NEW.id_compra)
  WHERE id_compra = NEW.id_compra;
END$$
DELIMITER ;
