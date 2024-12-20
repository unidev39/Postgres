------------------------------------------------------------------------------------------------
--------------------------Postgres Standalone DB Server Configuration---------------------------
------------------------------------------------------------------------------------------------
-- Step 1 -->> On Node 1 
root@ckyc-dc-n1:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  2.0G  1.3M  2.0G   1% /run
/dev/mapper/ckyc--vg0-ckyc--lvm--root                                                        xfs     80G  1.6G   79G   2% /
/dev/disk/by-id/dm-uuid-LVM-FersIwgBzvuAYO4FkGDbmjOT2jPb54qfD4p9qr3HoUkWmJqh57jAg9mhEvrgds7w xfs     10G  2.2G  7.8G  22% /usr
tmpfs                                                                                        tmpfs  9.8G     0  9.8G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/ckyc--vg0-ckyc--lvm--backup                                                      xfs     38G  777M   38G   2% /backup
/dev/mapper/ckyc--vg0-ckyc--lvm--home                                                        xfs     10G  228M  9.8G   3% /home
/dev/mapper/ckyc--vg0-ckyc--lvm--srv                                                         xfs     10G  228M  9.8G   3% /srv
/dev/mapper/ckyc--vg0-ckyc--lvm--data                                                        xfs    100G  2.0G   98G   2% /data
/dev/mapper/ckyc--vg0-ckyc--lvm--tmp                                                         xfs     10G  228M  9.8G   3% /tmp
/dev/mapper/ckyc--vg0-ckyc--lvm--var                                                         xfs     10G  393M  9.6G   4% /var
/dev/mapper/ckyc--vg0-ckyc--lvm--var--lib                                                    xfs     10G  424M  9.6G   5% /var/lib
/dev/sda2                                                                                    xfs    960M  146M  815M  16% /boot
tmpfs                                                                                        tmpfs  2.0G   12K  2.0G   1% /run/user/1000
*/


-- Step 2 -->> On Node 1 (Server Kernal version)
root@ckyc-dc-n1:~# uname -msr
/*
Linux 6.8.0-50-generic x86_64
*/

-- Step 3 -->> On Node 1 (Server Release)
root@ckyc-dc-n1:~# cat /etc/lsb-release
/*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.1 LTS"
*/

-- Step 4 -->> On Node 1 (Server Release)
root@ckyc-dc-n1:~# cat /etc/os-release
/*
PRETTY_NAME="Ubuntu 24.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.1 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
*/

-- Step 5 -->> On Node 1
root@ckyc-dc-n1:~# vi /etc/hosts
/*
127.0.0.1 localhost
127.0.1.1  ckyc-dc-n1

# Public
192.168.6.48 postgres.unidev.org.np postgres
*/

-- Step 6 -->> On Node 1
root@ckyc-dc-n1:~# hostnamectl set-hostname postgres.unidev.org.np

-- Step 7 -->> On Node 1
root@ckyc-dc-n1:~# hostnamectl
/*
 Static hostname: postgres.unidev.org.np
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 0dd73e8a15214bc18db6582556bf7fd0
         Boot ID: 954af960c4d14c228dfd490585d68c6a
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-50-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 2w 3d
*/

-- Step 8 -->> On Node 1 (Ethernet Configuration)
root@ckyc-dc-n1:~# vi /etc/netplan/50-cloud-init.yaml
/*
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens160:
            addresses:
            - 192.168.6.48/24
            nameservers:
                addresses:
                - 192.168.40.11
                - 192.168.40.12
                search: []
            routes:
            -   to: default
                via: 192.168.6.1
    version: 2
*/

-- Step 9 -->> On Node 1 (Restart Network)
root@ckyc-dc-n1:~# systemctl restart network-online.target

-- Step 10 -->> On Node 1 (Set Hostname)
root@ckyc-dc-n1:~# init 6

-- Step 11 -->> On Node 1
root@postgres:~# hostnamectl
/*
 Static hostname: postgres.unidev.org.np
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 0dd73e8a15214bc18db6582556bf7fd0
         Boot ID: 2a5d27b7844f42a1b36d6c1af60f5c1d
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-50-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 2w 3d
*/

-- Step 12 -->> On Node 1
root@postgres:~# vi /etc/sudoers
/*
%sudo   ALL=(ALL:ALL) ALL
*/

-- Step 12.1 -->> On Node 1
root@postgres:~# cat /etc/sudoers | grep -E "%sudo   ALL=\(ALL:ALL\) ALL"
/*
%sudo  ALL=(ALL:ALL) ALL
*/

-- Step 13 -->> On Node 1
root@postgres:~# useradd -G sudo postgres

-- Step 14 -->> On Node 1
root@postgres:~# usermod -a -G sudo postgres

