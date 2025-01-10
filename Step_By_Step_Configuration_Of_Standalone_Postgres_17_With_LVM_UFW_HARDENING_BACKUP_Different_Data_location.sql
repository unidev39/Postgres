------------------------------------------------------------------------------------------------
--------------------------Postgres Standalone DB Server Configuration---------------------------
--->> UAT-DB <<---------------------------------------------------------------------------------
--->> Server Hostname: standalone-n1.unidev.org.com<<-------------------------------------------
--->> IP Address: 192.168.21.22/24 <<-----------------------------------------------------------
--->> sysadmin/Sys#605014# <<-------------------------------------------------------------------
--->> postgres/Sys#605014# <<-------------------------------------------------------------------
--->> root/Sys#605014# <<-----------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Step 1 -->> On Node 1 
root@standalone-n1 :~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  1.6G  1.5M  1.6G   1% /run
/dev/mapper/gda--vg0-gda--lv--root                                                           xfs     49G  998M   48G   2% /
/dev/disk/by-id/dm-uuid-LVM-YXZGbCV3N2DrcudZ1TIkTPAcJryZuHjxZBoay929HzDWfXBycrxzaecxTed6EU3d xfs     10G  2.2G  7.8G  22% /usr
tmpfs                                                                                        tmpfs  7.8G     0  7.8G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/gda--vg0-gda--lv--home                                                           xfs     10G  228M  9.8G   3% /home
/dev/mapper/gda--vg0-gda--lv--tmp                                                            xfs     10G  228M  9.8G   3% /tmp
/dev/mapper/gda--vg0-gda--lv--srv                                                            xfs     10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg0-gda--lv--var                                                            xfs     10G  391M  9.6G   4% /var
/dev/mapper/gda--vg0-gda--lv--var--lib                                                       xfs     10G  418M  9.6G   5% /var/lib
/dev/sda2                                                                                    xfs    960M  146M  815M  16% /boot
tmpfs                                                                                        tmpfs  1.6G   12K  1.6G   1% /run/user/1000
*/

-- Step 2 -->> On Node 1 (Server Kernal version)
root@standalone-n1 :~# uname -msr
/*
Linux 6.8.0-51-generic x86_64
*/

-- Step 3 -->> On Node 1 (Server Release)
root@standalone-n1 :~# cat /etc/lsb-release
/*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.1 LTS"
*/

-- Step 4 -->> On Node 1 (Server Release)
root@standalone-n1 :~# cat /etc/os-release
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
root@standalone-n1 :~# vi /etc/hosts
/*
127.0.0.1 localhost
127.0.1.1  ckyc-dc-n1

# Public
192.168.21.22 standalone-n1.unidev.org.com standalone-n1
*/

-- Step 6 -->> On Node 1
root@standalone-n1 :~# hostnamectl set-hostname standalone-n1.unidev.org.com

-- Step 7 -->> On Node 1
root@standalone-n1 :~# hostnamectl
/*
 Static hostname: standalone-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: eff89c6100e84adab6d111b78e1d84db
         Boot ID: 165d1470f7a04030becc0348c79cebe6
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Wed 2018-12-12
    Firmware Age: 6y 4w
*/

-- Step 8 -->> On Node 1 (Ethernet Configuration)
root@standalone-n1 :~# vi /etc/netplan/50-cloud-init.yaml
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
            - 192.168.21.22/24
            nameservers:
                addresses:
                - 192.168.21.11
                - 192.168.21.12
                search: []
            routes:
            -   to: default
                via: 192.168.21.1
    version: 2
*/

-- Step 9 -->> On Node 1 (Restart Network)
root@standalone-n1 :~# systemctl restart network-online.target

-- Step 10 -->> On Node 1 (Hardening)
root@standalone-n1 :~# vi /etc/systemd/timesyncd.conf
/*
[Time]
NTP=192.168.22.35,192.168.22.36
FallbackNTP=ntp.ubuntu.com
*/

-- Step 10.1 -->> On Node 1 (Hardening)
root@standalone-n1 :~# timedatectl set-ntp true

-- Step 10.2 -->> On Node 1 (Hardening)
root@standalone-n1 :~# timedatectl set-timezone Asia/Kathmandu

-- Step 10.3 -->> On Node 1 (Hardening)
root@standalone-n1 :~# systemctl restart systemd-timesyncd.service

-- Step 10.4 -->> On Node 1 (Hardening)
root@standalone-n1 :~# systemctl enable systemd-timesyncd.service

-- Step 10.5 -->> On Node 1 (Hardening)
root@standalone-n1 :~# systemctl status systemd-timesyncd.service
/*
● systemd-timesyncd.service - Network Time Synchronization
     Loaded: loaded (/usr/lib/systemd/system/systemd-timesyncd.service; enabled; preset: enabled)
     Active: active (running) since Wed 2025-01-08 19:39:39 +0545; 8s ago
       Docs: man:systemd-timesyncd.service(8)
   Main PID: 1570 (systemd-timesyn)
     Status: "Idle."
      Tasks: 2 (limit: 19049)
     Memory: 1.4M (peak: 1.9M)
        CPU: 59ms
     CGroup: /system.slice/systemd-timesyncd.service
             └─1570 /usr/lib/systemd/systemd-timesyncd

Jan 08 19:39:39 standalone-n1.unidev.org.com systemd[1]: Starting systemd-timesyncd.service - Network Time Synchronization...
Jan 08 19:39:39 standalone-n1.unidev.org.com systemd[1]: Started systemd-timesyncd.service - Network Time Synchronization.
*/

-- Step 10.6 -->> On Node 1 (Hardening)
root@standalone-n1 :~# date
/*
Fri Jan  3 04:27:49 PM +0545 2025
*/

-- Step 10.7 -->> On Node 1 (Hardening)
root@standalone-n1 :~# vi /banner.txt
/*


WARNING!!!!

Welcome to the UNIDEV system.

Authorized Access Only.

This system is the property of UNIDEV.

*/

-- Step 10.8 -->> On Node 1 (Hardening)
root@standalone-n1 :~# vi /etc/ssh/sshd_config
/*
Banner /banner.txt
*/

-- Step 10.9 -->> On Node 1 (Hardening)
root@standalone-n1 :~# vi /etc/pam.d/sshd
/*
#session    optional     pam_motd.so  motd=/run/motd.dynamic
#session    optional     pam_motd.so noupdate
*/

-- Step 10.10 -->> On Node 1 (Hardening)
root@standalone-n1 :~# systemctl restart ssh.service

-- Step 10.11 -->> On Node 1 (Hardening)
root@standalone-n1 :~# systemctl status ssh.service
/*
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Wed 2025-01-08 19:41:30 +0545; 3s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 1636 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 1638 (sshd)
      Tasks: 1 (limit: 19049)
     Memory: 1.2M (peak: 1.4M)
        CPU: 39ms
     CGroup: /system.slice/ssh.service
             └─1638 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 08 19:41:30 standalone-n1.unidev.org.com systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Jan 08 19:41:30 standalone-n1.unidev.org.com sshd[1638]: Server listening on :: port 22.
Jan 08 19:41:30 standalone-n1.unidev.org.com systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
*/

