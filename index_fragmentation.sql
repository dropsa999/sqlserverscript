-- 15-30% reorg
-- >> 30% rebuild

SELECT DB_NAME(SDDIPS.[database_id]) AS [database_name],  
        OBJECT_NAME(SDDIPS.[object_id], DB_ID()) AS [object_name],  
        SSI.[name] AS [index_name], SDDIPS.partition_number,  
        SDDIPS.index_type_desc, SDDIPS.alloc_unit_type_desc,  
        SDDIPS.[avg_fragmentation_in_percent], SDDIPS.[page_count]  
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'detailed') SDDIPS 
        INNER JOIN sys.sysindexes SSI  
                ON SDDIPS.OBJECT_ID = SSI.id  
                        AND SDDIPS.index_id = SSI.indid  
WHERE SDDIPS.page_count > 30  
        AND avg_fragmentation_in_percent > 15  
        AND index_type_desc <> 'HEAP'  
ORDER BY OBJECT_NAME(SDDIPS.[object_id], DB_ID()), index_id

select db_name()
-- Find the average fragmentation percentage of all indexes
-- in the HumanResources.Employee table. 
SELECT a.index_id, name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'Cimentos_NPS_Votorantim_140265040101'), OBJECT_ID(N'tblcliente'), NULL, NULL, NULL) AS a
    JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id; 
GO


-- Individual
SELECT OBJECT_NAME(OBJECT_ID) as tableName, *
FROM sys.dm_db_index_physical_stats(DB_ID('celtrak_data'), Object_Id('tk_mu_data'), 1, NULL ,NULL)

--FASTER:

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
ON ind.object_id = indexstats.object_id 
AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 30 
ORDER BY indexstats.avg_fragmentation_in_percent DESC

--[dbo].[sp_BlitzIndex]