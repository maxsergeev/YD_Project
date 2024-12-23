CREATE TRIGGER trg_UpdateOrderPrice
ON Orders
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Обновление цены при добавлении или изменении заказов
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        UPDATE Orders
        SET Price = (SELECT CNYPrice * Quantity 
                     FROM ProductSizes 
                     WHERE ProductSizeID = ProductSizes.ID)
        WHERE ID IN (SELECT DISTINCT ID FROM inserted);
    END

    -- Обновление цены при удалении заказов
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        UPDATE Orders
        SET Price = (SELECT CNYPrice * Quantity 
                     FROM ProductSizes 
                     WHERE ProductSizeID = ProductSizes.ID)
        WHERE ID IN (SELECT DISTINCT ID FROM deleted);
    END
END;