USE CC_CARPINTERIA_DEL_SUR;

GO

-- TRIGGERS
-- TRIGGER: Actualizar pedidos totales
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

-- TRIGGER: Validar email
CREATE TRIGGER trg_validar_email_cliente
ON Cliente
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE email NOT LIKE '%@gmail.com%'
          AND email NOT LIKE '%@outlook.com%'
          AND email NOT LIKE '%@yahoo.com%'
    )
    BEGIN
        RAISERROR('El email debe ser de dominio permitido (gmail, outlook o yahoo).', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Si todo esta bien, insertar normalmente
    INSERT INTO Cliente (tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email)
    SELECT tipo, nombre, apellido, razon_social, doc_tipo, doc_numero, telefono, email
    FROM inserted;
END;
GO

-- TRIGGER: Actualizar Stock
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