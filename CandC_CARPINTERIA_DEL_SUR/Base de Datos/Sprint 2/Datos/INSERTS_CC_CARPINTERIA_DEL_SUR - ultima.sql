USE CC_CARPINTERIA_DEL_SUR;
GO

/* ===========================
   CLIENTES (10)
   =========================== */
INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
VALUES 
('Particular', 'Juan', 'Pérez', 'Pérez Juan', 'DNI', '30111222', '1122334455', 'juanp@gmail.com'),
('Empresa', 'Laura', 'Gómez', 'Muebles Gómez SRL', 'CUIT', '30-12345678-9', '1144556677', 'contactomueblesgomez@gmail.com'),
('Particular','Sofía','Martínez','Sofía Martínez','DNI','32555444','1155500011','sofia.martinez@outlook.com'),
('Empresa','Diego','Luna','Carpintería Luna SA','CUIT','30-11223344-5','1144443322','ventas.luna@yahoo.com'),
('Particular','Pilar','Mendes','Pilar Mendes','DNI','45999111','1177788899','pilar.mendes@gmail.com'),
('Particular','Marcos','Ibarra','Marcos Ibarra','DNI','34566777','1166677700','marcos.ibarra@gmail.com'),
('Empresa','Rocío','Sosa','Muebles RS SRL','CUIT','30-55667788-9','1130030030','contactomueblesrs@outlook.com'),
('Particular','Camila','Vega','Camila Vega','DNI','38111222','1144442211','camila.vega@yahoo.com'),
('Empresa','Hernán','Lopez','HL Carpintería SA','CUIT','30-99887766-5','1147779900','ventas.hl@gmail.com'),
('Particular','Valentina','Ríos','Valentina Ríos','DNI','40222333','1166004400','valentina.rios@outlook.com');
GO


/* ===========================
   CATEGORÍAS (10)
   =========================== */
INSERT INTO Categoria (nombre, descripcion)
VALUES 
('Sillas', 'Sillas de madera y metal'),
('Mesas', 'Mesas de comedor y oficina'),
('Estanterías', 'Muebles para almacenamiento'),
('Placards','Placards a medida'),
('Escritorios','Escritorios para oficina y estudio'),
('Bibliotecas','Bibliotecas y estantes'),
('Camas','Camas de una y dos plazas'),
('Banquetas','Banquetas y taburetes'),
('Bajomesadas','Muebles de cocina - bajomesada'),
('Alacenas','Muebles de cocina - alacenas');
GO


/* ===========================
   PRODUCTOS (10)
   =========================== */
INSERT INTO Producto (codigo, nombre, descripcion, precio_venta, costo_produccion, stock, id_categoria)
VALUES 
('S001', 'Silla de roble', 'Silla clásica de roble lustrado', 15000, 9000, 50, 1),
('M001', 'Mesa redonda', 'Mesa redonda para 4 personas', 40000, 25000, 20, 2),
('E001', 'Estantería 3 niveles', 'Estantería mediana de pino', 30000, 18000, 10, 3),
('P001','Placard 2 puertas','Placard melamina 2,0x2,2 m', 90000, 65000, 5, 4),
('D001','Escritorio simple','Escritorio 120x60', 45000, 28000, 15, 5),
('B001','Biblioteca 5 estantes','Biblioteca grande de melamina', 60000, 35000, 8, 6),
('C001','Cama matrimonial','Cama 2 plazas madera maciza', 120000, 80000, 4, 7),
('BN001','Banqueta alta','Banqueta de barra tapizada', 20000, 12000, 25, 8),
('BM001','Bajomesada 1.20','Bajomesada 1,20 m con 3 cajones', 85000, 50000, 3, 9),
('AL001','Alacena 0.80','Alacena 0,80 m con puertas vidrio', 55000, 30000, 6, 10);
GO


/* ===========================
   PROVEEDORES (10)
   =========================== */