-- Step 10.12 -->> On Node 1 (Hardening)
root@standalone-n1 :~# sshd -t

-- Step 10.13 -->> On Node 1 (Hardening)
root@standalone-n1 :~# init 6

-- Step 11 -->> On Node 1
root@standalone-n1 :~# hostnamectl
/*
 Static hostname: standalone-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: eff89c6100e84adab6d111b78e1d84db
         Boot ID: 53781f7886b74840be20a0d335d9be2f
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware Virtual Platform
Firmware Version: 6.00
   Firmware Date: Wed 2018-12-12
    Firmware Age: 6y 4w
*/

-- Step 11.1 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:0    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:1    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:2    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:3    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:4    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:5    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:6    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:7    0   20G  0 lvm  [SWAP]
sr0                             11:0    1 1024M  0 rom
*/

-- Step 11.2 -->> On Node 1 (LVM Partition)
-- Add Required Disk on DB Server manually 
root@standalone-n1 :~# init 0

-- Step 11.3 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:0    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:1    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:2    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:3    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:4    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:5    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:6    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:7    0   20G  0 lvm  [SWAP]
sdb                              8:16   0   50G  0 disk
sdc                              8:32   0   50G  0 disk
sr0                             11:0    1 1024M  0 rom
*/

-- Step 11.4 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# fdisk -ll | grep -E "sdb|sdc"
/*
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
*/

-- Step 11.5 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# fdisk /dev/sdb
/*

Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x20b352da.

Command (m for help): p
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x20b352da

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (1-4, default 1):
First sector (2048-104857599, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-104857599, default 104857599):

Created a new partition 1 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x20b352da

Device     Boot Start       End   Sectors Size Id Type
/dev/sdb1        2048 104857599 104855552  50G 83 Linux

Command (m for help): t

Selected partition 1
Hex code or alias (type L to list all): 8E
Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x20b352da

Device     Boot Start       End   Sectors Size Id Type
/dev/sdb1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 11.6 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x149aa13a.

Command (m for help): p
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x149aa13a

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (1-4, default 1):
First sector (2048-104857599, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-104857599, default 104857599):

Created a new partition 1 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x149aa13a

Device     Boot Start       End   Sectors Size Id Type
/dev/sdc1        2048 104857599 104855552  50G 83 Linux

Command (m for help): t
Selected partition 1
Hex code or alias (type L to list all): 8E
Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x149aa13a

Device     Boot Start       End   Sectors Size Id Type
/dev/sdc1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 11.7 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# partprobe /dev/sdb

-- Step 11.8 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# partprobe /dev/sdc

-- Step 11.9 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:0    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:1    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:2    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:3    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:4    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:5    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:6    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:7    0   20G  0 lvm  [SWAP]
sdb                              8:16   0   50G  0 disk
└─sdb1                           8:17   0   50G  0 part
sdc                              8:32   0   50G  0 disk
└─sdc1                           8:33   0   50G  0 part
sr0                             11:0    1 1024M  0 rom
*/

-- Step 11.10 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvs
/*
  PV         VG      Fmt  Attr PSize    PFree
  /dev/sda3  gda-vg0 lvm2 a--  <129.00g    0
*/

-- Step 11.11 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgs
/*
  VG      #PV #LV #SN Attr   VSize    VFree
  gda-vg0   1   8   0 wz--n- <129.00g    0
*/

-- Step 11.12 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvs
/*
  LV             VG      Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  gda-lv-home    gda-vg0 -wi-ao----  10.00g
  gda-lv-root    gda-vg0 -wi-ao----  49.00g
  gda-lv-srv     gda-vg0 -wi-ao----  10.00g
  gda-lv-swap    gda-vg0 -wi-ao---- <20.00g
  gda-lv-tmp     gda-vg0 -wi-ao----  10.00g
  gda-lv-usr     gda-vg0 -wi-ao----  10.00g
  gda-lv-var     gda-vg0 -wi-ao----  10.00g
  gda-lv-var-lib gda-vg0 -wi-ao----  10.00g
*/

-- Step 11.13 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvcreate /dev/sdb1
/*
  Physical volume "/dev/sdb1" successfully created.
*/

-- Step 11.14 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvcreate /dev/sdc1
/*
  Physical volume "/dev/sdc1" successfully created.
*/

-- Step 11.15 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvs
/*
  PV         VG      Fmt  Attr PSize    PFree
  /dev/sda3  gda-vg0 lvm2 a--  <129.00g      0
  /dev/sdb1          lvm2 ---   <50.00g <50.00g
  /dev/sdc1          lvm2 ---   <50.00g <50.00g
*/

-- Step 11.16 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvdisplay /dev/sdb1
/*
  "/dev/sdb1" is a new physical volume of "<50.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb1
  VG Name
  PV Size               <50.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               jMAKeK-V21G-0fQj-6kSs-UBGE-ID2a-NtSgPn
*/

-- Step 11.17 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# pvdisplay /dev/sdc1
/*
  "/dev/sdc1" is a new physical volume of "<50.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc1
  VG Name
  PV Size               <50.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               0m4OJG-BA6k-duDN-cDZr-nqhZ-gUTw-pQHgly
*/

-- Step 11.18 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgcreate -s 8M data-vg /dev/sdb1
/*
  Volume group "data-vg" successfully created
*/

-- Step 11.19 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgcreate -s 8M backup-vg /dev/sdc1
/*
  Volume group "backup-vg" successfully created
*/

-- Step 11.20 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgs
/*
  VG        #PV #LV #SN Attr   VSize    VFree
  backup-vg   1   0   0 wz--n-   49.99g 49.99g
  data-vg     1   0   0 wz--n-   49.99g 49.99g
  gda-vg0     1   8   0 wz--n- <129.00g     0
*/

-- Step 11.21 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgdisplay data-vg
/*
  --- Volume group ---
  VG Name               data-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               49.99 GiB
  PE Size               8.00 MiB
  Total PE              6399
  Alloc PE / Size       0 / 0
  Free  PE / Size       6399 / 49.99 GiB
  VG UUID               LLCcBC-CNYf-Bugc-MOJ8-RmBa-Firx-zg15mm
*/

-- Step 11.22 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vgdisplay backup-vg
/*
  --- Volume group ---
  VG Name               backup-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               49.99 GiB
  PE Size               8.00 MiB
  Total PE              6399
  Alloc PE / Size       0 / 0
  Free  PE / Size       6399 / 49.99 GiB
  VG UUID               MoNdmH-61XT-RKyK-Cb8J-An4d-5VuM-NsTgLi
*/

-- Step 11.23 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvcreate -n data-lv -L 49.91GB data-vg
/*
  Logical volume "data-lv" created.
*/

-- Step 11.24 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvcreate -n backup-lv -L 49.91GB backup-vg
/*
  Logical volume "backup-lv" created.
*/

