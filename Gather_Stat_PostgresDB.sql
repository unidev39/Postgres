--1. Understanding Statistics Collection in PostgreSQL
/*
PostgreSQL collects two types of statistics:
Vacuum Statistics: Collected by VACUUM for table cleanup and dead tuple removal.
Analyze Statistics: Collected by ANALYZE for query planning purposes (distribution of data).
*/

--2. Steps to Gather Statistics Manually
--Step 1: Analyze the Entire Database
--To collect statistics for all tables in the database:
ANALYZE;

--Step 2: Analyze a Specific Table
--To collect statistics for a single table:
ANALYZE table_name;

--Step 3: Analyze Specific Columns
--To reduce processing time, analyze only specific columns that are frequently used in queries:
ANALYZE table_name(column1, column2);

--3. Running VACUUM ANALYZE for Cleanup and Stats Update
--To remove dead tuples and update statistics together:
VACUUM ANALYZE;

--Or for a specific table:
VACUUM ANALYZE table_name;

--4. Checking Statistics Status
--To check the statistics collected using system catalogs:

--View Table-Level Statistics:
SELECT relname, last_analyze, last_autoanalyze
FROM pg_stat_user_tables
WHERE schemaname = 'public';

--View Column-Level Statistics:
SELECT attname, n_distinct, most_common_vals
FROM pg_stats
WHERE tablename = 'table_name';

--5. Automatic Statistics Collection (Autovacuum Daemon)
--PostgreSQL has an automatic process called Autovacuum, which runs ANALYZE and VACUUM periodically.
--Check if autovacuum is enabled:
SHOW autovacuum;

--Enable autovacuum in postgresql.conf (if disabled):
/*
autovacuum = on
*/

--Check recent autovacuum operations:

SELECT relname, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze
FROM pg_stat_user_tables;

--6. Adjusting Statistics Target for Better Planning
--You can fine-tune statistics collection per column by adjusting the statistics target value (default is 100):
ALTER TABLE table_name ALTER COLUMN column_name SET STATISTICS 200;

--After changing the target, re-run ANALYZE to update statistics.

--7. Monitoring Gather Progress
--Check the ongoing statistics collection or analyze operations:
SELECT pid, query, state, wait_event
FROM pg_stat_activity
WHERE query ILIKE '%ANALYZE%';

--8. Scheduling Regular Statistics Collection
--You can automate stats collection using PostgreSQL's pg_cron extension or system cron jobs to periodically run:

--Example cron job (Linux):
/*
0 2 * * * psql -U postgres -d mydb -c "ANALYZE VERBOSE;"
*/

--9. Verifying Query Plan Improvements
--After gathering statistics, check the improvement in query execution plans:
EXPLAIN ANALYZE SELECT * FROM table_name WHERE column_name = 'value';