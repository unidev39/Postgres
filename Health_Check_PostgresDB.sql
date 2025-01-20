--PostgreSQL 17 Health Check Steps
--Performing regular health checks on your PostgreSQL database helps ensure optimal performance, 
--availability, and reliability. Below is a structured approach to check the health of a PostgreSQL 17 instance.

--1. Connectivity and Uptime Checks
--a) Check if PostgreSQL is Running
systemctl status postgresql
pg_ctl status -D "C:\path\to\data\directory"

--b) Check Server Uptime
--Run inside PostgreSQL:
SELECT now() - pg_postmaster_start_time() AS uptime;

--c) Verify Connection Status
--Check active connections:
SELECT datname, usename, client_addr, state, backend_start 
FROM pg_stat_activity;

--2. Performance Monitoring
--a) Check Current Database Load (Active Queries)
SELECT pid, usename, datname, state, query_start, query 
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;

--b) Long-Running Queries
--Identify long-running queries that might degrade performance:
SELECT pid, usename, now() - query_start AS duration, query 
FROM pg_stat_activity 
WHERE state != 'idle' 
  AND now() - query_start > interval '5 minutes'
ORDER BY duration DESC;

--c) Check Connection Usage
SELECT 
    max_conn, 
    used_conn, 
    max_conn - used_conn AS remaining_conn
FROM (
    SELECT 
        setting::int AS max_conn, 
        COUNT(*) AS used_conn 
    FROM pg_stat_activity, pg_settings 
    WHERE name = 'max_connections'
) AS conn_data;

--3. Storage and Disk Space Monitoring
--a) Check Disk Space Usage (Database Size)
SELECT datname, pg_size_pretty(pg_database_size(datname)) AS size 
FROM pg_database 
ORDER BY pg_database_size(datname) DESC;

--b) Check Table Sizes
SELECT 
    relname AS table_name, 
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

--c) Check Tablespace Usage
SELECT spcname, pg_size_pretty(pg_tablespace_size(spcname)) AS size 
FROM pg_tablespace;

--4. Index and Vacuum Analysis
--a) Monitor Index Usage
SELECT 
    relname AS table_name, 
    indexrelname AS index_name, 
    idx_scan AS scans, 
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;

--b) Check for Bloated Tables
SELECT 
    schemaname, relname, 
    n_dead_tup, last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 10000  -- threshold
ORDER BY n_dead_tup DESC;

--c) Run Manual Vacuum and Analyze
VACUUM ANALYZE;

--5. Replication and Backup Status
--a) Check Replication Lag (If Replication is Enabled)
SELECT 
    client_addr, 
    state, 
    sent_lsn, 
    write_lsn, 
    flush_lsn, 
    replay_lsn, 
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS replication_lag
FROM pg_stat_replication;

--b) Verify WAL Archiving Status
SHOW archive_mode;
SHOW archive_command;

--c) Check Backup History
ls -lh /path/to/backup_directory/

--6. Locks and Blocking Sessions
--a) Identify Blocking Queries
SELECT blocking_pid, blocked_pid, blocked_query, blocking_query, waiting_duration 
FROM pg_blocking_pids() AS (blocking_pid int, blocked_pid int, blocked_query text, blocking_query text, waiting_duration interval);

--b) Identify Locked Tables
SELECT 
    locktype, relation::regclass AS locked_table, mode, granted 
FROM pg_locks 
WHERE NOT granted;

--7. Configuration Checks
--a) View Key Configuration Parameters
SHOW all;

--Key settings to check:
/*
max_connections
shared_buffers
work_mem
effective_cache_size
autovacuum
*/

--8. Log File Analysis
--a) Check PostgreSQL Logs for Errors
--Location of logs (default paths):
--Linux: /var/log/postgresql/postgresql.log
--Windows: C:\Program Files\PostgreSQL\XX\data\log\
--Example command to check logs on Linux:
tail -n 50 /var/log/postgresql/postgresql.log

--9. Security Audit
--a) Check Database Users and Their Privileges
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin 
FROM pg_roles;

--b) Check for Unauthorized Access
SELECT usename, client_addr, application_name 
FROM pg_stat_activity;

--c) Check SSL Status
SHOW ssl;
SHOW ssl_cert_file;

--10. Automation and Alerts
--Set up automated health checks using tools such as:
--pgAdmin – Built-in monitoring tools
--Nagios/Zabbix/Prometheus – External monitoring tools
--Example cron job to run health checks:
/*
0 3 * * * psql -U postgres -d mydb -c "VACUUM ANALYZE;"
*/