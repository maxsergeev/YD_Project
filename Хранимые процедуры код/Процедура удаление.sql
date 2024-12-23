ALTER PROCEDURE DeleteDatabase
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @DatabaseName NVARCHAR(128) = 'Shoe_shop';
    DECLARE @SQL NVARCHAR(MAX);

    -- ���������, ���������� �� ���� ������
    IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
    BEGIN
        -- ��������� SQL-������ ��� �������� ���� ������
        SET @SQL = 'DROP TABLE Orders';
        
        -- ��������� ������������ SQL
        EXEC sp_executesql @SQL;



        PRINT 'Orders deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Orders do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductSizes')
    BEGIN
        -- ��������� SQL-������ ��� �������� ���� ������
        SET @SQL = 'DROP TABLE ProductSizes';
        
        -- ��������� ������������ SQL
        EXEC sp_executesql @SQL;



        PRINT 'ProductSizes deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'ProductSizes do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
    BEGIN
        -- ��������� SQL-������ ��� �������� ���� ������
        SET @SQL = 'DROP TABLE Users';
        
        -- ��������� ������������ SQL
        EXEC sp_executesql @SQL;



        PRINT 'Users deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Users do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products')
    BEGIN
        -- ��������� SQL-������ ��� �������� ���� ������
        SET @SQL = 'DROP TABLE Products';
        
        -- ��������� ������������ SQL
        EXEC sp_executesql @SQL;



        PRINT 'Products deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Products do not exist: ';
    END
END;