USE CC_CARPINTERIA_DEL_SUR;
GO

/* 
Consulta de costos de materiales más utilizados.
La idea es saber cuánto dinero representan los materiales en producción, tomando siempre el costo más barato disponible para cada material entre todos los proveedores.
También contamos en cuántos productos distintos se usa cada material, para ver qué tan crítico es para la carpintería.
*/
SELECT 
    m.nombre AS material,
    SUM(df.cantidad * pm.costo_unitario_min) AS costo_total_usado,
    COUNT(DISTINCT df.id_producto) AS cantidad_productos_usan
FROM DetalleFabricacion df
JOIN Material m 
    ON df.id_material = m.id_material
JOIN (
    /* 
    Se calcula, para cada material, cuál es el costo unitario mínimo ofrecido por cualquier proveedor.
    Esto sirve como referencia de costo eficiente y evita inflar el costo usando un proveedor más caro.
    */
    SELECT 
        id_material,
        MIN(costo_unitario) AS costo_unitario_min
    FROM ProveedorMaterial
    GROUP BY id_material
) pm 
    ON pm.id_material = m.id_material
GROUP BY m.id_material, m.nombre
ORDER BY costo_total_usado DESC;



/* 
Consulta de qué productos (muebles) demandan más insumos.
Para cada producto sumamos la cantidad total de insumos requeridos y también contamos cuántos materiales distintos intervienen en su fabricación.
Esto ayuda a detectar diseños muy intensivos en materiales o productos más complejos.
*/
SELECT 
    p.nombre AS producto,
    SUM(df.cantidad) AS total_insumos_requeridos,
    COUNT(DISTINCT df.id_material) AS cantidad_materiales_diferentes
FROM DetalleFabricacion df
JOIN Producto p 
    ON df.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_insumos_requeridos DESC;



/*
Consulta de márgenes de ganancia por producto.
Calculamos el margen unitario en pesos (precio_venta - costo_produccion) y el margen porcentual respecto al precio de venta.
Se filtran solo los productos activos.
Sirve para identificar cuáles son los productos más rentables.
*/
SELECT 
    p.nombre AS producto,
    p.precio_venta,
    p.costo_produccion,
    (p.precio_venta - p.costo_produccion) AS margen_unitario,
    ROUND(
        ((p.precio_venta - p.costo_produccion) / p.precio_venta) * 100
    , 2) AS margen_porcentual
FROM Producto p
WHERE p.activo = 1
ORDER BY margen_porcentual DESC;



/*
Consulta de estadísticas generales de producción.
Se obtiene:
- cuántos productos diferentes se fabrican según el detalle de fabricación
- cuántos materiales distintos se usan
- la cantidad total de insumos sumando las cantidades declaradas en la fabricación
- el costo total estimado de los materiales utilizados, tomando para cada material su costo mínimo disponible
Esto da una foto rápida del volumen de producción y su costo de materia prima.
*/
SELECT 
    COUNT(DISTINCT p.id_producto) AS productos_fabricados,
    COUNT(DISTINCT m.id_material) AS materiales_usados,
    SUM(df.cantidad) AS total_insumos_usados,
    SUM(df.cantidad * pm.costo_unitario_min) AS costo_total_materiales
FROM DetalleFabricacion df
JOIN Producto p 
    ON df.id_producto = p.id_producto
JOIN Material m 
    ON df.id_material = m.id_material
JOIN (
    /*
    Para cada material se obtiene el costo unitario más barato entre proveedores.
    Se usa como referencia de costo estándar del material.
    */
    SELECT 
        id_material,
        MIN(costo_unitario) AS costo_unitario_min
    FROM ProveedorMaterial
    GROUP BY id_material
) pm 
    ON pm.id_material = m.id_material;