-- Step 15 -->> On Node 1
root@postgres:~# vi /etc/sudoers
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 16 -->> On Node 1
root@postgres:~# cat /etc/sudoers | grep -E "postgres  ALL=\(ALL:ALL\) ALL"
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 17 -->> On Node 1
root@postgres:~# apt update
root@postgres:~# apt -y upgrade
root@postgres:~# apt update && apt -y full-upgrade
root@postgres:~# apt -y install vim curl wget gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates
root@postgres:~# apt policy postgresql
/*
postgresql:
  Installed: (none)
  Candidate: 16+257build1.1
  Version table:
     16+257build1.1 500
        500 http://np.archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages
     16+257build1 500
        500 http://np.archive.ubuntu.com/ubuntu noble/main amd64 Packages
*/

---- Step 18 -->> On Node 1 (Add the PostgreSQL 17 repository:)
root@postgres:~# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

---- Step 19 -->> On Node 1 (Import the repository signing key:)
root@postgres:~# curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
root@postgres:~# apt  update

---- Step 20 -->> On Node 1 (Install PostgreSQL 17 and contrib modules:)
root@postgres:~# apt install postgresql-17
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libcommon-sense-perl libio-pty-perl libipc-run-perl libjson-perl libjson-xs-perl libllvm17t64 libpq5 libtypes-serialiser-perl postgresql-client-17 postgresql-client-common
  postgresql-common ssl-cert
Suggested packages:
  postgresql-doc-17
The following NEW packages will be installed:
  libcommon-sense-perl libio-pty-perl libipc-run-perl libjson-perl libjson-xs-perl libllvm17t64 libpq5 libtypes-serialiser-perl postgresql-17 postgresql-client-17 postgresql-client-common
  postgresql-common ssl-cert
0 upgraded, 13 newly installed, 0 to remove and 2 not upgraded.
Need to get 46.1 MB of archives.
After this operation, 195 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-common all 267.pgdg24.04+1 [36.5 kB]
Get:2 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-perl all 4.10000-1 [81.9 kB]
Get:3 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-common all 267.pgdg24.04+1 [169 kB]
Get:4 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 libpq5 amd64 17.2-1.pgdg24.04+1 [224 kB]
Get:5 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-17 amd64 17.2-1.pgdg24.04+1 [1,994 kB]
Get:6 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libio-pty-perl amd64 1:1.20-1build2 [31.2 kB]
Get:7 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libipc-run-perl all 20231003.0-1 [92.1 kB]
Get:8 http://np.archive.ubuntu.com/ubuntu noble/main amd64 ssl-cert all 1.1.2ubuntu1 [17.8 kB]
Get:9 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libcommon-sense-perl amd64 3.75-3build3 [20.4 kB]
Get:10 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libtypes-serialiser-perl all 1.01-1 [11.6 kB]
Get:11 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-xs-perl amd64 4.030-2build3 [83.6 kB]
Get:12 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libllvm17t64 amd64 1:17.0.6-9ubuntu1 [26.2 MB]
Get:13 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-17 amd64 17.2-1.pgdg24.04+1 [17.2 MB]
Fetched 46.1 MB in 6s (7,166 kB/s)
Preconfiguring packages ...
Selecting previously unselected package libjson-perl.
(Reading database ... 86498 files and directories currently installed.)
Preparing to unpack .../00-libjson-perl_4.10000-1_all.deb ...
Unpacking libjson-perl (4.10000-1) ...
Selecting previously unselected package libio-pty-perl.
Preparing to unpack .../01-libio-pty-perl_1%3a1.20-1build2_amd64.deb ...
Unpacking libio-pty-perl (1:1.20-1build2) ...
Selecting previously unselected package libipc-run-perl.
Preparing to unpack .../02-libipc-run-perl_20231003.0-1_all.deb ...
Unpacking libipc-run-perl (20231003.0-1) ...
Selecting previously unselected package postgresql-client-common.
Preparing to unpack .../03-postgresql-client-common_267.pgdg24.04+1_all.deb ...
Unpacking postgresql-client-common (267.pgdg24.04+1) ...
Selecting previously unselected package ssl-cert.
Preparing to unpack .../04-ssl-cert_1.1.2ubuntu1_all.deb ...
Unpacking ssl-cert (1.1.2ubuntu1) ...
Selecting previously unselected package postgresql-common.
Preparing to unpack .../05-postgresql-common_267.pgdg24.04+1_all.deb ...
Adding 'diversion of /usr/bin/pg_config to /usr/bin/pg_config.libpq-dev by postgresql-common'
Unpacking postgresql-common (267.pgdg24.04+1) ...
Selecting previously unselected package libcommon-sense-perl:amd64.
Preparing to unpack .../06-libcommon-sense-perl_3.75-3build3_amd64.deb ...
Unpacking libcommon-sense-perl:amd64 (3.75-3build3) ...
Selecting previously unselected package libtypes-serialiser-perl.
Preparing to unpack .../07-libtypes-serialiser-perl_1.01-1_all.deb ...
Unpacking libtypes-serialiser-perl (1.01-1) ...
Selecting previously unselected package libjson-xs-perl.
Preparing to unpack .../08-libjson-xs-perl_4.030-2build3_amd64.deb ...
Unpacking libjson-xs-perl (4.030-2build3) ...
Selecting previously unselected package libllvm17t64:amd64.
Preparing to unpack .../09-libllvm17t64_1%3a17.0.6-9ubuntu1_amd64.deb ...
Unpacking libllvm17t64:amd64 (1:17.0.6-9ubuntu1) ...
Selecting previously unselected package libpq5:amd64.
Preparing to unpack .../10-libpq5_17.2-1.pgdg24.04+1_amd64.deb ...
Unpacking libpq5:amd64 (17.2-1.pgdg24.04+1) ...
Selecting previously unselected package postgresql-client-17.
Preparing to unpack .../11-postgresql-client-17_17.2-1.pgdg24.04+1_amd64.deb ...
Unpacking postgresql-client-17 (17.2-1.pgdg24.04+1) ...
Selecting previously unselected package postgresql-17.
Preparing to unpack .../12-postgresql-17_17.2-1.pgdg24.04+1_amd64.deb ...
Unpacking postgresql-17 (17.2-1.pgdg24.04+1) ...
Setting up libio-pty-perl (1:1.20-1build2) ...
Setting up libpq5:amd64 (17.2-1.pgdg24.04+1) ...
Setting up libcommon-sense-perl:amd64 (3.75-3build3) ...
Setting up libllvm17t64:amd64 (1:17.0.6-9ubuntu1) ...
Setting up ssl-cert (1.1.2ubuntu1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/ssl-cert.service → /usr/lib/systemd/system/ssl-cert.service.
Setting up libipc-run-perl (20231003.0-1) ...
Setting up libtypes-serialiser-perl (1.01-1) ...
Setting up libjson-perl (4.10000-1) ...
Setting up postgresql-client-common (267.pgdg24.04+1) ...
Setting up libjson-xs-perl (4.030-2build3) ...
Setting up postgresql-client-17 (17.2-1.pgdg24.04+1) ...
update-alternatives: using /usr/share/postgresql/17/man/man1/psql.1.gz to provide /usr/share/man/man1/psql.1.gz (psql.1.gz) in auto mode
Setting up postgresql-common (267.pgdg24.04+1) ...

Creating config file /etc/postgresql-common/createcluster.conf with new version
Building PostgreSQL dictionaries from installed myspell/hunspell packages...
Removing obsolete dictionary files:
'/etc/apt/trusted.gpg.d/apt.postgresql.org.gpg' -> '/usr/share/postgresql-common/pgdg/apt.postgresql.org.gpg'
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /usr/lib/systemd/system/postgresql.service.
Setting up postgresql-17 (17.2-1.pgdg24.04+1) ...
Creating new PostgreSQL cluster 17/main ...
/usr/lib/postgresql/17/bin/initdb -D /var/lib/postgresql/17/main --auth-local peer --auth-host scram-sha-256 --no-instructions
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/17/main ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default "max_connections" ... 100
selecting default "shared_buffers" ... 128MB
selecting default time zone ... Etc/UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.3) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Running kernel seems to be up-to-date.

