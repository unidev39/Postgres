--1. Check if an Index is Needed
--Before creating an index, analyze your queries to determine if they will benefit from indexing. Use:
EXPLAIN ANALYZE SELECT * FROM table_name WHERE column_name = 'value';
If the query performs a sequential scan, an index might help.

--2. Identify Columns for Indexing
/*
Index columns frequently used in WHERE, JOIN, ORDER BY, and GROUP BY clauses.
Avoid indexing columns with low cardinality (few unique values).
Consider indexing columns used in foreign keys and unique constraints.
*/

--3. Syntax for Creating Indexes
--a) Basic B-Tree Index (Default)
CREATE INDEX idx_table_column
ON table_name (column_name);

--b) Unique Index
CREATE UNIQUE INDEX idx_table_column_unique
ON table_name (column_name);

--c) Composite (Multi-Column) Index
CREATE INDEX idx_table_columns
ON table_name (column1, column2);

--d) Partial Index (Conditional Index)
CREATE INDEX idx_partial
ON table_name (column_name)
WHERE column_name IS NOT NULL;

--e) Expression Index
CREATE INDEX idx_expression
ON table_name (LOWER(column_name));

--f) GIN Index (for JSON, Arrays, Full-Text Search)
CREATE INDEX idx_gin
ON table_name USING gin(column_name);

--g) GiST Index (for geometric or full-text search)
CREATE INDEX idx_gist
ON table_name USING gist(column_name);

--h) BRIN Index (for large tables with sequential data)
CREATE INDEX idx_brin
ON table_name USING brin(column_name);

--4. Check Existing Indexes
--Before creating an index, verify if an index already exists:
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'table_name';

--5. Monitoring Index Usage
--To monitor index performance:
SELECT 
    relname AS table_name, 
    indexrelname AS index_name, 
    idx_scan, 
    idx_tup_read, 
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE relname = 'table_name';


--6. Dropping an Index
--If an index is no longer needed, drop it using:
DROP INDEX IF EXISTS idx_table_column;

7. Reindexing to Improve Performance
--Over time, indexes may become bloated. Use:
REINDEX TABLE table_name;
--Or for the entire database:
REINDEX DATABASE database_name;

--8. Creating Indexes Concurrently (Minimize Downtime)
--To avoid locking the table during index creation:
CREATE INDEX CONCURRENTLY idx_table_column
ON table_name (column_name);
Note: Use CONCURRENTLY carefully, as it takes longer and requires an exclusive lock during the final phase.

--9. Analyzing Index Effectiveness
--Once the index is created, check its effectiveness using:
EXPLAIN ANALYZE SELECT * FROM table_name WHERE column_name = 'value';