-- Step 11.25 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvs
/*
  LV             VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  backup-lv      backup-vg -wi-a-----  49.91g
  data-lv        data-vg   -wi-a-----  49.91g
  gda-lv-home    gda-vg0   -wi-ao----  10.00g
  gda-lv-root    gda-vg0   -wi-ao----  49.00g
  gda-lv-srv     gda-vg0   -wi-ao----  10.00g
  gda-lv-swap    gda-vg0   -wi-ao---- <20.00g
  gda-lv-tmp     gda-vg0   -wi-ao----  10.00g
  gda-lv-usr     gda-vg0   -wi-ao----  10.00g
  gda-lv-var     gda-vg0   -wi-ao----  10.00g
  gda-lv-var-lib gda-vg0   -wi-ao----  10.00g
*/

-- Step 11.26 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# fdisk -ll | grep -E "data|backup"
/*
Disk /dev/mapper/backup--vg-backup--lv: 49.91 GiB, 53594816512 bytes, 104677376 sectors
Disk /dev/mapper/data--vg-data--lv: 49.91 GiB, 53594816512 bytes, 104677376 sectors
*/

-- Step 11.27 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvdisplay /dev/mapper/data--vg-data--lv
/*
  --- Logical volume ---
  LV Path                /dev/data-vg/data-lv
  LV Name                data-lv
  VG Name                data-vg
  LV UUID                FLUmQw-L6se-Dtg2-ev6f-WO6C-CXNP-kI9pjg
  LV Write Access        read/write
  LV Creation host, time standalone-n1.unidev.org.com, 2025-01-08 20:00:59 +0545
  LV Status              available
  # open                 0
  LV Size                49.91 GiB
  Current LE             6389
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:8
*/

-- Step 11.28 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lvdisplay /dev/mapper/backup--vg-backup--lv
/*
  --- Logical volume ---
  LV Path                /dev/backup-vg/backup-lv
  LV Name                backup-lv
  VG Name                backup-vg
  LV UUID                3jC45G-1X5Z-VAJN-O2QK-2bVf-4P9C-p1Qvjl
  LV Write Access        read/write
  LV Creation host, time standalone-n1.unidev.org.com, 2025-01-08 19:58:45 +0545
  LV Status              available
  # open                 0
  LV Size                49.91 GiB
  Current LE             6389
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:9
*/

-- Step 11.29 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mkfs.xfs -f /dev/mapper/data--vg-data--lv
/*
meta-data=/dev/mapper/data--vg-data--lv isize=512    agcount=4, agsize=3271168 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13084672, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
*/

-- Step 11.30 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mkfs.xfs -f /dev/mapper/backup--vg-backup--lv
/*
meta-data=/dev/mapper/backup--vg-backup--lv isize=512    agcount=4, agsize=3271168 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13084672, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Discarding blocks...Done.
*/

-- Step 11.31 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:0    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:1    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:2    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:3    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:4    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:5    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:6    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:7    0   20G  0 lvm  [SWAP]
sdb                              8:16   0   50G  0 disk
└─sdb1                           8:17   0   50G  0 part
  └─data--vg-data--lv          252:8    0 49.9G  0 lvm
sdc                              8:32   0   50G  0 disk
└─sdc1                           8:33   0   50G  0 part
  └─backup--vg-backup--lv      252:9    0 49.9G  0 lvm
sr0                             11:0    1 1024M  0 rom
*/

-- Step 11.32 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# blkid | grep -E "data|backup"
/*
/dev/mapper/data--vg-data--lv: UUID="3766f1d8-28c4-4d19-a836-696dd60b09f4" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/backup--vg-backup--lv: UUID="ea3852bc-b141-4220-ba51-2a1a7292736d" BLOCK_SIZE="512" TYPE="xfs"
*/

-- Step 11.33 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mkdir -p /data

-- Step 11.34 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mkdir -p /backup

-- Step 11.35 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mount /dev/mapper/data--vg-data--lv /data

-- Step 11.36 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mount /dev/mapper/backup--vg-backup--lv /backup

-- Step 11.37 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  1.6G  1.6M  1.6G   1% /run
/dev/mapper/gda--vg0-gda--lv--root                                                           xfs     49G  998M   48G   2% /
/dev/disk/by-id/dm-uuid-LVM-YXZGbCV3N2DrcudZ1TIkTPAcJryZuHjxZBoay929HzDWfXBycrxzaecxTed6EU3d xfs     10G  2.6G  7.4G  27% /usr
tmpfs                                                                                        tmpfs  7.8G     0  7.8G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/gda--vg0-gda--lv--home                                                           xfs     10G  228M  9.8G   3% /home
/dev/mapper/gda--vg0-gda--lv--tmp                                                            xfs     10G  228M  9.8G   3% /tmp
/dev/mapper/gda--vg0-gda--lv--srv                                                            xfs     10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg0-gda--lv--var                                                            xfs     10G  429M  9.6G   5% /var
/dev/mapper/gda--vg0-gda--lv--var--lib                                                       xfs     10G  427M  9.6G   5% /var/lib
/dev/sda2                                                                                    xfs    960M  234M  727M  25% /boot
tmpfs                                                                                        tmpfs  1.6G   12K  1.6G   1% /run/user/1000
/dev/mapper/data--vg-data--lv                                                                xfs     50G 1010M   49G   2% /data
/dev/mapper/backup--vg-backup--lv                                                            xfs     50G 1010M   49G   2% /backup
*/

-- Step 11.38 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# vi /etc/fstab
/*
# data
/dev/mapper/data--vg-data--lv /data xfs defaults 0 1
# backup
/dev/mapper/backup--vg-backup--lv /backup xfs defaults 0 1
*/

-- Step 11.39 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# umount /data

-- Step 11.40 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# umount /backup

-- Step 11.41 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# systemctl daemon-reload

-- Step 11.42 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# mount -a

-- Step 11.43 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:0    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:1    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:2    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:3    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:4    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:5    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:6    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:7    0   20G  0 lvm  [SWAP]
sdb                              8:16   0   50G  0 disk
└─sdb1                           8:17   0   50G  0 part
  └─data--vg-data--lv          252:8    0 49.9G  0 lvm  /data
sdc                              8:32   0   50G  0 disk
└─sdc1                           8:33   0   50G  0 part
  └─backup--vg-backup--lv      252:9    0 49.9G  0 lvm  /backup
sr0                             11:0    1 1024M  0 rom
*/

-- Step 11.44 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# init 6

