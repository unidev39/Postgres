------------------------------------------------------------------------------------------------
--------------------------Postgres Standalone DB Server Configuration---------------------------
------------------------------------------------------------------------------------------------
-- Step 1 -->> On All Nodes 
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  2.0G  1.3M  2.0G   1% /run
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--root                                                   xfs     80G  1.6G   79G   2% /
/dev/disk/by-id/dm-uuid-LVM-4PWqrInxjhS1ImwWi3y3l7qQGfvYrgsdRpRkRD7eGXIZ2W7wUyHvAw2MVIfsBktF xfs     10G  2.2G  7.8G  22% /usr
tmpfs                                                                                        tmpfs  9.8G     0  9.8G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--data                                                   xfs    100G  2.0G   98G   2% /data
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--home                                                   xfs     10G  228M  9.8G   3% /home
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--tmp                                                    xfs     10G  228M  9.8G   3% /tmp
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--var                                                    xfs     10G  377M  9.6G   4% /var
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--log                                                    xfs     38G  777M   38G   2% /log
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--srv                                                    xfs     10G  228M  9.8G   3% /srv
/dev/mapper/ckyc--lvm--vg0-ckyc--lvm--var--lib                                               xfs     10G  421M  9.6G   5% /var/lib
/dev/sda2                                                                                    xfs    960M  146M  815M  16% /boot
tmpfs                                                                                        tmpfs  2.0G   12K  2.0G   1% /run/user/1000
*/


-- Step 2 -->> On All Nodes (Server Kernal version)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# uname -msr
/*
Linux 6.8.0-51-generic x86_64
*/

-- Step 3 -->> On All Nodes (Server Release)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/lsb-release
/*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.1 LTS"
*/

-- Step 4 -->> On All Nodes (Server Release)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/os-release
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

-- Step 5 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/


-- Step 6 -->> On Node 1
root@postgres-dc-n1:~# hostnamectl set-hostname postgres-dc-n1.unidev.org.com

-- Step 6.1 -->> On Node 2
root@postgres-dr-n1:~# hostnamectl set-hostname postgres-dr-n1.unidev.org.com

-- Step 6.2 -->> On Node 3
root@postgres-dr-n2:~# hostnamectl set-hostname postgres-dr-n2.unidev.org.com

-- Step 7 -->> On Node 1
root@postgres-dc-n1:~# hostnamectl
/*
 Static hostname: postgres-dc-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: d0422714408a4d4ea1089faa4ede1a91
         Boot ID: c25aec48fbb84db2bd57e443f86452a4
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 7.1 -->> On Node 2
root@postgres-dr-n1:~# hostnamectl
/*
 Static hostname: postgres-dr-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: ad7d204cc2f14ed79b8a3c88a2ed2302
         Boot ID: 4fac2221330f4e6f91afddaf017414cc
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 7.2 -->> On Node 3
root@postgres-dr-n2:~# hostnamectl
/*
 Static hostname: postgres-dr-n2.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 0ed4162decd24c3e83f1abf681b88378
         Boot ID: f791c5087932449286c255c7eafcbbc4
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 8 -->> On Node 1 (Ethernet Configuration)
root@postgres-dc-n1:~# vi /etc/netplan/50-cloud-init.yaml
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
            - 192.168.6.21/24
            nameservers:
                addresses:
                - 192.168.4.11
                - 192.168.4.12
                search: []
            routes:
            -   to: default
                via: 192.168.6.1
    version: 2
*/

-- Step 8.1 -->> On Node 2 (Ethernet Configuration)
root@postgres-dr-n1:~# vi /etc/netplan/50-cloud-init.yaml
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
            - 192.168.6.22/24
            nameservers:
                addresses:
                - 192.168.4.11
                - 192.168.4.12
                search: []
            routes:
            -   to: default
                via: 192.168.6.1
    version: 2
*/

-- Step 8.2 -->> On Node 3 (Ethernet Configuration)
root@ppostgres-dr-n2:~# vi /etc/netplan/50-cloud-init.yaml
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
            - 192.168.6.23/24
            nameservers:
                addresses:
                - 192.168.4.11
                - 192.168.4.12
                search: []
            routes:
            -   to: default
                via: 192.168.6.1
    version: 2
*/

-- Step 9 -->> On All Nodes (Restart Network)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl restart network-online.target

-- Step 10 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/systemd/timesyncd.conf
/*
[Time]
NTP=192.168.1.35,192.168.1.36
FallbackNTP=ntp.ubuntu.com
*/

-- Step 10.1 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# timedatectl set-ntp true

-- Step 10.2 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# timedatectl set-timezone Asia/Kathmandu

-- Step 10.3 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl restart systemd-timesyncd.service

-- Step 10.4 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl enable systemd-timesyncd.service

-- Step 10.5 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status systemd-timesyncd.service
/*
● systemd-timesyncd.service - Network Time Synchronization
     Loaded: loaded (/usr/lib/systemd/system/systemd-timesyncd.service; enabled; preset: ena>
     Active: active (running) since Thu 2025-01-02 12:19:03 +0545; 17s ago
       Docs: man:systemd-timesyncd.service(8)
   Main PID: 74143 (systemd-timesyn)
     Status: "Idle."
      Tasks: 2 (limit: 23914)
     Memory: 1.3M (peak: 1.8M)
        CPU: 69ms
     CGroup: /system.slice/systemd-timesyncd.service
             └─74143 /usr/lib/systemd/systemd-timesyncd

Jan 02 12:19:02 postgres-dc-n1.unidev.org.com systemd[1]: Starting systemd-timesyncd.servic>
Jan 02 12:19:03 postgres-dc-n1.unidev.org.com systemd[1]: Started systemd-timesyncd.service>
*/

-- Step 10.6 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# date
/*
Thu Jan  2 12:19:26 PM +0545 2025
*/

-- Step 10.7 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~#  vi /banner.txt
/*


WARNING!!!!

Welcome to the KSKL system.

Authorized Access Only.
Any unauthorized use may be monitored, recorded, and subject to legal action.
By accessing you consent to such monitoring if unauthorized use is suspected.
Violators may face criminal, civil, and/or administrative action.

This system is the property of KSKL.




*/

-- Step 10.8 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/ssh/sshd_config
/*
Banner /banner.txt
*/

-- Step 10.9 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/pam.d/sshd
/*
#session    optional     pam_motd.so  motd=/run/motd.dynamic
#session    optional     pam_motd.so noupdate
*/

-- Step 10.10 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl restart ssh.service

-- Step 10.11 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status ssh.service
/*
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Thu 2025-01-02 12:34:12 +0545; 5s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 74364 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 74366 (sshd)
      Tasks: 1 (limit: 23914)
     Memory: 1.2M (peak: 1.5M)
        CPU: 39ms
     CGroup: /system.slice/ssh.service
             └─74366 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 02 12:34:12 postgres-dc-n1.unidev.org.com systemd[1]: Starting ssh.service - OpenBSD Se>
Jan 02 12:34:12 postgres-dc-n1.unidev.org.com sshd[74366]: Server listening on :: port 22.
Jan 02 12:34:12 postgres-dc-n1.unidev.org.com systemd[1]: Started ssh.service - OpenBSD Sec>
*/

-- Step 10.12 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sshd -t

-- Step 10.13 -->> On All Nodes (Hardening)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# init 6

-- Step 11 -->> On Node 1
root@postgres-dc-n1:~# hostnamectl
/*
 Static hostname: postgres-dc-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: d0422714408a4d4ea1089faa4ede1a91
         Boot ID: 2aa774824cd3498e82cc25d3185ec4bc
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 11.1 -->> On Node 2
root@postgres-dr-n1:~# hostnamectl
/*
 Static hostname: postgres-dr-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: ad7d204cc2f14ed79b8a3c88a2ed2302
         Boot ID: 77e7d6b233f243d58a6bed9cfb7a1338
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 11.2 -->> On Node 3
root@postgres-dr-n2:~# hostnamectl
/*
 Static hostname: postgres-dr-n2.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 0ed4162decd24c3e83f1abf681b88378
         Boot ID: 4ae53b865ab648d08a14c534fb048fbe
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Tue 2013-07-30
    Firmware Age: 11y 4month 3w 2d
*/

-- Step 12 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/sudoers
/*
%sudo   ALL=(ALL:ALL) ALL
*/

-- Step 12.1 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/sudoers | grep -E "%sudo   ALL=\(ALL:ALL\) ALL"
/*
%sudo  ALL=(ALL:ALL) ALL
*/

-- Step 13 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# useradd -G sudo postgres

-- Step 14 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# usermod -a -G sudo postgres

-- Step 15 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/sudoers
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 16 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/sudoers | grep -E "postgres  ALL=\(ALL:ALL\) ALL"
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 17 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt update

-- Step 17.1 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt -y upgrade

-- Step 17.2 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt update && apt -y full-upgrade

-- Step 17.3 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt -y install vim curl wget gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates

-- Step 17.4 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt policy postgresql
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

---- Step 18 -->> On All Nodes (Add the PostgreSQL 17 repository:)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

---- Step 19 -->> On All Nodes (Import the repository signing key:)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt update

---- Step 20 -->> On All Nodes (Install PostgreSQL 17 and contrib modules:)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# apt install postgresql-17
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libcommon-sense-perl libio-pty-perl libipc-run-perl libjson-perl libjson-xs-perl
  libllvm17t64 libpq5 libtypes-serialiser-perl postgresql-client-17 postgresql-client-common
  postgresql-common ssl-cert
Suggested packages:
  postgresql-doc-17
The following NEW packages will be installed:
  libcommon-sense-perl libio-pty-perl libipc-run-perl libjson-perl libjson-xs-perl
  libllvm17t64 libpq5 libtypes-serialiser-perl postgresql-17 postgresql-client-17
  postgresql-client-common postgresql-common ssl-cert
0 upgraded, 13 newly installed, 0 to remove and 2 not upgraded.
Need to get 46.1 MB of archives.
After this operation, 195 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-common all 267.pgdg24.04+1 [36.5 kB]
Get:2 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-perl all 4.10000-1 [81.9 kB]
Get:3 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-common all 267.pgdg24.04+1 [169 kB]
Get:4 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libio-pty-perl amd64 1:1.20-1build2 [31.2 kB]
Get:5 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 libpq5 amd64 17.2-1.pgdg24.04+1 [224 kB]
Get:6 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libipc-run-perl all 20231003.0-1 [92.1 kB]
Get:7 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-17 amd64 17.2-1.pgdg24.04+1 [1,994 kB]
Get:8 http://np.archive.ubuntu.com/ubuntu noble/main amd64 ssl-cert all 1.1.2ubuntu1 [17.8 kB]
Get:9 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libcommon-sense-perl amd64 3.75-3build3 [20.4 kB]
Get:10 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libtypes-serialiser-perl all 1.01-1 [11.6 kB]
Get:11 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-xs-perl amd64 4.030-2build3 [83.6 kB]
Get:12 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libllvm17t64 amd64 1:17.0.6-9ubuntu1 [26.2 MB]
Get:13 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-17 amd64 17.2-1.pgdg24.04+1 [17.2 MB]
Fetched 46.1 MB in 21s (2,184 kB/s)
Preconfiguring packages ...
Selecting previously unselected package libjson-perl.
(Reading database ... 86603 files and directories currently installed.)
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
 sysadmin @ session #149: sshd[3590]
 sysadmin @ user manager service: systemd[3595]

No VM guests are running outdated hypervisor (qemu) binaries on this host.
*/

-- Step 21 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 22 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl enable postgresql
/*
Synchronizing state of postgresql.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable postgresql
*/

-- Step 22.1 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl start postgresql

-- Step 22.2 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-23 06:06:55 UTC; 59s ago
    Process: 18260 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 18260 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 06:06:55 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql.service - Pos>
Dec 23 06:06:55 postgres-dc-n1.unidev.org.com systemd[1]: Finished postgresql.service - Pos>
*/

