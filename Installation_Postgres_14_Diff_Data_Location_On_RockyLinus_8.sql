[root@localhost ~]# df -Th
/*
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  1.8G     0  1.8G   0% /dev
tmpfs          tmpfs     1.9G     0  1.9G   0% /dev/shm
tmpfs          tmpfs     1.9G  9.0M  1.9G   1% /run
tmpfs          tmpfs     1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/sda2      ext4       35G   74M   33G   1% /
/dev/sda7      ext4      9.8G  2.2G  7.2G  23% /usr
/dev/sda6      ext4      9.8G   37M  9.3G   1% /home
/dev/sda3      ext4       15G   41M   14G   1% /opt
/dev/sda8      ext4      9.8G  362M  9.0G   4% /var
/dev/sda1      ext4      9.8G  217M  9.1G   3% /boot
tmpfs          tmpfs     371M     0  371M   0% /run/user/0
*/

--Step 1
[root@localhost ~]# hostnamectl set-hostname postgres.com

--Step 2
[root@localhost ~]# vi /etc/hosts
/*
192.168.56.136 postgres.com
*/

--Step 3
[root@localhost ~]# hostnamectl
/*
   Static hostname: postgres.com
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 175e4c7e59e144a187c0ccf7815dcd67
           Boot ID: 9a20baf4b79c43f28e4aa06e5e921dfd
    Virtualization: vmware
  Operating System: Rocky Linux 8.6 (Green Obsidian)
       CPE OS Name: cpe:/o:rocky:rocky:8:GA
            Kernel: Linux 4.18.0-372.9.1.el8.x86_64
      Architecture: x86-64
*/

--Step 4
[root@localhost ~]# init 6

--Step 5
[root@postgres ~]# dnf update -y
/*
Last metadata expiration check: 0:22:46 ago on Sun 07 Aug 2022 04:25:36 AM EDT.
Dependencies resolved.
Nothing to do.
Complete!
*/

--Step 6
[root@postgres ~]# rpm -qa | grep openssh-server
/*
openssh-server-8.0p1-13.el8.x86_64
*/

--Step 7
[root@postgres ~]# systemctl enable sshd --now

--Step 8
[root@postgres ~]# systemctl status sshd
/*
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2022-08-21 05:45:07 EDT; 2min 56s ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 842 (sshd)
    Tasks: 1 (limit: 23495)
   Memory: 3.9M
   CGroup: /system.slice/sshd.service
           └─842 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc,aes128-gcm@openssh.com,aes128-ctr,aes128-cbc -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-128>

Aug 21 05:45:07 postgres.com systemd[1]: Starting OpenSSH server daemon...
Aug 21 05:45:07 postgres.com sshd[842]: Server listening on 0.0.0.0 port 22.
Aug 21 05:45:07 postgres.com sshd[842]: Server listening on :: port 22.
Aug 21 05:45:07 postgres.com systemd[1]: Started OpenSSH server daemon.
Aug 21 05:45:48 postgres.com sshd[5392]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.1  user=root
Aug 21 05:45:49 postgres.com sshd[5392]: Failed password for root from 192.168.56.1 port 57314 ssh2
Aug 21 05:45:53 postgres.com sshd[5392]: Accepted password for root from 192.168.56.1 port 57314 ssh2
Aug 21 05:45:53 postgres.com sshd[5392]: pam_unix(sshd:session): session opened for user root by (uid=0)
*/

--Step 9
[root@postgres ~]# adduser postgres

--Step 10
[root@postgres ~]# passwd postgres
/*
Changing password for user postgres.
New password: postgres
BAD PASSWORD: The password contains the user name in some form
Retype new password: postgres
passwd: all authentication tokens updated successfully.
*/

--Step 11
[root@postgres ~]# vi /etc/sudoers

--Step 12
[root@postgres ~]# cat /etc/sudoers | grep wheel
/*
## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL
*/

--Step 13
[root@postgres ~]# usermod -a -G wheel postgres

--Step 14
[root@postgres /]# vi /etc/sudoers
/*
postgres        ALL=(ALL)       ALL
*/

--Step 15
[root@postgres ~]# mkdir -p /opt/postgres/14/data
[root@postgres ~]# cd /opt/
[root@postgres ~]# chown -R postgres:postgres postgres/
[root@postgres ~]# chmod -R 750 postgres/