Restarting services...

Service restarts being deferred:
 /etc/needrestart/restart.d/dbus.service
 systemctl restart systemd-logind.service

No containers need to be restarted.

User sessions running outdated binaries:
 sysadmin @ session #2: sshd[1298]
 sysadmin @ user manager service: systemd[1316]

No VM guests are running outdated hypervisor (qemu) binaries on this host.
*/

-- Step 21 -->> On Node 1
root@postgres:~# systemctl enable postgresql
/*
Synchronizing state of postgresql.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable postgresql
*/

-- Step 22 -->> On Node 1
root@postgres:~# systemctl start postgresql

-- Step 22.1 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-16 05:50:58 UTC; 1min 49s ago
   Main PID: 15008 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 16 05:50:58 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 16 05:50:58 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 23 -->> On Node 1
root@postgres:~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 24 -->> On Node 1
root@postgres:~# su - postgres
/*
su: warning: cannot change directory to /home/postgres: No such file or directory
$ psql
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \q
could not save history to file "/home/postgres/.psql_history": No such file or directory
$ exit
*/

-- Step 24.1 -->> On Node 1
root@postgres:~# ll /home/
/*
drwxr-xr-x  4 root     root       38 Dec 16 06:11 ./
drwxr-xr-x 24 root     root     4096 Dec 12 05:30 ../
drwxr-x---  4 sysadmin sysadmin  137 Dec 12 06:02 sysadmin/
*/

-- Step 24.2 -->> On Node 1
root@postgres:~# mkdir -p /home/postgres
root@postgres:~# chown postgres:postgres /home/postgres
root@postgres:~# chmod 755 /home/postgres

