USE CC_CARPINTERIA_DEL_SUR;
GO

/*------------------------------------------------------------
Muestra el precio más barato de cada material y qué proveedor lo ofrece.
Sirve para saber con quién conviene comprar y calcular costos actualizados de producción.
------------------------------------------------------------*/
CREATE OR ALTER VIEW dbo.vw_catalogo_precios_vigentes AS
/*
Subconsulta que calcula el costo mínimo por material.
*/
SELECT
    m.id_material,
    m.nombre                  AS material,
    m.tipo,
    m.unidad_medida,
    p.id_proveedor,
    p.razon_social            AS proveedor,
    pm.costo_unitario         AS costo_unitario_vigente,
    m.fecha_ult_actualizacion AS fecha_ult_actualizacion_material
FROM (
    SELECT
        id_material,
        MIN(costo_unitario) AS costo_unitario_min
    FROM dbo.ProveedorMaterial
    GROUP BY id_material
) AS cm
JOIN dbo.ProveedorMaterial pm
    ON pm.id_material   = cm.id_material
   AND pm.costo_unitario = cm.costo_unitario_min
JOIN dbo.Material m
    ON m.id_material = pm.id_material
JOIN dbo.Proveedor p
    ON p.id_proveedor = pm.id_proveedor;
GO

/*Muestra el contenido de la vista*/
SELECT *
FROM dbo.vw_catalogo_precios_vigentes
ORDER BY material;


CREATE OR ALTER VIEW dbo.vw_pedidos_pendientes_detalle AS
/*
Selecciona directamente los pedidos cuyo estado es 'Pendiente'
y los une con cliente, detalle de pedido y producto.
*/
SELECT
    p.id_pedido,
    p.fecha,
    p.estado,
    p.total_bruto,
    p.descuento_total,
    p.total_neto,
    c.id_cliente,
    c.nombre      AS nombre_cliente,
    c.apellido    AS apellido_cliente,
    c.razon_social,
    dp.id_detalle_pedido,
    pr.codigo     AS codigo_producto,
    pr.nombre     AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.descuento,
    dp.subtotal
FROM dbo.Pedido p
JOIN dbo.Cliente c
    ON c.id_cliente = p.id_cliente
JOIN dbo.DetallePedido dp
    ON dp.id_pedido = p.id_pedido
JOIN dbo.Producto pr
    ON pr.id_producto = dp.id_producto
WHERE p.estado = 'Pendiente';
GO

-- Ejemplo de uso:
SELECT *
FROM dbo.vw_pedidos_pendientes_detalle
ORDER BY fecha, id_pedido;