-- Step 11.45 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# df -Th
/*
Filesystem                                                                                   Type   Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs  1.6G  1.6M  1.6G   1% /run
/dev/mapper/gda--vg0-gda--lv--root                                                           xfs     49G  998M   48G   2% /
/dev/disk/by-id/dm-uuid-LVM-YXZGbCV3N2DrcudZ1TIkTPAcJryZuHjxZBoay929HzDWfXBycrxzaecxTed6EU3d xfs     10G  2.6G  7.4G  27% /usr
tmpfs                                                                                        tmpfs  7.8G     0  7.8G   0% /dev/shm
tmpfs                                                                                        tmpfs  5.0M     0  5.0M   0% /run/lock
/dev/mapper/backup--vg-backup--lv                                                            xfs     50G 1010M   49G   2% /backup
/dev/mapper/data--vg-data--lv                                                                xfs     50G 1010M   49G   2% /data
/dev/mapper/gda--vg0-gda--lv--var                                                            xfs     10G  453M  9.5G   5% /var
/dev/mapper/gda--vg0-gda--lv--srv                                                            xfs     10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg0-gda--lv--home                                                           xfs     10G  228M  9.8G   3% /home
/dev/mapper/gda--vg0-gda--lv--tmp                                                            xfs     10G  228M  9.8G   3% /tmp
/dev/mapper/gda--vg0-gda--lv--var--lib                                                       xfs     10G  429M  9.6G   5% /var/lib
/dev/sda2                                                                                    xfs    960M  234M  727M  25% /boot
tmpfs                                                                                        tmpfs  1.6G   12K  1.6G   1% /run/user/1000
*/

-- Step 11.46 -->> On Node 1 (LVM Partition)
root@standalone-n1 :~# lsblk
/*
NAME                           MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda                              8:0    0  130G  0 disk
├─sda1                           8:1    0    1M  0 part
├─sda2                           8:2    0    1G  0 part /boot
└─sda3                           8:3    0  129G  0 part
  ├─gda--vg0-gda--lv--root     252:2    0   49G  0 lvm  /
  ├─gda--vg0-gda--lv--home     252:3    0   10G  0 lvm  /home
  ├─gda--vg0-gda--lv--srv      252:4    0   10G  0 lvm  /srv
  ├─gda--vg0-gda--lv--usr      252:5    0   10G  0 lvm  /usr
  ├─gda--vg0-gda--lv--var      252:6    0   10G  0 lvm  /var
  ├─gda--vg0-gda--lv--var--lib 252:7    0   10G  0 lvm  /var/lib
  ├─gda--vg0-gda--lv--tmp      252:8    0   10G  0 lvm  /tmp
  └─gda--vg0-gda--lv--swap     252:9    0   20G  0 lvm  [SWAP]
sdb                              8:16   0   50G  0 disk
└─sdb1                           8:17   0   50G  0 part
  └─data--vg-data--lv          252:0    0 49.9G  0 lvm  /data
sdc                              8:32   0   50G  0 disk
└─sdc1                           8:33   0   50G  0 part
  └─backup--vg-backup--lv      252:1    0 49.9G  0 lvm  /backup
sr0                             11:0    1 1024M  0 rom
*/

-- Step 12 -->> On Node 1
root@standalone-n1 :~# vi /etc/sudoers
/*
%sudo   ALL=(ALL:ALL) ALL
*/

-- Step 12.1 -->> On Node 1
root@standalone-n1 :~# cat /etc/sudoers | grep -E "%sudo   ALL=\(ALL:ALL\) ALL"
/*
%sudo  ALL=(ALL:ALL) ALL
*/

-- Step 13 -->> On Node 1
root@standalone-n1 :~# useradd -G sudo postgres

-- Step 14 -->> On Node 1
root@standalone-n1 :~# usermod -a -G sudo postgres

-- Step 15 -->> On Node 1
root@standalone-n1 :~# vi /etc/sudoers
/*
# Postgres User
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 16 -->> On Node 1
root@standalone-n1 :~# cat /etc/sudoers | grep -E "postgres  ALL=\(ALL:ALL\) ALL"
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 17 -->> On Node 1
root@standalone-n1 :~# apt update
root@standalone-n1 :~# apt -y upgrade
root@standalone-n1 :~# apt update && apt -y full-upgrade
root@standalone-n1 :~# apt -y install vim curl wget gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates
root@standalone-n1 :~# apt policy postgresql
/*
postgresql:
  Installed: (none)
  Candidate: 16+257build1.1
  Version table:
     16+257build1.1 500
        500 http://archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages
     16+257build1 500
        500 http://archive.ubuntu.com/ubuntu noble/main amd64 Packages
*/

---- Step 18 -->> On Node 1 (Add the PostgreSQL 17 repository:)
root@standalone-n1 :~# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

---- Step 19 -->> On Node 1 (Import the repository signing key:)
root@standalone-n1 :~# curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
root@standalone-n1 :~# apt  update

---- Step 20 -->> On Node 1 (Install PostgreSQL 17 and contrib modules:)
root@standalone-n1 :~# apt install postgresql-17
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
0 upgraded, 13 newly installed, 0 to remove and 6 not upgraded.
Need to get 46.1 MB of archives.
After this operation, 195 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-common all 267.pgdg24.04+1 [36.5 kB]
Get:2 http://archive.ubuntu.com/ubuntu noble/main amd64 libjson-perl all 4.10000-1 [81.9 kB]
Get:3 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-common all 267.pgdg24.04+1 [169 kB]
Get:4 http://archive.ubuntu.com/ubuntu noble/main amd64 libio-pty-perl amd64 1:1.20-1build2 [31.2 kB]
Get:5 http://archive.ubuntu.com/ubuntu noble/main amd64 libipc-run-perl all 20231003.0-1 [92.1 kB]
Get:6 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 libpq5 amd64 17.2-1.pgdg24.04+1 [224 kB]
Get:7 http://archive.ubuntu.com/ubuntu noble/main amd64 ssl-cert all 1.1.2ubuntu1 [17.8 kB]
Get:8 http://archive.ubuntu.com/ubuntu noble/main amd64 libcommon-sense-perl amd64 3.75-3build3 [20.4 kB]
Get:9 http://archive.ubuntu.com/ubuntu noble/main amd64 libtypes-serialiser-perl all 1.01-1 [11.6 kB]
Get:10 http://archive.ubuntu.com/ubuntu noble/main amd64 libjson-xs-perl amd64 4.030-2build3 [83.6 kB]
Get:11 http://archive.ubuntu.com/ubuntu noble/main amd64 libllvm17t64 amd64 1:17.0.6-9ubuntu1 [26.2 MB]
Get:12 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-17 amd64 17.2-1.pgdg24.04+1 [1,994 kB]
Get:13 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-17 amd64 17.2-1.pgdg24.04+1 [17.2 MB]
Fetched 46.1 MB in 10min 59s (70.0 kB/s)
Preconfiguring packages ...
Selecting previously unselected package libjson-perl.
(Reading database ... 124488 files and directories currently installed.)
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
selecting default time zone ... Asia/Kathmandu
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.3) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
*/

-- Step 21 -->> On Node 1
root@standalone-n1 :~# systemctl enable postgresql
/*
Synchronizing state of postgresql.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable postgresql
*/

-- Step 22 -->> On Node 1
root@standalone-n1 :~# systemctl start postgresql

-- Step 22.1 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-01-08 20:22:36 +0545; 1h 12min ago
   Main PID: 4260 (code=exited, status=0/SUCCESS)
        CPU: 14ms