--Step 16
[root@postgres ~]# dnf install openssh-server
/*
Last metadata expiration check: 0:04:16 ago on Wed 17 Aug 2022 06:22:53 AM EDT.
Package openssh-server-8.0p1-13.el8.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
*/

--Step 17
[root@postgres ~]# dnf module list postgresql
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

--Step 18
[root@postgres ~]# dnf -qy module disable postgresql

--Step 19
[root@postgres ~]# dnf module list postgresql
/*
Last metadata expiration check: 0:00:48 ago on Wed 17 Aug 2022 07:06:15 AM EDT.
Rocky Linux 8 - AppStream
Name                                                Stream                                             Profiles                                                   Summary
postgresql                                          9.6 [x]                                            client, server [d]                                         PostgreSQL server and client module
postgresql                                          10 [d][x]                                          client, server [d]                                         PostgreSQL server and client module
postgresql                                          12 [x]                                             client, server [d]                                         PostgreSQL server and client module
postgresql                                          13 [x]                                             client, server [d]                                         PostgreSQL server and client module

Hint: [d]efault, [e]nabled, [x]disabled, [i]nstalled
*/

--Step 20
[root@postgres ~]# dnf install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
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

--Step 21
[root@postgres ~]# dnf install postgresql14 postgresql14-server -y
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

--Step 22
[root@postgres ~]# /usr/pgsql-14/bin/postgresql-14-setup initdb
/*
Initializing database ... OK
*/

--Step 23
[root@postgres ~]# systemctl start postgresql-14

--Step 24
[root@postgres ~]# systemctl enable postgresql-14
/*
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql-14.service → /usr/lib/systemd/system/postgresql-14.service.
*/

--Step 25
[root@postgres ~]# systemctl status postgresql-14
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

--Step 26
[root@postgres ~]# ss -antpl | grep 5432
/*
LISTEN 0      128        127.0.0.1:5432      0.0.0.0:*    users:(("postmaster",pid=6745,fd=7))
LISTEN 0      128            [::1]:5432         [::]:*    users:(("postmaster",pid=6745,fd=6))
*/

--Step 27
[root@postgres ~]# su - postgres
[postgres@postgres ~]$ psql
/*
psql (14.5)
Type "help" for help.

postgres=# show data_directory;
    data_directory
-------------------------
 /var/lib/pgsql/14/data/
(1 row)
postgres-# \q
*/

--Step 28
[root@postgres ~]# systemctl stop postgresql-14

--Step 29
[root@postgres ~]# su - postgres
[postgres@postgres ~]$ cd /var/lib/pgsql/14/data/
[postgres@postgres data]$ cp -r postgresql.conf backup_postgresql.conf
[postgres@postgres data]$ vi postgresql.conf
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

--Step 30
[postgres@postgres data]$ /usr/pgsql-14/bin/initdb -D /opt/postgres/14/data/
/*
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /opt/postgres/14/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... America/New_York
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

initdb: warning: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    /usr/pgsql-14/bin/pg_ctl -D /opt/postgres/14/data/ -l logfile start

*/

--Step 31
[postgres@postgres data]$ ll /opt/postgres/14/data/
/*
drwx------ 5 postgres postgres  4096 Aug 21 06:02 base
drwx------ 2 postgres postgres  4096 Aug 21 06:02 global
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_commit_ts
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_dynshmem
-rw------- 1 postgres postgres  4789 Aug 21 06:02 pg_hba.conf
-rw------- 1 postgres postgres  1636 Aug 21 06:02 pg_ident.conf
drwx------ 4 postgres postgres  4096 Aug 21 06:02 pg_logical
drwx------ 4 postgres postgres  4096 Aug 21 06:02 pg_multixact
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_notify
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_replslot
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_serial
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_snapshots
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_stat
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_stat_tmp
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_subtrans
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_tblspc
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_twophase
-rw------- 1 postgres postgres     3 Aug 21 06:02 PG_VERSION
drwx------ 3 postgres postgres  4096 Aug 21 06:02 pg_wal
drwx------ 2 postgres postgres  4096 Aug 21 06:02 pg_xact
-rw------- 1 postgres postgres    88 Aug 21 06:02 postgresql.auto.conf
-rw------- 1 postgres postgres 28776 Aug 21 06:02 postgresql.conf
*/

--Step 32
[root@postgres ~]# systemctl start postgresql-14