-- Step 24.3 -->> On Node 1
root@postgres:~# vi /etc/passwd
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On Node 1
root@postgres:~# cat /etc/passwd | grep -i "postgres:x:1001:1001::/home/postgres:/bin/bash"
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 26 -->> On Node 1
root@postgres:~# su - postgres
/*
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
*/

-- Step 26.1 -->> On Node 1
postgres@postgres:~$ psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# show data_directory;
       data_directory
-----------------------------
 /var/lib/postgresql/17/main
(1 row)

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(3 rows)

postgres=# \q
*/

-- Step 26.2 -->> On Node 1
postgres@postgres:~$ exit
/*
logout
*/

-- Step 27 -->> On Node 1 (Default Location)
root@postgres:~# ll /var/lib/postgresql/17/main/
/*
drwx------ 19 postgres postgres 4096 Dec 16 05:51 ./
drwxr-xr-x  3 postgres postgres   18 Dec 16 05:50 ../
drwx------  5 postgres postgres   33 Dec 16 05:50 base/
drwx------  2 postgres postgres 4096 Dec 16 05:54 global/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_commit_ts/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_dynshmem/
drwx------  4 postgres postgres   68 Dec 16 05:51 pg_logical/
drwx------  4 postgres postgres   36 Dec 16 05:50 pg_multixact/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_notify/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_replslot/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_serial/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_snapshots/
drwx------  2 postgres postgres    6 Dec 16 05:51 pg_stat/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_stat_tmp/
drwx------  2 postgres postgres   18 Dec 16 05:50 pg_subtrans/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_tblspc/
drwx------  2 postgres postgres    6 Dec 16 05:50 pg_twophase/
-rw-------  1 postgres postgres    3 Dec 16 05:50 PG_VERSION
drwx------  4 postgres postgres   77 Dec 16 05:50 pg_wal/
drwx------  2 postgres postgres   18 Dec 16 05:50 pg_xact/
-rw-------  1 postgres postgres   88 Dec 16 05:50 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Dec 16 05:51 postmaster.opts
-rw-------  1 postgres postgres  109 Dec 16 05:51 postmaster.pid
*/

-- Step 28 -->> On Node 1 (Configure New Location)
root@postgres:~# mkdir -p /data/postgres/17/data
root@postgres:~# cd /data/
root@postgres:/data# chown -R postgres:postgres postgres/
root@postgres:/data# chmod -R 750 postgres/

-- Step 28.1 -->> On Node 1
root@postgres:~# ll /data/postgres/17/data/
/*
drwxr-x--- 2 postgres postgres  6 Dec 16 05:57 ./
drwxr-x--- 3 postgres postgres 18 Dec 16 05:57 ../
*/

-- Step 28.2 -->> On Node 1
root@postgres:~# systemctl stop postgresql

-- Step 28.3 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Mon 2024-12-16 09:35:36 UTC; 4s ago
   Duration: 2h 17min 7.882s
    Process: 17099 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 17099 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 16 07:18:28 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 16 07:18:28 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 16 09:35:36 postgres.unidev.org.np systemd[1]: postgresql.service: Deactivated successfully.
Dec 16 09:35:36 postgres.unidev.org.np systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 28.4 -->> On Node 1 (allow remote connections by changing listen_addresses to *:)
root@postgres:~# cp /etc/postgresql/17/main/postgresql.conf /etc/postgresql/17/main/postgresql.conf.bk
root@postgres:~# ll /etc/postgresql/17/main/ | grep postgresql
/*
-rw-r--r-- 1 postgres postgres 30962 Dec 16 06:25 postgresql.conf
-rw-r--r-- 1 root     root     30963 Dec 16 06:24 postgresql.conf.bk
*/

-- Step 28.5 -->> On Node 1
root@postgres:~# cd /etc/postgresql/17/main/

-- Step 28.6 -->> On Node 1
root@postgres:/etc/postgresql/17/main# vi postgresql.conf

-- Step 28.7 -->> On Node 1
root@postgres:/etc/postgresql/17/main# cat postgresql.conf | grep -E "data_directory|max_connections = 150|shared_buffers = 256MB"
/*
data_directory = '/data/postgres/17/data' # use data in another directory
max_connections = 150                   # (change requires restart)
shared_buffers = 256MB                  # min 128kB
*/

-- Step 28.8 -->> On Node 1
root@postgres:/var/lib/postgresql/17/main# cp -r * /data/postgres/17/data/

