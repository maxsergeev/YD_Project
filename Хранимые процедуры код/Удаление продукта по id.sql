-- Хранимая процедура для удаления продукта по ProductId
CREATE PROCEDURE DeleteProductById
    @ProductId INT
AS
BEGIN
    DELETE FROM Products
    WHERE ID = @ProductId;
END
GO