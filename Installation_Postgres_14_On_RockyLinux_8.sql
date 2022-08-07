--https://www.atlantic.net/tutorials/how-to-install-postgresql-14-in-rocky-linux-8/
--Step 1
[root@rockylinux ~]# dnf update -y
/*
Last metadata expiration check: 0:22:46 ago on Sun 07 Aug 2022 04:25:36 AM EDT.
Dependencies resolved.
Nothing to do.
Complete!
*/

--Step 2
[root@rockylinux ~]# dnf module list postgresql
/*
Last metadata expiration check: 0:23:01 ago on Sun 07 Aug 2022 04:25:36 AM EDT.
Rocky Linux 8 - AppStream
Name                                                 Stream                                          Profiles                                                    Summary
postgresql                                           9.6                                             client, server [d]                                          PostgreSQL server and client module
postgresql                                           10 [d]                                          client, server [d]                                          PostgreSQL server and client module
postgresql                                           12                                              client, server [d]                                          PostgreSQL server and client module
postgresql                                           13                                              client, server [d]                                          PostgreSQL server and client module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
*/

--Step 3
[root@rockylinux ~]# dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
/*
Last metadata expiration check: 0:23:49 ago on Sun 07 Aug 2022 04:25:36 AM EDT.
pgdg-redhat-repo-latest.noarch.rpm                                                                                                                                                                           8.6 kB/s |  13 kB     00:01
Dependencies resolved.
=============================================================================================================================================================================================================================================
 Package                                                        Architecture                                         Version                                                Repository                                                  Size
=============================================================================================================================================================================================================================================
Installing:
 pgdg-redhat-repo                                               noarch                                               42.0-24                                                @commandline                                                13 k

Transaction Summary
=============================================================================================================================================================================================================================================
Install  1 Package

Total size: 13 k
Installed size: 12 k
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                     1/1
  Installing       : pgdg-redhat-repo-42.0-24.noarch                                                                                                                                                                                     1/1
  Verifying        : pgdg-redhat-repo-42.0-24.noarch                                                                                                                                                                                     1/1

Installed:
  pgdg-redhat-repo-42.0-24.noarch

Complete!
*/

--Step 4
[root@rockylinux ~]# dnf -qy module disable postgresql

--Step 5
[root@rockylinux ~]# dnf install postgresql14 postgresql14-server -y
/*
Last metadata expiration check: 0:00:36 ago on Sun 07 Aug 2022 04:51:39 AM EDT.
Dependencies resolved.
=============================================================================================================================================================================================================================================
 Package                                                         Architecture                                       Version                                                         Repository                                          Size
=============================================================================================================================================================================================================================================
Installing:
 postgresql14                                                    x86_64                                             14.4-1PGDG.rhel8                                                pgdg14                                             1.5 M
 postgresql14-server                                             x86_64                                             14.4-1PGDG.rhel8                                                pgdg14                                             5.7 M
Installing dependencies:
 lz4                                                             x86_64                                             1.8.3-3.el8_4                                                   baseos                                             102 k
 postgresql14-libs                                               x86_64                                             14.4-1PGDG.rhel8                                                pgdg14                                             276 k

Transaction Summary
=============================================================================================================================================================================================================================================
Install  4 Packages

Total download size: 7.6 M
Installed size: 32 M
Downloading Packages:
(1/4): lz4-1.8.3-3.el8_4.x86_64.rpm                                                                                                                                                                           76 kB/s | 102 kB     00:01
(2/4): postgresql14-libs-14.4-1PGDG.rhel8.x86_64.rpm                                                                                                                                                         152 kB/s | 276 kB     00:01
(3/4): postgresql14-14.4-1PGDG.rhel8.x86_64.rpm                                                                                                                                                              645 kB/s | 1.5 MB     00:02
(4/4): postgresql14-server-14.4-1PGDG.rhel8.x86_64.rpm                                                                                                                                                       1.1 MB/s | 5.7 MB     00:05
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                        1.0 MB/s | 7.6 MB     00:07
PostgreSQL 14 for RHEL / Rocky 8 - x86_64                                                                                                                                                                    1.6 MB/s | 1.7 kB     00:00
Importing GPG key 0x442DF0F8:
 Userid     : "PostgreSQL RPM Building Project <pgsql-pkg-yum@postgresql.org>"
 Fingerprint: 68C9 E2B9 1A37 D136 FE74 D176 1F16 D2E1 442D F0F8
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                     1/1
  Installing       : postgresql14-libs-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                           1/4
  Running scriptlet: postgresql14-libs-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                           1/4
  Installing       : lz4-1.8.3-3.el8_4.x86_64                                                                                                                                                                                            2/4
  Installing       : postgresql14-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                                3/4
  Running scriptlet: postgresql14-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                                3/4
  Running scriptlet: postgresql14-server-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                         4/4
  Installing       : postgresql14-server-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                         4/4
  Running scriptlet: postgresql14-server-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                         4/4
  Verifying        : lz4-1.8.3-3.el8_4.x86_64                                                                                                                                                                                            1/4
  Verifying        : postgresql14-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                                2/4
  Verifying        : postgresql14-libs-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                           3/4
  Verifying        : postgresql14-server-14.4-1PGDG.rhel8.x86_64                                                                                                                                                                         4/4

Installed:
  lz4-1.8.3-3.el8_4.x86_64                       postgresql14-14.4-1PGDG.rhel8.x86_64                       postgresql14-libs-14.4-1PGDG.rhel8.x86_64                       postgresql14-server-14.4-1PGDG.rhel8.x86_64

Complete!
*/

