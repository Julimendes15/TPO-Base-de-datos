USE CC_CARPINTERÍA_DEL_SUR;
GO


-- COSTOS DE LOS MATERIALES MAS UTILIZADOS 
SELECT 
    m.nombre AS material,
    SUM(df.cantidad * m.costo_unitario) AS costo_total_usado,
    COUNT(DISTINCT df.id_producto) AS cantidad_productos_usan
FROM DetalleFabricacion df
JOIN Material m ON df.id_material = m.id_material
GROUP BY m.id_material, m.nombre
ORDER BY costo_total_usado DESC;


-- TIPOS DE MUEBLES QUE DEMANDAN MAYOR INSUMOS 
SELECT 
    p.nombre AS producto,
    SUM(df.cantidad) AS total_insumos_requeridos,
    COUNT(DISTINCT df.id_material) AS cantidad_materiales_diferentes
FROM DetalleFabricacion df
JOIN Producto p ON df.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_insumos_requeridos DESC;

-- CLIENTES CON MAYORES COMPRAS
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellido) AS Cliente,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    SUM(p.total_neto) AS total_gastado
FROM Cliente c
JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY total_gastado DESC;

-- PRODUCTOR CON MAYOR MARGEN DE GANACIA
SELECT 
    p.nombre AS producto,
    p.precio_venta,
    p.costo_produccion,
    (p.precio_venta - p.costo_produccion) AS margen_unitario,
    ROUND(((p.precio_venta - p.costo_produccion) / p.precio_venta) * 100, 2) AS margen_porcentual
FROM Producto p
WHERE p.activo = 1
ORDER BY margen_porcentual DESC;

-- ESTADISTICAS GENERALES DE PRODUCCION
SELECT 
    COUNT(DISTINCT p.id_producto) AS productos_fabricados,
    COUNT(DISTINCT m.id_material) AS materiales_usados,
    SUM(df.cantidad) AS total_insumos_usados,
    SUM(df.cantidad * m.costo_unitario) AS costo_total_materiales
FROM DetalleFabricacion df
JOIN Producto p ON df.id_producto = p.id_producto
JOIN Material m ON df.id_material = m.id_material;


-- ESTADISTICAS GENERALES DE VENTAS
SELECT 
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    COUNT(DISTINCT c.id_cliente) AS total_clientes,
    SUM(p.total_neto) AS facturacion_total,
    ROUND(AVG(p.total_neto), 2) AS promedio_por_pedido,
    ROUND(SUM(p.total_neto) / COUNT(DISTINCT c.id_cliente), 2) AS promedio_por_cliente
FROM Pedido p
JOIN Cliente c ON p.id_cliente = c.id_cliente;

-- RENTABILIDAD COMBINADA (VENTAS VS COSTOS DE MATERIALES)  
SELECT 
    SUM(p.total_neto) AS ingresos_totales,
    SUM(df.cantidad * m.costo_unitario) AS costo_total_materiales,
    (SUM(p.total_neto) - SUM(df.cantidad * m.costo_unitario)) AS ganancia_estimada
FROM Pedido p
JOIN DetallePedido dp ON p.id_pedido = dp.id_pedido
JOIN Producto pr ON dp.id_producto = pr.id_producto
JOIN DetalleFabricacion df ON pr.id_producto = df.id_producto
JOIN Material m ON df.id_material = m.id_material;

-- PRODUCTOS MAS VENDIDOS Y SU MARGEN 
SELECT 
    pr.nombre AS producto,
    SUM(dp.cantidad) AS unidades_vendidas,
    SUM(dp.subtotal) AS ingresos,
    (pr.precio_venta - pr.costo_produccion) AS margen_unitario,
    SUM(dp.cantidad * (pr.precio_venta - pr.costo_produccion)) AS margen_total
FROM DetallePedido dp
JOIN Producto pr ON dp.id_producto = pr.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.precio_venta, pr.costo_produccion
ORDER BY margen_total DESC;

-- EVOLUCION MENSUAL DE VENTAS
SELECT 
    FORMAT(fecha, 'yyyy-MM') AS mes,
    COUNT(*) AS pedidos,
    SUM(total_neto) AS ventas_totales
FROM Pedido
GROUP BY FORMAT(fecha, 'yyyy-MM')
ORDER BY mes;