--Step 33
[root@postgres ~]# systemctl status postgresql-14
/*
● postgresql-14.service - PostgreSQL 14 database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql-14.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-08-21 06:03:35 EDT; 5s ago
     Docs: https://www.postgresql.org/docs/14/static/
  Process: 6749 ExecStartPre=/usr/pgsql-14/bin/postgresql-14-check-db-dir ${PGDATA} (code=exited, status=0/SUCCESS)
 Main PID: 6755 (postmaster)
    Tasks: 8 (limit: 23495)
   Memory: 25.0M
   CGroup: /system.slice/postgresql-14.service
           ├─6755 /usr/pgsql-14/bin/postmaster -D /var/lib/pgsql/14/data/
           ├─6756 postgres: logger
           ├─6758 postgres: checkpointer
           ├─6759 postgres: background writer
           ├─6760 postgres: walwriter
           ├─6761 postgres: autovacuum launcher
           ├─6762 postgres: stats collector
           └─6763 postgres: logical replication launcher

Aug 21 06:03:34 postgres.com systemd[1]: Starting PostgreSQL 14 database server...
Aug 21 06:03:35 postgres.com postmaster[6755]: 2022-08-21 06:03:35.088 EDT [6755] LOG:  redirecting log output to logging collector process
Aug 21 06:03:35 postgres.com postmaster[6755]: 2022-08-21 06:03:35.088 EDT [6755] HINT:  Future log output will appear in directory "log".
Aug 21 06:03:35 postgres.com systemd[1]: Started PostgreSQL 14 database server.
*/

--Step 34
[root@postgres ~]# su - postgres
/*
Last login: Sun Aug 21 05:59:25 EDT 2022 on pts/0
[postgres@postgres ~]$ psql
psql (14.5)
Type "help" for help.

postgres=# show data_directory;
    data_directory
-----------------------
 /opt/postgres/14/data
(1 row)
postgres=#\q
*/

--Step 35
[postgres@postgres ~]$ ll /var/lib/pgsql/14/data/
/*
-rw------- 1 postgres postgres 28776 Aug 21 05:59 backup_postgresql.conf
drwx------ 5 postgres postgres  4096 Aug 21 05:55 base
-rw------- 1 postgres postgres    30 Aug 21 05:57 current_logfiles
drwx------ 2 postgres postgres  4096 Aug 21 05:58 global
drwx------ 2 postgres postgres  4096 Aug 21 05:57 log
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_commit_ts
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_dynshmem
-rw------- 1 postgres postgres  4577 Aug 21 05:55 pg_hba.conf
-rw------- 1 postgres postgres  1636 Aug 21 05:55 pg_ident.conf
drwx------ 4 postgres postgres  4096 Aug 21 05:59 pg_logical
drwx------ 4 postgres postgres  4096 Aug 21 05:55 pg_multixact
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_notify
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_replslot
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_serial
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_snapshots
drwx------ 2 postgres postgres  4096 Aug 21 05:59 pg_stat
drwx------ 2 postgres postgres  4096 Aug 21 05:59 pg_stat_tmp
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_subtrans
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_tblspc
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_twophase
-rw------- 1 postgres postgres     3 Aug 21 05:55 PG_VERSION
drwx------ 3 postgres postgres  4096 Aug 21 05:55 pg_wal
drwx------ 2 postgres postgres  4096 Aug 21 05:55 pg_xact
-rw------- 1 postgres postgres    88 Aug 21 05:55 postgresql.auto.conf
-rw------- 1 postgres postgres 28787 Aug 21 06:01 postgresql.conf
-rw------- 1 postgres postgres    58 Aug 21 05:57 postmaster.opts
*/

--Step 36
[postgres@postgres ~]$ du -sh /var/lib/pgsql/14/
/*
43M     /var/lib/pgsql/14/
*/
[postgres@postgres ~]$ du -sh /opt/postgres/14/
/*
43M     /opt/postgres/14/
*/

--Step 37 (Testing)
[postgres@postgres ~]$ psql
/*
psql (14.4)
Type "help" for help.

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

--Step 38
[postgres@postgres ~]$ du -sh /var/lib/pgsql/14/
/*
43M     /var/lib/pgsql/14/
*/
[postgres@postgres ~]$ du -sh /opt/postgres/14/
/*
52M     /opt/postgres/14/
*/

--pg_dump --dbname=dgbroker --schema=dgschema > /var/lib/pgsql/14/backups/dgschema_$(date +%Y-%m-%d).psql

--psql -h localhost -d dgbroker -U postgres < /var/lib/pgsql/14/backups/dgschema_2022-08-14.psql