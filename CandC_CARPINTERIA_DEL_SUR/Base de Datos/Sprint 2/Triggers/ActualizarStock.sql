USE CC_CARPINTERlA_DEL_SUR;

GO

CREATE TRIGGER trg_actualizar_stock_pedido
ON DetallePedido
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.stock = p.stock - i.cantidad
    FROM Producto p
    INNER JOIN inserted i ON p.id_producto = i.id_producto;
END;
GO