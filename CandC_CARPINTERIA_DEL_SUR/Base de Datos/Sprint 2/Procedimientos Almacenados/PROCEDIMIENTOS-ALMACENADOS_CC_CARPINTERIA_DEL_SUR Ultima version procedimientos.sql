USE CC_CARPINTERlA_DEL_SUR;
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


-- PROCEDIMIENTOS TABLA CATEGORIA
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

-- PROCEDIMIENTO: Eliminar proveedor de forma segura
CREATE PROCEDURE SP_eliminar_prov_seguro
	@id_proveedor INT
AS 
BEGIN 
	IF EXISTS (SELECT 1 FROM ProveedorMaterial WHERE id_proveedor = @id_proveedor)
      PRINT('No se puede eliminar: tiene materiales asociados (ProveedorMaterial).')

	IF EXISTS (SELECT 1 FROM OrdenCompra WHERE id_proveedor = @id_proveedor)
      PRINT('No se puede eliminar: tiene órdenes de compra asociadas.')

	DELETE FROM Proveedor WHERE id_proveedor = @id_proveedor;
END
GO

-- PROCEDIMIENTOS TABLA MATERIAL
-- PROCEDIMIENTO: MOSTRAR MATERIALES CON EL MISMO TIPO DE MATERIAL Y LA MISMA UNIDAD DE MEDIAD
CREATE PROCEDURE SP_Mostrar_mat_con_mismo_tipo
	@tipo NVARCHAR(50),
	@unidad_medida NVARCHAR(50)
AS 
BEGIN
	SELECT nombre, tipo, unidad_medida FROM Material WHERE tipo = @tipo AND unidad_medida = @unidad_medida;
END 
GO

EXEC SP_Mostrar_mat_con_mismo_tipo @tipo = 'Madera', @unidad_medida = 'm2';
GO

-- PROCEDIMIENTO: Listar materiales (con datos del proveedor)
CREATE PROCEDURE SP_material_listar
AS
BEGIN
  SELECT m.id_material, m.nombre, m.tipo, m.unidad_medida, m.fecha_ult_actualizacion, m.activo, p.id_proveedor, p.razon_social, p.estado AS estado_proveedor
  FROM dbo.Material AS m
  JOIN dbo.Proveedor AS p ON p.id_proveedor = m.id_proveedor
  ORDER BY m.id_material;
END
GO

EXEC SP_material_listar
GO

-- PROCEDIMIENTOS TABLA PEDIDO
-- PROCEDIMIENTO: procedimiento para ver que clientes gastaron cierta cantidad de dinero en un producto 
CREATE PROCEDURE SP_filtrar_pedidos_x_precio
	@precioA INT, 
	@precioB INT
AS 
BEGIN 
	SELECT p.id_cliente, c.nombre, p.total_neto AS Total_del_pedido
	FROM Pedido AS p
	JOIN Cliente AS c ON p.id_cliente = c.id_cliente
	WHERE p.total_neto BETWEEN @precioA AND @precioB;
END	
GO

DECLARE @precioa INT;
DECLARE @preciob INT;

EXEC SP_filtrar_pedidos_x_precio @precioa = 75000, @preciob = 110000;
SELECT total_neto FROM Pedido;
GO

CREATE PROCEDURE SP_pedido_historial_cliente
  @id_cliente INT
AS
BEGIN
  SELECT id_pedido, fecha, estado, total_neto
  FROM Pedido
  WHERE id_cliente = @id_cliente
  ORDER BY fecha DESC, id_pedido DESC;
END
GO

EXEC SP_pedido_historial_cliente @id_cliente = 10000;
GO

-- PROCEDIMIENTOS TABLA FACTURA
-- PROCEDIMIENTO: factura en un punto de venta especifico (definido en el EXEC) 
CREATE PROCEDURE SP_factura_punto_de_venta
	@punto_venta NVARCHAR(10)
AS 
BEGIN 
	SELECT punto_venta FROM Factura; 
END 

EXEC SP_factura_punto_de_venta @punto_venta = '0001';

--PROCEDIMIENTO: Listar facturas de un cliente 
CREATE PROCEDURE sp_factura_por_cliente
  @id_cliente INT
AS
BEGIN
  SELECT f.id_factura, f.fecha, f.tipo, f.punto_venta, f.numero,
         f.total, f.estado, f.id_pedido
  FROM Factura f
  JOIN Pedido p ON p.id_pedido = f.id_pedido
  WHERE p.id_cliente = @id_cliente
  ORDER BY f.fecha DESC, f.id_factura DESC;
END
GO

EXEC sp_factura_por_cliente @id_cliente = 10000;