-- Step 23 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 24 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# su - postgres
/*
su: warning: cannot change directory to /home/postgres: No such file or directory
$ psql
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# show data_directory;
       data_directory
-----------------------------
 /var/lib/postgresql/17/main
(1 row)

postgres=# show log_directory ;
 log_directory
---------------
 log
(1 row)

postgres=# \q
could not save history to file "/home/postgres/.psql_history": No such file or directory
$ exit
*/

-- Step 24.1 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ll /home/
/*
drwxr-xr-x  3 root     root       22 Dec 22 06:30 ./
drwxr-xr-x 24 root     root     4096 Dec 22 06:23 ../
drwxr-x---  4 sysadmin sysadmin  137 Dec 22 06:34 sysadmin/
*/

-- Step 24.2 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# mkdir -p /home/postgres
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# chown postgres:postgres /home/postgres
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# chmod 755 /home/postgres

-- Step 24.3 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/passwd
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/passwd | grep -i "postgres:x:1001:1001::/home/postgres:/bin/bash"
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On All Nodes (Fix The User-postgres login issue)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# su - postgres
/*
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
*/

-- Step 25 -->> On All Nodes (Change the Data Directory)
postgres@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~$ psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# show data_directory;
       data_directory
-----------------------------
 /var/lib/postgresql/17/main
(1 row)

postgres=# show log_directory;
 log_directory
---------------
 log
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

-- Step 25.1 -->> On All Nodes (Change the Data Directory)
postgres@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~$ exit
/*
logout
*/

-- Step 25.2 -->> On All Nodes (Change the Data Directory)-(Default Location)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ll /var/lib/postgresql/17/main/
/*
drwx------ 19 postgres postgres 4096 Dec 23 07:07 ./
drwxr-xr-x  3 postgres postgres   18 Dec 23 07:07 ../
drwx------  5 postgres postgres   33 Dec 23 07:07 base/
drwx------  2 postgres postgres 4096 Dec 23 07:11 global/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_commit_ts/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_dynshmem/
drwx------  4 postgres postgres   68 Dec 23 07:12 pg_logical/
drwx------  4 postgres postgres   36 Dec 23 07:07 pg_multixact/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_notify/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_replslot/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_serial/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_snapshots/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_stat/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_stat_tmp/
drwx------  2 postgres postgres   18 Dec 23 07:07 pg_subtrans/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_tblspc/
drwx------  2 postgres postgres    6 Dec 23 07:07 pg_twophase/
-rw-------  1 postgres postgres    3 Dec 23 07:07 PG_VERSION
drwx------  4 postgres postgres   77 Dec 23 07:07 pg_wal/
drwx------  2 postgres postgres   18 Dec 23 07:07 pg_xact/
-rw-------  1 postgres postgres   88 Dec 23 07:07 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Dec 23 07:07 postmaster.opts
-rw-------  1 postgres postgres  108 Dec 23 07:07 postmaster.pid
*/

