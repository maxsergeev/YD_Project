-- �������� ��������� ��� �������� �������� �� ProductId
CREATE PROCEDURE DeleteProductById
    @ProductId INT
AS
BEGIN
    DELETE FROM Products
    WHERE ID = @ProductId;
END
GO