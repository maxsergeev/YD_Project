CREATE PROCEDURE ShowTables
AS
BEGIN
    SET NOCOUNT ON;

    -- Создаем временную таблицу для хранения результатов
    CREATE TABLE #Results (
        TableName NVARCHAR(128),
        RowData NVARCHAR(MAX)
    );

    -- Объявляем переменные для хранения данных
    DECLARE @TableName NVARCHAR(128);
    DECLARE @SQL NVARCHAR(MAX);

    -- Список таблиц для обработки
    DECLARE TableCursor CURSOR FOR
    SELECT name FROM sys.tables WHERE name IN ('Products', 'ProductSizes', 'Users', 'Orders');

    OPEN TableCursor;
    FETCH NEXT FROM TableCursor INTO @TableName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Формируем SQL-запрос для получения данных из текущей таблицы
        IF @TableName = 'Products'
            SET @SQL = 'INSERT INTO #Results (TableName, RowData) SELECT ''Products'', STRING_AGG(CONVERT(NVARCHAR(MAX), ID) + '','' + CONVERT(NVARCHAR(MAX), Link) + '','' + CONVERT(NVARCHAR(MAX), Name)+ '','' + CONVERT(NVARCHAR(MAX), Type), '','') FROM Products';
        ELSE IF @TableName = 'ProductSizes'
            SET @SQL = 'INSERT INTO #Results (TableName, RowData) SELECT ''ProductSizes'', STRING_AGG(CONVERT(NVARCHAR(MAX), ID) + '','' + CONVERT(NVARCHAR(MAX), CNYPrice) + '','' + CONVERT(NVARCHAR(MAX), Size)+ '','' + CONVERT(NVARCHAR(MAX), ProductId), '','') FROM ProductSizes';
        ELSE IF @TableName = 'Users'
            SET @SQL = 'INSERT INTO #Results (TableName, RowData) SELECT ''Users'', STRING_AGG(CONVERT(NVARCHAR(MAX), ID) + '','' + CONVERT(NVARCHAR(MAX), UserName), '','') FROM Users';
        ELSE IF @TableName = 'Orders'
            SET @SQL = 'INSERT INTO #Results (TableName, RowData) SELECT ''Orders'', STRING_AGG(CONVERT(NVARCHAR(MAX), ID) + '','' + CONVERT(NVARCHAR(MAX), Quantity) + '','' + CONVERT(NVARCHAR(MAX), Price)+ '','' + CONVERT(NVARCHAR(MAX), ProductSizeID)+ '','' + CONVERT(NVARCHAR(MAX), UserId), '','') FROM Orders';

        -- Выполняем динамический SQL
        EXEC sp_executesql @SQL;

        FETCH NEXT FROM TableCursor INTO @TableName;
    END

    CLOSE TableCursor;
    DEALLOCATE TableCursor;

    -- Возвращаем результаты
    SELECT * FROM #Results;

    -- Удаляем временную таблицу
    DROP TABLE #Results;
END;