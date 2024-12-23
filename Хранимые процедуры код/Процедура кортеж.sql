CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @Name NVARCHAR(100),
    @Link NVARCHAR(255),
    @Type INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Обновление записи в таблице Products
    UPDATE Products
    SET 
        Name = @Name,
        Link = @Link,
        Type = @Type
    WHERE 
        ID = @ProductID;

    -- Проверка, была ли обновлена запись
    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Product with ID %d not found.', 16, 1, @ProductID);
    END
END