-- Step 28.9 -->> On Node 1
root@postgres:/var/lib/postgresql/17/main# ls -ltr /data/postgres/17/data/
/*
drwx------ 5 root root   33 Dec 16 09:36 base
drwx------ 4 root root   36 Dec 16 09:36 pg_multixact
drwx------ 4 root root   68 Dec 16 09:36 pg_logical
drwx------ 2 root root    6 Dec 16 09:36 pg_dynshmem
drwx------ 2 root root    6 Dec 16 09:36 pg_commit_ts
drwx------ 2 root root 4096 Dec 16 09:36 global
drwx------ 2 root root    6 Dec 16 09:36 pg_twophase
drwx------ 2 root root    6 Dec 16 09:36 pg_tblspc
drwx------ 2 root root   18 Dec 16 09:36 pg_subtrans
drwx------ 2 root root    6 Dec 16 09:36 pg_stat_tmp
drwx------ 2 root root   25 Dec 16 09:36 pg_stat
drwx------ 2 root root    6 Dec 16 09:36 pg_snapshots
drwx------ 2 root root    6 Dec 16 09:36 pg_serial
drwx------ 2 root root    6 Dec 16 09:36 pg_replslot
drwx------ 2 root root    6 Dec 16 09:36 pg_notify
-rw------- 1 root root    3 Dec 16 09:36 PG_VERSION
-rw------- 1 root root  130 Dec 16 09:36 postmaster.opts
-rw------- 1 root root   88 Dec 16 09:36 postgresql.auto.conf
drwx------ 2 root root   18 Dec 16 09:36 pg_xact
drwx------ 4 root root   77 Dec 16 09:36 pg_wal
*/

-- Step 28.10 -->> On Node 1
root@postgres:/var/lib/postgresql/17/main# rm -rf *

-- Step 28.11 -->> On Node 1
root@postgres:~# cd /data/postgres/17/data/

-- Step 28.12 -->> On Node 1
root@postgres:/data/postgres/17/data# chown -R postgres:postgres *

-- Step 28.13 -->> On Node 1
root@postgres:/data/postgres/17/data# ll
/*
drwxr-x--- 19 postgres postgres 4096 Dec 16 09:36 ./
drwxr-x---  3 postgres postgres   18 Dec 16 05:57 ../
drwx------  5 postgres postgres   33 Dec 16 09:36 base/
drwx------  2 postgres postgres 4096 Dec 16 09:36 global/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_commit_ts/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_dynshmem/
drwx------  4 postgres postgres   68 Dec 16 09:36 pg_logical/
drwx------  4 postgres postgres   36 Dec 16 09:36 pg_multixact/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_notify/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_replslot/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_serial/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_snapshots/
drwx------  2 postgres postgres   25 Dec 16 09:36 pg_stat/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_stat_tmp/
drwx------  2 postgres postgres   18 Dec 16 09:36 pg_subtrans/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_tblspc/
drwx------  2 postgres postgres    6 Dec 16 09:36 pg_twophase/
-rw-------  1 postgres postgres    3 Dec 16 09:36 PG_VERSION
drwx------  4 postgres postgres   77 Dec 16 09:36 pg_wal/
drwx------  2 postgres postgres   18 Dec 16 09:36 pg_xact/
-rw-------  1 postgres postgres   88 Dec 16 09:36 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Dec 16 09:36 postmaster.opts
*/

-- Step 28.14 -->> On Node 1
root@postgres:~# du -sh /data/postgres/17/data/
/*
39M     /data/postgres/17/data/
*/

-- Step 28.15 -->> On Node 1
root@postgres:~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 28.16 -->> On Node 1
root@postgres:~# systemctl start postgresql

-- Step 28.17 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-16 09:40:38 UTC; 3s ago
    Process: 17877 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 17877 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 16 09:40:38 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 16 09:40:38 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 29 -->> On Node 1
postgres@postgres:~$ psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# show data_directory;
     data_directory
------------------------
 /data/postgres/17/data
(1 row)

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(3 rows)

postgres=# ALTER USER postgres PASSWORD 'Sys#605014';
ALTER ROLE

postgres=# CREATE DATABASE ckyc;
CREATE DATABASE

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 ckyc      | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# CREATE TABLE ckycschema.tbl_test(sn int);
ckyc=# CREATE SCHEMA ckycschema;
CREATE SCHEMA

ckyc=# CREATE TABLE ckycschema.tbl_test(sn int);
CREATE TABLE

INSERT INTO ckycschema.tbl_test
SELECT 1 sn UNION ALL
SELECT 2 sn UNION ALL
SELECT 3 sn UNION ALL
SELECT 4 sn UNION ALL
SELECT 5 sn UNION ALL
SELECT 6 sn UNION ALL
SELECT 7 sn UNION ALL
SELECT 8 sn UNION ALL
SELECT 9 sn UNION ALL
SELECT 10 sn;
INSERT 0 10

ckyc=# commit;
WARNING:  there is no transaction in progress
COMMIT

ckyc=# select count(*) from ckycschema.tbl_test;
 count
-------
    10
(1 row)
postgres=# exit
*/

-- Step 30 -->> On Node 1
root@postgres:~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 31 -->> On Node 1
root@postgres:~# du -sh /data/postgres/17/data/
/*
46M     /data/postgres/17/data/
*/

-- Step 32 -->> On Node 1
root@postgres:~# systemctl stop postgresql

-- Step 33 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Mon 2024-12-16 09:58:06 UTC; 8s ago
   Duration: 17min 27.709s
    Process: 17877 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 17877 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 16 09:40:38 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 16 09:40:38 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 16 09:58:06 postgres.unidev.org.np systemd[1]: postgresql.service: Deactivated successfully.
