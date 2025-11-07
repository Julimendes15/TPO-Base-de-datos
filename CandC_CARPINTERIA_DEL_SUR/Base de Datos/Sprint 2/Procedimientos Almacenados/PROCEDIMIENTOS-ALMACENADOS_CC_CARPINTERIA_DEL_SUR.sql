USE CC_CARPINTERÍA_DEL_SUR;
GO

-- PROCEDIMIENTOS ALMACENADOS --

/* PROCEDIMIENTOS TABLA CLIENTES 
   PROCEDIMIENTO: Insertar valores en la tabla Cliente
*/
CREATE PROCEDURE SP_Insert_Cliente 
	@tipo NVARCHAR(30) NOT NULL,
	@nombre NVARCHAR(100) NOT NULL,
    @apellido NVARCHAR(100) NOT NULL,
    @razon_social NVARCHAR(150) NOT NULL,
    @doc_tipo NVARCHAR(20) NOT NULL,
    @doc_numero NVARCHAR(20) NOT NULL,
    @telefono NVARCHAR(50) NOT NULL,
    @email NVARCHAR(100) NOT NULL
AS 
BEGIN 
	INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
	VALUES (@tipo, @nombre, @apellido, @razon_social, @doc_tipo, @doc_numero, @telefono, @email);
END;
GO

-- PROCEDIMIENTO: Mostrar cantidad total de clientes 
CREATE PROCEDURE SP_Contar_Cliente
    @Total INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
    SELECT @Total = COUNT(*) FROM Cliente;
END
GO

DECLARE @tot INT;
EXEC SP_Contar_Cliente @Total = @tot OUTPUT;
SELECT @tot AS total_clientes
GO


-- PROCEDIMIENTOS TABLA CLIENTES
-- PROCEDIMIENTO: Ver categoria segun nombre
CREATE PROCEDURE SP_Listar_Categoria_especifica
	@nombre NVARCHAR(100) OUTPUT
AS 
BEGIN 
	SELECT id_categoria, nombre, descripcion
  FROM Categoria
  WHERE nombre = @nombre;
END
GO

EXEC SP_Listar_Categoria_especifica @nombre = 'Sillas';
GO

-- PROCEDIMIENTO: Eliminar categoria de forma segura, si tiene productos asociados, no se puede eliminar. 
CREATE PROCEDURE SP_Eliminacion_segura
	@id_categoria INT
AS 
BEGIN
	IF EXISTS (SELECT 1 FROM Producto WHERE id_categoria = @id_categoria)
	BEGIN 
		RAISERROR('No se puede eliminar: la categoria esta asociada a prodcutos', 16, 1); -- 16 = severidad indica la gravedad del error (16 es para lo errores de ususario) y 1 es un numero para identificar el error si tenes varios RAISERROR
		RETURN;
	END

	DELETE FROM Categoria WHERE id_categoria = @id_categoria;
END
GO 

EXEC SP_Eliminacion_segura @id_categoria = 1;
GO

-- PROCEDIMIENTOS TABLA PRODUCTO
-- PROCEDIMIENTO: Actualizar precio de venta
CREATE PROCEDURE SP_Act_Pventa
	@codigo NVARCHAR(50),
	@precio_venta DECIMAL(12,2)
AS
BEGIN	
	UPDATE Producto SET precio_venta = @precio_venta WHERE codigo = @codigo;
END 
GO 

EXEC SP_Act_Pventa @codigo = 'S001', @precio_venta = 16000;

SELECT codigo, precio_venta FROM Producto;
DROP PROCEDURE SP_Act_Pventa;
GO

-- PROCEDIMIENTO: Productos por categoría con stock bajo (alerta operativa)
CREATE PROCEDURE SP_producto_stock_bajo
	@id_categoria INT = NULL, 
	@cant_min_de_buen_stock DECIMAL(10,2) = 5 -- esto sirve para definir a partir de que cant de stock se considera bajo
AS 
BEGIN 
	SELECT p.id_producto, p.codigo, p.nombre, p.stock, c.nombre AS categoria
	FROM Producto AS p
	JOIN Categoria AS c ON c.id_categoria = p.id_categoria
	WHERE p.stock < @cant_min_de_buen_stock
	ORDER BY p.stock ASC;
END
GO 

EXEC SP_producto_stock_bajo @cant_min_de_buen_stock = 5;
GO
DROP PROCEDURE SP_producto_stock_bajo;
GO

-- PROCEDIMIENTOS TABLA PROVEEDOR
-- PROCEDIMIENTO: Insertar proveedor (valida CUIT único)
CREATE PROCEDURE SP_Insertar_prov
	@razon_social NVARCHAR(150),
	@cuit         NVARCHAR(20),
	@telefono     NVARCHAR(50),
	@email        NVARCHAR(100),
	@direccion    NVARCHAR(200),
	@estado       NVARCHAR(50) = 'Activo'
AS 
BEGIN 
	IF EXISTS (SELECT 1 FROM Proveedor WHERE cuit = @cuit)
	PRINT('Ya existe un proveedor con es CUIT')

	INSERT INTO Proveedor (razon_social, cuit, telefono, email, direccion, estado)
	VALUES (@razon_social, @cuit, @telefono, @email, @direccion, @estado);
END 
GO

/* EXEC SP_Insertar_prov .... */

-- PROCEDIMIENTO: Buscar informacion del proveedor por texto
CREATE PROCEDURE SP_eliminar_prov_seguro
	@id_proveedor INT
AS 
BEGIN 
	IF EXISTS (SELECT 1 FROM dbo.ProveedorMaterial WHERE id_proveedor = @id_proveedor)
      PRINT('No se puede eliminar: tiene materiales asociados (ProveedorMaterial).')

	IF EXISTS (SELECT 1 FROM dbo.OrdenCompra WHERE id_proveedor = @id_proveedor)
      PRINT('No se puede eliminar: tiene órdenes de compra asociadas.')

	DELETE FROM dbo.Proveedor WHERE id_proveedor = @id_proveedor;
END
GO