INSERT INTO Proveedor (razon_social, cuit, telefono, email, direccion, estado)
VALUES
('Maderas Argentinas', '30-99999999-9', '1133344455', 'contacto@maderas.com', 'Av. Mitre 123, Buenos Aires', 'Activo'),
('Pinturas del Sur', '30-88888888-8', '1166677788', 'ventas@pinturas.com', 'Ruta 3 km 12, Lomas', 'Activo'),
('Ferretería Centro', '30-77777777-7', '1144440000', 'ventas@ferre.com', 'Av. Rivadavia 500', 'Activo'), 
('Acero Tornillos SA', '30-66666666-6', '1144440001', 'info@acero.com', 'Mitre 200', 'Activo'),          
('Mayorista Insumos',  '30-55555555-5', '1144440002', 'contacto@mayorista.com', 'Alsina 300', 'Activo'),
('Melaminas Norte', '30-44444444-4', '1140001000', 'ventas@melaminasnorte.com', 'Av. San Martín 900', 'Activo'),
('Herrajes Patagónicos', '30-33333333-3', '1140002000', 'ventas@herrajespat.com', 'Perito Moreno 1200', 'Activo'),
('Barnices Premium', '30-22222222-2', '1140003000', 'contacto@barnicespremium.com', 'Alsina 50', 'Activo'),
('Transportes Rápidos', '30-11111111-1', '1140004000', 'info@transrapidos.com', 'Ruta 2 km 35', 'Activo'),
('Maderas del Oeste', '30-10101010-0', '1140005000', 'ventas@maderasoeste.com', 'Av. Gaona 3200', 'Activo');
GO
-- Ahora tenemos proveedores con id_proveedor = 1..10


/* ===========================
   MATERIALES (10)
   IMPORTANTE: ahora incluimos id_proveedor
   =========================== */
INSERT INTO Material (nombre, tipo, unidad_medida, id_proveedor)
VALUES 
('Madera roble', 'Madera', 'm2', 1),            -- proveedor 1: Maderas Argentinas
('Barniz protector', 'Pintura', 'lt', 2),       -- proveedor 2: Pinturas del Sur
('Tornillos acero', 'Accesorios', 'kg', 4),     -- proveedor 4: Acero Tornillos SA
('Melamina blanca','Melamina','m2', 6),         -- proveedor 6: Melaminas Norte
('Bisagras acero','Herrajes','un', 7),          -- proveedor 7: Herrajes Patagónicos
('Tiradores aluminio','Herrajes','un', 7),
('Laca poliuretánica','Pintura','lt', 8),       -- proveedor 8: Barnices Premium
('Masilla para madera','Insumo','kg', 2),      -- Pinturas del Sur
('Tapacanto PVC','Insumo','m', 6),
('Correderas telescópicas','Herrajes','un', 7),
('Tornillos acero', 'Accesorios', 'kg', 3);  

GO
-- Ahora Material tiene id_material = 1..10


/* ===========================
   PROVEEDOR-MATERIAL (10)
   (relación n a n + precio)
   OJO: usamos el orden correcto de columnas
   =========================== */
INSERT INTO ProveedorMaterial (id_proveedor, id_material, costo_unitario) 
VALUES 
(1, 1, 1500.00),   -- Maderas Argentinas vende Madera roble a 1500
(10,1, 1300.00),   -- Maderas del Oeste vende Madera roble a 1300
(2, 2, 2200.00),   -- Pinturas del Sur vende Barniz protector
(8, 2, 2000.00),   -- Barnices Premium vende Barniz protector más barato
(4, 3,  100.00),   -- Acero Tornillos SA vende Tornillos acero
(5, 3,   80.00),   -- Mayorista Insumos vende Tornillos acero más barato
(6, 4, 1800.00),   -- Melaminas Norte vende Melamina blanca
(7, 5,  150.00),   -- Herrajes Patagónicos vende Bisagras acero
(8, 7, 2200.00),   -- Barnices Premium vende Laca poliuretánica
(7,10, 1200.00),   -- Herrajes Patagónicos vende Correderas telescópicas
(3, 3,  90.00);
GO