/*
Consulta de estadísticas generales de ventas.
Se mide:
- cantidad de pedidos totales
- cantidad de clientes únicos que compraron
- facturación total
- promedio gastado por pedido
- promedio gastado por cliente
Se hace a partir de Pedido y Cliente.
*/
SELECT 
    COUNT(DISTINCT p.id_pedido) AS total_pedidos,
    COUNT(DISTINCT c.id_cliente) AS total_clientes,
    SUM(p.total_neto) AS facturacion_total,
    ROUND(AVG(p.total_neto), 2) AS promedio_por_pedido,
    ROUND(SUM(p.total_neto) / COUNT(DISTINCT c.id_cliente), 2) AS promedio_por_cliente
FROM Pedido p
JOIN Cliente c 
    ON p.id_cliente = c.id_cliente;



/*
Consulta de rentabilidad combinada.
Se compara el dinero que entra por las ventas con el costo estimado de la materia prima utilizada para fabricar exactamente lo que se vendió.
La diferencia entre ambos valores es una ganancia estimada.

La primera subconsulta calcula, por pedido y material, cuánta materia prima se consumió. Para eso multiplica:
- cuánto material lleva una unidad del producto (DetalleFabricacion)
por
- cuántas unidades se vendieron en ese pedido (DetallePedido)

La segunda subconsulta obtiene, para cada material, el costo unitario más bajo disponible entre los proveedores, que se usa como referencia de costo.

Luego se multiplica cuánto material se usó por su costo mínimo y se compara contra el total facturado de cada pedido.
*/
SELECT 
    SUM(p.total_neto) AS ingresos_totales,
    SUM(cm.cantidad_material_usada * cmm.costo_unitario_min) AS costo_total_materiales,
    SUM(p.total_neto) 
        - SUM(cm.cantidad_material_usada * cmm.costo_unitario_min) AS ganancia_estimada
FROM Pedido p
JOIN (
    /*
    Para cada pedido, producto y material se calcula cuánta cantidad de ese material se consumió en total.
    Se suma (cantidad de material que requiere fabricar una unidad del producto) por (cantidad de unidades vendidas en ese pedido).
    Esto refleja el consumo real de materia prima asociado a cada venta.
    */
    SELECT 
        p.id_pedido,
        pr.id_producto,
        df.id_material,
        SUM(df.cantidad * dp.cantidad) AS cantidad_material_usada
    FROM DetallePedido dp
    JOIN Producto pr 
        ON dp.id_producto = pr.id_producto
    JOIN DetalleFabricacion df 
        ON pr.id_producto = df.id_producto
    JOIN Pedido p 
        ON dp.id_pedido = p.id_pedido
    GROUP BY p.id_pedido, pr.id_producto, df.id_material
) cm 
    ON p.id_pedido = cm.id_pedido
JOIN (
    /*
    Para cada material se toma el costo unitario más barato entre todos los proveedores.
    Se usa como base para valorar el costo de la materia prima consumida.
    */
    SELECT 
        id_material,
        MIN(costo_unitario) AS costo_unitario_min
    FROM ProveedorMaterial
    GROUP BY id_material
) cmm 
    ON cm.id_material = cmm.id_material;



/*
Consulta de la evolución mensual de ventas.
Se agrupan las ventas por mes (año-mes).
Por cada mes se cuenta cuántos pedidos hubo y se suma la facturación total de ese mes.
Sirve para ver tendencia de demanda y facturación a lo largo del tiempo.
*/
SELECT 
    FORMAT(fecha, 'yyyy-MM') AS mes,
    COUNT(*) AS pedidos,
    SUM(total_neto) AS ventas_totales
FROM Pedido
GROUP BY FORMAT(fecha, 'yyyy-MM')
ORDER BY mes;