-- PROCEDIMIENTOS TABLA DOMICILIO 
-- PROCEDIMIENTO: Domicilio completo de un cliente con su nombre
CREATE PROCEDURE SP_domicilio_completo_cliente
	@nombre_cliente VARCHAR(15),
	@apellido_cliente VARCHAR(15)
AS 
BEGIN 
	SELECT c.nombre , c.apellido ,d.calle, d.numero, d.ciudad, d.provincia, d.codigo_postal, d.pais
	FROM Domicilio AS d
	JOIN Cliente AS c ON c.id_cliente = d.id_cliente
	WHERE c.nombre = @nombre_cliente AND c.apellido = @apellido_cliente;
END 
GO

EXEC SP_domicilio_completo_cliente @nombre_cliente = 'Juan', @apellido_cliente = 'Pérez';
GO

-- PROCEDIMIENTO: Cliente de una misma ciudad extraidos por Código postal
CREATE PROCEDURE SP_clientes_misma_ciudad_x_CP
	@codigoPostal NVARCHAR(20)
AS
BEGIN 
	SELECT c.nombre, c.apellido, d.ciudad, d.codigo_postal 
	FROM Domicilio AS d
	JOIN Cliente AS c ON c.id_cliente = d.id_cliente
	WHERE d.codigo_postal = @codigoPostal
END
GO

EXEC SP_clientes_misma_ciudad_x_CP @codigoPostal = '1870';
GO 


-- PROCEDIMIENTOS TABLA DETALLE PEDIDO 
-- PROCEDIMIENTO: Mostrar los descuentos que se le hicieron a los pedidos hechos por un cliente
CREATE OR ALTER PROCEDURE dbo.SP_descuentos_en_pedidos_de_cliente
  @id_cliente INT,
  @solo_con_descuento BIT = 1
AS
BEGIN
  SELECT 
      p.id_pedido, p.fecha, c.nombre,
      c.apellido, d.id_detalle_pedido, d.id_producto, d.cantidad,
      d.precio_unitario, d.descuento AS descuento_linea,
      d.subtotal  AS subtotal_linea
  FROM Pedido AS p
  JOIN DetallePedido AS d ON d.id_pedido = p.id_pedido
  JOIN Cliente AS c ON c.id_cliente = p.id_cliente
  WHERE p.id_cliente = @id_cliente
    AND (@solo_con_descuento = 0 OR d.descuento > 0)
  ORDER BY p.fecha DESC, p.id_pedido, d.id_detalle_pedido;
END
GO

EXEC dbo.SP_descuentos_en_pedidos_de_cliente @id_cliente = 10000;           -- solo con descuento
EXEC dbo.SP_descuentos_en_pedidos_de_cliente @id_cliente = 10000, @solo_con_descuento = 0;  -- todo
GO

-- PROCEDIMIENTO: resumen de un pedido 
CREATE OR ALTER PROCEDURE SP_detalle_resumen_pedido
  @id_pedido INT
AS
BEGIN
  SELECT
    SUM(d.cantidad * d.precio_unitario) AS bruto_detalle,
    SUM(d.descuento) AS descuento_lineas,
    SUM(d.subtotal) AS neto_detalle
  FROM DetallePedido AS d
  WHERE d.id_pedido = @id_pedido;
END
GO


-- PROCEDIMIENTOS TABLA DETALLE FABRICACION 
-- PROCEDIMEINTO: CONTAR CUANTOS MATERIALES USA CADA PRODUCTO 
CREATE PROCEDURE SP_cantidad_materiales_por_producto
AS
BEGIN
  SELECT p.nombre AS producto,
      COUNT(df.id_material) AS materiales_usados
  FROM DetalleFabricacion df
  JOIN Producto p ON p.id_producto = df.id_producto
  GROUP BY p.nombre
  ORDER BY materiales_usados DESC;
END
GO

EXEC SP_cantidad_materiales_por_producto
GO

-- PROCEDIMIENTO: 
CREATE PROCEDURE SP_materiales_por_producto
  @id_producto INT
AS
BEGIN
  SELECT 
      df.id_detalle_fab,
      p.nombre AS producto,
      m.nombre AS material,
      df.cantidad,
      df.merma_pct, (df.cantidad * (1 + df.merma_pct/100.0)) AS cantidad_total_requerida
  FROM dbo.DetalleFabricacion df
  JOIN dbo.Producto p ON p.id_producto = df.id_producto
  JOIN dbo.Material m ON m.id_material = df.id_material
  WHERE df.id_producto = @id_producto;
END
GO

EXEC dbo.sp_materiales_por_producto @id_producto = 3;


-- PROCEDIMIENTOS TABLA ProveedorMaterial
-- PROCEDIMIENTO: Cuantos materiales provee un proveedor especifico determinaod por id
CREATE PROCEDURE SP_Mat_d_prov 
	@id_proveedor INT