/* ===========================
   PEDIDOS (10)
   =========================== */
INSERT INTO Pedido (fecha, total_bruto, descuento_total, total_neto, estado, id_cliente)
VALUES 
('2025-10-20',  80000,     0,  80000, 'Facturado', 10000),
('2025-10-22',  60000,  5000,  55000, 'Pendiente', 10000),
('2025-10-23',  30000,     0,  30000, 'Pendiente', 10002),
('2025-10-24',  90000, 10000,  80000, 'Pendiente', 10003),
('2025-10-25',  45000,     0,  45000, 'Facturado', 10004),
('2025-10-26',  60000,     0,  60000, 'Pendiente', 10005),
('2025-10-27', 120000, 20000, 100000, 'Pendiente', 10006),
('2025-10-28',  40000,     0,  40000, 'Pendiente', 10007),
('2025-10-29', 140000,     0, 140000, 'Facturado', 10008),
('2025-10-30',  30000,  3000,  27000, 'Pendiente', 10009);
GO
-- Ahora Pedido tiene id_pedido = 1..10


/* ===========================
   DETALLEPEDIDO
   (líneas por producto; coherente con Pedido)
   =========================== */
INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
-- Pedido 1
(2, 40000,     0, 80000, 1, 2),

-- Pedido 2 (60.000 bruto / 5.000 desc / 55.000 neto)
(1, 15000,     0, 15000, 2, 1),
(1, 30000,     0, 30000, 2, 3),
(1, 15000,  5000, 10000, 2, 1),

-- Pedido 3
(1, 30000,     0, 30000, 3, 3),

-- Pedido 4
(1, 90000, 10000, 80000, 4, 4),

-- Pedido 5
(1, 45000,     0, 45000, 5, 5),

-- Pedido 6
(1, 60000,     0, 60000, 6, 6),

-- Pedido 7
(1,120000, 20000,100000, 7, 7),

-- Pedido 8
(2, 20000,     0, 40000, 8, 8);
GO

-- Pedido 9 (dos líneas)
INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
(1, 85000, 0, 85000, 9, 9),
(1, 55000, 0, 55000, 9, 10);
GO

-- Pedido 10
INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
(2, 15000, 3000, 27000, 10, 1);
GO


/* ===========================
   RECETAS / DetalleFabricacion (10)
   usa los ids reales de producto y material
   =========================== */
INSERT INTO DetalleFabricacion (cantidad, merma_pct, id_producto, id_material)
VALUES
(3, 5, 1, 1),   -- Silla de roble usa Madera roble
(1, 2, 1, 2),   -- Silla de roble usa Barniz protector
(4, 7, 2, 1),   -- Mesa redonda usa Madera roble
(1, 2, 2, 2),   -- Mesa redonda usa Barniz protector
(3, 4, 3, 4),   -- Estantería usa Melamina blanca
(4, 5, 4, 5),   -- Placard usa Bisagras acero
(2, 3, 5, 4),   -- Escritorio usa Melamina blanca
(4, 5, 6, 4),   -- Biblioteca usa Melamina blanca
(6, 7, 7, 1),   -- Cama matrimonial usa Madera roble
(1, 2, 8, 1);   -- Banqueta alta usa Madera roble
GO

