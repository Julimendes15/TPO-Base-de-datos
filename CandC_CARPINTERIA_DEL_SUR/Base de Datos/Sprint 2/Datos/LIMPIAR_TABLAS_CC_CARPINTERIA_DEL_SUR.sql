USE CC_CARPINTERÍA_DEL_SUR;
GO

PRINT '--- DESHABILITANDO RESTRICCIONES ---';
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";
GO

PRINT '--- ELIMINANDO DATOS (orden seguro) ---';

-- 1. Tablas intermedias o dependientes
DELETE FROM ProveedorMaterial;
DELETE FROM DetalleCompra;
DELETE FROM DetalleFabricacion;
DELETE FROM DetallePedido;
DELETE FROM Factura;
DELETE FROM Domicilio;
DELETE FROM OrdenCompra;
DELETE FROM Pedido;

-- 2. Tablas principales (sin dependencias hacia abajo)
DELETE FROM Producto;
DELETE FROM Material;
DELETE FROM Categoria;
DELETE FROM Proveedor;
DELETE FROM Cliente;
GO

PRINT '--- RESETEANDO IDENTITY ---';
DBCC CHECKIDENT ('Cliente', RESEED, 9999);       -- empieza en 10000
DBCC CHECKIDENT ('Categoria', RESEED, 0);
DBCC CHECKIDENT ('Producto', RESEED, 0);
DBCC CHECKIDENT ('Proveedor', RESEED, 0);
DBCC CHECKIDENT ('Material', RESEED, 0);
DBCC CHECKIDENT ('Pedido', RESEED, 0);
DBCC CHECKIDENT ('Factura', RESEED, 0);
DBCC CHECKIDENT ('Domicilio', RESEED, 0);
DBCC CHECKIDENT ('OrdenCompra', RESEED, 0);
DBCC CHECKIDENT ('DetallePedido', RESEED, 0);
DBCC CHECKIDENT ('DetalleFabricacion', RESEED, 0);
DBCC CHECKIDENT ('DetalleCompra', RESEED, 0);
GO

PRINT '--- HABILITANDO RESTRICCIONES NUEVAMENTE ---';
EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";
GO

PRINT '--- LIMPIEZA COMPLETADA EXITOSAMENTE ---';