-- Step 25.3 -->> On All Nodes (Change the Data Directory)-(Configure New Location for Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# mkdir -p /data/postgres/17/data
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cd /data/
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/data# chown -R postgres:postgres postgres/
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/data# chmod -R 750 postgres/

-- Step 25.4 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ll /data/postgres/17/data/
/*
drwxr-x--- 2 postgres postgres  6 Dec 23 06:20 ./
drwxr-x--- 3 postgres postgres 18 Dec 23 06:20 ../
*/

-- Step 25.5 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl stop postgresql

-- Step 25.6 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Mon 2024-12-23 07:14:05 UTC; 7s ago
   Duration: 6min 35.637s
   Main PID: 4119 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 07:07:29 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 07:07:29 postgres-dc-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 23 07:14:05 postgres-dc-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Dec 23 07:14:05 postgres-dc-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 25.7 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cp /etc/postgresql/17/main/postgresql.conf /etc/postgresql/17/main/postgresql.conf.bk
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ll /etc/postgresql/17/main/ | grep postgresql
/*
-rw-r--r-- 1 postgres postgres 30963 Dec 23 07:07 postgresql.conf
-rw-r--r-- 1 root     root     30963 Dec 23 07:14 postgresql.conf.bk
*/

-- Step 25.8 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
data_directory = '/data/postgres/17/data' # use data in another directory
max_connections = 500                     # (change requires restart)
shared_buffers = 4GB                      # min 128kB
*/

-- Step 25.9 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "data_directory|max_connections = 500|shared_buffers = 4GB"
/*
data_directory = '/data/postgres/17/data' # use data in another directory
max_connections = 500                     # (change requires restart)
shared_buffers = 4GB                      # min 128kB
*/

-- Step 25.10 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:# cp -r /var/lib/postgresql/17/main/* /data/postgres/17/data/
--*/

-- Step 25.11 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:# ls -ltr /data/postgres/17/data/
/*
drwx------ 5 root root   33 Dec 23 07:18 base
drwx------ 2 root root    6 Dec 23 07:18 pg_dynshmem
drwx------ 2 root root    6 Dec 23 07:18 pg_commit_ts
drwx------ 2 root root 4096 Dec 23 07:18 global
drwx------ 2 root root    6 Dec 23 07:18 pg_stat_tmp
drwx------ 2 root root   25 Dec 23 07:18 pg_stat
drwx------ 2 root root    6 Dec 23 07:18 pg_snapshots
drwx------ 2 root root    6 Dec 23 07:18 pg_serial
drwx------ 2 root root    6 Dec 23 07:18 pg_replslot
drwx------ 2 root root    6 Dec 23 07:18 pg_notify
drwx------ 4 root root   36 Dec 23 07:18 pg_multixact
drwx------ 4 root root   68 Dec 23 07:18 pg_logical
drwx------ 4 root root   77 Dec 23 07:18 pg_wal
-rw------- 1 root root    3 Dec 23 07:18 PG_VERSION
drwx------ 2 root root    6 Dec 23 07:18 pg_twophase
drwx------ 2 root root    6 Dec 23 07:18 pg_tblspc
drwx------ 2 root root   18 Dec 23 07:18 pg_subtrans
drwx------ 2 root root   18 Dec 23 07:18 pg_xact
-rw------- 1 root root  130 Dec 23 07:18 postmaster.opts
-rw------- 1 root root   88 Dec 23 07:18 postgresql.auto.conf
*/

-- Step 25.12 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:# cd /var/lib/postgresql/17/main/

-- Step 25.13 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/var/lib/postgresql/17/main# rm -rf *

-- Step 25.14 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/var/lib/postgresql/17/main# cd /data/postgres/17/data/

-- Step 25.15 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/data/postgres/17/data# chown -R postgres:postgres *

-- Step 25.16 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/data/postgres/17/data# ll
/*
drwxr-x--- 19 postgres postgres 4096 Dec 23 07:18 ./
drwxr-x---  3 postgres postgres   18 Dec 23 06:20 ../
drwx------  5 postgres postgres   33 Dec 23 07:18 base/
drwx------  2 postgres postgres 4096 Dec 23 07:18 global/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_commit_ts/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_dynshmem/
drwx------  4 postgres postgres   68 Dec 23 07:18 pg_logical/
drwx------  4 postgres postgres   36 Dec 23 07:18 pg_multixact/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_notify/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_replslot/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_serial/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_snapshots/
drwx------  2 postgres postgres   25 Dec 23 07:18 pg_stat/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_stat_tmp/
drwx------  2 postgres postgres   18 Dec 23 07:18 pg_subtrans/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_tblspc/
drwx------  2 postgres postgres    6 Dec 23 07:18 pg_twophase/
-rw-------  1 postgres postgres    3 Dec 23 07:18 PG_VERSION
drwx------  4 postgres postgres   77 Dec 23 07:18 pg_wal/
drwx------  2 postgres postgres   18 Dec 23 07:18 pg_xact/
-rw-------  1 postgres postgres   88 Dec 23 07:18 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Dec 23 07:18 postmaster.opts
*/

-- Step 25.17 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# du -sh /data/postgres/17/data/
/*
39M     /data/postgres/17/data/
*/

-- Step 25.18 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 25.19 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl start postgresql

-- Step 25.20 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-23 07:21:11 UTC; 11s ago
    Process: 5435 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5435 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 07:21:11 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 07:21:11 postgres-dc-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 25.21 -->> On All Nodes (Change the Data Directory)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# su - postgres

-- Step 25.22 -->> On All Nodes (Change the Data Directory)
postgres@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~$ psql
/*
postgres@postgres-dc-n1:~$ psql
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# show data_directory;
     data_directory
------------------------
 /data/postgres/17/data
(1 row)

postgres=# show log_directory;
 log_directory
---------------
 log
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

-- Step 26 -->> On All Nodes (One Mater and Slaves Configuration Start)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl stop postgresql

-- Step 26.1 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Mon 2024-12-23 07:25:44 UTC; 7s ago
   Duration: 4min 33.196s
    Process: 5435 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5435 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 07:21:11 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 07:21:11 postgres-dc-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 23 07:25:44 postgres-dc-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Dec 23 07:25:44 postgres-dc-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 27 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ping -c 2 192.168.6.21
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ping -c 2 192.168.6.22
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# ping -c 2 192.168.6.23

-- Step 28 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
listen_addresses = '*'          # what IP address(es) to listen on;
wal_level = replica             # minimal, replica, or logical
wal_log_hints = on              # also do full page writes of non-critical updates
wal_compression = on            # enable compression of full-page writes
max_wal_size = 1GB
min_wal_size = 80MB
max_wal_senders = 10            # max number of walsender processes
hot_standby = on                # "off" disallows queries during recovery
synchronous_commit = on         # synchronization level;
archive_mode = on               # enables archiving; off, on, or always
archive_command = 'cp %p /log/postgres/17/archive/%f'           # command to use to archive a WAL file
wal_keep_size = 64              # in megabytes; 0 disables
summarize_wal = on              # run WAL summarizer process?
*/

-- Step 28.1 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "listen_addresses = '*'|wal_level|wal_log_hints|wal_compression|max_wal_size|min_wal_size|max_wal_senders|hot_standby = on|synchronous_commit|wal_keep_size = 64|archive_mode|archive_command|summarize_wal = on"
/*
listen_addresses = '*'          # what IP address(es) to listen on;
wal_level = replica             # minimal, replica, or logical
wal_log_hints = on              # also do full page writes of non-critical updates
wal_compression = on            # enable compression of full-page writes
max_wal_size = 1GB
min_wal_size = 80MB
max_wal_senders = 10            # max number of walsender processes
hot_standby = on                # "off" disallows queries during recovery
synchronous_commit = on         # synchronization level;
archive_mode = on               # enables archiving; off, on, or always
archive_command = 'cp %p /log/postgres/17/archive/%f'           # command to use to archive a WAL file
wal_keep_size = 64              # in megabytes; 0 disables
summarize_wal = on              # run WAL summarizer process?
*/

-- Step 29 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# mkdir -p /log/postgres/17/archive
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cd /log/
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/log# chmod -R 755 *
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/log# chown -R postgres:postgres *

-- Step 30 -->> On All Nodes (Configure PostgreSQL to use md5 password authentication by editing pg_hba.conf , this is important if you wish to connect remotely e.g. via PGADMIN :)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sed -i '/^host/s/ident/md5/' /etc/postgresql/17/main/pg_hba.conf
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sed -i '/^local/s/peer/trust/' /etc/postgresql/17/main/pg_hba.conf
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf

-- Step 31 -->> On Node 1 (Allow Current Live IP in Current Backup)
root@postgres-dc-n1:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/

-- Step 31.2 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host   replication      all             192.168.6.22/32          trust
host   replication      all             192.168.6.23/32          trust
*/

-- Step 31.3 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
#host    replication     all             192.168.6.23/32          trust
*/

-- Step 31.4 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
#host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 31.5 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014' # connection string to sending server
*/

-- Step 31.6 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "primary_conninfo"
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014' # connection string to sending server
*/

--root@postgres-dc-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
--/*
--# Do not edit this file manually!
--# It will be overwritten by the ALTER SYSTEM command.
--#primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
--*/
--
--root@postgres-dr-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
--/*
--# Do not edit this file manually!
--# It will be overwritten by the ALTER SYSTEM command.
--primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
--*/
--
--root@postgres-dr-n2:~# vi /data/postgres/17/data/postgresql.auto.conf
--/*
--# Do not edit this file manually!
--# It will be overwritten by the ALTER SYSTEM command.
--primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
--*/

-- Step 32 -->> On Node 1
root@postgres-dc-n1:~# systemctl start postgresql

-- Step 32.1 -->> On Node 1
root@postgres-dc-n1:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-23 08:57:26 UTC; 8s ago
    Process: 5818 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5818 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 08:57:26 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 08:57:26 postgres-dc-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 33 -->> On Node 1 (Create Replocation User)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

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

postgres=# CREATE ROLE replica_user WITH REPLICATION LOGIN PASSWORD 'Sys#605014';
CREATE ROLE

postgres=# \q
*/

-- Step 34 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Mon 2024-12-23 07:25:45 UTC; 1h 40min ago
   Duration: 4min 30.923s
    Process: 5275 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5275 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 07:21:14 postgres-dr-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 07:21:14 postgres-dr-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Dec 23 07:25:45 postgres-dr-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Dec 23 07:25:45 postgres-dr-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 35 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# cd /data/postgres/17/
root@postgres-dr-n1/postgres-dr-n2:/data/postgres/17# mkdir postgres_data_bk
root@postgres-dr-n1/postgres-dr-n2:/data/postgres/17# cp -r data/ postgres_data_bk/
root@postgres-dr-n1/postgres-dr-n2:/data/postgres/17# cd data/
root@postgres-dr-n1/postgres-dr-n2:/data/postgres/17/data# rm -rf *
root@postgres-dr-n1/postgres-dr-n2:/data/postgres/17/data# ll
/*
drwxr-x--- 2 postgres postgres  6 Dec 23 09:17 ./
drwxr-x--- 4 postgres postgres 42 Dec 23 09:15 ../
*/

-- Step 36 -->> On Node 2 and Node 3
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# telnet 192.168.6.21 5432
/*
Trying 192.168.6.21...
Connected to 192.168.6.21.
*/

-- Step 37 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres pg_basebackup -h 192.168.6.21 -D /data/postgres/17/data/ -U replica_user -P -v -R -X stream
/*
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/6000028 on timeline 1
pg_basebackup: starting background WAL receiver
pg_basebackup: created replication slot "slave_standby_n1"
23167/23167 kB (100%), 1/1 tablespace
pg_basebackup: write-ahead log end point: 0/6000120
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: syncing data to disk ...
pg_basebackup: renaming backup_manifest.tmp to backup_manifest
pg_basebackup: base backup completed
*/

-- Step 37.1 -->> On Node 2
root@postgres-dr-n1:~# ll /data/postgres/17/data/
/*
drwxr-x--- 19 postgres postgres   4096 Dec 23 09:30 ./
drwxr-x---  4 postgres postgres     42 Dec 23 09:15 ../
-rw-r-----  1 postgres postgres    225 Dec 23 09:30 backup_label
-rw-r-----  1 postgres postgres 136936 Dec 23 09:30 backup_manifest
drwx------  5 postgres postgres     33 Dec 23 09:30 base/
drwx------  2 postgres postgres   4096 Dec 23 09:30 global/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_commit_ts/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_dynshmem/
drwx------  4 postgres postgres     68 Dec 23 09:30 pg_logical/
drwx------  4 postgres postgres     36 Dec 23 09:30 pg_multixact/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_notify/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_replslot/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_serial/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_snapshots/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_stat/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_stat_tmp/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_subtrans/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_tblspc/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_twophase/
-rw-------  1 postgres postgres      3 Dec 23 09:30 PG_VERSION
drwx------  4 postgres postgres     77 Dec 23 09:30 pg_wal/
drwx------  2 postgres postgres     18 Dec 23 09:30 pg_xact/
-rw-------  1 postgres postgres    474 Dec 23 09:30 postgresql.auto.conf
-rw-r-----  1 postgres postgres      0 Dec 23 09:30 standby.signal
*/

-- Step 38 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres pg_basebackup -h 192.168.6.21 -D /data/postgres/17/data/ -U replica_user -P -v -R -X stream -C -S slave_standby_n2
/*
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/8000028 on timeline 1
pg_basebackup: starting background WAL receiver
pg_basebackup: created replication slot "slave_standby_n2"
23167/23167 kB (100%), 1/1 tablespace
pg_basebackup: write-ahead log end point: 0/8000120
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: syncing data to disk ...
pg_basebackup: renaming backup_manifest.tmp to backup_manifest
pg_basebackup: base backup completed
*/

-- Step 38.1 -->> On Node 3
root@postgres-dr-n2:~# ll /data/postgres/17/data/
/*
drwxr-x--- 19 postgres postgres   4096 Dec 23 09:30 ./
drwxr-x---  4 postgres postgres     42 Dec 23 09:16 ../
-rw-r-----  1 postgres postgres    225 Dec 23 09:30 backup_label
-rw-r-----  1 postgres postgres 136936 Dec 23 09:30 backup_manifest
drwx------  5 postgres postgres     33 Dec 23 09:30 base/
drwx------  2 postgres postgres   4096 Dec 23 09:30 global/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_commit_ts/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_dynshmem/
drwx------  4 postgres postgres     68 Dec 23 09:30 pg_logical/
drwx------  4 postgres postgres     36 Dec 23 09:30 pg_multixact/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_notify/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_replslot/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_serial/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_snapshots/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_stat/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_stat_tmp/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_subtrans/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_tblspc/
drwx------  2 postgres postgres      6 Dec 23 09:30 pg_twophase/
-rw-------  1 postgres postgres      3 Dec 23 09:30 PG_VERSION
drwx------  4 postgres postgres     77 Dec 23 09:30 pg_wal/
drwx------  2 postgres postgres     18 Dec 23 09:30 pg_xact/
-rw-------  1 postgres postgres    474 Dec 23 09:30 postgresql.auto.conf
-rw-r-----  1 postgres postgres      0 Dec 23 09:30 standby.signal
*/

-- Step 39 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# systemctl start postgresql

-- Step 39.1 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Mon 2024-12-23 09:33:23 UTC; 19s ago
    Process: 5747 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5747 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Dec 23 09:33:23 postgres-dr-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Dec 23 09:33:23 postgres-dr-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 40 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# telnet 192.168.6.21 5432 & telnet 192.168.6.22 5432 & telnet 192.168.6.23 5432 &
/*
Trying 192.168.6.22...
Trying 192.168.6.23...
Trying 192.168.6.21...
Connected to 192.168.6.21.
Escape character is '^]'.
Connected to 192.168.6.23.
Escape character is '^]'.
Connected to 192.168.6.22.
Escape character is '^]'.
*/

-- Step 41 -->> On Node 1 (Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

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

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 6053
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 39580
backend_start    | 2024-12-23 09:33:21.771049+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/9000168
write_lsn        | 0/9000168
flush_lsn        | 0/9000168
replay_lsn       | 0/9000168
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-23 09:53:53.918854+00

-[ RECORD 2 ]----+------------------------------
pid              | 6054
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 40012
backend_start    | 2024-12-23 09:33:24.933103+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/9000168
write_lsn        | 0/9000168
flush_lsn        | 0/9000168
replay_lsn       | 0/9000168
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-23 09:53:53.914837+00

postgres=# \q
*/

-- Step 41.1 -->> On Node 2 (Verification)-(If it is streaming that means working fine)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

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

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 5735
status                | streaming
receive_start_lsn     | 0/7000000
receive_start_tli     | 1
written_lsn           | 0/9000168
flushed_lsn           | 0/9000168
received_tli          | 1
last_msg_send_time    | 2024-12-23 09:55:13.943144+00
last_msg_receipt_time | 2024-12-23 09:55:13.942952+00
latest_end_lsn        | 0/9000168
latest_end_time       | 2024-12-23 09:35:43.495095+00
slot_name             | slave_standby_n1
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 41.2 -->> On Node 3 (Verification)-(If it is streaming that means working fine)
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

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

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 6219
status                | streaming
receive_start_lsn     | 0/9000000
receive_start_tli     | 1
written_lsn           | 0/9000168
flushed_lsn           | 0/9000168
received_tli          | 1
last_msg_send_time    | 2024-12-23 09:57:13.988518+00
last_msg_receipt_time | 2024-12-23 09:57:13.985986+00
latest_end_lsn        | 0/9000168
latest_end_time       | 2024-12-23 09:35:43.495137+00
slot_name             | slave_standby_n2
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 41.3 -->> On Node 2 (Verification of Read Only)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# CREATE DATABASE ckyc;
ERROR:  cannot execute CREATE DATABASE in a read-only transaction
postgres=# \q
*/

-- Step 41.4 -->> On Node 3 (Verification of Read Only)
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# CREATE DATABASE ckyc;
ERROR:  cannot execute CREATE DATABASE in a read-only transaction
postgres=# \q
*/

-- Step 41.5 -->> On Node 1 (Verification - Replication)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

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

postgres=#  ALTER USER postgres PASSWORD 'Sys#605014';
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

ckyc=# CREATE SCHEMA ckycschema;
CREATE SCHEMA

ckyc=# CREATE TABLE ckycschema.tbl_test(sn int);
CREATE TABLE

ckyc=# INSERT INTO ckycschema.tbl_test
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

ckyc=# exit
*/

-- Step 41.6 -->> On Node 2 (Verification - Replication)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
root@postgres-dr-n1:~# sudo -u postgres psql
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

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# select count(*) from ckycschema.tbl_test;
 count
-------
    10
(1 row)

ckyc=# exit
*/

-- Step 41.7 -->> On Node 3 (Verification - Replication)
root@postgres-dr-n2:~# sudo -u postgres psql
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

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# select count(*) from ckycschema.tbl_test;
 count
-------
    10
(1 row)

ckyc=# \q
*/

-- Step 01 -->> On All Nodes (status Using pg_ctl)
-- https://manpages.ubuntu.com/manpages/mantic/man1/pg_ctl.1.html
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sudo find / -name pg_ctl
/*
/usr/lib/postgresql/17/bin/pg_ctl
*/

-- Step 01.01 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# /usr/lib/postgresql/17/bin/pg_ctl --version
/*
pg_ctl (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 01.02 -->> On Node 1
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 5885)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 01.03 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 5731)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 01.04 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 6215)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

--(Manully Shutdown master and slave Using pg_ctl)
--Data Consistency: Shutting down the slave node first ensures that it has completed replicating all the data from the master node. This helps maintain data consistency and integrity.
--So, the sequence should be:
--1. Shut down the slave node.
--2. Shut down the master node.

--1. Smart Shutdown: Waits for all active sessions to complete.
--2. Fast Shutdown: Rolls back active transactions and disconnects clients immediately.
--3. Immediate Shutdown: Stops the server immediately without waiting for transactions to complete. Use this only in emergencies.

--1. Smart Shutdown: Waits for all active sessions to complete.
sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
--2. Fast Shutdown: Rolls back active transactions and disconnects clients immediately.
sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m fast
--3. Immediate Shutdown: Stops the server immediately without waiting for transactions to complete. Use this only in emergencies.
sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m immediate

-- Step 02 -->> On Node 2 (Shutting Down the Slave Node)
-- Smart Shutdown: Waits for all active sessions to complete.
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
/*
waiting for server to shut down.... done
server stopped
*/

-- Step 02.01 -->> On Node 2 (Shutting Down the Slave Node Log)
root@postgres-dr-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:12:39.501 UTC [5731] LOG:  received smart shutdown request
2024-12-24 06:12:39.503 UTC [5735] FATAL:  terminating walreceiver process due to administrator command
2024-12-24 06:12:39.509 UTC [5732] LOG:  shutting down
2024-12-24 06:12:39.537 UTC [5731] LOG:  database system is shut down
*/

-- Step 02.02 -->> On Node 3 (Shutting Down the Slave Node)
-- Smart Shutdown: Waits for all active sessions to complete.
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
/*
waiting for server to shut down.... done
server stopped
*/

-- Step 02.03 -->> On Node 3 (Shutting Down the Slave Node Log)
root@postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:16:56.936 UTC [6215] LOG:  received smart shutdown request
2024-12-24 06:16:56.938 UTC [6219] FATAL:  terminating walreceiver process due to administrator command
2024-12-24 06:16:56.944 UTC [6216] LOG:  shutting down
2024-12-24 06:16:56.973 UTC [6215] LOG:  database system is shut down
*/

-- Step 02.04 -->> On Node 1 (Shutting Down the Master Node)
-- Smart Shutdown: Waits for all active sessions to complete.
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
/*
waiting for server to shut down.... done
server stopped
*/

-- Step 02.05 -->> On Node 1 (Shutting Down the Master Node Log)
root@postgres-dc-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:19:49.194 UTC [5885] LOG:  received smart shutdown request
2024-12-24 06:19:49.201 UTC [5885] LOG:  background worker "logical replication launcher" (PID 5892) exited with exit code 1
2024-12-24 06:19:49.201 UTC [5886] LOG:  shutting down
2024-12-24 06:19:49.263 UTC [5886] LOG:  checkpoint starting: shutdown immediate
2024-12-24 06:19:49.699 UTC [5886] LOG:  checkpoint complete: wrote 0 buffers (0.0%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.016 s, sync=0.001 s, total=0.449 s; sync files=0, longest=0.000 s, average=0.000 s; distance=12025 kB, estimate=24249 kB; lsn=0/A000028, redo lsn=0/A000028
2024-12-24 06:19:49.731 UTC [5885] LOG:  database system is shut down
*/


--(Manully Startup master and slave Using pg_ctl)
--Replication Setup: The slave node needs to connect to the master node to start replicating data. If the master node is not running, the slave node won't be able to establish this connection.
--Avoiding Errors: Starting the master node first ensures that the slave node can properly synchronize with it, avoiding replication errors.
--So, the sequence should be:
--1. Start the master node.
--2. Start the slave node.

-- Step 03 -->> On Node 1 (Strating the Master Node)
--Strating the Master Node
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"
/*
waiting for server to start.... done
server started
*/

-- Step 03.01 -->> On Node 1 (Strating the Master Node Log)
root@postgres-dc-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:34:05.101 UTC [12438] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2024-12-24 06:34:05.102 UTC [12438] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2024-12-24 06:34:05.102 UTC [12438] LOG:  listening on IPv6 address "::", port 5432
2024-12-24 06:34:05.103 UTC [12438] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2024-12-24 06:34:05.108 UTC [12441] LOG:  database system was shut down at 2024-12-24 06:19:49 UTC
2024-12-24 06:34:05.117 UTC [12438] LOG:  database system is ready to accept connections
*/

-- Step 03.02 -->> On Node 1 (Status of Master Node)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 12438)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 03.03 -->> On Node 2 (Strating of Slave Node)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"
/*
waiting for server to start.... done
server started
*/

-- Step 03.04 -->> On Node 2 (Strating of Slave Node Log)
root@postgres-dr-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:39:24.400 UTC [8518] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2024-12-24 06:39:24.400 UTC [8518] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2024-12-24 06:39:24.400 UTC [8518] LOG:  listening on IPv6 address "::", port 5432
2024-12-24 06:39:24.402 UTC [8518] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2024-12-24 06:39:24.406 UTC [8521] LOG:  database system was shut down in recovery at 2024-12-24 06:12:39 UTC
2024-12-24 06:39:24.407 UTC [8521] LOG:  entering standby mode
2024-12-24 06:39:24.410 UTC [8521] LOG:  redo starts at 0/94419C8
2024-12-24 06:39:24.410 UTC [8521] LOG:  consistent recovery state reached at 0/9441B08
2024-12-24 06:39:24.410 UTC [8521] LOG:  invalid record length at 0/9441B08: expected at least 24, got 0
2024-12-24 06:39:24.410 UTC [8518] LOG:  database system is ready to accept read-only connections
2024-12-24 06:39:24.429 UTC [8522] LOG:  started streaming WAL from primary at 0/9000000 on timeline 1
*/

-- Step 03.05 -->> On Node 2 (Status of Slave Node)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 8518)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 03.06 -->> On Node 3 (Strating of Slave Node)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"
/*
waiting for server to start.... done
server started
*/

-- Step 03.07 -->> On Node 3 (Strating of Slave Node Log)
root@postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 06:40:18.389 UTC [8509] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2024-12-24 06:40:18.390 UTC [8509] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2024-12-24 06:40:18.390 UTC [8509] LOG:  listening on IPv6 address "::", port 5432
2024-12-24 06:40:18.392 UTC [8509] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2024-12-24 06:40:18.397 UTC [8512] LOG:  database system was shut down in recovery at 2024-12-24 06:16:56 UTC
2024-12-24 06:40:18.397 UTC [8512] LOG:  entering standby mode
2024-12-24 06:40:18.400 UTC [8512] LOG:  redo starts at 0/94419C8
2024-12-24 06:40:18.400 UTC [8512] LOG:  consistent recovery state reached at 0/9441B08
2024-12-24 06:40:18.400 UTC [8512] LOG:  invalid record length at 0/9441B08: expected at least 24, got 0
2024-12-24 06:40:18.400 UTC [8509] LOG:  database system is ready to accept read-only connections
2024-12-24 06:40:18.418 UTC [8513] LOG:  started streaming WAL from primary at 0/9000000 on timeline 1
*/

-- Step 03.08 -->> On Node 3 (Status of Slave Node)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 8509)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 03.09 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 12477
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 53772
backend_start    | 2024-12-24 06:39:24.421774+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/A0001E0
write_lsn        | 0/A0001E0
flush_lsn        | 0/A0001E0
replay_lsn       | 0/A0001E0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-24 06:42:34.689679+00