Dec 16 09:58:06 postgres.unidev.org.np systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 34 -->> On Node 1
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
listen_addresses = '*'                  # what IP address(es) to listen on;
*/

-- Step 34.1 -->> On Node 1
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -i "listen_addresses = '*'"
/*
listen_addresses = '*'                  # what IP address(es) to listen on;
*/

-- Step 35 -->> On Node 1 (Configure PostgreSQL to use md5 password authentication by editing pg_hba.conf , this is important if you wish to connect remotely e.g. via PGADMIN :)
root@postgres:~# sed -i '/^host/s/ident/md5/' /etc/postgresql/17/main/pg_hba.conf
root@postgres:~# sed -i '/^local/s/peer/trust/' /etc/postgresql/17/main/pg_hba.conf
root@postgres:~# echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf

-- Step 36 -->> On Node 1
root@postgres:~# systemctl start postgresql

-- Step 37 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-16 10:04:45 UTC; 4s ago
    Process: 18153 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 18153 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 16 10:04:45 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 16 10:04:45 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 38 -->> On Node 1
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "port = 5432"
/*
port = 5432                             # (change requires restart)
*/

-- Step 39 -->> On Node 1
root@postgres:~# ufw status
/*
Status: inactive
*/

-- Step 40 -->> On Node 1
root@postgres:~# ufw enable
/*
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
*/

-- Step 41 -->> On Node 1
root@postgres:~# systemctl start ufw

-- Step 42 -->> On Node 1
root@postgres:~# systemctl status ufw
/*
● ufw.service - Uncomplicated firewall
     Loaded: loaded (/usr/lib/systemd/system/ufw.service; enabled; preset: enabled)
     Active: active (exited) since Tue 2024-12-17 03:47:36 UTC; 3 days ago
       Docs: man:ufw(8)
    Process: 933 ExecStart=/usr/lib/ufw/ufw-init start quiet (code=exited, status=0/SUCCESS)
   Main PID: 933 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Dec 17 03:47:36 postgres.unidev.org.np systemd[1]: Starting ufw.service - Uncomplicated firewall...
Dec 17 03:47:36 postgres.unidev.org.np systemd[1]: Finished ufw.service - Uncomplicated firewall.
*/

-- Step 43 -->> On Node 1
root@postgres:~# ufw status
/*
Status: active
*/

-- Step 44 -->> On Node 1
root@postgres:~# ufw allow 5432/tcp
/*
Rule added
Rule added (v6)
*/

-- Step 45 -->> On Node 1
root@postgres:~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
5432/tcp (v6)              ALLOW       Anywhere (v6)
*/

-- Step 0 -->> On Node 1 (Tuning of Postgresql)
root@postgres:~# systemctl stop postgresql

-- Step 0.1 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Tue 2024-12-17 06:39:35 UTC; 2s ago
   Duration: 2h 51min 53.903s
    Process: 1558 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 1558 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 17 03:47:41 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 17 03:47:41 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 17 06:39:35 postgres.unidev.org.np systemd[1]: postgresql.service: Deactivated successfully.
Dec 17 06:39:35 postgres.unidev.org.np systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 1 -->> On Node 1 - Memory Tuning 
-- Shared Buffers (shared_buffers = 25% of your total RAM)
-- Work Mem (set this based on your available RAM and the number of concurrent connections)
-- Maintenance Work Mem (This setting controls the memory available for maintenance operations such as VACUUM, CREATE INDEX, and ALTER TABLE. For a system with larger data sets, increasing this can speed up these tasks)
-- Effective Cache Size (set this to around 50-75% of your total system memory)
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
shared_buffers = 4GB                    # min 128kB
work_mem = 16MB                         # min 64kB
maintenance_work_mem = 1GB              # min 64kB
effective_cache_size = 12GB
*/

-- Step 1.1 -->> On Node 1 - Memory Tuning - Verification 
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "shared_buffers = 4GB|work_mem = 16MB|maintenance_work_mem = 1GB|effective_cache_size = 12GB"
/*
shared_buffers = 4GB                    # min 128kB
work_mem = 16MB                         # min 64kB
maintenance_work_mem = 1GB              # min 64kB
effective_cache_size = 12GB
*/


-- Step 2 -->> On Node 1 - Disk I/O Tuning - (Checkpoint Settings)
--Checkpoints are moments when all data is flushed to disk. Optimizing these reduces disk I/O pressure during peak times.
--checkpoint_segments: Controls the number of log segments between checkpoints. Increasing this reduces the frequency of checkpoints.
--checkpoint_timeout: Increases the time between checkpoints.
--checkpoint_completion_target: Controls how aggressively PostgreSQL writes dirty buffers to disk between checkpoints. A higher value smooths disk I/O load.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
checkpoint_timeout = 15min              # range 30s-1d
checkpoint_completion_target = 0.9      # checkpoint target duration, 0.0 - 1.0
checkpoint_warning = 30s                # 0 disables
max_wal_size = 2GB
*/

