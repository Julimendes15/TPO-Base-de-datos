USE CC_CARPINTERlA_DEL_SUR;

GO

CREATE TRIGGER trg_actualizar_totales_pedido
ON DetallePedido
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @id_pedido INT;

    -- Determinar que pedido fue afectado
    SELECT TOP 1 @id_pedido = id_pedido FROM inserted
    UNION
    SELECT TOP 1 id_pedido FROM deleted;

    -- Recalcular los totales
    UPDATE Pedido
    SET total_bruto = (
            SELECT SUM(subtotal)
            FROM DetallePedido
            WHERE id_pedido = @id_pedido
        ),
        total_neto = (
            SELECT SUM(subtotal - descuento)
            FROM DetallePedido
            WHERE id_pedido = @id_pedido
        ),
        descuento_total = (
            SELECT SUM(descuento)
            FROM DetallePedido
            WHERE id_pedido = @id_pedido
        )
    WHERE id_pedido = @id_pedido;
END;
GO