-[ RECORD 2 ]----+------------------------------
pid              | 12481
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 33486
backend_start    | 2024-12-24 06:40:18.408475+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/A0001E0
write_lsn        | 0/A0001E0
flush_lsn        | 0/A0001E0
replay_lsn       | 0/A0001E0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-24 06:42:28.603087+00

postgres=# \q
*/

-- Step 03.10 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 8522
status                | streaming
receive_start_lsn     | 0/9000000
receive_start_tli     | 1
written_lsn           | 0/A0001E0
flushed_lsn           | 0/A0001E0
received_tli          | 1
last_msg_send_time    | 2024-12-24 06:43:24.707535+00
last_msg_receipt_time | 2024-12-24 06:43:24.702649+00
latest_end_lsn        | 0/A0001E0
latest_end_time       | 2024-12-24 06:39:24.434647+00
slot_name             | slave_standby_n1
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 03.10 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 8513
status                | streaming
receive_start_lsn     | 0/9000000
receive_start_tli     | 1
written_lsn           | 0/A0001E0
flushed_lsn           | 0/A0001E0
received_tli          | 1
last_msg_send_time    | 2024-12-24 06:43:18.617781+00
last_msg_receipt_time | 2024-12-24 06:43:18.61574+00
latest_end_lsn        | 0/A0001E0
latest_end_time       | 2024-12-24 06:40:18.420652+00
slot_name             | slave_standby_n2
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 03.11 -->> On Node 1 (Master Node Verification) - (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 03.12 -->> On Node 2 and Node 3 (Slave Node Verification) - (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 03.13 -->> On Node 2 and Node 3 (Slave Node Verification) - (This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

------>>
------>>
--OR-->>
------>>
------>>

-- Step 04 -->> On All Nodes (status Using pg_ctlcluster)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# sudo find / -name pg_ctlcluster
/*
/usr/bin/pg_ctlcluster
*/

-- Step 04.01 -->> On All Nodes
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# which pg_ctlcluster
/*
/usr/bin/pg_ctlcluster
*/

-- Step 04.02 -->> On Node 1 (Replace main with the actual name of your cluster if it different)
root@postgres-dc-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 12438)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 04.03 -->> On Node 2 (Replace main with the actual name of your cluster if it different)
root@postgres-dr-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 8518)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 04.04 -->> On Node 3 (Replace main with the actual name of your cluster if it different)
root@postgres-dr-n2:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 8509)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

--(Manully Shutdown master and slave Using pg_ctlcluster)
--Data Consistency: Shutting down the slave node first ensures that it has completed replicating all the data from the master node. This helps maintain data consistency and integrity.
--So, the sequence should be:
--1. Shut down the slave node.
--2. Shut down the master node.

--1. Smart Shutdown: Waits for all active sessions to complete.
--2. Fast Shutdown: Rolls back active transactions and disconnects clients immediately.
--3. Immediate Shutdown: Stops the server immediately without waiting for transactions to complete. Use this only in emergencies.

--1. Smart Shutdown: Waits for all active sessions to complete.
sudo -u postgres pg_ctlcluster 17 main stop -m smart
--2. Fast Shutdown: Rolls back active transactions and disconnects clients immediately.
sudo -u postgres pg_ctlcluster 17 main stop -m fast
--3. Immediate Shutdown: Stops the server immediately without waiting for transactions to complete. Use this only in emergencies.
sudo -u postgres pg_ctlcluster 17 main stop -m immediate

-- Step 05 -->> On Node 2 (Shutting Down the Slave Node)
-- Smart Shutdown: This waits for all active sessions to complete.
root@postgres-dr-n1:~# sudo -u postgres pg_ctlcluster 17 main stop -m smart

-- Step 05.01 -->> On Node 2 (Shutting Down the Slave Node Log)
root@postgres-dr-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 07:50:13.359 UTC [8518] LOG:  received smart shutdown request
2024-12-24 07:50:13.361 UTC [8522] FATAL:  terminating walreceiver process due to administrator command
2024-12-24 07:50:13.366 UTC [8519] LOG:  shutting down
2024-12-24 07:50:13.396 UTC [8518] LOG:  database system is shut down
*/

-- Step 05.02 -->> On Node 2 (Status Down the Slave Node)
root@postgres-dr-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: no server running
*/

-- Step 05.03 -->> On Node 3 (Shutting Down the Slave Node)
-- Smart Shutdown: This waits for all active sessions to complete.
root@postgres-dr-n2:~# sudo -u postgres pg_ctlcluster 17 main stop -m smart

-- Step 05.04 -->> On Node 3 (Shutting Down the Slave Node Log)
root@postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 07:52:45.027 UTC [8509] LOG:  received smart shutdown request
2024-12-24 07:52:45.029 UTC [8513] FATAL:  terminating walreceiver process due to administrator command
2024-12-24 07:52:45.034 UTC [8510] LOG:  shutting down
2024-12-24 07:52:45.060 UTC [8509] LOG:  database system is shut down
*/

-- Step 05.05 -->> On Node 3 (Status Down the Slave Node)
root@postgres-dr-n2:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: no server running
*/

-- Step 05.06 -->> On Node 1 (Shutting Down the Master Node)
-- Smart Shutdown: This waits for all active sessions to complete.
root@postgres-dc-n1:~# sudo -u postgres pg_ctlcluster 17 main stop -m smart
/*
Warning: stopping the cluster using pg_ctlcluster will mark the systemd unit as failed. Consider using systemctl:
  sudo systemctl stop postgresql@17-main
*/

-- Step 05.06.01 -->> On Node 1 (Shutting Down the Master Node)
root@postgres-dc-n1:~# sudo systemctl stop postgresql@17-main

