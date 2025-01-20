--Procedure to Rebuild an Existing Index in PostgreSQL 17
--Rebuilding an index in PostgreSQL is useful when an index becomes bloated or inefficient over time. 
--This process helps optimize performance without needing to drop and recreate the index manually.

--1. Methods to Rebuild an Index
--a) Using REINDEX Command (Recommended)
--The REINDEX command rebuilds an index in place, improving performance and reducing bloat.
--Syntax to Rebuild a Specific Index
REINDEX INDEX index_name;

--Syntax to Rebuild All Indexes on a Table
REINDEX TABLE table_name;

--Syntax to Rebuild All Indexes in the Database
REINDEX DATABASE database_name;

--Syntax to Rebuild All Indexes in the System Catalogs
REINDEX SYSTEM database_name;

--b) Concurrent Index Rebuild (Minimizes Locking)
--For large tables where downtime should be minimized, use REINDEX CONCURRENTLY, which allows the index to be rebuilt without locking the table.
--Syntax to Rebuild an Index Concurrently
REINDEX INDEX CONCURRENTLY index_name;
--Note: Concurrent rebuilding requires additional space and takes longer.

--c) Dropping and Recreating Index Manually
--If the index is severely corrupted or inefficient, manually dropping and recreating the index may be an option.

--Drop the index:
DROP INDEX IF EXISTS index_name;

--Recreate the index:
CREATE INDEX index_name ON table_name (column_name);

--Verify the index:
SELECT * FROM pg_indexes WHERE tablename = 'table_name';

--2. Monitoring Index Performance
--Before and after rebuilding, check index usage statistics:
SELECT 
    relname AS table_name, 
    indexrelname AS index_name, 
    idx_scan AS scans, 
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    idx_tup_read, 
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE relname = 'your_table_name';

--3. Checking for Index Bloat (Before Rebuilding)
--Identify bloated indexes that may benefit from a rebuild:
SELECT 
    schemaname, 
    relname AS table_name, 
    indexrelname AS index_name, 
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
    idx_scan AS scans, 
    idx_tup_read, 
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0 
ORDER BY pg_relation_size(indexrelid) DESC;

--4. Automating Index Rebuild Process
--To automate index rebuilding at regular intervals, schedule it using pg_cron (PostgreSQL's cron job extension).
--Example cron job to rebuild indexes at midnight every Sunday:
SELECT cron.schedule('0 0 * * 0', 'REINDEX DATABASE my_database');

--5. Considerations When Rebuilding Indexes
--Locking: Regular REINDEX locks the table, so consider using CONCURRENTLY if downtime is critical.
--Disk Space: Rebuilding requires additional disk space, especially for concurrent rebuilds.
--Performance Impact: Run the rebuild process during off-peak hours to avoid performance degradation.
--Replication: If using replication, concurrent index rebuilds should be monitored to avoid replication lag.

--6. Verify Index Health After Rebuild
--Once the rebuild is done, run an EXPLAIN ANALYZE query to check if the index is being used efficiently:
EXPLAIN ANALYZE SELECT * FROM table_name WHERE column_name = 'value';