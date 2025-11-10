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