--Step 6
[root@rockylinux ~]# /usr/pgsql-14/bin/postgresql-14-setup initdb
/*
Initializing database ... OK
*/

--Step 7
[root@rockylinux ~]# systemctl start postgresql-14

--Step 8
[root@rockylinux ~]# systemctl enable postgresql-14
/*
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql-14.service → /usr/lib/systemd/system/postgresql-14.service.
*/

--Step 9
[root@rockylinux ~]# systemctl status postgresql-14
/*
● postgresql-14.service - PostgreSQL 14 database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql-14.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-08-07 04:53:45 EDT; 14s ago
     Docs: https://www.postgresql.org/docs/14/static/
 Main PID: 6745 (postmaster)
    Tasks: 8 (limit: 23476)
   Memory: 16.7M
   CGroup: /system.slice/postgresql-14.service
           ├─6745 /usr/pgsql-14/bin/postmaster -D /var/lib/pgsql/14/data/
           ├─6746 postgres: logger
           ├─6748 postgres: checkpointer
           ├─6749 postgres: background writer
           ├─6750 postgres: walwriter
           ├─6751 postgres: autovacuum launcher
           ├─6752 postgres: stats collector
           └─6753 postgres: logical replication launcher

Aug 07 04:53:45 rockylinux.rockylinux systemd[1]: Starting PostgreSQL 14 database server...
Aug 07 04:53:45 rockylinux.rockylinux postmaster[6745]: 2022-08-07 04:53:45.685 EDT [6745] LOG:  redirecting log output to logging collector process
Aug 07 04:53:45 rockylinux.rockylinux postmaster[6745]: 2022-08-07 04:53:45.685 EDT [6745] HINT:  Future log output will appear in directory "log".
Aug 07 04:53:45 rockylinux.rockylinux systemd[1]: Started PostgreSQL 14 database server.
*/

--Step 10
[root@rockylinux ~]# ss -antpl | grep 5432
/*
LISTEN 0      128        127.0.0.1:5432      0.0.0.0:*    users:(("postmaster",pid=6745,fd=7))
LISTEN 0      128            [::1]:5432         [::]:*    users:(("postmaster",pid=6745,fd=6))
*/

--Step 11
[root@rockylinux ~]# sudo -u postgres psql
/*
could not change directory to "/root": Permission denied
psql (14.4)
Type "help" for help.

postgres=# exit
*/

--Step 12
[root@rockylinux ~]# su - postgres
[postgres@rockylinux ~]$ psql
/*
psql (14.4)
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

dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# INSERT INTO dgschema.test VALUES (1);
INSERT 0 1
dgbroker=# commit;

dgbroker=# select count(*) from  dgschema.test;
 count
-------
     2
(1 row)

dgbroker=# exit
*/