Jan 08 20:22:36 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 20:22:36 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 23 -->> On Node 1
root@standalone-n1 :~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 24 -->> On Node 1
root@standalone-n1 :~# su - postgres
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
root@standalone-n1 :~# ll /home/
/*
drwxr-xr-x  3 root     root       22 Jan  8 18:58 ./
drwxr-xr-x 24 root     root     4096 Jan  8 20:03 ../
drwxr-x---  4 sysadmin sysadmin  137 Jan  8 19:03 sysadmin/
*/

-- Step 24.2 -->> On Node 1
root@standalone-n1 :~# mkdir -p /home/postgres
root@standalone-n1 :~# chown postgres:postgres /home/postgres
root@standalone-n1 :~# chmod 755 /home/postgres

-- Step 24.3 -->> On Node 1
root@standalone-n1 :~# vi /etc/passwd
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On Node 1
root@standalone-n1 :~# cat /etc/passwd | grep -i "postgres:x:1001:1001::/home/postgres:/bin/bash"
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 26 -->> On Node 1
root@standalone-n1 :~# su - postgres
/*
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
*/

-- Step 26.1 -->> On Node 1
postgres@standalone-n1 :~$ psql
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
postgres@standalone-n1 :~$ exit
/*
logout
*/

-- Step 27 -->> On Node 1 (Default Location)
root@standalone-n1 :~# ll /var/lib/postgresql/17/main/
/*
drwx------ 19 postgres postgres 4096 Jan  8 20:22 ./
drwxr-xr-x  3 postgres postgres   18 Jan  8 20:22 ../
drwx------  5 postgres postgres   33 Jan  8 20:22 base/
drwx------  2 postgres postgres 4096 Jan  8 21:35 global/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_commit_ts/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_dynshmem/
drwx------  4 postgres postgres   68 Jan  8 20:27 pg_logical/
drwx------  4 postgres postgres   36 Jan  8 20:22 pg_multixact/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_notify/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_replslot/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_serial/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_snapshots/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_stat/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_stat_tmp/
drwx------  2 postgres postgres   18 Jan  8 20:22 pg_subtrans/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_tblspc/
drwx------  2 postgres postgres    6 Jan  8 20:22 pg_twophase/
-rw-------  1 postgres postgres    3 Jan  8 20:22 PG_VERSION
drwx------  4 postgres postgres   77 Jan  8 20:22 pg_wal/
drwx------  2 postgres postgres   18 Jan  8 20:22 pg_xact/
-rw-------  1 postgres postgres   88 Jan  8 20:22 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Jan  8 20:22 postmaster.opts
-rw-------  1 postgres postgres  108 Jan  8 20:22 postmaster.pid
*/

-- Step 28 -->> On Node 1 (Configure New Location)
root@standalone-n1 :~# mkdir -p /data/postgres/17/data
root@standalone-n1 :~# cd /data/
root@standalone-n1 :/data# chown -R postgres:postgres postgres/
root@standalone-n1 :/data# chmod -R 750 postgres/

-- Step 28.1 -->> On Node 1
root@standalone-n1 :~# ll /data/postgres/17/data/
/*
drwxr-x--- 2 postgres postgres  6 Jan  3 17:46 ./
drwxr-x--- 3 postgres postgres 18 Jan  3 17:46 ../
*/

-- Step 28.2 -->> On Node 1
root@standalone-n1 :~# systemctl stop postgresql

-- Step 28.3 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Wed 2025-01-08 21:38:12 +0545; 3s ago
   Duration: 1h 15min 36.114s
   Main PID: 4260 (code=exited, status=0/SUCCESS)
        CPU: 14ms

Jan 08 20:22:36 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 20:22:36 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 08 21:38:12 standalone-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 08 21:38:12 standalone-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 28.4 -->> On Node 1 (allow remote connections by changing listen_addresses to *:)
root@standalone-n1 :~# cp /etc/postgresql/17/main/postgresql.conf /etc/postgresql/17/main/postgresql.conf.bk
root@standalone-n1 :~# ll /etc/postgresql/17/main/ | grep postgresql
/*
-rw-r--r-- 1 postgres postgres 30977 Jan  8 20:22 postgresql.conf
-rw-r--r-- 1 root     root     30977 Jan  8 21:38 postgresql.conf.bk
*/

-- Step 28.5 -->> On Node 1
root@standalone-n1 :~# cd /etc/postgresql/17/main/

-- Step 28.6 -->> On Node 1
root@standalone-n1 :/etc/postgresql/17/main# vi postgresql.conf
/*
data_directory = '/data/postgres/17/data'  # use data in another directory
max_connections = 500                   # (change requires restart)
shared_buffers = 4GB                    # min 128kB
*/

-- Step 28.7 -->> On Node 1
root@standalone-n1 :/etc/postgresql/17/main# cat postgresql.conf | grep -E "data_directory|max_connections = 500|shared_buffers = 4GB"
/*
data_directory = '/data/postgres/17/data'  # use data in another directory
max_connections = 500                   # (change requires restart)
shared_buffers = 4GB                    # min 128kB
*/

-- Step 28.8 -->> On Node 1
root@standalone-n1 :~# cd /var/lib/postgresql/17/main
root@standalone-n1 :/var/lib/postgresql/17/main# cp -r * /data/postgres/17/data/

-- Step 28.9 -->> On Node 1
root@standalone-n1 :/var/lib/postgresql/17/main# ls -ltr /data/postgres/17/data/
/*
total 16
drwx------ 5 root root   33 Jan  8 21:42 base
drwx------ 2 root root    6 Jan  8 21:42 pg_notify
drwx------ 4 root root   36 Jan  8 21:42 pg_multixact
drwx------ 4 root root   68 Jan  8 21:42 pg_logical
drwx------ 2 root root    6 Jan  8 21:42 pg_dynshmem
drwx------ 2 root root    6 Jan  8 21:42 pg_commit_ts
drwx------ 2 root root 4096 Jan  8 21:42 global
drwx------ 4 root root   77 Jan  8 21:42 pg_wal
-rw------- 1 root root    3 Jan  8 21:42 PG_VERSION
drwx------ 2 root root    6 Jan  8 21:42 pg_twophase
drwx------ 2 root root    6 Jan  8 21:42 pg_tblspc
drwx------ 2 root root   18 Jan  8 21:42 pg_subtrans
drwx------ 2 root root    6 Jan  8 21:42 pg_stat_tmp
drwx------ 2 root root   25 Jan  8 21:42 pg_stat
drwx------ 2 root root    6 Jan  8 21:42 pg_snapshots
drwx------ 2 root root    6 Jan  8 21:42 pg_serial
drwx------ 2 root root    6 Jan  8 21:42 pg_replslot
-rw------- 1 root root  130 Jan  8 21:42 postmaster.opts
-rw------- 1 root root   88 Jan  8 21:42 postgresql.auto.conf
drwx------ 2 root root   18 Jan  8 21:42 pg_xact
*/

-- Step 28.10 -->> On Node 1
root@standalone-n1 :/var/lib/postgresql/17/main# rm -rf *

