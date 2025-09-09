-- creación de la base de datos 'cotillon_db' si no existe y selección para usarla
CREATE DATABASE IF NOT EXISTS cotillon_db;
USE cotillon_db;

-- tabla categoria: tipos de productos (ej: globos, decoraciones)
CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,   -- id único de la categoría
  nombre_categoria VARCHAR(50) NOT NULL          -- nombre de la categoría
);

-- tabla producto: información de los productos disponibles para la venta
CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,    -- id único del producto
  nombre VARCHAR(100) NOT NULL,                  -- nombre del producto
  descripcion VARCHAR(255),                      -- descripción del producto
  id_categoria INT,                              -- referencia a categoría
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0), -- precio por unidad
  stock_actual INT NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),       -- stock disponible
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)        -- clave foránea a categoría
);

-- tabla cliente: datos de los clientes que compran
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,     -- id único del cliente
  nombre VARCHAR(50) NOT NULL,                   -- nombre del cliente
  apellido VARCHAR(50) NOT NULL,                 -- apellido del cliente
  telefono VARCHAR(20),                          -- teléfono de contacto
  email VARCHAR(100),                            -- correo electrónico
  direccion VARCHAR(255)                         -- dirección física
);

-- tabla proveedor: datos de los proveedores que suministran productos
CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,   -- id único del proveedor
  nombre_proveedor VARCHAR(100) NOT NULL,        -- nombre o razón social del proveedor
  telefono VARCHAR(20),                          -- teléfono de contacto
  email VARCHAR(100),                            -- correo electrónico
  direccion VARCHAR(255)                         -- dirección física
);

-- tabla venta: registro de cada venta a un cliente
CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,       -- id único de la venta
  fecha_venta DATE NOT NULL,                     -- fecha en que se hizo la venta
  id_cliente INT,                                -- cliente que hizo la compra
  total DECIMAL(10,2) NOT NULL CHECK (total >= 0),  -- monto total de la venta
  estado ENUM('pendiente','pagada','cancelada') DEFAULT 'pendiente', -- estado de la venta
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)  -- clave foránea hacia cliente
);

-- tabla detalle_venta: detalle de productos en cada venta
CREATE TABLE Detalle_Venta (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,     -- id único del detalle de venta
  id_venta INT NOT NULL,                         -- referencia a la venta
  id_producto INT NOT NULL,                      -- referencia al producto vendido
  cantidad INT NOT NULL CHECK (cantidad > 0),    -- cantidad vendida	
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0), -- precio por unidad
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),          -- clave foránea hacia venta
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)   -- clave foránea hacia producto
);

-- tabla compra: registro de compras a proveedores
CREATE TABLE Compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,      -- id único de la compra
  id_proveedor INT NOT NULL,                     -- proveedor de la compra
  fecha_compra DATE NOT NULL,                    -- fecha de la compra
  total_compra DECIMAL(10,2) NOT NULL CHECK (total_compra >= 0), -- monto total pagado
  estado ENUM('pendiente','pagada','cancelada') DEFAULT 'pendiente', -- estado de la compra
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)  -- clave foránea hacia proveedor
);

-- tabla detalle_compra: detalle de productos en cada compra
CREATE TABLE Detalle_Compra (
  id_detalle_compra INT AUTO_INCREMENT PRIMARY KEY, -- id único del detalle de compra
  id_compra INT NOT NULL,                           -- referencia a la compra
  id_producto INT NOT NULL,                         -- referencia al producto comprado
  cantidad INT NOT NULL CHECK (cantidad > 0),       -- cantidad comprada
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0), -- precio por unidad
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra),            -- clave foránea hacia compra
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)        -- clave foránea hacia producto
);