-- Step 2.1 -->> On Node 1 - Disk I/O Tuning - (Checkpoint Settings) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "checkpoint_timeout = 15min|checkpoint_completion_target = 0.9|checkpoint_warning = 30s|max_wal_size = 2GB"
/*
checkpoint_timeout = 15min              # range 30s-1d
checkpoint_completion_target = 0.9      # checkpoint target duration, 0.0 - 1.0
checkpoint_warning = 30s                # 0 disables
max_wal_size = 2GB
*/

-- Step 3 -->> On Node 1 - Disk I/O Tuning - (WAL Settings)
--The write-ahead log (WAL) settings control how PostgreSQL writes transactions to disk.
--wal_buffers: Defines the amount of shared memory for the WAL.
--wal_writer_delay: Controls how often WAL is flushed to disk. Increasing this slightly can reduce disk I/O without impacting durability.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
wal_buffers = 16MB                      # min 32kB, -1 sets based on shared_buffers
wal_writer_delay = 500ms                # 1-10000 milliseconds
*/

-- Step 3.1 -->> On Node 1 - Disk I/O Tuning - (WAL Settings) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "wal_buffers = 16MB|wal_writer_delay = 500ms"
/*
wal_buffers = 16MB                      # min 32kB, -1 sets based on shared_buffers
wal_writer_delay = 500ms                # 1-10000 milliseconds
*/

-- Step 4 -->> On Node 1 - Disk I/O Tuning - (Random Page Cost)
--random_page_cost tells PostgreSQL how expensive it is to read a page randomly from disk versus sequentially. If you have fast SSDs, you can lower this to improve index usage.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
random_page_cost = 1.1                  # Default is 4; 1.1 or 1.5 is recommended for SSDs
*/

-- Step 4.1 -->> On Node 1 - Disk I/O Tuning - (Random Page Cost) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "random_page_cost = 1.1"
/*
random_page_cost = 1.1                  # Default is 4; 1.1 or 1.5 is recommended for SSDs
*/

-- Step 5 -->> On Node 1 - Disk I/O Tuning - (Sequential Page Cost)
--seq_page_cost is the cost of reading a page sequentially. Lowering this value makes PostgreSQL prefer sequential scans.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
seq_page_cost = 1.0                     # measured on an arbitrary scale
*/

-- Step 5.1 -->> On Node 1 - Disk I/O Tuning - (Sequential Page Cost) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "seq_page_cost = 1.0"
/*
seq_page_cost = 1.0                     # measured on an arbitrary scale
*/

-- Step 6 -->> On Node 1 - Connection Tuning - (Max Connections)
--Tuning connection settings is crucial for systems with many concurrent users.
--max_connections defines the maximum number of concurrent connections to the database. Having too many connections can cause resource contention. 
--Use a connection pooler like pgbouncer to manage connections efficiently.
--Connection Pooling - Consider using pgbouncer or another connection pooler to handle large numbers of short-lived connections efficiently.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_connections = 200                   # Based on system resources and usage patterns
*/

-- Step 6.1 -->> On Node 1 - Connection Tuning - (Max Connections) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_connections = 200"
/*
max_connections = 200                   # Based on system resources and usage patterns
*/

-- Step 7 -->> On Node 1 - Autovacuum Tuning - (Autovacuum Settings)
--The autovacuum process automatically reclaims storage by cleaning up dead rows. However, its default configuration can lead to poor performance if not tuned.
--autovacuum_vacuum_cost_delay: Increase this to reduce the impact of autovacuum on performance.
--autovacuum_max_workers: The number of autovacuum processes that can run in parallel.
--autovacuum_vacuum_threshold and autovacuum_analyze_threshold: Lower these values to trigger more frequent vacuums and analyze runs.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
autovacuum_vacuum_cost_delay = 10ms     # default vacuum cost delay for (Lower this to decrease autovacuum impact)
autovacuum_max_workers = 6              # max number of autovacuum subprocesses (Increase for larger systems)
autovacuum_vacuum_scale_factor = 0.2    # fraction of table size before vacuum (Set lower to vacuum more frequently)
autovacuum_analyze_scale_factor = 0.1   # fraction of table size before analyze (Set lower to analyze more frequently)
*/

-- Step 7.1 -->> On Node 1 - Autovacuum Tuning - (Autovacuum Settings) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "autovacuum_vacuum_cost_delay = 10ms|autovacuum_max_workers = 6|autovacuum_vacuum_scale_factor = 0.2|autovacuum_analyze_scale_factor = 0.1"
/*
autovacuum_vacuum_cost_delay = 10ms     # default vacuum cost delay for (Lower this to decrease autovacuum impact)
autovacuum_max_workers = 6              # max number of autovacuum subprocesses (Increase for larger systems)
autovacuum_vacuum_scale_factor = 0.2    # fraction of table size before vacuum (Set lower to vacuum more frequently)
autovacuum_analyze_scale_factor = 0.1   # fraction of table size before analyze (Set lower to analyze more frequently)
*/

