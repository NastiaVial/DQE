CREATE OR ALTER PROCEDURE db_schema_tables_info 
  (  
   @p_DatabaseName NVARCHAR(MAX)
  ,@p_SchemaName   NVARCHAR(MAX)
  ,@p_TableName    NVARCHAR(MAX)
  )

AS
BEGIN
DECLARE @v_Query NVARCHAR(MAX), @v_Query_db NVARCHAR(MAX)

DECLARE @v_TablesList TABLE ([DatabaseName] VARCHAR(100),
							[SchemaName] VARCHAR(100),
							[TableName] VARCHAR(100),
							[ColumnName] VARCHAR(100),
							[DataType] VARCHAR(100) );


SELECT @v_Query_db = 'USE ' + @p_DatabaseName + '
SELECT  a.TABLE_CATALOG as DatabaseName
		,a.TABLE_SCHEMA AS SchemaName
		,a.TABLE_NAME AS TableName
		,a.COLUMN_NAME AS ColumnName
		,a.[DATA_TYPE] AS [DataType]
FROM [sys].[all_objects] b
JOIN INFORMATION_SCHEMA.COLUMNS a
ON b.name=a.TABLE_NAME
WHERE [type_desc] = ''USER_TABLE''
ORDER BY
		DatabaseName
		,SchemaName
		,TableName
		,ColumnName;'
insert into @v_TablesList
			EXEC SP_EXECUTESQL @v_Query_db;

WITH
    tbl_list AS 
    (
        SELECT
            [DatabaseName] ,[SchemaName], [TableName],  [ColumnName], [DataType]
            ,LEAD([ColumnName]) OVER (ORDER BY [ColumnName]) [lead_row]
        FROM @v_TablesList
		where [DatabaseName]=@p_DatabaseName and [SchemaName]=@p_SchemaName and [TableName] like @p_TableName
	  )
   ,query_not_agg AS
    (
        SELECT 
		    CASE
                WHEN [lead_row] IS NOT NULL THEN ' SELECT 
				''' + [DatabaseName] + ''' as [Database Name],
				''' + [SchemaName] + ''' as [Schema Name], 
				''' + [TableName] + ''' as [Table Name],
				COUNT(*) [Total row count], 
				''' + [ColumnName] + ''' as [Column Name],
				''' + [DataType] + ''' as [Data Type],  
				COUNT(distinct ['+[TableName]+'].[' + [ColumnName] + ']) as [Count of DISTINCT values], 
				COUNT(*)-COUNT(['+[TableName]+'].[' + [ColumnName] + ']) as [Count of NULL values],
				CAST(MIN(['+[TableName]+'].[' + [ColumnName] + ']) AS VARCHAR) as [MIN value],
				CAST(MAX(['+[TableName]+'].[' + [ColumnName] + ']) AS VARCHAR) as [MAX value],
				sum(case when (['+[TableName]+'].[' + [ColumnName] + '])=UPPER(['+[TableName]+'].[' + [ColumnName] + '])COLLATE SQL_Latin1_General_CP1_CS_AS then 1 else 0 end) [Only UPPERCASE strings],
                sum(case when (['+[TableName]+'].[' + [ColumnName] + '])=LOWER(['+[TableName]+'].[' + [ColumnName] + '])COLLATE SQL_Latin1_General_CP1_CS_AS then 1 else 0 end) [Only LOWER strings]
				FROM [' + @p_DatabaseName + '].['+[SchemaName]+'].[' + [TableName] + ']  UNION ALL '
				ELSE ' SELECT 
				''' + [DatabaseName] + ''' as [Database_Name],
				''' + [SchemaName] + ''' as [Schema Name], 
				''' + [TableName] + ''' as [Table Name],
				COUNT(*) [Total row count],
				''' + [ColumnName] + ''' as [Column Name],
				''' + [DataType] + ''' as [Data Type], 
				COUNT(distinct ['+[TableName]+'].[' + [ColumnName] + ']) as [Count of DISTINCT values],
				COUNT(*)-COUNT(['+[TableName]+'].[' + [ColumnName] + ']) as [Count of NULL values],
				CAST(MIN(['+[TableName]+'].[' + [ColumnName] + ']) AS VARCHAR) as [MIN value],
				CAST(MAX(['+[TableName]+'].[' + [ColumnName] + ']) AS VARCHAR) as [MAX value],
				sum(case when (['+[TableName]+'].[' + [ColumnName] + '])=UPPER(['+[TableName]+'].[' + [ColumnName] + '])COLLATE SQL_Latin1_General_CP1_CS_AS then 1 else 0 end) [Only UPPERCASE strings],
                sum(case when (['+[TableName]+'].[' + [ColumnName] + '])=LOWER(['+[TableName]+'].[' + [ColumnName] + '])COLLATE SQL_Latin1_General_CP1_CS_AS then 1 else 0 end) [Only LOWER strings]
				FROM [' + @p_DatabaseName + '].['+[SchemaName]+'].[' + [TableName] + ']'
            END [query_text]
        FROM tbl_list
		)

	SELECT @v_Query= STRING_AGG(convert(nvarchar(max),[query_text]), ' ') WITHIN GROUP (ORDER BY [query_text])
	FROM query_not_agg;
 
EXEC SP_EXECUTESQL @v_Query;
END
GO

EXEC db_schema_tables_info  @p_DatabaseName = 'TRN', @p_SchemaName = 'hr', @p_TableName = 'regions';
	select * from trn.hr.regions


EXEC db_schema_tables_info
@p_DatabaseName = 'AdventureWorks2016'
    ,@p_SchemaName = 'Person'
    ,@p_TableName = 'ContactType';