AS 
BEGIN 
	SELECT pm.id_proveedor, pm.id_material, p.razon_social, m.nombre AS Material, m.tipo AS tipo_material
	FROM ProveedorMaterial AS pm
	JOIN Proveedor AS p ON pm.id_proveedor = p.id_proveedor
	JOIN Material AS m ON p.id_proveedor = m.id_proveedor
	WHERE pm.id_proveedor = @id_proveedor
END 
GO

EXEC SP_Mat_d_prov @id_proveedor = 2;
GO

-- PROCEDIMIENTO: Obtener material y los proveedores de los mismos para decidir cuál elegir
CREATE PROCEDURE SP_precio_material_prov
  @material NVARCHAR(100)
AS
BEGIN
  SELECT 
      m.nombre AS nombre_material,
      p.razon_social AS proveedor,
      pm.costo_unitario
  FROM ProveedorMaterial AS pm
  JOIN Material AS m ON pm.id_material = m.id_material
  JOIN Proveedor AS p ON pm.id_proveedor = p.id_proveedor
  WHERE m.nombre = @material
  ORDER BY pm.costo_unitario ASC;  -- más barato primero
END
GO

EXEC SP_precio_material_prov @material = 'Tornillos acero';
GO

-- PROCEDIMIENTOS TABLA OrdenCmpra 
-- PROCEDIMIENTO: Mostrar todas las órdenes con su proveedor y total
CREATE PROCEDURE SP_Listar_Ordenes_Compra
AS
BEGIN
    SELECT 
        oc.id_orden_compra,
        p.razon_social AS proveedor,
        oc.fecha,
        oc.estado,
        oc.total
    FROM OrdenCompra oc
    JOIN Proveedor p ON oc.id_proveedor = p.id_proveedor
    ORDER BY oc.fecha DESC;
END
GO

EXEC SP_Listar_Ordenes_Compra;
GO

-- PROCEDIMIENTO: Mostrar órdenes de compra filtradas por proveedor
CREATE PROCEDURE SP_Ordenes_Por_Proveedor
    @id_proveedor INT
AS
BEGIN
    SELECT 
        id_orden_compra,
        fecha,
        estado,
        total
    FROM OrdenCompra
    WHERE id_proveedor = @id_proveedor
    ORDER BY fecha DESC;
END
GO

EXEC SP_Ordenes_Por_Proveedor @id_proveedor = 1;
GO

-- PROCEDIMIENTOS TABLA DetalleCompra
-- PROCEDIMIENTO: Mostrar los materiales comprados en una orden
CREATE PROCEDURE SP_Materiales_Por_Orden
    @id_orden_compra INT
AS
BEGIN
    SELECT 
        m.nombre AS material,
        dc.cantidad,
        dc.costo_unitario,
        dc.subtotal
    FROM DetalleCompra dc
    JOIN Material m ON dc.id_material = m.id_material
    WHERE dc.id_orden_compra = @id_orden_compra;
END
GO

EXEC SP_Materiales_Por_Orden @id_orden_compra = 1;
go

-- PROCEDIMIENTO:Mostrar materiales más comprados (por cantidad)
CREATE PROCEDURE SP_Materiales_Mas_Comprados
AS
BEGIN
    SELECT 
        m.nombre AS material,
        SUM(dc.cantidad) AS total_comprado
    FROM DetalleCompra dc
    JOIN Material m ON dc.id_material = m.id_material
    GROUP BY m.nombre
    ORDER BY total_comprado DESC;
END
GO

EXEC SP_Materiales_Mas_Comprados;
GO

-- FUNCION + PROCEDIMIENTO ALMACENADO 
-- FUNCION: Calcular el total neto de un pedido. Devuelve el total real del pedido (bruto - descuento).
CREATE FUNCTION FN_TotalNetoPedido (@id_pedido INT)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @total DECIMAL(12,2);

    SELECT @total = (total_bruto - descuento_total)
    FROM Pedido
    WHERE id_pedido = @id_pedido;

    RETURN @total;
END;
GO

SELECT dbo.FN_TotalNetoPedido(1) AS Total_Neto;

-- PROCEDIMIENTO: Mostrar pedidos con su total neto (usando la función)
CREATE PROCEDURE SP_Listar_Pedidos_Con_TotalNeto
AS
BEGIN
    SELECT 
        p.id_pedido,
        c.nombre + ' ' + c.apellido AS cliente,
        p.total_bruto,
        p.descuento_total,
        dbo.FN_TotalNetoPedido(p.id_pedido) AS total_neto
    FROM Pedido p
    JOIN Cliente c ON p.id_cliente = c.id_cliente;
END;
GO

EXEC SP_Listar_Pedidos_Con_TotalNeto;
GO