/*
Consulta del costo total de fabricación estimado por producto.
Para cada producto se informa:
- El costo estimado de los materiales necesarios para fabricar una sola unidad. Para eso se toma la lista de materiales que requiere ese producto y se multiplica la cantidad requerida de cada material por el costo mínimo de ese material en proveedores, y luego se suman todos esos costos.
- La variedad de insumos distintos que requiere (cuántos materiales diferentes intervienen).
- El margen unitario del producto según la tabla Producto (precio de venta menos costo de producción declarado).

Las subconsultas que aparecen en el SELECT se calculan producto por producto.
*/
SELECT 
    p.id_producto,
    p.nombre AS producto,

    (
        /* 
        Se calcula el costo total de la materia prima necesaria para fabricar una unidad de este producto.
        Para eso se toman todas las filas de DetalleFabricacion de ese producto y se multiplica la cantidad de cada material por su costo más barato disponible.
        Luego se suman todos esos valores.
        */
        SELECT 
            SUM(df.cantidad * pm.costo_unitario_min)
        FROM DetalleFabricacion df
        JOIN (
            /*
            Se obtiene, por material, el costo unitario más barato ofrecido por cualquier proveedor.
            Esto da una referencia de costo mínimo del insumo.
            */
            SELECT 
                id_material,
                MIN(costo_unitario) AS costo_unitario_min
            FROM ProveedorMaterial
            GROUP BY id_material
        ) pm
            ON pm.id_material = df.id_material
        WHERE df.id_producto = p.id_producto
    ) AS costo_materiales_por_unidad,

    (
        /*
        Se cuenta cuántos materiales distintos se necesitan para fabricar este producto.
        Esto da una idea de complejidad: si usa muchos tipos de insumos diferentes o si es algo más simple.
        */
        SELECT COUNT(DISTINCT df2.id_material)
        FROM DetalleFabricacion df2
        WHERE df2.id_producto = p.id_producto
    ) AS variedad_insumos,

    (p.precio_venta - p.costo_produccion) AS margen_unitario
FROM Producto p
ORDER BY costo_materiales_por_unidad DESC;	


/*
Consulta de los mejores clientes.
Para cada cliente se arma:
- Total gastado histórico, sumando el total_neto de todos sus pedidos.
- Cantidad de pedidos que hizo.
Esto permite identificar a los clientes más valiosos.

Las subconsultas del SELECT miran únicamente los pedidos del cliente actual.
*/
SELECT 
    c.id_cliente,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,

    (
        /*
        Se suma el total_neto de todos los pedidos que hizo este cliente.
        Esto representa cuánto dinero generó ese cliente en total.
        */
        SELECT SUM(p.total_neto)
        FROM Pedido p
        WHERE p.id_cliente = c.id_cliente
    ) AS total_gastado,

    (
        /*
        Se cuenta cuántos pedidos hizo este cliente.
        Esto sirve para distinguir entre un cliente que compra poco pero tickets altos vs uno que compra seguido.
        */
        SELECT COUNT(*)
        FROM Pedido p
        WHERE p.id_cliente = c.id_cliente
    ) AS cantidad_pedidos

FROM Cliente c
ORDER BY total_gastado DESC;



/*
Consulta del ranking de productos más vendidos.
Para cada producto se arma un resumen con:
- Cantidad total vendida (unidades_vendidas)
- Ingresos generados (ingresos)
- Margen unitario declarado en Producto
- Margen total estimado del producto multiplicando el margen unitario por todas las unidades vendidas

La subconsulta interna primero resume las ventas por producto a partir del detalle de cada pedido.
Luego se enriquece con la información del producto.
*/
SELECT 
    v.id_producto,
    p.nombre AS producto,
    v.unidades_vendidas,
    v.ingresos,
    (p.precio_venta - p.costo_produccion) AS margen_unitario,
    v.unidades_vendidas * (p.precio_venta - p.costo_produccion) AS margen_total_estimado
FROM (
    /*
    Se agrupan todas las líneas de venta (DetallePedido) por producto.
    Se suman las cantidades vendidas totales de ese producto y el total facturado de ese producto.
    Esto sirve para saber cuáles son los más vendidos y cuáles generan más ingresos.
    */
    SELECT 
        dp.id_producto,
        SUM(dp.cantidad) AS unidades_vendidas,
        SUM(dp.subtotal) AS ingresos
    FROM DetallePedido dp
    GROUP BY dp.id_producto
) v
JOIN Producto p 
    ON p.id_producto = v.id_producto
