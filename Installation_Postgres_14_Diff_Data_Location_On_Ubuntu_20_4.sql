--Step 1
root@localhost:~# hostnamectl set-hostname postgres.com

--Step 2
root@localhost:~# vi /etc/hosts
/*
192.168.56.136 postgres.com
*/

--Step 3
root@localhost:~# hostnamectl
/*
  Static hostname: postgres.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: a434c1d766244447a5168b41881c7123
           Boot ID: cb162863cea64272918646318b335861
    Virtualization: vmware
  Operating System: Ubuntu 20.04.4 LTS
            Kernel: Linux 5.15.0-41-generic
      Architecture: x86-64
*/

--Step 4
root@localhost:~# init 6

--Step 5
root@postgres:~# vi /etc/sudoers
/*
# Allow members of group sudo to execute any command
%sudo  ALL=(ALL:ALL) ALL
*/

--Step 6
root@postgres:~# usermod -a -G sudo postgres

--Step 7
[root@postgres /# vi /etc/sudoers
/*
postgres	ALL=(ALL:ALL) ALL
*/

--Step 8
root@postgres:~# apt update
/*
Hit:1 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu focal InRelease
Hit:3 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
Building dependency tree       
Reading state information... Done
45 packages can be upgraded. Run 'apt list --upgradable' to see them.
*/

--Step 10
root@postgres:~# apt -y upgrade

--Step 11
root@postgres:~# sudo apt update && sudo apt -y full-upgrade

--Step 12
root@postgres:~# sudo apt install vim curl wget gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates

--Step 13
root@postgres:~# apt policy postgresql
/*
postgresql:
  Installed: (none)
  Candidate: 12+214ubuntu0.1
  Version table:
     12+214ubuntu0.1 500
        500 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages
        500 http://us.archive.ubuntu.com/ubuntu focal-updates/main i386 Packages
        500 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages
        500 http://security.ubuntu.com/ubuntu focal-security/main i386 Packages
     12+214 500
        500 http://us.archive.ubuntu.com/ubuntu focal/main amd64 Packages
        500 http://us.archive.ubuntu.com/ubuntu focal/main i386 Packages
*/

--Step 14
root@postgres:~# curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

--Step 15
root@postgres:~# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

--Step 16
root@postgres:~# sudo apt  update

--Step 17
root@postgres:~# sudo apt install postgresql-14

--Step 18
root@postgres:~# systemctl enable postgresql@14-main.service
/*
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql@14-main.service → /lib/systemd/system/postgresql@.service.
*/

--Step 19
root@postgres:~# systemctl status postgresql@14-main.services
/*
● postgresql@14-main.services.service - PostgreSQL Cluster 14-main.services
     Loaded: loaded (/lib/systemd/system/postgresql@.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
root@postgres:~# systemctl status postgresql@14-main.service
● postgresql@14-main.service - PostgreSQL Cluster 14-main
     Loaded: loaded (/lib/systemd/system/postgresql@.service; enabled-runtime; vendor preset: enabled)
     Active: active (running) since Sun 2022-08-21 03:45:26 PDT; 1min 7s ago
   Main PID: 5265 (postgres)
      Tasks: 7 (limit: 4577)
     Memory: 17.4M
     CGroup: /system.slice/system-postgresql.slice/postgresql@14-main.service
             ├─5265 /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
             ├─5267 postgres: 14/main: checkpointer
             ├─5268 postgres: 14/main: background writer
             ├─5269 postgres: 14/main: walwriter
             ├─5270 postgres: 14/main: autovacuum launcher
             ├─5271 postgres: 14/main: stats collector
             └─5272 postgres: 14/main: logical replication launcher

Aug 21 03:45:23 postgres.com systemd[1]: Starting PostgreSQL Cluster 14-main...
Aug 21 03:45:26 postgres.com systemd[1]: Started PostgreSQL Cluster 14-main.
*/

--Step 20
root@postgres:~# ll /var/lib/postgresql/14/main/
/*
drwx------ 19 postgres postgres 4096 Aug 21 03:45 ./
drwxr-xr-x  3 postgres postgres 4096 Aug 21 03:45 ../
drwx------  5 postgres postgres 4096 Aug 21 03:45 base/
drwx------  2 postgres postgres 4096 Aug 21 03:45 global/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_commit_ts/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_dynshmem/
drwx------  4 postgres postgres 4096 Aug 21 03:50 pg_logical/
drwx------  4 postgres postgres 4096 Aug 21 03:45 pg_multixact/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_notify/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_replslot/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_serial/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_snapshots/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_stat/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_stat_tmp/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_subtrans/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_tblspc/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_twophase/
-rw-------  1 postgres postgres    3 Aug 21 03:45 PG_VERSION
drwx------  3 postgres postgres 4096 Aug 21 03:45 pg_wal/
drwx------  2 postgres postgres 4096 Aug 21 03:45 pg_xact/
-rw-------  1 postgres postgres   88 Aug 21 03:45 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Aug 21 03:45 postmaster.opts
-rw-------  1 postgres postgres  108 Aug 21 03:45 postmaster.pid
*/

--Step 21
root@postgres:~# mkdir -p /opt/postgres/14/data
root@postgres:~# cd /opt/
root@postgres:~# chown -R postgres:postgres postgres/
root@postgres:~# chmod -R 750 postgres/

--Step 22
root@postgres:~# su - postgres

postgres@postgres:~$ psql
/*
psql (14.5 (Ubuntu 14.5-1.pgdg20.04+1))
Type "help" for help.

postgres=# show data_directory;
       data_directory        
-----------------------------
 /var/lib/postgresql/14/main
(1 row)

postgres=# \q
*/

--Step 23
root@postgres:~# systemctl status postgresql@14-main.service
/*
● postgresql@14-main.service - PostgreSQL Cluster 14-main
     Loaded: loaded (/lib/systemd/system/postgresql@.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-08-21 03:45:26 PDT; 19min ago
   Main PID: 5265 (postgres)
      Tasks: 7 (limit: 4577)
     Memory: 18.9M
     CGroup: /system.slice/system-postgresql.slice/postgresql@14-main.service
             ├─5265 /usr/lib/postgresql/14/bin/postgres -D /var/lib/postgresql/14/main -c config_file=/etc/postgresql/14/main/postgresql.conf
             ├─5267 postgres: 14/main: checkpointer
             ├─5268 postgres: 14/main: background writer
             ├─5269 postgres: 14/main: walwriter
             ├─5270 postgres: 14/main: autovacuum launcher
             ├─5271 postgres: 14/main: stats collector
             └─5272 postgres: 14/main: logical replication launcher

Aug 21 03:45:23 postgres.com systemd[1]: Starting PostgreSQL Cluster 14-main...
Aug 21 03:45:26 postgres.com systemd[1]: Started PostgreSQL Cluster 14-main.
*/

--Step 24
root@postgres:~# systemctl stop postgresql@14-main.service

--Step 25
root@postgres:~# su - postgres
postgres@postgres:~$ cd /etc/postgresql/14/main/
postgres@postgres:/etc/postgresql/14/main
postgres@postgres:/etc/postgresql/14/main cp -r postgresql.conf backup_postgresql.conf

--Step 26
postgres@postgres:/etc/postgresql/14/main vi postgresql.conf
/*
data_directory = '/opt/postgres/14/data/'
max_connections = 150
shared_buffers = 256MB
*/
[postgres@postgres data]$ cat postgresql.conf | grep data_directory
/*
data_directory = '/opt/postgres/14/data/' # use data in another directory
*/
[postgres@postgres data]$ cat postgresql.conf | grep max_connections
/*
max_connections = 150                   # (change requires restart)
*/
[postgres@postgres data]$ cat postgresql.conf | grep shared_buffers
/*
shared_buffers = 256MB                  # min 128kB
*/

--Step 27
postgres@postgres:~$ cd /var/lib/postgresql/14/main/
postgres@postgres:~/14/main$ cp -r * /opt/postgres/14/data/
postgres@postgres:~/14/main$ ls -ltr /opt/postgres/14/data/
/*
drwx------ 5 postgres postgres 4096 Aug 21 04:12 base
drwx------ 4 postgres postgres 4096 Aug 21 04:12 pg_multixact
drwx------ 4 postgres postgres 4096 Aug 21 04:12 pg_logical
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_dynshmem
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_commit_ts
drwx------ 2 postgres postgres 4096 Aug 21 04:12 global
-rw------- 1 postgres postgres    3 Aug 21 04:12 PG_VERSION
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_twophase
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_tblspc
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_subtrans
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_stat_tmp
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_stat
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_snapshots
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_serial
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_replslot
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_notify
-rw------- 1 postgres postgres  130 Aug 21 04:12 postmaster.opts
-rw------- 1 postgres postgres   88 Aug 21 04:12 postgresql.auto.conf
drwx------ 2 postgres postgres 4096 Aug 21 04:12 pg_xact
drwx------ 3 postgres postgres 4096 Aug 21 04:12 pg_wal
*/

--Step 28
root@postgres:~# du -sh /var/lib/postgresql/14/main/
/*
42M	/var/lib/postgresql/14/main/
*/

root@postgres:~# du -sh /opt/postgres/14/data/
/*
42M	/opt/postgres/14/data/
*/

--Step 29
root@postgres:~# systemctl start postgresql@14-main.service
root@postgres:~# systemctl status postgresql@14-main.service
/*
● postgresql@14-main.service - PostgreSQL Cluster 14-main
     Loaded: loaded (/lib/systemd/system/postgresql@.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-08-21 04:14:35 PDT; 2s ago
    Process: 8298 ExecStart=/usr/bin/pg_ctlcluster --skip-systemctl-redirect 14-main start (code=exited, status=0/SUCCESS)
   Main PID: 8303 (postgres)
      Tasks: 7 (limit: 4577)
     Memory: 25.5M
     CGroup: /system.slice/system-postgresql.slice/postgresql@14-main.service
             ├─8303 /usr/lib/postgresql/14/bin/postgres -D /opt/postgres/14/data -c config_file=/etc/postgresql/14/main/postgresql.conf
             ├─8305 postgres: 14/main: checkpointer
             ├─8306 postgres: 14/main: background writer
             ├─8307 postgres: 14/main: walwriter
             ├─8308 postgres: 14/main: autovacuum launcher
             ├─8309 postgres: 14/main: stats collector
             └─8310 postgres: 14/main: logical replication launcher

Aug 21 04:14:33 postgres.com systemd[1]: Starting PostgreSQL Cluster 14-main...
Aug 21 04:14:35 postgres.com systemd[1]: Started PostgreSQL Cluster 14-main.
*/

--Step 30
root@postgres:~# su - postgres

--Step 31
postgres@postgres:~$ psql
/*
psql (14.5 (Ubuntu 14.5-1.pgdg20.04+1))
Type "help" for help.

postgres=# show data_directory;
    data_directory     
-----------------------
 /opt/postgres/14/data
(1 row)

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=# CREATE DATABASE dgbroker;
CREATE DATABASE
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 dgbroker  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=# \connect dgbroker
You are now connected to database "dgbroker" as user "postgres".

dgbroker=# CREATE SCHEMA dgschema;
CREATE SCHEMA

dgbroker=# CREATE TABLE dgschema.test(sn int);
CREATE TABLE

dgbroker=#
dgbroker=# CREATE TABLE dgschema.test(sn int);
CREATE TABLE
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# commit;

dgbroker=# select count(*) from  dgschema.test;
 count
-------
     22
(1 row)

dgbroker=# exit
*/

--Step 32
postgres@postgres:~$ du -sh /var/lib/postgresql/14/main/
/*
42M /var/lib/postgresql/14/main/
*/
postgres@postgres:~$ du -sh /opt/postgres/14/data/
/*
51M /opt/postgres/14/data/
*/

--Step 33
postgres@postgres:~$ psql
/*
psql (14.5 (Ubuntu 14.5-1.pgdg20.04+1))
Type "help" for help.

postgres=# ALTER USER postgres WITH PASSWORD 'postgres'

postgres=# \q
*/

--Step 34
root@postgres:~# systemctl stop postgresql@14-main.service

--Step 35
-- Change from peer to scram-sha-256
root@postgres:~# vi /etc/postgresql/14/main/pg_hba.conf
/*
 Database administrative login by Unix domain socket
local   all             postgres                    scram-sha-256

# "local" is for Unix domain socket connections only
local   all             all                         scram-sha-256
*/

--Step 36
root@postgres:~# systemctl start postgresql@14-main.service
root@postgres:~# systemctl status postgresql@14-main.service

--Step 37
postgres@postgres:~$ psql
/*
Password for user postgres: postgres
psql (14.5 (Ubuntu 14.5-1.pgdg20.04+1))
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 dgbroker  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(4 rows)

postgres=# \q
*/
