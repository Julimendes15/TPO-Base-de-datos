
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