ORDER BY v.unidades_vendidas DESC;



/*
Consulta del consumo real de materiales según ventas.
El objetivo es estimar cuánto costaron, en total, todos los materiales que efectivamente se usaron para producir lo que se vendió.

La primera subconsulta calcula, para cada material, cuánta cantidad total se utilizó en todas las ventas registradas. Esto se hace multiplicando lo que ese producto necesita de cada material por la cantidad de unidades vendidas de ese producto.

La segunda subconsulta consigue, para cada material, el costo unitario más bajo disponible. Eso se usa para valorizar económicamente el consumo.

Luego se multiplica la cantidad total usada de cada material por su costo unitario mínimo y finalmente se suman todos esos valores para obtener un costo total estimado global de materia prima gastada.
*/
SELECT
    SUM(mu.cantidad_material_usada * cm.costo_unitario_minimo) AS costo_total_estimado_global
FROM (
    /*
    Para cada material se suma cuánta cantidad se usó en todas las ventas.
    Se toma la relación entre DetallePedido y DetalleFabricacion para calcular: 
    cantidad de material que requiere fabricar una unidad del producto, multiplicado por la cantidad de ese producto vendida.
    El resultado es el consumo total de cada material.
    */
    SELECT 
        df.id_material,
        SUM(df.cantidad * dp.cantidad) AS cantidad_material_usada
    FROM DetallePedido dp
    JOIN DetalleFabricacion df 
        ON dp.id_producto = df.id_producto
    GROUP BY df.id_material
) mu
JOIN (
    /*
    Para cada material se determina el costo unitario más barato entre todos los proveedores.
    Este valor se usa para asignarle un costo razonable al consumo de cada material.
    */
    SELECT 
        pm.id_material,
        MIN(pm.costo_unitario) AS costo_unitario_minimo
    FROM ProveedorMaterial pm
    GROUP BY pm.id_material
) cm
    ON mu.id_material = cm.id_material;



/*
Consulta de datos completos de pedidos.
Por cada pedido se devuelve:
- la fecha
- el cliente
- el total vendido
- cuántas unidades totales se vendieron en ese pedido (sumando todas las líneas)
- el margen estimado del pedido. Ese margen se calcula multiplicando la cantidad vendida de cada producto por el margen unitario de ese producto (precio de venta menos costo de producción declarado) y luego sumando todos esos márgenes parciales.

Las subconsultas del SELECT se calculan pedido por pedido.
*/
SELECT 
    p.id_pedido,
    p.fecha,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    p.total_neto AS total_vendido,

    (
        /*
        Se suman todas las cantidades vendidas dentro de este pedido.
        Esto dice cuántas unidades totales se vendieron en esa orden.
        */
        SELECT SUM(dp.cantidad)
        FROM DetallePedido dp
        WHERE dp.id_pedido = p.id_pedido
    ) AS total_unidades_en_pedido,

    (
        /*
        Se estima el margen total del pedido.
        Para cada línea del pedido se toma la cantidad vendida y se multiplica por el margen unitario del producto (precio de venta menos costo de producción).
        Luego se suman todos esos márgenes parciales.
        Esto se interpreta como una ganancia bruta aproximada del pedido.
        */
        SELECT SUM(
            dp.cantidad * (pr.precio_venta - pr.costo_produccion)
        )
        FROM DetallePedido dp
        JOIN Producto pr 
            ON pr.id_producto = dp.id_producto
        WHERE dp.id_pedido = p.id_pedido
    ) AS margen_estimado_pedido

FROM Pedido p
JOIN Cliente c 
    ON c.id_cliente = p.id_cliente
ORDER BY p.fecha DESC;


SELECT * FROM DetalleFabricacion