-- Step 28.11 -->> On Node 1
root@standalone-n1 :~# cd /data/postgres/17/data/

-- Step 28.12 -->> On Node 1
root@standalone-n1 :/data/postgres/17/data# chown -R postgres:postgres *

-- Step 28.13 -->> On Node 1
root@standalone-n1 :/data/postgres/17/data# ll
/*
drwxr-x--- 19 postgres postgres 4096 Jan  8 21:42 ./
drwxr-x---  3 postgres postgres   18 Jan  8 21:37 ../
drwx------  5 postgres postgres   33 Jan  8 21:42 base/
drwx------  2 postgres postgres 4096 Jan  8 21:42 global/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_commit_ts/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_dynshmem/
drwx------  4 postgres postgres   68 Jan  8 21:42 pg_logical/
drwx------  4 postgres postgres   36 Jan  8 21:42 pg_multixact/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_notify/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_replslot/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_serial/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_snapshots/
drwx------  2 postgres postgres   25 Jan  8 21:42 pg_stat/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_stat_tmp/
drwx------  2 postgres postgres   18 Jan  8 21:42 pg_subtrans/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_tblspc/
drwx------  2 postgres postgres    6 Jan  8 21:42 pg_twophase/
-rw-------  1 postgres postgres    3 Jan  8 21:42 PG_VERSION
drwx------  4 postgres postgres   77 Jan  8 21:42 pg_wal/
drwx------  2 postgres postgres   18 Jan  8 21:42 pg_xact/
-rw-------  1 postgres postgres   88 Jan  8 21:42 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Jan  8 21:42 postmaster.opts
*/

-- Step 28.14 -->> On Node 1
root@standalone-n1 :~# du -sh /data/postgres/17/data/
/*
39M     /data/postgres/17/data/
*/

-- Step 28.15 -->> On Node 1
root@standalone-n1 :~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 28.16 -->> On Node 1
root@standalone-n1 :~# systemctl start postgresql

-- Step 28.17 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-01-08 21:43:41 +0545; 3s ago
    Process: 5703 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5703 (code=exited, status=0/SUCCESS)
        CPU: 2ms

Jan 08 21:43:41 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 21:43:41 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

root@standalone-n1 :~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2025-01-08 21:38:12.248 +0545 [5150] LOG:  background worker "logical replication launcher" (PID 5156) exited with exit code 1
2025-01-08 21:38:12.252 +0545 [5151] LOG:  shutting down
2025-01-08 21:38:12.252 +0545 [5151] LOG:  checkpoint starting: shutdown immediate
2025-01-08 21:38:12.254 +0545 [5151] LOG:  checkpoint complete: wrote 0 buffers (0.0%); 0 WAL file(s) added, 0 removed, 0 recycled; write=0.001 s, sync=0.001 s, total=0.003 s; sync files=0, longest=0.000 s, average=0.000 s; distance=0 kB, estimate=242 kB; lsn=0/152DE48, redo lsn=0/152DE48
2025-01-08 21:38:12.264 +0545 [5150] LOG:  database system is shut down
2025-01-08 21:43:39.187 +0545 [5685] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2025-01-08 21:43:39.187 +0545 [5685] LOG:  listening on IPv4 address "127.0.0.1", port 5432
2025-01-08 21:43:39.188 +0545 [5685] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2025-01-08 21:43:39.194 +0545 [5688] LOG:  database system was shut down at 2025-01-08 21:38:12 +0545
2025-01-08 21:43:39.209 +0545 [5685] LOG:  database system is ready to accept connections
*/

-- Step 29 -->> On Node 1
root@standalone-n1 :~# su - postgres
postgres@standalone-n1 :~$ psql
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

postgres=# ALTER USER postgres PASSWORD 'Sys#605014#';
ALTER ROLE

postgres=# CREATE ROLE root WITH LOGIN SUPERUSER PASSWORD 'Sys#605014#';

postgres=# CREATE DATABASE gdaengine;
CREATE DATABASE

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 gdaengine | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".

gdaengine=# CREATE SCHEMA gdaauth;
CREATE SCHEMA

gdaengine=# CREATE SCHEMA gdapii;
CREATE SCHEMA

gdaengine=# \q
*/

-- Step 30 -->> On Node 1
root@standalone-n1 :~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 31 -->> On Node 1
root@standalone-n1 :~# du -sh /data/postgres/17/data/
/*
44M     /data/postgres/17/data/
*/

-- Step 32 -->> On Node 1
root@standalone-n1 :~# systemctl stop postgresql

-- Step 33 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Wed 2025-01-08 21:55:01 +0545; 4s ago
   Duration: 11min 19.708s
    Process: 5703 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5703 (code=exited, status=0/SUCCESS)
        CPU: 2ms

Jan 08 21:43:41 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 21:43:41 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 08 21:55:01 standalone-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 08 21:55:01 standalone-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 34 -->> On Node 1
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
listen_addresses = '*'                  # what IP address(es) to listen on;
*/

-- Step 34.1 -->> On Node 1
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -i "listen_addresses = '*'"
/*
listen_addresses = '*'                  # what IP address(es) to listen on;
*/

-- Step 35 -->> On Node 1 (Configure PostgreSQL to use md5 password authentication by editing pg_hba.conf , this is important if you wish to connect remotely e.g. via PGADMIN :)
root@standalone-n1 :~# sed -i '/^host/s/ident/md5/' /etc/postgresql/17/main/pg_hba.conf
root@standalone-n1 :~# sed -i '/^local/s/peer/trust/' /etc/postgresql/17/main/pg_hba.conf
root@standalone-n1 :~# echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf

-- Step 36 -->> On Node 1
root@standalone-n1 :~# systemctl start postgresql

-- Step 37 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-01-08 21:57:33 +0545; 3s ago
    Process: 5867 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5867 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 08 21:57:33 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 21:57:33 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 38 -->> On Node 1
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "port = 5432"
/*
port = 5432                             # (change requires restart)
*/

-- Step 39 -->> On Node 1
root@standalone-n1 :~# ufw status
/*
Status: inactive
*/

-- Step 40 -->> On Node 1
root@standalone-n1 :~# ufw enable
/*
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
*/

-- Step 41 -->> On Node 1
root@standalone-n1 :~# systemctl start ufw

-- Step 42 -->> On Node 1
root@standalone-n1 :~# systemctl status ufw
/*
● ufw.service - Uncomplicated firewall
     Loaded: loaded (/usr/lib/systemd/system/ufw.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-01-08 20:06:05 +0545; 1h 52min ago
       Docs: man:ufw(8)
   Main PID: 953 (code=exited, status=0/SUCCESS)
        CPU: 11ms

Jan 08 20:06:05 standalone-n1.unidev.org.com systemd[1]: Starting ufw.service - Uncomplicated firewall...
Jan 08 20:06:05 standalone-n1.unidev.org.com systemd[1]: Finished ufw.service - Uncomplicated firewall.
*/

