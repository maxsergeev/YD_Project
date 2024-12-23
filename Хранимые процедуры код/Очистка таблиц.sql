USE [Shoe_shop]
GO
/****** Object:  StoredProcedure [dbo].[ClearAllTables]    Script Date: 23.12.2024 16:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Хранимая процедура для полной очистки всех таблиц
ALTER PROCEDURE [dbo].[ClearAllTables]
AS
BEGIN

    -- Очистка таблицы Orders
    DELETE FROM Orders;
	
	-- Очистка таблицы ProductSizes
    DELETE FROM ProductSizes;

    -- Очистка таблицы Users
    DELETE FROM Users;

	-- Очистка таблицы Products
    DELETE FROM Products;
END