-- 10 domicilios (uno por cliente 10000..10009)
INSERT INTO Domicilio (calle, numero, ciudad, provincia, codigo_postal, pais, tipo, id_cliente) VALUES
(N'Av. Mitre',     N'123', N'Avellaneda', N'Buenos Aires', N'1870', N'Argentina', N'fiscal',  10000),
(N'Ruta 3',        N'1200',N'Lomas',      N'Buenos Aires', N'1832', N'Argentina', N'entrega', 10001),
(N'Belgrano',      N'450', N'Lanús',      N'Buenos Aires', N'1824', N'Argentina', N'entrega', 10002),
(N'San Martín',    N'980', N'Quilmes',    N'Buenos Aires', N'1878', N'Argentina', N'fiscal',  10003),
(N'Mitre',         N'220', N'Banfield',   N'Buenos Aires', N'1828', N'Argentina', N'entrega', 10004),
(N'Alsina',        N'300', N'Adrogué',    N'Buenos Aires', N'1846', N'Argentina', N'entrega', 10005),
(N'Rivadavia',     N'500', N'Morón',      N'Buenos Aires', N'1708', N'Argentina', N'fiscal',  10006),
(N'Cabildo',       N'1200',N'CABA',       N'CABA',         N'1426', N'Argentina', N'entrega', 10007),
(N'Gaona',         N'3200',N'CABA',       N'CABA',         N'1416', N'Argentina', N'entrega', 10008),
(N'Perito Moreno', N'1200',N'Ramos Mejía',N'Buenos Aires', N'1704', N'Argentina', N'retiro',  10009);
GO

-- Facturas para pedidos facturados
INSERT INTO Factura (fecha, tipo, punto_venta, numero, total, estado, id_pedido) VALUES
('2025-10-20', 'A', '0001', '00000001',  80000, 'Emitida', 1),
('2025-10-25', 'B', '0001', '00000002',  45000, 'Emitida', 5),
('2025-10-29', 'C', '0001', '00000003', 140000, 'Emitida', 9);
GO

-- 5 órdenes de compra
INSERT INTO OrdenCompra (fecha, estado, total, id_proveedor) VALUES
('2025-10-18', 'Recibida', 52000, 10),  -- Maderas del Oeste
('2025-10-19', 'Recibida', 66000, 6),   -- Melaminas Norte
('2025-10-20', 'Recibida', 39000, 7),   -- Herrajes Patagónicos
('2025-10-21', 'Recibida', 73000, 8),   -- Barnices Premium
('2025-10-22', 'Recibida', 24000, 5);   -- Mayorista Insumos
GO
-- OC ids: 1..5

-- OC 1 (prov 10: Maderas del Oeste) → material 1
INSERT INTO DetalleCompra (cantidad, costo_unitario, subtotal, id_orden_compra, id_material) VALUES
(40, 1300.00, 52000.00, 1, 1);

-- OC 2 (prov 6: Melaminas Norte) → materiales 4 y 9
INSERT INTO DetalleCompra (cantidad, costo_unitario, subtotal, id_orden_compra, id_material) VALUES
(30, 1800.00, 54000.00, 2, 4),
(200,   60.00, 12000.00, 2, 9);

-- OC 3 (prov 7: Herrajes Patagónicos) → materiales 5 y 10
INSERT INTO DetalleCompra (cantidad, costo_unitario, subtotal, id_orden_compra, id_material) VALUES
(100,  150.00, 15000.00, 3, 5),
(20,  1200.00, 24000.00, 3,10);

-- OC 4 (prov 8: Barnices Premium) → materiales 2 y 7
INSERT INTO DetalleCompra (cantidad, costo_unitario, subtotal, id_orden_compra, id_material) VALUES
(20, 2000.00, 40000.00, 4, 2),
(15, 2200.00, 33000.00, 4, 7);

-- OC 5 (prov 5: Mayorista Insumos) → material 3
INSERT INTO DetalleCompra (cantidad, costo_unitario, subtotal, id_orden_compra, id_material) VALUES
(300,   80.00, 24000.00, 5, 3);
GO


-- PRUEBAS DE TRIGGERS
INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
VALUES ('Empresa', 'Laura', 'Gómez', 'Muebles Gómez SRL', 'CUIT', '30-12345678-9', '1144556677', 'contactomueblesgomez@random.com')
GO
