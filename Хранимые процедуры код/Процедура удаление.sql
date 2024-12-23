ALTER PROCEDURE DeleteDatabase
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @DatabaseName NVARCHAR(128) = 'Shoe_shop';
    DECLARE @SQL NVARCHAR(MAX);

    -- Проверяем, существует ли база данных
    IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
    BEGIN
        -- Формируем SQL-запрос для удаления базы данных
        SET @SQL = 'DROP TABLE Orders';
        
        -- Выполняем динамический SQL
        EXEC sp_executesql @SQL;



        PRINT 'Orders deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Orders do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductSizes')
    BEGIN
        -- Формируем SQL-запрос для удаления базы данных
        SET @SQL = 'DROP TABLE ProductSizes';
        
        -- Выполняем динамический SQL
        EXEC sp_executesql @SQL;



        PRINT 'ProductSizes deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'ProductSizes do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
    BEGIN
        -- Формируем SQL-запрос для удаления базы данных
        SET @SQL = 'DROP TABLE Users';
        
        -- Выполняем динамический SQL
        EXEC sp_executesql @SQL;



        PRINT 'Users deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Users do not exist: ';
    END

	IF EXISTS (SELECT * FROM Shoe_shop.INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Products')
    BEGIN
        -- Формируем SQL-запрос для удаления базы данных
        SET @SQL = 'DROP TABLE Products';
        
        -- Выполняем динамический SQL
        EXEC sp_executesql @SQL;



        PRINT 'Products deleted: ';
    END
    ELSE
    BEGIN
        PRINT 'Products do not exist: ';
    END
END;