-- Step 43 -->> On Node 1
root@standalone-n1 :~# ufw status
/*
Status: active
*/

-- Step 43.1 -->> On Node 1
root@standalone-n1 :~# ufw allow 5432/tcp
/*
Rule added
Rule added (v6)
*/

-- Step 43.2 -->> On Node 1
root@standalone-n1 :~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
5432/tcp (v6)              ALLOW       Anywhere (v6)
*/

-- Step 43.3 -->> On Node 1
root@standalone-n1 :~# ufw allow from 10.0.131.3 to any port 22 proto tcp
/*
Rule added
*/

-- Step 43.4 -->> On Node 1
root@standalone-n1 :~# ufw reload
/*
Firewall reloaded
*/

-- Step 43.5 -->> On Node 1
root@standalone-n1 :~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
22/tcp                     ALLOW       10.0.131.3
5432/tcp (v6)              ALLOW       Anywhere (v6)
*/

-- Step 43.6 -->> On Node 1
root@standalone-n1 :~# ufw allow 22/tcp
/*
Rule added
Rule added (v6)
*/

-- Step 43.7 -->> On Node 1
root@standalone-n1 :~# ufw reload
/*
Firewall reloaded
*/

-- Step 43.8 -->> On Node 1
root@standalone-n1 :~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
22/tcp                     ALLOW       10.0.131.3
22/tcp                     ALLOW       Anywhere
5432/tcp (v6)              ALLOW       Anywhere (v6)
22/tcp (v6)                ALLOW       Anywhere (v6)
*/

-- Step 44 -->> On Node 1
-- Prerequisites for Base Backup of Postgres: Ensure Write-Ahead Logging (WAL) is enabled:
postgres@standalone-n1 :~$ mkdir -p /backup/archive
postgres@standalone-n1 :~$ psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 gdaengine | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM

postgres=# ALTER SYSTEM SET archive_mode = 'on';
ALTER SYSTEM

postgres=# ALTER SYSTEM SET archive_command = 'cp %p /backup/archive/%f';
ALTER SYSTEM

postgres=# SELECT pg_reload_conf();
 pg_reload_conf
----------------
 t
(1 row)

postgres=# ALTER SYSTEM SET summarize_wal = 'on';
ALTER SYSTEM

postgres=# SELECT pg_reload_conf();
 pg_reload_conf
----------------
 t
(1 row)

postgres=# \q
*/


-- Step 0 -->> On Node 1 (Tuning of Postgresql)
root@standalone-n1 :~# systemctl stop postgresql

-- Step 0.1 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Wed 2025-01-08 22:01:11 +0545; 5s ago
   Duration: 3min 37.134s
    Process: 5867 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 5867 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 08 21:57:33 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 21:57:33 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 08 22:01:11 standalone-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 08 22:01:11 standalone-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 1 -->> On Node 1 - Memory Tuning 
-- Shared Buffers (shared_buffers = 25% of your total RAM)
-- Work Mem (set this based on your available RAM and the number of concurrent connections)
-- Maintenance Work Mem (This setting controls the memory available for maintenance operations such as VACUUM, CREATE INDEX, and ALTER TABLE. For a system with larger data sets, increasing this can speed up these tasks)
-- Effective Cache Size (set this to around 50-75% of your total system memory)
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
shared_buffers = 4GB                    # min 128kB
work_mem = 1024MB                       # min 64kB
maintenance_work_mem = 2GB              # min 64kB
effective_cache_size = 12GB
*/

-- Step 1.1 -->> On Node 1 - Memory Tuning - Verification 
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "shared_buffers = 4GB|work_mem = 1024MB|maintenance_work_mem = 2GB|effective_cache_size = 12GB"
/*
shared_buffers = 4GB                    # min 128kB
work_mem = 1024MB                       # min 64kB
maintenance_work_mem = 2GB              # min 64kB
effective_cache_size = 12GB
*/


-- Step 2 -->> On Node 1 - Disk I/O Tuning - (Checkpoint Settings)
--Checkpoints are moments when all data is flushed to disk. Optimizing these reduces disk I/O pressure during peak times.
--checkpoint_segments: Controls the number of log segments between checkpoints. Increasing this reduces the frequency of checkpoints.
--checkpoint_timeout: Increases the time between checkpoints.
--checkpoint_completion_target: Controls how aggressively PostgreSQL writes dirty buffers to disk between checkpoints. A higher value smooths disk I/O load.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
checkpoint_timeout = 15min              # range 30s-1d
checkpoint_completion_target = 0.9      # checkpoint target duration, 0.0 - 1.0
checkpoint_warning = 30s                # 0 disables
max_wal_size = 2GB
*/

-- Step 2.1 -->> On Node 1 - Disk I/O Tuning - (Checkpoint Settings) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "checkpoint_timeout = 15min|checkpoint_completion_target = 0.9|checkpoint_warning = 30s|max_wal_size = 2GB"
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
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
wal_buffers = 16MB                      # min 32kB, -1 sets based on shared_buffers
wal_writer_delay = 500ms                # 1-10000 milliseconds
*/

-- Step 3.1 -->> On Node 1 - Disk I/O Tuning - (WAL Settings) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "wal_buffers = 16MB|wal_writer_delay = 500ms"
/*
wal_buffers = 16MB                      # min 32kB, -1 sets based on shared_buffers
wal_writer_delay = 500ms                # 1-10000 milliseconds
*/

-- Step 4 -->> On Node 1 - Disk I/O Tuning - (Random Page Cost)
--random_page_cost tells PostgreSQL how expensive it is to read a page randomly from disk versus sequentially. If you have fast SSDs, you can lower this to improve index usage.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
random_page_cost = 1.1                  # Default is 4; 1.1 or 1.5 is recommended for SSDs
*/

-- Step 4.1 -->> On Node 1 - Disk I/O Tuning - (Random Page Cost) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "random_page_cost = 1.1"
/*
random_page_cost = 1.1                  # Default is 4; 1.1 or 1.5 is recommended for SSDs
*/

-- Step 5 -->> On Node 1 - Disk I/O Tuning - (Sequential Page Cost)
--seq_page_cost is the cost of reading a page sequentially. Lowering this value makes PostgreSQL prefer sequential scans.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
seq_page_cost = 1.0                     # measured on an arbitrary scale
*/

-- Step 5.1 -->> On Node 1 - Disk I/O Tuning - (Sequential Page Cost) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "seq_page_cost = 1.0"
/*
seq_page_cost = 1.0                     # measured on an arbitrary scale
*/

-- Step 6 -->> On Node 1 - Connection Tuning - (Max Connections)
--Tuning connection settings is crucial for systems with many concurrent users.
--max_connections defines the maximum number of concurrent connections to the database. Having too many connections can cause resource contention. 
--Use a connection pooler like pgbouncer to manage connections efficiently.
--Connection Pooling - Consider using pgbouncer or another connection pooler to handle large numbers of short-lived connections efficiently.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_connections = 500                   # Based on system resources and usage patterns
*/

