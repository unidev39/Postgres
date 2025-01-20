--1. Tables Occupied Spaces
SELECT 
    relname AS table_name, 
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size, 
    pg_size_pretty(pg_relation_size(relid)) AS table_size,
    pg_size_pretty(pg_indexes_size(relid)) AS index_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

--2. Tablespace Sizes
SELECT 
    spcname AS tablespace_name, 
    pg_size_pretty(pg_tablespace_size(spcname)) AS size
FROM pg_tablespace;

--3. Regularly Adding Spaces (Autovacuum and Autorepair Growth)
SELECT 
    schemaname, 
    relname AS table_name, 
    n_live_tup AS live_rows, 
    n_dead_tup AS dead_rows, 
    autovacuum_count, 
    autoanalyze_count, 
    last_autovacuum, 
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY last_autovacuum DESC NULLS LAST;

--4. Long Running Sessions
SELECT 
    pid, 
    usename AS username, 
    datname AS database_name, 
    state, 
    query, 
    now() - pg_stat_activity.query_start AS duration
FROM pg_stat_activity
WHERE state != 'idle' 
  AND now() - pg_stat_activity.query_start > interval '5 minutes'
ORDER BY duration DESC;

--5. Kill Sessions
--5.1 To terminate a session, use the following query by replacing the pid:
SELECT pg_terminate_backend(<PID>);


--5.2 To terminate forcefully (not recommended unless necessary):
SELECT pg_cancel_backend(<PID>);

--You can retrieve session PIDs from the pg_stat_activity query above.


--6. Tables Locked by Sessions
SELECT 
    pg_stat_activity.pid, 
    pg_stat_activity.query, 
    pg_locks.relation::regclass AS locked_table, 
    pg_stat_activity.state, 
    pg_stat_activity.wait_event_type
FROM pg_locks
JOIN pg_stat_activity 
    ON pg_locks.pid = pg_stat_activity.pid
WHERE pg_locks.mode = 'ExclusiveLock';


--7. Query for Index Status
SELECT 
    schemaname, 
    relname AS table_name, 
    indexrelname AS index_name, 
    idx_scan AS index_scans, 
    idx_tup_read AS tuples_read, 
    idx_tup_fetch AS tuples_fetched,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

--7.1 Monitoring Index Performance
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

--7.2 Checking for Index Bloat (Before Rebuilding)
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
WHERE idx_scan = 0;


--8. Query for Gathers Status (Parallel Query Execution Status)
SELECT 
    pid, 
    query, 
    calls, 
    total_time, 
    rows, 
    shared_blks_hit, 
    shared_blks_read, 
    shared_blks_written 
FROM pg_stat_statements
WHERE query ILIKE '%Gather%'
ORDER BY total_time DESC;