-- Step 8 -->> On Node 1 - Query Planner Tuning - (Enable JIT Compilation)
--PostgreSQL 17 supports Just-In-Time (JIT) compilation for faster query execution. Enabling this can improve performance for complex queries.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
jit = on                                # allow JIT compilation
*/

-- Step 8.1 -->> On Node 1 - Query Planner Tuning - (Enable JIT Compilation) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "jit = on"
/*
jit = on                                # allow JIT compilation
*/

-- Step 9 -->> On Node 1 - Query Planner Tuning - (Parallel Queries)
--PostgreSQL can run queries in parallel across multiple CPUs, which can speed up large scans and joins. Tuning the number of workers is crucial for improving query performance.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_parallel_workers_per_gather = 4     # limited by max_parallel_workers (Set based on available CPU cores)
max_worker_processes = 8                # (change requires restart)
max_parallel_workers = 8                # number of max_worker_processes that
*/

-- Step 9.1 -->> On Node 1 - Query Planner Tuning - (Parallel Queries) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_parallel_workers_per_gather = 4|max_worker_processes = 8|max_parallel_workers = 8"
/*
max_parallel_workers_per_gather = 4     # limited by max_parallel_workers (Set based on available CPU cores)
max_worker_processes = 8                # (change requires restart)
max_parallel_workers = 8                # number of max_worker_processes that
*/

-- Step 10 -->> On Node 1 - Logging and Monitoring - (Log Slow Queries)
--Tuning PostgreSQL's logging can help track slow queries and detect bottlenecks.
--Log any query that exceeds a certain duration to help identify performance issues.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
log_min_duration_statement = 1000       # -1 is disabled, 0 logs all statements (Logs queries taking longer than 1 second)
log_checkpoints = on
log_lock_waits = on                     # log lock waits >= deadlock_timeout
log_temp_files = 0                      # log temporary files equal or larger
*/

-- Step 10.1 -->> On Node 1 - Query Planner Tuning - (Log Slow Queries) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "log_min_duration_statement = 1000|log_checkpoints = on|log_lock_waits = on|log_temp_files = 0"
/*
log_min_duration_statement = 1000       # -1 is disabled, 0 logs all statements (Logs queries taking longer than 1 second)
log_checkpoints = on
log_lock_waits = on                     # log lock waits >= deadlock_timeout
log_temp_files = 0                      # log temporary files equal or larger
*/

-- Step 11 -->> On Node 1 - Logging and Monitoring - (Enable Stats Collection)
--Collecting statistics on database activity can provide insights into query patterns and index usage.
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
track_io_timing = on
track_activity_query_size = 2048        # (change requires restart)
track_functions = all                   # none, pl, all
*/

-- Step 11.1 -->> On Node 1 - Logging and Monitoring - (Enable Stats Collection) - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "track_io_timing = on|track_activity_query_size = 2048|track_functions = all"
/*
track_io_timing = on
track_activity_query_size = 2048        # (change requires restart)
track_functions = all                   # none, pl, all
*/

-- Step 12 -->> On Node 1 - File Descriptors
--Configure PostgreSQL’s max_files_per_process:
root@postgres:~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_files_per_process = 10000           # min 64
*/

-- Step 12.1 -->> On Node 1 - File Descriptors - Verification
root@postgres:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_files_per_process = 10000"
/*
max_files_per_process = 10000           # min 64
*/

-- Step 13 -->> On Node 1 - Kernel and OS Level Tuning - (Kernel Shared Memory-File Descriptors)
--Adjust the shared memory settings for PostgreSQL at the OS level.
--sudo sysctl -w kernel.shmmax=17179869184  # Set based on total system memory
--sudo sysctl -w kernel.shmall=4194304
--Increase the maximum number of file descriptors allowed for PostgreSQL. 
root@postgres:~# vi /etc/security/limits.conf
/*
* soft nofile 65536
* hard nofile 65536
*/

-- Step 13.1 -->> On Node 1 - Kernel and OS Level Tuning - (Kernel Shared Memory-File Descriptors) - Verification
root@postgres:~# cat /etc/security/limits.conf | grep -E "soft nofile 65536|hard nofile 65536"
/*
* soft nofile 65536
* hard nofile 65536
*/

-- Step 14 -->> On Node 1
root@postgres:~# systemctl start postgresql

-- Step 15 -->> On Node 1
root@postgres:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Tue 2024-12-17 07:34:25 UTC; 4s ago
    Process: 2890 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 2890 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 17 07:34:25 postgres.unidev.org.np systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 17 07:34:25 postgres.unidev.org.np systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 16 -->> On Node 1
root@postgres:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 ckyc      | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \q
*/