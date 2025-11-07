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