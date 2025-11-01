-- CARGA DE DATOS 
USE CC_CARPINTERÍA_DEL_SUR;
GO

-- CLIENTES
INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
VALUES 
('Particular', 'Juan', 'Pérez', 'Pérez Juan', 'DNI', '30111222', '1122334455', 'juanp@gmail.com'),
('Empresa', 'Laura', 'Gómez', 'Muebles Gómez SRL', 'CUIT', '30-12345678-9', '1144556677', 'contacto@mueblesgomez@gmail.com');

-- CATEGORÍAS
INSERT INTO Categoria (nombre, descripcion)
VALUES 
('Sillas', 'Sillas de madera y metal'),
('Mesas', 'Mesas de comedor y oficina'),
('Estanterías', 'Muebles para almacenamiento');


-- PRODUCTOS
INSERT INTO Producto (codigo, nombre, descripcion, precio_venta, costo_produccion, stock, id_categoria)
VALUES 
('S001', 'Silla de roble', 'Silla clásica de roble lustrado', 15000, 9000, 50, 1),
('M001', 'Mesa redonda', 'Mesa redonda para 4 personas', 40000, 25000, 20, 2),
('E001', 'Estantería 3 niveles', 'Estantería mediana de pino', 30000, 18000, 10, 3);


-- PROVEEDORES
INSERT INTO Proveedor (razon_social, cuit, telefono, email, direccion, estado)
VALUES
('Maderas Argentinas', '30-99999999-9', '1133344455', 'contacto@maderas.com', 'Av. Mitre 123, Buenos Aires', 'Activo'),
('Pinturas del Sur', '30-88888888-8', '1166677788', 'ventas@pinturas.com', 'Ruta 3 km 12, Lomas', 'Activo');


-- MATERIALES
INSERT INTO Material (nombre, tipo, unidad_medida, costo_unitario, id_proveedor)
VALUES 
('Madera roble', 'Madera', 'm2', 2500, 1),
('Barniz protector', 'Pintura', 'lt', 1500, 2),
('Tornillos acero', 'Accesorios', 'kg', 800, 1);


-- RECETAS (DetalleFabricacion)
INSERT INTO DetalleFabricacion (cantidad, merma_pct, id_producto, id_material)
VALUES
(3, 5, 1, 1), -- Silla usa 3 m2 de roble
(1, 2, 1, 2), -- Silla usa 1 lt de barniz
(4, 7, 2, 1), -- Mesa usa 4 m2 de roble
(1, 2, 2, 2); -- Mesa usa 1 lt de barniz


-- PEDIDOS Y DETALLES
INSERT INTO Pedido (fecha, total_bruto, descuento_total, total_neto, estado, id_cliente)
VALUES 
('2025-10-20', 80000, 0, 80000, 'Facturado', 10000),
('2025-10-22', 60000, 5000, 55000, 'Pendiente', 10001);

INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
(2, 40000, 0, 80000, 1, 2),
(1, 15000, 0, 15000, 2, 1);