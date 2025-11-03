-- CARGA DE DATOS 
USE CC_CARPINTERÍA_DEL_SUR;
GO


/* ===========================
   CLIENTES (10)
   =========================== */
INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
VALUES 
('Particular', 'Juan', 'Pérez', 'Pérez Juan', 'DNI', '30111222', '1122334455', 'juanp@gmail.com'),
('Empresa', 'Laura', 'Gómez', 'Muebles Gómez SRL', 'CUIT', '30-12345678-9', '1144556677', 'contacto@mueblesgomez@gmail.com'),
('Particular','Sofía','Martínez','Sofía Martínez','DNI','32555444','1155500011','sofia.martinez@outlook.com'),
('Empresa','Diego','Luna','Carpintería Luna SA','CUIT','30-11223344-5','1144443322','ventas.luna@yahoo.com'),
('Particular','Pilar','Mendes','Pilar Mendes','DNI','45999111','1177788899','pilar.mendes@gmail.com'),
('Particular','Marcos','Ibarra','Marcos Ibarra','DNI','34566777','1166677700','marcos.ibarra@gmail.com'),
('Empresa','Rocío','Sosa','Muebles RS SRL','CUIT','30-55667788-9','1130030030','contacto@mueblesrs@outlook.com'), -- válido por tu CHECK
('Particular','Camila','Vega','Camila Vega','DNI','38111222','1144442211','camila.vega@yahoo.com'),
('Empresa','Hernán','Lopez','HL Carpintería SA','CUIT','30-99887766-5','1147779900','ventas.hl@gmail.com'),
('Particular','Valentina','Ríos','Valentina Ríos','DNI','40222333','1166004400','valentina.rios@outlook.com');

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

/* ===========================
   MATERIALES (10)
   =========================== */
INSERT INTO Material (nombre, tipo, unidad_medida)
VALUES 
('Madera roble', 'Madera', 'm2'),
('Barniz protector', 'Pintura', 'lt'),
('Tornillos acero', 'Accesorios', 'kg'),
('Melamina blanca','Melamina','m2'),
('Bisagras acero','Herrajes','un'),
('Tiradores aluminio','Herrajes','un'),
('Laca poliuretánica','Pintura','lt'),
('Masilla para madera','Insumo','kg'),
('Tapacanto PVC','Insumo','m'),
('Correderas telescópicas','Herrajes','un');

/* ===========================
   PROVEEDOR-MATERIAL (10)
   =========================== */
INSERT INTO ProveedorMaterial (id_material, id_proveedor, costo_unitario) 
VALUES 
(1, 1, 1500.00), 
(1, 2, 1300.00),
(2, 1, 2200.00),
(2, 3, 2000.00),
(3, 4,  100.00),
(3, 5,   80.00),
(4, 6, 1800.00),
(5, 7,  150.00),
(7, 8, 2200.00),
(10,7, 1200.00);

/* ===========================
   RECETAS / DetalleFabricacion (10)
   =========================== */
INSERT INTO DetalleFabricacion (cantidad, merma_pct, id_producto, id_material)
VALUES
(3, 5, 1, 1),   -- Silla: roble
(1, 2, 1, 2),   -- Silla: barniz
(4, 7, 2, 1),   -- Mesa: roble
(1, 2, 2, 2),   -- Mesa: barniz
(3, 4, 3, 4),   -- Estantería: melamina blanca
(4, 5, 4, 5),   -- Placard: bisagras
(2, 3, 5, 4),   -- Escritorio: melamina blanca
(4, 5, 6, 4),   -- Biblioteca: melamina blanca
(6, 7, 7, 1),   -- Cama: roble
(1, 2, 8, 1);   -- Banqueta: roble

/* ===========================
   PEDIDOS (10)  – totales coherentes
   =========================== */
INSERT INTO Pedido (fecha, total_bruto, descuento_total, total_neto, estado, id_cliente)
VALUES 
('2025-10-20', 80000, 0,     80000, 'Facturado', 10000),
('2025-10-22', 60000, 5000,  55000, 'Pendiente', 10001),
('2025-10-23', 30000, 0,     30000, 'Pendiente', 10002),
('2025-10-24', 90000, 10000, 80000, 'Pendiente', 10003),
('2025-10-25', 45000, 0,     45000, 'Facturado', 10004),
('2025-10-26', 60000, 0,     60000, 'Pendiente', 10005),
('2025-10-27',120000, 20000,100000, 'Pendiente', 10006),
('2025-10-28', 40000, 0,     40000, 'Pendiente', 10007),
('2025-10-29',140000, 0,    140000, 'Facturado', 10008),
('2025-10-30', 30000, 3000,  27000, 'Pendiente', 10009);

/* ===========================
   DETALLEPEDIDO (10) – suma = totales de arriba
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

-- Pedido 9 (dos líneas de ejemplo)
INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
(1, 85000, 0, 85000, 9, 9),
(1, 55000, 0, 55000, 9, 10);

-- Pedido 10
INSERT INTO DetallePedido (cantidad, precio_unitario, descuento, subtotal, id_pedido, id_producto)
VALUES
(2, 15000, 3000, 27000, 10, 1);