-- Step 05.07 -->> On Node 1 (Shutting Down the Master Node Log)
root@postgres-dc-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2024-12-24 08:09:06.325 UTC [13371] LOG:  received smart shutdown request
2024-12-24 08:09:06.330 UTC [13371] LOG:  background worker "logical replication launcher" (PID 13378) exited with exit code 1
2024-12-24 08:09:06.331 UTC [13372] LOG:  shutting down
2024-12-24 08:09:06.449 UTC [13372] LOG:  checkpoint starting: shutdown immediate
2024-12-24 08:09:06.629 UTC [13372] LOG:  checkpoint complete: wrote 3 buffers (0.0%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.020 s, sync=0.012 s, total=0.220 s; sync files=2, longest=0.012 s, average=0.006 s; distance=16384 kB, estimate=16384 kB; lsn=0/11000028, redo lsn=0/11000028
2024-12-24 08:09:06.659 UTC [13371] LOG:  database system is shut down
*/

-- Step 05.08 -->> On Node 1 (Status Down the Master Node)
root@postgres-dc-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: no server running
*/

--(Manully Startup master and slave Using pg_ctlcluster)
--Replication Setup: The slave node needs to connect to the master node to start replicating data. If the master node is not running, the slave node won't be able to establish this connection.
--Avoiding Errors: Starting the master node first ensures that the slave node can properly synchronize with it, avoiding replication errors.
--So, the sequence should be:
--1. Start the master node.
--2. Start the slave node.

-- Step 06 -->> On Node 1 (Strating the Master Node)
-- Starting the Master Node
root@postgres-dc-n1:~# sudo -u postgres pg_ctlcluster 17 main start
/*
Warning: the cluster will not be running as a systemd service. Consider using systemctl:
  sudo systemctl start postgresql@17-main
*/

-- Step 06.01.01 -->> On Node 1 (Strating the Master Node)
root@postgres-dc-n1:~# sudo systemctl start postgresql@17-main
/*
Job for postgresql@17-main.service failed because the service did not take the steps required by its unit configuration.
See "systemctl status postgresql@17-main.service" and "journalctl -xeu postgresql@17-main.service" for details.
*/

-- Step 06.01.02 -->> On Node 1 (Strating the Master Node)
root@postgres-dc-n1:~# sudo pkill -u postgres

-- Step 06.01.03 -->> On Node 1 (Strating the Master Node)
root@postgres-dc-n1:~# sudo systemctl start postgresql@17-main

-- Step 06.01.03 -->> On Node 1 (Status the Master Node)
root@postgres-dc-n1:~# sudo systemctl status postgresql@17-main
/*
● postgresql@17-main.service - PostgreSQL Cluster 17-main
     Loaded: loaded (/usr/lib/systemd/system/postgresql@.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-12-24 08:10:52 UTC; 4s ago
    Process: 13464 ExecStart=/usr/bin/pg_ctlcluster --skip-systemctl-redirect 17-main start (code=exited, status=0/SUCCESS)
   Main PID: 13469 (postgres)
      Tasks: 7 (limit: 23914)
     Memory: 133.2M (peak: 142.5M)
        CPU: 360ms
     CGroup: /system.slice/system-postgresql.slice/postgresql@17-main.service
             ├─13469 /usr/lib/postgresql/17/bin/postgres -D /data/postgres/17/data -c config_file=/etc/postgresql/17/main/postgresql.conf
             ├─13470 "postgres: 17/main: checkpointer "
             ├─13471 "postgres: 17/main: background writer "
             ├─13473 "postgres: 17/main: walwriter "
             ├─13474 "postgres: 17/main: autovacuum launcher "
             ├─13475 "postgres: 17/main: archiver last was 000000010000000000000011"
             └─13476 "postgres: 17/main: logical replication launcher "

Dec 24 08:10:50 postgres-dc-n1.unidev.org.com systemd[1]: Starting postgresql@17-main.service - PostgreSQL Cluster 17-main...
Dec 24 08:10:52 postgres-dc-n1.unidev.org.com systemd[1]: Started postgresql@17-main.service - PostgreSQL Cluster 17-main.
*/

-- Step 06.01.04 -->> On Node 1 (Status the Master Node)
root@postgres-dc-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 13469)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 06.02 -->> On Node 2 (Starting the Slave Node)
root@postgres-dr-n1:~# sudo -u postgres pg_ctlcluster 17 main start
/*
Warning: the cluster will not be running as a systemd service. Consider using systemctl:
  sudo systemctl start postgresql@17-main
*/

-- Step 06.02.01 -->> On Node 2 (Starting the Slave Node)
root@postgres-dr-n1:~# sudo systemctl start postgresql@17-main
/*
Job for postgresql@17-main.service failed because the service did not take the steps required by its unit configuration.
See "systemctl status postgresql@17-main.service" and "journalctl -xeu postgresql@17-main.service" for details.
*/

-- Step 06.02.02 -->> On Node 2 (Starting the Slave Node)
root@postgres-dr-n1:~# sudo pkill -u postgres

-- Step 06.02.03 -->> On Node 2 (Starting the Slave Node)
root@postgres-dr-n1:~# sudo systemctl start postgresql@17-main

-- Step 06.02.04 -->> On Node 2 (Status the Slave Node)
root@postgres-dr-n1:~# sudo systemctl status postgresql@17-main
/*
● postgresql@17-main.service - PostgreSQL Cluster 17-main
     Loaded: loaded (/usr/lib/systemd/system/postgresql@.service; enabled-runtime; preset: enabled)
     Active: active (running) since Tue 2024-12-24 08:14:49 UTC; 4s ago
    Process: 9241 ExecStart=/usr/bin/pg_ctlcluster --skip-systemctl-redirect 17-main start (code=exited, status=0/SUCCESS)
   Main PID: 9246 (postgres)
      Tasks: 5 (limit: 23914)
     Memory: 115.9M (peak: 125.5M)
        CPU: 354ms
     CGroup: /system.slice/system-postgresql.slice/postgresql@17-main.service
             ├─9246 /usr/lib/postgresql/17/bin/postgres -D /data/postgres/17/data -c config_file=/etc/postgresql/17/main/postgresql.conf
             ├─9247 "postgres: 17/main: checkpointer "
             ├─9248 "postgres: 17/main: background writer "
             ├─9249 "postgres: 17/main: startup recovering 000000010000000000000012"
             └─9250 "postgres: 17/main: walreceiver "

Dec 24 08:14:47 postgres-dr-n1.unidev.org.com systemd[1]: Starting postgresql@17-main.service - PostgreSQL Cluster 17-main...
Dec 24 08:14:49 postgres-dr-n1.unidev.org.com systemd[1]: Started postgresql@17-main.service - PostgreSQL Cluster 17-main.
*/

-- Step 06.02.05 -->> On Node 2 (Status the Slave Node)
root@postgres-dr-n1:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 9246)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/


-- Step 06.03 -->> On Node 3 (Starting the Slave Node)
root@postgres-dr-n2:~# sudo -u postgres pg_ctlcluster 17 main start
/*
Warning: the cluster will not be running as a systemd service. Consider using systemctl:
  sudo systemctl start postgresql@17-main
*/

-- Step 06.03.01 -->> On Node 3 (Starting the Slave Node)
root@postgres-dr-n2:~# sudo systemctl start postgresql@17-main
/*
Job for postgresql@17-main.service failed because the service did not take the steps required by its unit configuration.
See "systemctl status postgresql@17-main.service" and "journalctl -xeu postgresql@17-main.service" for details.
*/

-- Step 06.03.02 -->> On Node 3 (Starting the Slave Node)
root@postgres-dr-n2:~# sudo pkill -u postgres

-- Step 06.03.03 -->> On Node 3 (Starting the Slave Node)
root@postgres-dr-n2:~# sudo systemctl start postgresql@17-main

-- Step 06.03.04 -->> On Node 3 (Status the Slave Node)
root@postgres-dr-n2:~# sudo systemctl status postgresql@17-main
/*
● postgresql@17-main.service - PostgreSQL Cluster 17-main
     Loaded: loaded (/usr/lib/systemd/system/postgresql@.service; enabled-runtime; preset: enabled)
     Active: active (running) since Tue 2024-12-24 08:16:41 UTC; 4s ago
    Process: 8870 ExecStart=/usr/bin/pg_ctlcluster --skip-systemctl-redirect 17-main start (code=exited, status=0/SUCCESS)
   Main PID: 8875 (postgres)
      Tasks: 5 (limit: 23914)
     Memory: 115.8M (peak: 125.2M)
        CPU: 354ms
     CGroup: /system.slice/system-postgresql.slice/postgresql@17-main.service
             ├─8875 /usr/lib/postgresql/17/bin/postgres -D /data/postgres/17/data -c config_file=/etc/postgresql/17/main/postgresql.conf
             ├─8876 "postgres: 17/main: checkpointer "
             ├─8877 "postgres: 17/main: background writer "
             ├─8878 "postgres: 17/main: startup recovering 000000010000000000000012"
             └─8879 "postgres: 17/main: walreceiver "

Dec 24 08:16:39 postgres-dr-n2.unidev.org.com systemd[1]: Starting postgresql@17-main.service - PostgreSQL Cluster 17-main...
Dec 24 08:16:41 postgres-dr-n2.unidev.org.com systemd[1]: Started postgresql@17-main.service - PostgreSQL Cluster 17-main.
*/

-- Step 06.03.05 -->> On Node 3 (Status the Slave Node)
root@postgres-dr-n2:~# sudo -u postgres pg_ctlcluster 17 main status
/*
pg_ctl: server is running (PID: 8875)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 06.04 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 13520
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 53362
backend_start    | 2024-12-24 08:14:47.422634+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/120001E0
write_lsn        | 0/120001E0
flush_lsn        | 0/120001E0
replay_lsn       | 0/120001E0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-24 08:18:17.880748+00

-[ RECORD 2 ]----+------------------------------
pid              | 13531
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 44178
backend_start    | 2024-12-24 08:16:39.768022+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/120001E0
write_lsn        | 0/120001E0
flush_lsn        | 0/120001E0
replay_lsn       | 0/120001E0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-24 08:18:19.820745+00

postgres=# \q
*/