-- Step 6.1 -->> On Node 1 - Connection Tuning - (Max Connections) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_connections = 200"
/*
max_connections = 500                   # Based on system resources and usage patterns
*/

-- Step 7 -->> On Node 1 - Autovacuum Tuning - (Autovacuum Settings)
--The autovacuum process automatically reclaims storage by cleaning up dead rows. However, its default configuration can lead to poor performance if not tuned.
--autovacuum_vacuum_cost_delay: Increase this to reduce the impact of autovacuum on performance.
--autovacuum_max_workers: The number of autovacuum processes that can run in parallel.
--autovacuum_vacuum_threshold and autovacuum_analyze_threshold: Lower these values to trigger more frequent vacuums and analyze runs.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
autovacuum_vacuum_cost_delay = 10ms     # default vacuum cost delay for (Lower this to decrease autovacuum impact)
autovacuum_max_workers = 6              # max number of autovacuum subprocesses (Increase for larger systems)
autovacuum_vacuum_scale_factor = 0.2    # fraction of table size before vacuum (Set lower to vacuum more frequently)
autovacuum_analyze_scale_factor = 0.1   # fraction of table size before analyze (Set lower to analyze more frequently)
*/

-- Step 7.1 -->> On Node 1 - Autovacuum Tuning - (Autovacuum Settings) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "autovacuum_vacuum_cost_delay = 10ms|autovacuum_max_workers = 6|autovacuum_vacuum_scale_factor = 0.2|autovacuum_analyze_scale_factor = 0.1"
/*
autovacuum_vacuum_cost_delay = 10ms     # default vacuum cost delay for (Lower this to decrease autovacuum impact)
autovacuum_max_workers = 6              # max number of autovacuum subprocesses (Increase for larger systems)
autovacuum_vacuum_scale_factor = 0.2    # fraction of table size before vacuum (Set lower to vacuum more frequently)
autovacuum_analyze_scale_factor = 0.1   # fraction of table size before analyze (Set lower to analyze more frequently)
*/

-- Step 8 -->> On Node 1 - Query Planner Tuning - (Enable JIT Compilation)
--PostgreSQL 17 supports Just-In-Time (JIT) compilation for faster query execution. Enabling this can improve performance for complex queries.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
jit = on                                # allow JIT compilation
*/

-- Step 8.1 -->> On Node 1 - Query Planner Tuning - (Enable JIT Compilation) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "jit = on"
/*
jit = on                                # allow JIT compilation
*/

-- Step 9 -->> On Node 1 - Query Planner Tuning - (Parallel Queries)
--PostgreSQL can run queries in parallel across multiple CPUs, which can speed up large scans and joins. Tuning the number of workers is crucial for improving query performance.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_parallel_workers_per_gather = 4     # limited by max_parallel_workers (Set based on available CPU cores)
max_worker_processes = 8                # (change requires restart)
max_parallel_workers = 8                # number of max_worker_processes that
*/

-- Step 9.1 -->> On Node 1 - Query Planner Tuning - (Parallel Queries) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_parallel_workers_per_gather = 4|max_worker_processes = 8|max_parallel_workers = 8"
/*
max_parallel_workers_per_gather = 4     # limited by max_parallel_workers (Set based on available CPU cores)
max_worker_processes = 8                # (change requires restart)
max_parallel_workers = 8                # number of max_worker_processes that
*/

-- Step 10 -->> On Node 1 - Logging and Monitoring - (Log Slow Queries)
--Tuning PostgreSQL's logging can help track slow queries and detect bottlenecks.
--Log any query that exceeds a certain duration to help identify performance issues.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
log_min_duration_statement = 1000       # -1 is disabled, 0 logs all statements (Logs queries taking longer than 1 second)
log_checkpoints = on
log_lock_waits = on                     # log lock waits >= deadlock_timeout
log_temp_files = 0                      # log temporary files equal or larger
*/

-- Step 10.1 -->> On Node 1 - Query Planner Tuning - (Log Slow Queries) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "log_min_duration_statement = 1000|log_checkpoints = on|log_lock_waits = on|log_temp_files = 0"
/*
log_min_duration_statement = 1000       # -1 is disabled, 0 logs all statements (Logs queries taking longer than 1 second)
log_checkpoints = on
log_lock_waits = on                     # log lock waits >= deadlock_timeout
log_temp_files = 0                      # log temporary files equal or larger
*/

-- Step 11 -->> On Node 1 - Logging and Monitoring - (Enable Stats Collection)
--Collecting statistics on database activity can provide insights into query patterns and index usage.
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
track_io_timing = on
track_activity_query_size = 2048        # (change requires restart)
track_functions = all                   # none, pl, all
*/

-- Step 11.1 -->> On Node 1 - Logging and Monitoring - (Enable Stats Collection) - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "track_io_timing = on|track_activity_query_size = 2048|track_functions = all"
/*
track_io_timing = on
track_activity_query_size = 2048        # (change requires restart)
track_functions = all                   # none, pl, all
*/

-- Step 12 -->> On Node 1 - File Descriptors
--Configure PostgreSQL’s max_files_per_process:
root@standalone-n1 :~# vi /etc/postgresql/17/main/postgresql.conf
/*
max_files_per_process = 10000           # min 64
*/

-- Step 12.1 -->> On Node 1 - File Descriptors - Verification
root@standalone-n1 :~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "max_files_per_process = 10000"
/*
max_files_per_process = 10000           # min 64
*/

-- Step 13 -->> On Node 1 - Kernel and OS Level Tuning - (Kernel Shared Memory-File Descriptors)
--Adjust the shared memory settings for PostgreSQL at the OS level.
--sudo sysctl -w kernel.shmmax=17179869184  # Set based on total system memory
--sudo sysctl -w kernel.shmall=4194304
--Increase the maximum number of file descriptors allowed for PostgreSQL. 
root@standalone-n1 :~# vi /etc/security/limits.conf
/*
* soft nofile 65536
* hard nofile 65536
*/

-- Step 13.1 -->> On Node 1 - Kernel and OS Level Tuning - (Kernel Shared Memory-File Descriptors) - Verification
root@standalone-n1 :~# cat /etc/security/limits.conf | grep -E "soft nofile 65536|hard nofile 65536"
/*
* soft nofile 65536
* hard nofile 65536
*/

-- Step 14 -->> On Node 1
root@standalone-n1 :~# systemctl start postgresql

-- Step 15 -->> On Node 1
root@standalone-n1 :~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Wed 2025-01-08 22:15:47 +0545; 4s ago
    Process: 6641 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6641 (code=exited, status=0/SUCCESS)
        CPU: 4ms

Jan 08 22:15:47 standalone-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 08 22:15:47 standalone-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 16 -->> On Node 1
root@standalone-n1 :~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \l
                                                     List of databases
   Name    |  Owner   | Encoding | Locale Provider |   Collate   |    Ctype    | Locale | ICU Rules |   Access privileges
-----------+----------+----------+-----------------+-------------+-------------+--------+-----------+-----------------------
 gdaengine | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \q
*/