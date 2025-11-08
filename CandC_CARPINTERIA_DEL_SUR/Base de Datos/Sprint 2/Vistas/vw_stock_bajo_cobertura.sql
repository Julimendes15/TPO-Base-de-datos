USE CC_CARPINTERÍA_DEL_SUR;
GO
/*
------------------------------------------------------------
vw_stock_bajo_cobertura
------------------------------------------------------------
Muestra los productos que tienen poco stock y cuántos días alcanzaría según lo que se vende.
Sirve para detectar qué productos se están por quedar sin stock y planificar reposición o fabricación.
------------------------------------------------------------
*/



CREATE OR ALTER VIEW dbo.vw_stock_bajo_cobertura AS

/*
UMBRAL_STOCK = 5 si un producto tiene menos de 5 unidades, lo marcamos como “stock bajo”.

DIAS_30 = 30, DIAS_90 = 90  ventanas de tiempo para mirar venta
*/
WITH
constantes AS (
    SELECT CAST(5 AS INT) AS UMBRAL_STOCK, 30 AS DIAS_30, 90 AS DIAS_90
),

/*
Mira los pedidos y suma las cantidades por producto.
Calcula ventas en los últimos 30 y 90 días
*/
ventas AS (
    SELECT
        dp.id_producto,
        SUM(CASE WHEN p.fecha >= DATEADD(DAY, -c.DIAS_30, CAST(GETDATE() AS DATE))
                 THEN dp.cantidad ELSE 0 END) AS ventas_30d,
        SUM(CASE WHEN p.fecha >= DATEADD(DAY, -c.DIAS_90, CAST(GETDATE() AS DATE))
                 THEN dp.cantidad ELSE 0 END) AS ventas_90d
    FROM dbo.DetallePedido dp
    JOIN dbo.Pedido p
      ON p.id_pedido = dp.id_pedido
    CROSS JOIN constantes c
    GROUP BY dp.id_producto
)

/*
Trae los datos del producto.
Completa las ventas con 0 si el producto no tuvo ventas.
Calcula la venta promedio por día usando la ventana de 30 días
*/
SELECT
    pr.id_producto,
    pr.codigo,
    pr.nombre AS producto,
    pr.stock,
    pr.activo,
    c.UMBRAL_STOCK                        AS umbral_stock,
    ISNULL(v.ventas_30d, 0)               AS ventas_30d,
    ISNULL(v.ventas_90d, 0)               AS ventas_90d,
    CAST(ISNULL(v.ventas_30d, 0) / 30.0 AS DECIMAL(12,2)) AS venta_diaria_30d,

    CASE
        WHEN ISNULL(v.ventas_30d, 0) = 0 THEN NULL
        ELSE CAST(pr.stock / NULLIF(ISNULL(v.ventas_30d, 0) / 30.0, 0) AS DECIMAL(12,1)) /*NULLIF(..., 0) evita división por cero*/
    END                                   AS cobertura_dias,/*Si no hubo ventas, devuelve NULL*/
	/*Cobertura en días = stock actual / venta diaria.*/
    CASE
	/*Estima cuándo se te acaba el stock: hoy + cobertura
		Si no hay ventas, queda NULL.*/
        WHEN ISNULL(v.ventas_30d, 0) = 0 THEN NULL
        ELSE DATEADD(DAY,
                     CEILING(pr.stock / NULLIF(ISNULL(v.ventas_30d, 0) / 30.0, 0)),
                     CAST(GETDATE() AS DATE))
    END                                   AS fecha_agotamiento_estim,
    CASE WHEN pr.stock < c.UMBRAL_STOCK THEN 1 ELSE 0 END AS stock_bajo

/*LEFT JOIN ventas: incluís todos los productos activos, incluso si no vendieron nada
CROSS JOIN constantes: trae las constantes a cada fila.
WHERE pr.activo = 1: sólo productos habilitados.*/

FROM dbo.Producto pr
LEFT JOIN ventas v
  ON v.id_producto = pr.id_producto
CROSS JOIN constantes c
WHERE pr.activo = 1;
GO



SELECT *
FROM dbo.vw_stock_bajo_cobertura;