-- Step 06.05 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 9250
status                | streaming
receive_start_lsn     | 0/12000000
receive_start_tli     | 1
written_lsn           | 0/120001E0
flushed_lsn           | 0/120001E0
received_tli          | 1
last_msg_send_time    | 2024-12-24 08:18:57.884818+00
last_msg_receipt_time | 2024-12-24 08:18:57.883437+00
latest_end_lsn        | 0/120001E0
latest_end_time       | 2024-12-24 08:15:57.81658+00
slot_name             | slave_standby_n1
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 06.06 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 8879
status                | streaming
receive_start_lsn     | 0/12000000
receive_start_tli     | 1
written_lsn           | 0/120001E0
flushed_lsn           | 0/12000000
received_tli          | 1
last_msg_send_time    | 2024-12-24 08:18:39.820958+00
last_msg_receipt_time | 2024-12-24 08:18:39.820431+00
latest_end_lsn        | 0/120001E0
latest_end_time       | 2024-12-24 08:16:39.783322+00
slot_name             | slave_standby_n2
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 06.07 -->> On Node 1 (Master Node Verification) - (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 06.08 -->> On Node 2 and Node 3 (Slave Node Verification) - (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 06.09 -->> On Node 2 and Node 3 (Slave Node Verification) - (This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/


-- Switch Over and Switch Back Steps
-- Switchover Steps from 192.168.6.21 postgres-dc-n1.unidev.org.com to 192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1
-- Prepare the Current Primary: (192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1)
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/

-- Step 07 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 07.01 -->> On Node 2 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 07.02 -->> On Node 2 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 07.03 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 60608
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 38814
backend_start    | 2024-12-31 06:00:20.328559+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/28009218
write_lsn        | 0/28009218
flush_lsn        | 0/28009218
replay_lsn       | 0/28009218
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:16:56.56188+00

-[ RECORD 2 ]----+------------------------------
pid              | 60610
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 52902
backend_start    | 2024-12-31 06:00:25.697021+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/28009218
write_lsn        | 0/28009218
flush_lsn        | 0/28009218
replay_lsn       | 0/28009218
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:16:56.56724+00

postgres=# \q
*/

-- Step 07.04 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30577
status                | streaming
receive_start_lsn     | 0/27000000
receive_start_tli     | 5
written_lsn           | 0/28009218
flushed_lsn           | 0/28009218
received_tli          | 5
last_msg_send_time    | 2024-12-31 07:17:26.575895+00
last_msg_receipt_time | 2024-12-31 07:17:26.573962+00
latest_end_lsn        | 0/28009218
latest_end_time       | 2024-12-31 06:10:25.060691+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 07.05 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30239
status                | streaming
receive_start_lsn     | 0/27000000
receive_start_tli     | 5
written_lsn           | 0/28009218
flushed_lsn           | 0/28009218
received_tli          | 5
last_msg_send_time    | 2024-12-31 07:17:26.573257+00
last_msg_receipt_time | 2024-12-31 07:17:26.579151+00
latest_end_lsn        | 0/28009218
latest_end_time       | 2024-12-31 06:10:25.060691+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 07.06 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.6.21/32          trust
#host   replication      all             192.168.6.22/32          trust
#host   replication      all             192.168.6.23/32          trust
*/

-- Step 07.07 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.6.21/32          trust
#host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 07.08 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
#host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 07.09 -->> On Node 1 - On the old primary server, stop the PostgreSQL service:
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 07.10 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data


-- Step 07.10 -->> On Node 2 - Promote the Standby - (On the standby server (192.168.6.22), promote it to primary using the pg_ctl command)
--root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@postgres-dr-n1:~# sudo -u postgres psql -c "SELECT pg_promote();"
/*
 pg_promote
------------
 t
(1 row)
*/

-- Step 07.11 -->> On Node 1 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@postgres-dc-n1:~# su - postgres

-- Step 07.11.01 -->> On Node 1
postgres@postgres-dc-n1:~$ touch /data/postgres/17/data/standby.signal

-- Step 07.11.02 -->> On Node 1
postgres@postgres-dc-n1:~$ exit
/*
logout
*/

-- Step 07.11.03 -->> On Node 1
root@postgres-dc-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres      0 Dec 31 07:20 standby.signal
*/


-- Step 07.12 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dc-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 07.12.01 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.22 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 07.13 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
# primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 07.13.01 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
# primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 07.14 -->> On Node 3 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n2:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 07.14.01 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.22 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 07.15 -->> On Node 1 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 07.15.01 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 07.16 -->> On Node 1 (Fresh Stop)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 07.16.01 -->> On Node 3 (Fresh Stop)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 07.16.02 -->> On Node 2 (Fresh Stop)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 07.17 -->> On Node 2 (Fresh Start)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 07.17.01 -->> On Node 1 (Fresh Start)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 07.17.02 -->> On Node 3 (Fresh Start)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 07.17.03 -->> On All Nodes - Logs
root@postgres-dr-n1/postgres-dc-n1/postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log


-- Step 07.18 -->> On Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 07.19 -->> On Node 1 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 07.20 -->> On Node 1 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dc-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/


-- Step 07.21 -->> On Node 2 (Master Node Verification)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 30940
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.21
client_hostname  |
client_port      | 45510
backend_start    | 2024-12-31 07:23:20.843103+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2A0000D8
write_lsn        | 0/2A0000D8
flush_lsn        | 0/2A0000D8
replay_lsn       | 0/2A0000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:25:31.444644+00

-[ RECORD 2 ]----+------------------------------
pid              | 30942
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 33428
backend_start    | 2024-12-31 07:23:24.136412+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2A0000D8
write_lsn        | 0/2A0000D8
flush_lsn        | 0/2A0000D8
replay_lsn       | 0/2A0000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:25:31.447628+00

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# create table ckycschema.tbl_test5 (sn int);
CREATE TABLE

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# \q
*/

-- Step 07.22 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 61130
status                | streaming
receive_start_lsn     | 0/29000000
receive_start_tli     | 6
written_lsn           | 0/2A0000D8
flushed_lsn           | 0/2A0000D8
received_tli          | 6
last_msg_send_time    | 2024-12-31 07:26:01.458424+00
last_msg_receipt_time | 2024-12-31 07:26:01.456954+00
latest_end_lsn        | 0/2A0000D8
latest_end_time       | 2024-12-31 07:23:31.399359+00
slot_name             |
sender_host           | 192.168.6.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# insert into ckycschema.tbl_test5 values (1);
ERROR:  cannot execute INSERT in a read-only transaction

ckyc=# \q

*/

-- Step 07.23 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30564
status                | streaming
receive_start_lsn     | 0/29000000
receive_start_tli     | 6
written_lsn           | 0/2A0000D8
flushed_lsn           | 0/2A0000D8
received_tli          | 6
last_msg_send_time    | 2024-12-31 07:26:01.460842+00
last_msg_receipt_time | 2024-12-31 07:26:01.461646+00
latest_end_lsn        | 0/2A0000D8
latest_end_time       | 2024-12-31 07:23:31.399234+00
slot_name             |
sender_host           | 192.168.6.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# delete from ckycschema.tbl_test5;
ERROR:  cannot execute DELETE in a read-only transaction

ckyc=# \q
*/


-- Switchback Steps from 192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1 to 192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1
-- Prepare the Current Primary: 192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/

-- Step 08 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 08.01 -->> On Node 1 and Node 3- Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 08.02 -->> On Node 1 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dc-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 08.03 -->> On Node 2 (Master Node Verification)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 30940
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.21
client_hostname  |
client_port      | 45510
backend_start    | 2024-12-31 07:23:20.843103+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2A009410
write_lsn        | 0/2A009410
flush_lsn        | 0/2A009410
replay_lsn       | 0/2A009410
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:33:55.187693+00

-[ RECORD 2 ]----+------------------------------
pid              | 30942
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 33428
backend_start    | 2024-12-31 07:23:24.136412+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2A009410
write_lsn        | 0/2A009410
flush_lsn        | 0/2A009410
replay_lsn       | 0/2A009410
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:33:55.18602+00

postgres=# \q
*/

-- Step 08.04 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 61130
status                | streaming
receive_start_lsn     | 0/29000000
receive_start_tli     | 6
written_lsn           | 0/2A009410
flushed_lsn           | 0/2A009410
received_tli          | 6
last_msg_send_time    | 2024-12-31 07:34:25.201454+00
last_msg_receipt_time | 2024-12-31 07:34:25.199837+00
latest_end_lsn        | 0/2A009410
latest_end_time       | 2024-12-31 07:33:25.178327+00
slot_name             |
sender_host           | 192.168.6.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 08.05 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30564
status                | streaming
receive_start_lsn     | 0/29000000
receive_start_tli     | 6
written_lsn           | 0/2A009410
flushed_lsn           | 0/2A009410
received_tli          | 6
last_msg_send_time    | 2024-12-31 07:34:25.201455+00
last_msg_receipt_time | 2024-12-31 07:34:25.19818+00
latest_end_lsn        | 0/2A009410
latest_end_time       | 2024-12-31 07:33:25.178376+00
slot_name             |
sender_host           | 192.168.6.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 08.06 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
#host    replication     all             192.168.6.23/32          trust
*/

-- Step 08.07 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 08.08 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
#host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 08.09 -->> On Node 2 - On the old primary server, stop the PostgreSQL service:
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 08.10 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data


-- Step 08.11 -->> On Node 1 - Promote the Standby - (On the standby server (192.168.6.21), promote it to primary using the pg_ctl command)
--root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_promote();"


-- Step 08.12 -->> On Node 2 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@postgres-dr-n1:~# su - postgres

-- Step 08.12.01 -->> On Node 2
postgres@postgres-dr-n1:~$ touch /data/postgres/17/data/standby.signal

-- Step 08.12.02 -->> On Node 2
postgres@postgres-dr-n1:~$ exit
/*
logout
*/

-- Step 08.12.03 -->> On Node 2
root@postgres-dr-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres      0 Dec 31 07:38 standby.signal
*/


-- Step 08.13 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 08.13.01 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 08.14 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dc-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
#primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 08.14.01 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
#primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 08.15 -->> On Node 3 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n2:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 08.15.01 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 08.16 -->> On Node 2 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 08.16.01 -->> On Node 3
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 08.17 -->> On Node 2 (Fresh Stop)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 08.17.01 -->> On Node 3 (Fresh Stop)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 08.17.02 -->> On Node 1 (Fresh Stop)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 08.18 -->> On Node 1 (Fresh Start)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 08.18.01 -->> On Node 2 (Fresh Start)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 08.18.02 -->> On Node 3 (Fresh Start)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 08.19.03 -->> On All Nodes - Logs
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log

-- Step 08.20 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 08.21 -->> On Node 2 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 08.22 -->> On Node 2 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 08.23 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 61264
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 49984
backend_start    | 2024-12-31 07:41:44.728179+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2C0000D8
write_lsn        | 0/2C0000D8
flush_lsn        | 0/2C0000D8
replay_lsn       | 0/2C0000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:43:04.194189+00

-[ RECORD 2 ]----+------------------------------
pid              | 61266
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 36110
backend_start    | 2024-12-31 07:41:55.458726+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2C0000D8
write_lsn        | 0/2C0000D8
flush_lsn        | 0/2C0000D8
replay_lsn       | 0/2C0000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 07:43:05.782437+00

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".
ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# drop table ckycschema.tbl_test5;
DROP TABLE
ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# \q

*/

-- Step 08.24 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31089
status                | streaming
receive_start_lsn     | 0/2B000000
receive_start_tli     | 7
written_lsn           | 0/2C001A58
flushed_lsn           | 0/2C001A58
received_tli          | 7
last_msg_send_time    | 2024-12-31 07:46:10.397198+00
last_msg_receipt_time | 2024-12-31 07:46:10.399453+00
latest_end_lsn        | 0/2C001A58
latest_end_time       | 2024-12-31 07:45:40.385687+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# create table ckycschema.tbl_test5 (sn int);
ERROR:  cannot execute CREATE TABLE in a read-only transaction

ckyc=# \q
*/

-- Step 08.25 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30662
status                | streaming
receive_start_lsn     | 0/2B000000
receive_start_tli     | 7
written_lsn           | 0/2C001A58
flushed_lsn           | 0/2C001A58
received_tli          | 7
last_msg_send_time    | 2024-12-31 07:46:10.397537+00
last_msg_receipt_time | 2024-12-31 07:46:10.393685+00
latest_end_lsn        | 0/2C001A58
latest_end_time       | 2024-12-31 07:45:40.385609+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# drop table ckycschema.tbl_test4;
ERROR:  cannot execute DROP TABLE in a read-only transaction

ckyc=# \q
*/

-- Switch Over and Switch Back Steps
-- Switchover Steps from 192.168.6.21 postgres-dc-n1.unidev.org.com to 192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
-- Prepare the Current Primary: (192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1)
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/

-- Step 09 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 09.01 -->> On Node 2 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 09.02 -->> On Node 2 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 09.03 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 61264
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 49984
backend_start    | 2024-12-31 07:41:44.728179+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2C001B60
write_lsn        | 0/2C001B60
flush_lsn        | 0/2C001B60
replay_lsn       | 0/2C001B60
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:04:03.982088+00

-[ RECORD 2 ]----+------------------------------
pid              | 61266
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 36110
backend_start    | 2024-12-31 07:41:55.458726+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2C001B60
write_lsn        | 0/2C001B60
flush_lsn        | 0/2C001B60
replay_lsn       | 0/2C001B60
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:04:03.973937+00

postgres=# \q
*/

-- Step 09.04 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31089
status                | streaming
receive_start_lsn     | 0/2B000000
receive_start_tli     | 7
written_lsn           | 0/2C001B60
flushed_lsn           | 0/2C001B60
received_tli          | 7
last_msg_send_time    | 2024-12-31 09:04:13.976515+00
last_msg_receipt_time | 2024-12-31 09:04:13.972998+00
latest_end_lsn        | 0/2C001B60
latest_end_time       | 2024-12-31 07:46:42.189428+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 09.05 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 30662
status                | streaming
receive_start_lsn     | 0/2B000000
receive_start_tli     | 7
written_lsn           | 0/2C001B60
flushed_lsn           | 0/2C001B60
received_tli          | 7
last_msg_send_time    | 2024-12-31 09:04:13.968221+00
last_msg_receipt_time | 2024-12-31 09:04:13.964918+00
latest_end_lsn        | 0/2C001B60
latest_end_time       | 2024-12-31 07:46:42.189428+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 09.06 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.6.21/32          trust
#host   replication      all             192.168.6.22/32          trust
#host   replication      all             192.168.6.23/32          trust
*/

-- Step 09.07 -->> On Node 7
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
#host    replication     all             192.168.6.23/32          trust
*/

-- Step 09.08 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
#host    replication     all             192.168.6.23/32          trust
*/

-- Step 09.09 -->> On Node 1 - On the old primary server, stop the PostgreSQL service:
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 09.10 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data


-- Step 09.10 -->> On Node 2 - Promote the Standby - (On the standby server (192.168.6.23), promote it to primary using the pg_ctl command)
--root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_promote();"
/*
 pg_promote
------------
 t
(1 row)
*/

-- Step 09.11 -->> On Node 1 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@postgres-dc-n1:~# su - postgres

-- Step 09.11.01 -->> On Node 1
postgres@postgres-dc-n1:~$ touch /data/postgres/17/data/standby.signal

-- Step 09.11.02 -->> On Node 1
postgres@postgres-dc-n1:~$ exit
/*
logout
*/

-- Step 09.11.03 -->> On Node 1
root@postgres-dc-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres      0 Dec 31 09:08 standby.signal
*/


-- Step 09.12 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dc-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.23 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 09.12.01 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.23 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 09.13 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.23 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 09.13.01 -->> On Node 2 
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.23 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 09.14 -->> On Node 3 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n2:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
#primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 09.14.01 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
#primary_conninfo = 'host=192.168.6.23 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 09.15 -->> On Node 1 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 09.15.01 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 09.16 -->> On Node 1 (Fresh Stop)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 09.16.01 -->> On Node 2 (Fresh Stop)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 09.16.02 -->> On Node 3 (Fresh Stop)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 09.17 -->> On Node 3 (Fresh Start)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 09.17.01 -->> On Node 1 (Fresh Start)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 09.17.02 -->> On Node 2 (Fresh Start)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"


-- Step 09.17.03 -->> On All Nodes - Logs
root@postgres-dr-n2/postgres-dc-n1/postgres-dr-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log

-- Step 09.18 -->> On Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 09.19 -->> On Node 1 and Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1/postgres-dr-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 09.20 -->> On Node 1 and Node 2 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dc-n1/postgres-dr-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/


-- Step 09.21 -->> On Node 3 (Master Node Verification)
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 30927
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.21
client_hostname  |
client_port      | 44866
backend_start    | 2024-12-31 09:13:31.378624+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2E0005F0
write_lsn        | 0/2E0005F0
flush_lsn        | 0/2E0005F0
replay_lsn       | 0/2E0005F0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:14:58.71467+00

-[ RECORD 2 ]----+------------------------------
pid              | 30929
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 46502
backend_start    | 2024-12-31 09:13:33.408858+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2E0005F0
write_lsn        | 0/2E0005F0
flush_lsn        | 0/2E0005F0
replay_lsn       | 0/2E0005F0
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:14:58.710508+00

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# create table ckycschema.tbl_test5 (sn int);
CREATE TABLE

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# \q
*/

-- Step 09.22 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 61662
status                | streaming
receive_start_lsn     | 0/2D000000
receive_start_tli     | 8
written_lsn           | 0/2E0096C0
flushed_lsn           | 0/2E0096C0
received_tli          | 8
last_msg_send_time    | 2024-12-31 09:16:00.858748+00
last_msg_receipt_time | 2024-12-31 09:16:00.859166+00
latest_end_lsn        | 0/2E0096C0
latest_end_time       | 2024-12-31 09:16:00.858748+00
slot_name             |
sender_host           | 192.168.6.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# insert into ckycschema.tbl_test5 values (1);
ERROR:  cannot execute INSERT in a read-only transaction

ckyc=# \q

*/

-- Step 09.23 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31289
status                | streaming
receive_start_lsn     | 0/2D000000
receive_start_tli     | 8
written_lsn           | 0/2E0096C0
flushed_lsn           | 0/2E0096C0
received_tli          | 8
last_msg_send_time    | 2024-12-31 09:16:00.858748+00
last_msg_receipt_time | 2024-12-31 09:16:00.855399+00
latest_end_lsn        | 0/2E0096C0
latest_end_time       | 2024-12-31 09:16:00.858748+00
slot_name             |
sender_host           | 192.168.6.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# delete from ckycschema.tbl_test5;
ERROR:  cannot execute DELETE in a read-only transaction

ckyc=# \q
*/


-- Switchback Steps from 192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2 to 192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1
-- Prepare the Current Primary: 192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.6.21 postgres-dc-n1.unidev.org.com postgres-dc-n1

# Slave Node 1 - DR
192.168.6.22 postgres-dr-n1.unidev.org.com postgres-dr-n1

# Slave Node 2 - DR
192.168.6.23 postgres-dr-n2.unidev.org.com postgres-dr-n2
*/

-- Step 10 -->> On Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 10.01 -->> On Node 1 and Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1/postgres-dr-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 10.02 -->> On Node 1 and Node 2 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dc-n1/postgres-dr-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 10.03 -->> On Node 3 (Master Node Verification)
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 30927
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.21
client_hostname  |
client_port      | 44866
backend_start    | 2024-12-31 09:13:31.378624+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2E0097C8
write_lsn        | 0/2E0097C8
flush_lsn        | 0/2E0097C8
replay_lsn       | 0/2E0097C8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:20:14.450627+00

-[ RECORD 2 ]----+------------------------------
pid              | 30929
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 46502
backend_start    | 2024-12-31 09:13:33.408858+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/2E0097C8
write_lsn        | 0/2E0097C8
flush_lsn        | 0/2E0097C8
replay_lsn       | 0/2E0097C8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:20:14.446672+00

postgres=# \q
*/

-- Step 10.04 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 61662
status                | streaming
receive_start_lsn     | 0/2D000000
receive_start_tli     | 8
written_lsn           | 0/2E0097C8
flushed_lsn           | 0/2E0097C8
received_tli          | 8
last_msg_send_time    | 2024-12-31 09:20:34.452405+00
last_msg_receipt_time | 2024-12-31 09:20:34.451901+00
latest_end_lsn        | 0/2E0097C8
latest_end_time       | 2024-12-31 09:18:34.406303+00
slot_name             |
sender_host           | 192.168.6.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 10.05 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31289
status                | streaming
receive_start_lsn     | 0/2D000000
receive_start_tli     | 8
written_lsn           | 0/2E0097C8
flushed_lsn           | 0/2E0097C8
received_tli          | 8
last_msg_send_time    | 2024-12-31 09:21:04.464197+00
last_msg_receipt_time | 2024-12-31 09:21:04.46196+00
latest_end_lsn        | 0/2E0097C8
latest_end_time       | 2024-12-31 09:18:34.406204+00
slot_name             |
sender_host           | 192.168.6.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 10.06 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
#host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 10.07 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
host    replication     all             192.168.6.23/32          trust
*/

-- Step 10.08 -->> On Node 2
root@postgres-dr-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.6.21/32          trust
host    replication     all             192.168.6.22/32          trust
#host    replication     all             192.168.6.23/32          trust
*/

-- Step 10.09 -->> On Node 3 - On the old primary server, stop the PostgreSQL service:
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 10.10 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data


-- Step 10.11 -->> On Node 1 - Promote the Standby - (On the standby server (192.168.6.21), promote it to primary using the pg_ctl command)
--root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_promote();"
/*
 pg_promote
------------
 t
(1 row)
*/

-- Step 10.12 -->> On Node 3 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@postgres-dr-n2:~# su - postgres

-- Step 10.12.01 -->> On Node 3
postgres@postgres-dr-n2:~$ touch /data/postgres/17/data/standby.signal

-- Step 10.12.02 -->> On Node 3
postgres@postgres-dr-n2:~$ exit
/*
logout
*/

-- Step 10.12.03 -->> On Node 3
root@postgres-dr-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres      0 Dec 31 09:25 standby.signal
*/


-- Step 10.13 -->> On Node 3 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n2:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 10.13.01 -->> On Node 3
root@postgres-dr-n2:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 10.14 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dc-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
#primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.23 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 10.14.01 -->> On Node 1
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
#primary_conninfo = 'host=192.168.6.23 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 10.15 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@postgres-dr-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.6.21 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 10.15.01 -->> On Node 2
root@postgres-dc-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.6.21 port=5432 user=replica_user password=Sys#605014'      # connection string to sending server
*/

-- Step 10.16 -->> On Node 3 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 10.16.01 -->> On Node 2
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 10.17 -->> On Node 3 (Fresh Stop)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 10.17.01 -->> On Node 2 (Fresh Stop)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 10.17.01 -->> On Node 1 (Fresh Stop)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 10.18 -->> On Node 1 (Fresh Start)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 10.18.01 -->> On Node 2 (Fresh Start)
root@postgres-dr-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 10.18.02 -->> On Node 3 (Fresh Start)
root@postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"


-- Step 10.18.03 -->> On All Nodes - Logs
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# tail -f /var/log/postgresql/postgresql-17-main.log

-- Step 10.19 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 10.20 -->> On Node 2 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 10.21 -->> On Node 2 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 10.22 -->> On Node 1 (Master Node Verification)
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 61803
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 53106
backend_start    | 2024-12-31 09:31:35.084658+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/300000D8
write_lsn        | 0/300000D8
flush_lsn        | 0/300000D8
replay_lsn       | 0/300000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:32:45.414629+00

-[ RECORD 2 ]----+------------------------------
pid              | 61805
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 33464
backend_start    | 2024-12-31 09:31:39.306073+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/300000D8
write_lsn        | 0/300000D8
flush_lsn        | 0/300000D8
replay_lsn       | 0/300000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2024-12-31 09:32:45.4207+00

postgres=# \connect ckyc
You are now connected to database "ckyc" as user "postgres".
ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
(5 rows)

ckyc=# drop table ckycschema.tbl_test5;
DROP TABLE
ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# \q

*/

-- Step 10.23 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31392
status                | streaming
receive_start_lsn     | 0/2F000000
receive_start_tli     | 9
written_lsn           | 0/30001AA8
flushed_lsn           | 0/30001AA8
received_tli          | 9
last_msg_send_time    | 2024-12-31 09:33:47.313565+00
last_msg_receipt_time | 2024-12-31 09:33:47.309456+00
latest_end_lsn        | 0/30001AA8
latest_end_time       | 2024-12-31 09:33:47.313565+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# create table ckycschema.tbl_test5 (sn int);
ERROR:  cannot execute CREATE TABLE in a read-only transaction

ckyc=# \q
*/

-- Step 10.24 -->> On Node 3 (Slave Node Verification) - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 31077
status                | streaming
receive_start_lsn     | 0/2F000000
receive_start_tli     | 9
written_lsn           | 0/30001AA8
flushed_lsn           | 0/30001AA8
received_tli          | 9
last_msg_send_time    | 2024-12-31 09:33:47.313575+00
last_msg_receipt_time | 2024-12-31 09:33:47.315898+00
latest_end_lsn        | 0/30001AA8
latest_end_time       | 2024-12-31 09:33:47.313575+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# drop table ckycschema.tbl_test4;
ERROR:  cannot execute DROP TABLE in a read-only transaction

ckyc=# \q
*/

-- Step 11 -->> On Required Nodes (To delete the archive logs)
--1. Backup Strategy: Ensure that you retain enough WAL files to cover the period between your base backups. For example, if you take a base backup every week, you should keep at least one week-s worth of WAL files.
--2. Recovery Point Objective (RPO): Determine how much data loss is acceptable in the event of a failure. If you need to recover to any point in time within the last 24 hours, you should keep at least 24 hours worth of WAL files.
--3. Disk Space: Monitor your disk space and ensure that the WAL archive directory does not consume excessive storage. You can configure PostgreSQL to automatically manage WAL file retention using parameters like max_wal_size and checkpoint_timeout
--4. Regulatory Requirements: Some industries have specific regulations regarding data retention. Ensure that your WAL retention policy complies with any relevant regulations.
--5. Performance Considerations: Frequent checkpoints can reduce the amount of WAL data generated, but they can also impact performance. Balance the frequency of checkpoints with your performance and recovery needs

-- Step 11.01 -->> On Required Nodes (To delete the archive logs)
root@postgres-dc-n1:~# su - postgres

-- Step 11.02 -->> On Required Nodes (To delete the archive logs)
postgres@postgres-dc-n1:~$ which pg_archivecleanup
/*
/usr/bin/pg_archivecleanup
*/

-- Step 11.03 -->> On Required Nodes (To delete the archive logs)
postgres@postgres-dc-n1:~$ oldest_file=$(find /log/postgres/17/archive/ -type f -name '0000000*' ! -name '*.history' ! -name '*.backup' | sort | tail -n 10 | head -n 1)

-- Step 11.04 -->> On Required Nodes (To delete the archive logs)
postgres@postgres-dc-n1:~$ pg_archivecleanup /log/postgres/17/archive $(basename $oldest_file)


-- Step 12 -->> On Node 1 (To Take a Base Backups)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT rolname FROM pg_roles WHERE rolname = 'root'";
/*
 rolname
---------
 root
(1 row)
*/

-- Step 12.01.01 -->> On Node 1 (If Not Created)
--CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'Sys#605014!';

-- Step 12.02 -->> On Node 1 (Take full base backup with manifest and checksum algorithm)
postgres@postgres-dc-n1:~$ pg_basebackup -D /data/postgres/17/backup/Bck_W01_Full_Jan_2025 -Fp -Xs -P -U replica_user --write-recovery-conf --manifest-checksums=SHA256

-- Step 12.03 -->> On Node 1 (Take Cumulative Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ pg_basebackup -D /data/postgres/17/backup/Bck_W01_Inc_05_Jan_2025_1227 -Fp -Xs -P -U replica_user --incremental=/data/postgres/17/backup/Bck_W01_Full_Jan_2025/backup_manifest

-- Step 12.03.01 -->> On Node 1 (Take Cumulative Incremental base backup using existing manifest)
root@postgres-dc-n1:/data/postgres/17# ll backup/
/*
drwxrwxr-x  5 postgres postgres  107 Jan  5 12:29 ./
drwxr-x---  6 postgres postgres   61 Jan  5 12:23 ../
drwxrwxr-x 19 postgres postgres 4096 Jan  5 12:23 Bck_W01_Full_Jan_2025/
drwxrwxr-x 19 postgres postgres 4096 Jan  5 12:27 Bck_W01_Inc_05_Jan_2025_1227/
drwxrwxr-x 19 postgres postgres 4096 Jan  5 12:29 Bck_W01_Inc_05_Jan_2025_1229/
*/

-- Step 12.03.02 -->> On Node 1 (To combine Fuul base backup with Cumulative Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ export PATH=$PATH:/usr/lib/postgresql/17/bin

-- Step 12.03.03 -->> On Node 1 (To combine Fuul base backup with Cumulative Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ pg_combinebackup -o /data/postgres/17/combine /data/postgres/17/backup/Bck_W01_Full_Jan_2025 /data/postgres/17/backup/Bck_W01_Inc_05_Jan_2025_1229


-- Step 12.04 -->> On Node 1 (Take full base backup with manifest and checksum algorithm)
postgres@postgres-dc-n1:~$ pg_basebackup -D /data/postgres/17/backup/Bck_W02_Full_Jan_2025 -Fp -Xs -P -U replica_user --write-recovery-conf --manifest-checksums=SHA256

-- Step 12.05 -->> On Node 1 (Take Differential Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ pg_basebackup -D /data/postgres/17/backup/Bck_W02_Inc_08_Jan_2025_1700 -Fp -Xs -P -U replica_user --incremental=/data/postgres/17/backup/Bck_W02_Inc_08_Jan_2025_1700/backup_manifest

-- Step 12.05.01 -->> On Node 1 (Take Differential Incremental base backup using existing manifest)
root@postgres-dc-n1:~# ll /data/postgres/17/backup/
/*
drwxrwxr-x  9 postgres postgres  251 Jan  8 17:00 ./
drwxr-x---  7 postgres postgres   77 Jan  5 12:47 ../
drwxrwxr-x 19 postgres postgres 4096 Jan  6 03:21 Bck_W02_Full_Jan_2025/
drwxrwxr-x 19 postgres postgres 4096 Jan  6 05:00 Bck_W02_Inc_06_Jan_2025_0500/
drwxrwxr-x 19 postgres postgres 4096 Jan  6 17:00 Bck_W02_Inc_06_Jan_2025_1700/
drwxrwxr-x 19 postgres postgres 4096 Jan  7 05:00 Bck_W02_Inc_07_Jan_2025_0500/
drwxrwxr-x 19 postgres postgres 4096 Jan  7 05:12 Bck_W02_Inc_07_Jan_2025_0512/
drwxrwxr-x 19 postgres postgres 4096 Jan  8 05:00 Bck_W02_Inc_08_Jan_2025_0500/
drwxrwxr-x 19 postgres postgres 4096 Jan  8 17:00 Bck_W02_Inc_08_Jan_2025_1700/
*/

-- Step 12.05.02 -->> On Node 1 (To combine Fuul base backup with Differential Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ export PATH=$PATH:/usr/lib/postgresql/17/bin
postgres@postgres-dc-n1:~$ which pg_combinebackup
/*
/usr/lib/postgresql/17/bin/pg_combinebackup
*/

-- Step 12.05.03 -->> On Node 1 (To combine Fuul base backup with Differential Incremental base backup using existing manifest)
postgres@postgres-dc-n1:~$ pg_combinebackup -o /data/postgres/17/combine /data/postgres/17/backup/Bck_W02_Full_Jan_2025 $(ls -d /data/postgres/17/backup/Bck_W02_Inc_* | sort)


-- Step 13 -->> On Node 2 and Node 3 (To Restore the Full Base Backup On Master and Slave Using pg_ctl)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 13.01 -->> On Node 1 (To Restore the Full Base Backup On Master and Slave Using pg_ctl)
root@postgres-dc-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 13.02 -->> On All Nodes (Stop postgres services)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# systemctl stop postgresql

-- Step 13.03 -->> On All Nodes (Erase Archive Log - WALL Files)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cd /log/postgres/17/archive/

-- Step 13.03.01 -->> On All Nodes (Erase Archive Log - WALL Files)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/log/postgres/17/archive# rm -rf *

-- Step 13.04 -->> On All Nodes (Erase Data Files)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:~# cd /data/postgres/17/data/

-- Step 13.04.01 -->> On All Nodes (Erase Data Files)
root@postgres-dc-n1/postgres-dr-n1/postgres-dr-n2:/data/postgres/17/data# rm -rf *

-- Step 13.05 -->> On Node 1 (After Combined: Copy data from combine directory on Master Node)
root@postgres-dc-n1:~# cp -r /data/postgres/17/combine/* /data/postgres/17/data/
*/

-- Step 13.05.01 -->> On Node 1
root@postgres-dc-n1:~# cd /data/

-- Step 13.05.02 -->> On Node 1
root@postgres-dc-n1:/data# chown -R postgres:postgres postgres/

-- Step 13.05.03 -->> On Node 1
root@postgres-dc-n1:~# systemctl start postgresql

-- Step 13.05.04 -->> On Node 1
root@postgres-dc-n1:~# systemctl status postgresql

-- Step 13.06 -->> On Node 2 and Node 3 (To push the data from Master Node to Slave Nodes)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres pg_basebackup -h 192.168.6.21 -D /data/postgres/17/data/ -U replica_user -P -v -R -X stream

-- Step 13.06.01 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# systemctl start postgresql

-- Step 13.06.02 -->> On Node 2 and Node 3
root@postgres-dr-n1/postgres-dr-n2:~# systemctl status postgresql


-- Step 13.07 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dc-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 13.08 -->> On Node 2 and Node 3 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 13.09 -->> On Node 2 and Node 3 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@postgres-dr-n1/postgres-dr-n2:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 13.10 -->> On Node 1 - Verification
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 26176
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.22
client_hostname  |
client_port      | 39838
backend_start    | 2025-01-05 08:40:28.842747+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/9E000168
write_lsn        | 0/9E000168
flush_lsn        | 0/9E000168
replay_lsn       | 0/9E000168
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-05 08:51:07.062269+00

-[ RECORD 2 ]----+------------------------------
pid              | 26177
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.6.23
client_hostname  |
client_port      | 48206
backend_start    | 2025-01-05 08:40:32.724173+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/9E000168
write_lsn        | 0/9E000168
flush_lsn        | 0/9E000168
replay_lsn       | 0/9E000168
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-05 08:51:07.181801+00

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
ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_inc1  | table | postgres
 ckycschema | tbl_inc2  | table | postgres
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
 ckycschema | tbl_test5 | table | postgres
 ckycschema | tbl_test6 | table | postgres
 ckycschema | tbl_test8 | table | postgres
 ckycschema | tbl_test9 | table | postgres
(10 rows)

ckyc=# select count(*) from ckycschema.tbl_inc1;
 count
-------
    16
(1 row)

ckyc=# select count(*) from ckycschema.tbl_inc2;
 count
-------
     6
(1 row)

ckyc=# \q

*/

-- Step 13.11 -->> On Node 2 - Verification - If it is streaming that means working fine
root@postgres-dc-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 9780
status                | streaming
receive_start_lsn     | 0/9C000000
receive_start_tli     | 9
written_lsn           | 0/9E000350
flushed_lsn           | 0/9E000350
received_tli          | 9
last_msg_send_time    | 2025-01-05 08:52:46.015205+00
last_msg_receipt_time | 2025-01-05 08:52:43.719279+00
latest_end_lsn        | 0/9E000350
latest_end_time       | 2025-01-05 08:52:46.015205+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# create table ckycschema.tbl_test5 (sn int);
ERROR:  cannot execute CREATE TABLE in a read-only transaction

ckyc=# \q
*/

-- Step 13.12 -->> On Node 3 - Verification - If it is streaming that means working fine
root@postgres-dr-n2:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 9558
status                | streaming
receive_start_lsn     | 0/9E000000
receive_start_tli     | 9
written_lsn           | 0/9E000350
flushed_lsn           | 0/9E000350
received_tli          | 9
last_msg_send_time    | 2025-01-05 08:52:46.015216+00
last_msg_receipt_time | 2025-01-05 08:52:43.844031+00
latest_end_lsn        | 0/9E000350
latest_end_time       | 2025-01-05 08:52:46.015216+00
slot_name             |
sender_host           | 192.168.6.21
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.6.21 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=#  \connect ckyc
You are now connected to database "ckyc" as user "postgres".

ckyc=# \dt ckycschema.*
             List of relations
   Schema   |   Name    | Type  |  Owner
------------+-----------+-------+----------
 ckycschema | tbl_test  | table | postgres
 ckycschema | tbl_test2 | table | postgres
 ckycschema | tbl_test3 | table | postgres
 ckycschema | tbl_test4 | table | postgres
(4 rows)

ckyc=# drop table ckycschema.tbl_test4;
ERROR:  cannot execute DROP TABLE in a read-only transaction

ckyc=# \q
*/
