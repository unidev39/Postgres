------------------------------------------------------------------------------------------------
------------------------Postgres Master Salve DB Server Configuration---------------------------
--->> Live-DB <<--------------------------------------------------------------------------------
--->> Server Hostname: master-n1.unidev.org.com,slave-n1.unidev.org.com<<-----------------------
--->> IP Address: 192.168.21.22/24,192.178.21.23/24 <<--------------------------------------------
--->> sysadmin/Sys#605014# <<-------------------------------------------------------------------
--->> postgres/Sys#605014# <<-------------------------------------------------------------------
--->> root/Sys#605014# <<-----------------------------------------------------------------------
--->> replica_user/Sys#605014# <<---------------------------------------------------------------
------------------------------------------------------------------------------------------------

-- Step 1 -->> On All Nodes 
root@master-n1/slave-n1:~# df -Th
/*
Filesystem                                                                                   Type      Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs     1.6G  1.4M  1.6G   1% /run
efivarfs                                                                                     efivarfs  256K   54K  198K  22% /sys/firmware/efi/efivars
/dev/mapper/gda--vg01-gda--lv--root                                                          xfs        48G  979M   47G   2% /
/dev/disk/by-id/dm-uuid-LVM-0m25Uf9hLfxXFptzs9MKLJtfiFpsrAy8rZUXLlzBNdVN4kdMFem6YAcQRCylJtU1 xfs        10G  2.3G  7.7G  24% /usr
tmpfs                                                                                        tmpfs     7.9G     0  7.9G   0% /dev/shm
tmpfs                                                                                        tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/mapper/gda--vg01-gda--lv--home                                                          xfs        10G  228M  9.8G   3% /home
/dev/mapper/gda--vg01-gda--lv--srv                                                           xfs        10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg01-gda--lv--var                                                           xfs        10G  379M  9.6G   4% /var
/dev/sda2                                                                                    xfs       960M  147M  814M  16% /boot
/dev/mapper/gda--vg01-gda--lv--tmp                                                           xfs        10G  228M  9.8G   3% /tmp
/dev/sda1                                                                                    vfat      1.1G  6.2M  1.1G   1% /boot/efi
/dev/mapper/gda--vg01-gda--lv--var--lib                                                      xfs        10G  425M  9.6G   5% /var/lib
tmpfs                                                                                        tmpfs     1.6G   12K  1.6G   1% /run/user/1000
*/


-- Step 2 -->> On All Nodes (Server Kernal version)
root@master-n1/slave-n1:~# uname -msr
/*
Linux 6.8.0-51-generic x86_64
*/

-- Step 3 -->> On All Nodes (Server Release)
root@master-n1/slave-n1:~# cat /etc/lsb-release
/*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.1 LTS"
*/

-- Step 4 -->> On All Nodes (Server Release)
root@master-n1/slave-n1:~# cat /etc/os-release
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
root@master-n1/slave-n1:~# vi /etc/hosts
/*
# Master Node 1 - DC
192.168.21.22  master-n1.unidev.org.com master-n1

# Slave Node 1 - DR
192.178.21.23  slave-n1.unidev.org.com  slave-n1
*/


-- Step 6 -->> On Node 1
root@master-n1:~# hostnamectl set-hostname master-n1.unidev.org.com

-- Step 6.1 -->> On Node 2
root@slave-n1:~# hostnamectl set-hostname slave-n1.unidev.org.com

-- Step 7 -->> On Node 1
root@master-n1:~# hostnamectl
/*
 Static hostname: master-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 06ab3df8184d4ddababc40f09c8af4e7
         Boot ID: b55db6eaa4ac43d8911b407969775d85
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware20,1
Firmware Version: VMW201.00V.20829224.B64.2211211842
   Firmware Date: Mon 2022-11-21
    Firmware Age: 2y 1month 2w 6d
*/

-- Step 7.1 -->> On Node 2
root@slave-n1:~# hostnamectl
/*
 Static hostname: slave-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 348ed1c2acdf474a8cd504d07a89b405
         Boot ID: 9a91d4745f0e451e9095e66cc9298bd2
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware20,1
Firmware Version: VMW201.00V.20829224.B64.2211211842
   Firmware Date: Mon 2022-11-21
    Firmware Age: 2y 1month 2w 6d
*/

-- Step 8 -->> On Node 1 (Ethernet Configuration)
root@master-n1:~# vi /etc/netplan/50-cloud-init.yaml
/*
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens33:
            addresses:
            - 192.168.21.22/24
            nameservers:
                addresses:
                - 192.168.1.11
                - 192.168.1.12
                search: []
            routes:
            -   to: default
                via: 192.168.21.1
    version: 2
*/

-- Step 8.1 -->> On Node 2 (Ethernet Configuration)
root@slave-n1:~# vi /etc/netplan/50-cloud-init.yaml
/*
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        ens33:
            addresses:
            - 192.178.21.23/24
            nameservers:
                addresses:
                - 192.168.1.11
                - 192.168.1.12
                search: []
            routes:
            -   to: default
                via: 192.168.21.1
    version: 2
*/

-- Step 9 -->> On All Nodes (Restart Network)
root@master-n1/slave-n1:~# systemctl restart network-online.target

-- Step 10 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# vi /etc/systemd/timesyncd.conf
/*
[Time]
NTP=192.178.21.23,192.178.21.24
FallbackNTP=ntp.ubuntu.com
*/

-- Step 10.1 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# timedatectl set-ntp true

-- Step 10.2 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# timedatectl set-timezone Asia/Kathmandu

-- Step 10.3 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# systemctl restart systemd-timesyncd.service

-- Step 10.4 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# systemctl enable systemd-timesyncd.service

-- Step 10.5 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# systemctl status systemd-timesyncd.service
/*
● systemd-timesyncd.service - Network Time Synchronization
     Loaded: loaded (/usr/lib/systemd/system/systemd-timesyncd.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-01-10 19:30:11 +0545; 10s ago
       Docs: man:systemd-timesyncd.service(8)
   Main PID: 1606 (systemd-timesyn)
     Status: "Idle."
      Tasks: 2 (limit: 19103)
     Memory: 1.3M (peak: 1.9M)
        CPU: 31ms
     CGroup: /system.slice/systemd-timesyncd.service
             └─1606 /usr/lib/systemd/systemd-timesyncd

Jan 10 19:30:11 master-n1.unidev.org.com systemd[1]: Starting systemd-timesyncd.service - Network Time Synchronization...
Jan 10 19:30:11 master-n1.unidev.org.com systemd[1]: Started systemd-timesyncd.service - Network Time Synchronization.
*/

-- Step 10.6 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# date
/*
Thu Jan  9 07:14:11 PM +0545 2025
*/

-- Step 10.7 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~#  vi /banner.txt
/*


WARNING!!!!

Welcome to the UNIDEV system.

Authorized Access Only.

This system is the property of UNIDEV.



*/

-- Step 10.8 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# vi /etc/ssh/sshd_config
/*
Banner /banner.txt
*/

-- Step 10.9 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# vi /etc/pam.d/sshd
/*
#session    optional     pam_motd.so  motd=/run/motd.dynamic
#session    optional     pam_motd.so noupdate
*/

-- Step 10.10 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# systemctl restart ssh.service

-- Step 10.11 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# systemctl status ssh.service
/*
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: active (running) since Fri 2025-01-10 19:33:19 +0545; 10s ago
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 1728 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 1730 (sshd)
      Tasks: 1 (limit: 19103)
     Memory: 1.2M (peak: 1.6M)
        CPU: 18ms
     CGroup: /system.slice/ssh.service
             └─1730 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 10 19:33:19 master-n1.unidev.org.com systemd[1]: Starting ssh.service - OpenBSD Secure Shell server...
Jan 10 19:33:19 master-n1.unidev.org.com sshd[1730]: Server listening on :: port 22.
Jan 10 19:33:19 master-n1.unidev.org.com systemd[1]: Started ssh.service - OpenBSD Secure Shell server.
*/

-- Step 10.12 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# sshd -t

-- Step 10.13 -->> On All Nodes (Hardening)
root@master-n1/slave-n1:~# init 6

-- Step 11 -->> On Node 1
root@master-n1:~# hostnamectl
/*
 Static hostname: master-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 06ab3df8184d4ddababc40f09c8af4e7
         Boot ID: 77a1b91a247149d7bc7bb09c9491ba82
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware20,1
Firmware Version: VMW201.00V.20829224.B64.2211211842
   Firmware Date: Mon 2022-11-21
    Firmware Age: 2y 1month 2w 6d
*/

-- Step 11.1 -->> On Node 2
root@slave-n1:~# hostnamectl
/*
 Static hostname: slave-n1.unidev.org.com
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: 348ed1c2acdf474a8cd504d07a89b405
         Boot ID: c8685b267e7548038ef2e49dc4246d83
  Virtualization: vmware
Operating System: Ubuntu 24.04.1 LTS
          Kernel: Linux 6.8.0-51-generic
    Architecture: x86-64
 Hardware Vendor: VMware, Inc.
  Hardware Model: VMware20,1
Firmware Version: VMW201.00V.20829224.B64.2211211842
   Firmware Date: Mon 2022-11-21
    Firmware Age: 2y 1month 2w 6d
*/

-- Step 11.2 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                               8:0    0   130G  0 disk
├─sda1                            8:1    0     1G  0 part /boot/efi
├─sda2                            8:2    0     1G  0 part /boot
└─sda3                            8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root     252:0    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home     252:1    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv      252:2    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr      252:3    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var      252:4    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib 252:5    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp      252:6    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap     252:7    0  19.9G  0 lvm  [SWAP]
sr0                              11:0    1  1024M  0 rom
*/

-- Step 11.3 -->> On All Nodes (LVM Partition)
-- Add Required Disk on DB Server manually 
root@master-n1/slave-n1:~# init 0

-- Step 11.4 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                               8:0    0   130G  0 disk
├─sda1                            8:1    0     1G  0 part /boot/efi
├─sda2                            8:2    0     1G  0 part /boot
└─sda3                            8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root     252:0    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home     252:1    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv      252:2    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr      252:3    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var      252:4    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib 252:5    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp      252:6    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap     252:7    0  19.9G  0 lvm  [SWAP]
sdb                               8:16   0    50G  0 disk
sdc                               8:32   0    50G  0 disk
sdd                               8:48   0    50G  0 disk
sr0                              11:0    1  1024M  0 rom
*/

-- Step 11.5 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# fdisk -ll | grep -E "sdb|sdc|sdd"
/*
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk /dev/sdd: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
*/

-- Step 11.6 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x957a5faa.

Command (m for help): p
Disk /dev/sdb: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x957a5faa

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
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
Disk identifier: 0x957a5faa

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
Disk identifier: 0x957a5faa

Device     Boot Start       End   Sectors Size Id Type
/dev/sdb1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 11.7 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x84b5f6f5.

Command (m for help): p
Disk /dev/sdc: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x84b5f6f5

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
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
Disk identifier: 0x84b5f6f5

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
Disk identifier: 0x84b5f6f5

Device     Boot Start       End   Sectors Size Id Type
/dev/sdc1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/


-- Step 11.8 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0xe47c6c93.

Command (m for help): p
Disk /dev/sdd: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-104857599, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-104857599, default 104857599):

Created a new partition 1 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdd: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Device     Boot Start       End   Sectors Size Id Type
/dev/sdd1        2048 104857599 104855552  50G 83 Linux

Command (m for help): t
Selected partition 1
Hex code or alias (type L to list all): 8E
Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdd: 50 GiB, 53687091200 bytes, 104857600 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Device     Boot Start       End   Sectors Size Id Type
/dev/sdd1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
*/

-- Step 11.9 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# partprobe /dev/sdb

-- Step 11.10 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# partprobe /dev/sdc

-- Step 11.11 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# partprobe /dev/sdd

-- Step 11.12 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                               8:0    0   130G  0 disk
├─sda1                            8:1    0     1G  0 part /boot/efi
├─sda2                            8:2    0     1G  0 part /boot
└─sda3                            8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root     252:0    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home     252:1    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv      252:2    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr      252:3    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var      252:4    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib 252:5    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp      252:6    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap     252:7    0  19.9G  0 lvm  [SWAP]
sdb                               8:16   0    50G  0 disk
└─sdb1                            8:17   0    50G  0 part
sdc                               8:32   0    50G  0 disk
└─sdc1                            8:33   0    50G  0 part
sdd                               8:48   0    50G  0 disk
└─sdd1                            8:49   0    50G  0 part
sr0                              11:0    1  1024M  0 rom
*/

-- Step 11.13 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvs
/*
  PV         VG       Fmt  Attr PSize    PFree
  /dev/sda3  gda-vg01 lvm2 a--  <127.95g    0
*/

-- Step 11.14 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgs
/*
  VG       #PV #LV #SN Attr   VSize    VFree
  gda-vg01   1   8   0 wz--n- <127.95g    0
*/

-- Step 11.15 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvs
/*
  LV             VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  gda-lv-home    gda-vg01 -wi-ao----  10.00g
  gda-lv-root    gda-vg01 -wi-ao----  48.00g
  gda-lv-srv     gda-vg01 -wi-ao----  10.00g
  gda-lv-swap    gda-vg01 -wi-ao---- <19.95g
  gda-lv-tmp     gda-vg01 -wi-ao----  10.00g
  gda-lv-usr     gda-vg01 -wi-ao----  10.00g
  gda-lv-var     gda-vg01 -wi-ao----  10.00g
  gda-lv-var-lib gda-vg01 -wi-ao----  10.00g
*/

-- Step 11.16 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvcreate /dev/sdb1
/*
  Physical volume "/dev/sdb1" successfully created.
*/

-- Step 11.17 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvcreate /dev/sdc1
/*
  Physical volume "/dev/sdc1" successfully created.
*/

-- Step 11.18 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvcreate /dev/sdd1
/*
  Physical volume "/dev/sdc1" successfully created.
*/

-- Step 11.19 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvs
/*
  PV         VG       Fmt  Attr PSize    PFree
  /dev/sda3  gda-vg01 lvm2 a--  <127.95g      0
  /dev/sdb1           lvm2 ---   <50.00g <50.00g
  /dev/sdc1           lvm2 ---   <50.00g <50.00g
  /dev/sdd1           lvm2 ---   <50.00g <50.00g
*/

-- Step 11.20 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvdisplay /dev/sdb1
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
  PV UUID               xjayO7-pUke-kwHE-Cck9-M58A-1n9G-NkUZ12
*/

-- Step 11.21 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvdisplay /dev/sdc1
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
  PV UUID               nuEZsX-jpLn-lDVz-YOwn-8dYN-TZUX-JfSTAC
*/

-- Step 11.22 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# pvdisplay /dev/sdd1
/*
  "/dev/sdd1" is a new physical volume of "<50.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdd1
  VG Name
  PV Size               <50.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               EJ3BIn-HHTs-EANU-ERRB-qgdu-KUvu-sOk15U
*/

-- Step 11.23 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgcreate -s 8M gda-vg02-data /dev/sdb1
/*
  Volume group "gda-vg02-data" successfully created
*/

-- Step 11.24 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgcreate -s 8M gda-vg02-backup /dev/sdc1
/*
  Volume group "gda-vg02-backup" successfully created
*/

-- Step 11.25 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgcreate -s 8M gda-vg02-log /dev/sdd1
/*
  Volume group "gda-vg02-log" successfully created
*/

-- Step 11.26 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgs
/*
  VG              #PV #LV #SN Attr   VSize    VFree
  gda-vg01          1   8   0 wz--n- <127.95g     0
  gda-vg02-backup   1   0   0 wz--n-   49.99g 49.99g
  gda-vg02-data     1   0   0 wz--n-   49.99g 49.99g
  gda-vg02-log      1   0   0 wz--n-   49.99g 49.99g
*/

-- Step 11.27 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgdisplay gda-vg02-data
/*
  --- Volume group ---
  VG Name               gda-vg02-data
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
  VG UUID               XKLNRo-XNcc-LUSW-cd6f-5Cnx-iUxW-Luamgl
*/

-- Step 11.28 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgdisplay gda-vg02-backup
/*
  --- Volume group ---
  VG Name               gda-vg02-backup
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
  VG UUID               b5LL0T-IdmK-Yw2L-mSMI-qDu4-cZ59-ZMPQNY
*/

-- Step 11.29 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vgdisplay gda-vg02-log
/*
  --- Volume group ---
  VG Name               gda-vg02-log
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
  VG UUID               1g3HJP-N3kK-Jg89-WfzG-AWY6-1xk4-euOe3k
*/

-- Step 11.30 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvcreate -n gda-lv-data -L 49.96GB gda-vg02-data
/*
  Rounding up size to full physical extent 49.96 GiB
  Logical volume "gda-lv-data" created.
*/

-- Step 11.31 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvcreate -n gda-lv-backup -L 49.96GB gda-vg02-backup
/*
  Rounding up size to full physical extent 49.96 GiB
  Logical volume "gda-lv-backup" created.
*/


-- Step 11.32 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvcreate -n gda-lv-log -L 49.96GB gda-vg02-log
/*
  Rounding up size to full physical extent 49.96 GiB
  Logical volume "gda-lv-log" created.
*/

-- Step 11.33 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvs
/*
  LV             VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  gda-lv-home    gda-vg01        -wi-ao----  10.00g
  gda-lv-root    gda-vg01        -wi-ao----  48.00g
  gda-lv-srv     gda-vg01        -wi-ao----  10.00g
  gda-lv-swap    gda-vg01        -wi-ao---- <19.95g
  gda-lv-tmp     gda-vg01        -wi-ao----  10.00g
  gda-lv-usr     gda-vg01        -wi-ao----  10.00g
  gda-lv-var     gda-vg01        -wi-ao----  10.00g
  gda-lv-var-lib gda-vg01        -wi-ao----  10.00g
  gda-lv-backup  gda-vg02-backup -wi-a-----  49.96g
  gda-lv-data    gda-vg02-data   -wi-a-----  49.96g
  gda-lv-log     gda-vg02-log    -wi-a-----  49.96g
*/

-- Step 11.34 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# fdisk -ll | grep -E "data|backup|log-"
/*
Disk /dev/mapper/gda--vg02--data-gda--lv--data: 49.96 GiB, 53645148160 bytes, 104775680 sectors
Disk /dev/mapper/gda--vg02--backup-gda--lv--backup: 49.96 GiB, 53645148160 bytes, 104775680 sectors
Disk /dev/mapper/gda--vg02--log-gda--lv--log: 49.96 GiB, 53645148160 bytes, 104775680 sectors
*/

-- Step 11.35 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvdisplay /dev/mapper/gda--vg02--data-gda--lv--data
/*
  --- Logical volume ---
  LV Path                /dev/gda-vg02-data/gda-lv-data
  LV Name                gda-lv-data
  VG Name                gda-vg02-data
  LV UUID                vSywbR-oVw8-SfMo-vJlV-l9i1-PRWU-2N1Puy
  LV Write Access        read/write
  LV Creation host, time master-n1.unidev.org.com, 2025-01-10 20:04:03 +0545
  LV Status              available
  # open                 0
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:8
*/

-- Step 11.36 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvdisplay /dev/mapper/gda--vg02--backup-gda--lv--backup
/*
  --- Logical volume ---
  LV Path                /dev/gda-vg02-backup/gda-lv-backup
  LV Name                gda-lv-backup
  VG Name                gda-vg02-backup
  LV UUID                9j9XjW-2so3-tLBe-rTYb-RQnB-7AXW-93AE74
  LV Write Access        read/write
  LV Creation host, time master-n1.unidev.org.com, 2025-01-10 20:04:20 +0545
  LV Status              available
  # open                 0
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:9
*/

-- Step 11.37 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lvdisplay /dev/mapper/gda--vg02--log-gda--lv--log
/*
  --- Logical volume ---
  LV Path                /dev/gda-vg02-log/gda-lv-log
  LV Name                gda-lv-log
  VG Name                gda-vg02-log
  LV UUID                keePEs-2umI-aYXJ-Xstq-mHAl-P0TN-8tvXVX
  LV Write Access        read/write
  LV Creation host, time master-n1.unidev.org.com, 2025-01-10 20:04:41 +0545
  LV Status              available
  # open                 0
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:10
*/


-- Step 11.38 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkfs.xfs -f /dev/mapper/gda--vg02--data-gda--lv--data
/*
meta-data=/dev/mapper/gda--vg02--data-gda--lv--data isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
*/

-- Step 11.39 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkfs.xfs -f /dev/mapper/gda--vg02--backup-gda--lv--backup
/*
meta-data=/dev/mapper/gda--vg02--backup-gda--lv--backup isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
*/

-- Step 11.40 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkfs.xfs -f /dev/mapper/gda--vg02--log-gda--lv--log
/*
meta-data=/dev/mapper/gda--vg02--log-gda--lv--log isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
*/

-- Step 11.41 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root           252:0    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home           252:1    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv            252:2    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr            252:3    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var            252:4    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib       252:5    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp            252:6    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap           252:7    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0    50G  0 disk
└─sdb1                                  8:17   0    50G  0 part
  └─gda--vg02--data-gda--lv--data     252:8    0    50G  0 lvm
sdc                                     8:32   0    50G  0 disk
└─sdc1                                  8:33   0    50G  0 part
  └─gda--vg02--backup-gda--lv--backup 252:9    0    50G  0 lvm
sdd                                     8:48   0    50G  0 disk
└─sdd1                                  8:49   0    50G  0 part
  └─gda--vg02--log-gda--lv--log       252:10   0    50G  0 lvm
sr0                                    11:0    1  1024M  0 rom
*/

-- Step 11.42 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# blkid | grep -E "data|backup|log"
/*
/dev/mapper/gda--vg02--log-gda--lv--log: UUID="24b53f31-d820-4071-a45d-1fa258645f2f" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/gda--vg02--data-gda--lv--data: UUID="765ec272-1271-4da9-9fa3-c57c49664b0d" BLOCK_SIZE="512" TYPE="xfs"
/dev/mapper/gda--vg02--backup-gda--lv--backup: UUID="14c38ca2-e944-46b4-a4dc-028103f63c73" BLOCK_SIZE="512" TYPE="xfs"
*/

-- Step 11.43 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkdir -p /data

-- Step 11.44 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkdir -p /backup

-- Step 11.45 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mkdir -p /log

-- Step 11.46 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mount /dev/mapper/gda--vg02--data-gda--lv--data /data

-- Step 11.47 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mount /dev/mapper/gda--vg02--backup-gda--lv--backup /backup

-- Step 11.48 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mount /dev/mapper/gda--vg02--log-gda--lv--log /log

-- Step 11.49 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# df -Th
/*
Filesystem                                                                                   Type      Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs     1.6G  1.4M  1.6G   1% /run
efivarfs                                                                                     efivarfs  256K   54K  198K  22% /sys/firmware/efi/efivars
/dev/mapper/gda--vg01-gda--lv--root                                                          xfs        48G  979M   47G   2% /
/dev/disk/by-id/dm-uuid-LVM-0m25Uf9hLfxXFptzs9MKLJtfiFpsrAy8rZUXLlzBNdVN4kdMFem6YAcQRCylJtU1 xfs        10G  2.3G  7.7G  24% /usr
tmpfs                                                                                        tmpfs     7.9G     0  7.9G   0% /dev/shm
tmpfs                                                                                        tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/mapper/gda--vg01-gda--lv--var                                                           xfs        10G  414M  9.6G   5% /var
/dev/mapper/gda--vg01-gda--lv--home                                                          xfs        10G  228M  9.8G   3% /home
/dev/mapper/gda--vg01-gda--lv--srv                                                           xfs        10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg01-gda--lv--tmp                                                           xfs        10G  228M  9.8G   3% /tmp
/dev/sda2                                                                                    xfs       960M  147M  814M  16% /boot
/dev/sda1                                                                                    vfat      1.1G  6.2M  1.1G   1% /boot/efi
/dev/mapper/gda--vg01-gda--lv--var--lib                                                      xfs        10G  426M  9.6G   5% /var/lib
tmpfs                                                                                        tmpfs     1.6G   12K  1.6G   1% /run/user/1000
/dev/mapper/gda--vg02--data-gda--lv--data                                                    xfs        50G 1011M   49G   2% /data
/dev/mapper/gda--vg02--backup-gda--lv--backup                                                xfs        50G 1011M   49G   2% /backup
/dev/mapper/gda--vg02--log-gda--lv--log                                                      xfs        50G 1011M   49G   2% /log
*/

-- Step 11.50 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# vi /etc/fstab
/*
# data
/dev/mapper/gda--vg02--data-gda--lv--data /data xfs defaults 0 1
# backup
/dev/mapper/gda--vg02--backup-gda--lv--backup /backup xfs defaults 0 1
# archive log
/dev/mapper/gda--vg02--log-gda--lv--log /log xfs defaults 0 1
*/

-- Step 11.51 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# umount /data

-- Step 11.52 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# umount /backup

-- Step 11.53 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# umount /log

-- Step 11.54 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# systemctl daemon-reload

-- Step 11.55 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# mount -a

-- Step 11.56 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root           252:0    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home           252:1    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv            252:2    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr            252:3    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var            252:4    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib       252:5    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp            252:6    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap           252:7    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0    50G  0 disk
└─sdb1                                  8:17   0    50G  0 part
  └─gda--vg02--data-gda--lv--data     252:8    0    50G  0 lvm  /data
sdc                                     8:32   0    50G  0 disk
└─sdc1                                  8:33   0    50G  0 part
  └─gda--vg02--backup-gda--lv--backup 252:9    0    50G  0 lvm  /backup
sdd                                     8:48   0    50G  0 disk
└─sdd1                                  8:49   0    50G  0 part
  └─gda--vg02--log-gda--lv--log       252:10   0    50G  0 lvm  /log
sr0                                    11:0    1  1024M  0 rom
*/

-- Step 11.57 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# init 6

-- Step 11.58 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# df -Th
/*
Filesystem                                                                                   Type      Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs     1.6G  1.5M  1.6G   1% /run
efivarfs                                                                                     efivarfs  256K   54K  198K  22% /sys/firmware/efi/efivars
/dev/mapper/gda--vg01-gda--lv--root                                                          xfs        48G  979M   47G   2% /
/dev/disk/by-id/dm-uuid-LVM-0m25Uf9hLfxXFptzs9MKLJtfiFpsrAy8rZUXLlzBNdVN4kdMFem6YAcQRCylJtU1 xfs        10G  2.3G  7.7G  24% /usr
tmpfs                                                                                        tmpfs     7.9G     0  7.9G   0% /dev/shm
tmpfs                                                                                        tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/mapper/gda--vg01-gda--lv--var                                                           xfs        10G  428M  9.6G   5% /var
/dev/mapper/gda--vg01-gda--lv--home                                                          xfs        10G  228M  9.8G   3% /home
/dev/sda2                                                                                    xfs       960M  147M  814M  16% /boot
/dev/mapper/gda--vg01-gda--lv--srv                                                           xfs        10G  228M  9.8G   3% /srv
/dev/mapper/gda--vg01-gda--lv--tmp                                                           xfs        10G  228M  9.8G   3% /tmp
/dev/mapper/gda--vg02--log-gda--lv--log                                                      xfs        50G 1011M   49G   2% /log
/dev/sda1                                                                                    vfat      1.1G  6.2M  1.1G   1% /boot/efi
/dev/mapper/gda--vg02--backup-gda--lv--backup                                                xfs        50G 1011M   49G   2% /backup
/dev/mapper/gda--vg02--data-gda--lv--data                                                    xfs        50G 1011M   49G   2% /data
/dev/mapper/gda--vg01-gda--lv--var--lib                                                      xfs        10G  426M  9.6G   5% /var/lib
tmpfs                                                                                        tmpfs     1.6G   12K  1.6G   1% /run/user/1000
*/

-- Step 11.59 -->> On All Nodes (LVM Partition)
root@master-n1/slave-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─gda--vg01-gda--lv--root           252:3    0    48G  0 lvm  /
  ├─gda--vg01-gda--lv--home           252:4    0    10G  0 lvm  /home
  ├─gda--vg01-gda--lv--srv            252:5    0    10G  0 lvm  /srv
  ├─gda--vg01-gda--lv--usr            252:6    0    10G  0 lvm  /usr
  ├─gda--vg01-gda--lv--var            252:7    0    10G  0 lvm  /var
  ├─gda--vg01-gda--lv--var--lib       252:8    0    10G  0 lvm  /var/lib
  ├─gda--vg01-gda--lv--tmp            252:9    0    10G  0 lvm  /tmp
  └─gda--vg01-gda--lv--swap           252:10   0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0    50G  0 disk
└─sdb1                                  8:17   0    50G  0 part
  └─gda--vg02--data-gda--lv--data     252:2    0    50G  0 lvm  /data
sdc                                     8:32   0    50G  0 disk
└─sdc1                                  8:33   0    50G  0 part
  └─gda--vg02--backup-gda--lv--backup 252:1    0    50G  0 lvm  /backup
sdd                                     8:48   0    50G  0 disk
└─sdd1                                  8:49   0    50G  0 part
  └─gda--vg02--log-gda--lv--log       252:0    0    50G  0 lvm  /log
sr0                                    11:0    1  1024M  0 rom
*/

-- Step 12 -->> On All Nodes
root@master-n1/slave-n1:~# vi /etc/sudoers
/*
%sudo   ALL=(ALL:ALL) ALL
*/

-- Step 12.1 -->> On All Nodes
root@master-n1/slave-n1:~# cat /etc/sudoers | grep -E "%sudo   ALL=\(ALL:ALL\) ALL"
/*
%sudo  ALL=(ALL:ALL) ALL
*/

-- Step 13 -->> On All Nodes
root@master-n1/slave-n1:~# useradd -G sudo postgres

-- Step 14 -->> On All Nodes
root@master-n1/slave-n1:~# usermod -a -G sudo postgres

-- Step 15 -->> On All Nodes
root@master-n1/slave-n1:~# vi /etc/sudoers
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 16 -->> On All Nodes
root@master-n1/slave-n1:~# cat /etc/sudoers | grep -E "postgres  ALL=\(ALL:ALL\) ALL"
/*
postgres  ALL=(ALL:ALL) ALL
*/

-- Step 17 -->> On All Nodes
root@master-n1/slave-n1:~# apt update

-- Step 17.1 -->> On All Nodes
root@master-n1/slave-n1:~# apt -y upgrade

-- Step 17.2 -->> On All Nodes
root@master-n1/slave-n1:~# apt update && apt -y full-upgrade

-- Step 17.3 -->> On All Nodes
root@master-n1/slave-n1:~# apt -y install vim curl wget gpg gnupg2 software-properties-common apt-transport-https lsb-release ca-certificates

-- Step 17.4 -->> On All Nodes
root@master-n1/slave-n1:~# apt policy postgresql
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
root@master-n1/slave-n1:~# sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

---- Step 19 -->> On All Nodes (Import the repository signing key:)
root@master-n1/slave-n1:~# curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
root@master-n1/slave-n1:~# apt update

---- Step 20 -->> On All Nodes (Install PostgreSQL 17 and contrib modules:)
root@master-n1/slave-n1:~# apt install postgresql-17
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
Get:1 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-perl all 4.10000-1 [81.9 kB]
Get:2 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-common all 267.pgdg24.04+1 [36.5 kB]
Get:3 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libio-pty-perl amd64 1:1.20-1build2 [31.2 kB]
Get:4 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-common all 267.pgdg24.04+1 [169 kB]
Get:5 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libipc-run-perl all 20231003.0-1 [92.1 kB]
Get:6 http://np.archive.ubuntu.com/ubuntu noble/main amd64 ssl-cert all 1.1.2ubuntu1 [17.8 kB]
Get:7 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libcommon-sense-perl amd64 3.75-3build3 [20.4 kB]
Get:8 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libtypes-serialiser-perl all 1.01-1 [11.6 kB]
Get:9 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libjson-xs-perl amd64 4.030-2build3 [83.6 kB]
Get:10 http://np.archive.ubuntu.com/ubuntu noble/main amd64 libllvm17t64 amd64 1:17.0.6-9ubuntu1 [26.2 MB]
Get:11 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 libpq5 amd64 17.2-1.pgdg24.04+1 [224 kB]
Get:12 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-client-17 amd64 17.2-1.pgdg24.04+1 [1,994 kB]
Get:13 http://apt.postgresql.org/pub/repos/apt noble-pgdg/main amd64 postgresql-17 amd64 17.2-1.pgdg24.04+1 [17.2 MB]
Fetched 46.1 MB in 4s (11.2 MB/s)
Preconfiguring packages ...
Selecting previously unselected package libjson-perl.
(Reading database ... 86625 files and directories currently installed.)
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

-- Step 21 -->> On All Nodes
root@master-n1/slave-n1:~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 22 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl enable postgresql
/*
Synchronizing state of postgresql.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable postgresql
*/

-- Step 22.1 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl start postgresql

-- Step 22.2 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Fri 2025-01-10 21:54:01 +0545; 2min 39s ago
   Main PID: 4774 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 10 21:54:01 master-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 21:54:01 master-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 23 -->> On All Nodes
root@master-n1/slave-n1:~# psql --version
/*
psql (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 24 -->> On All Nodes (Fix The User-postgres login issue)
root@master-n1/slave-n1:~# su - postgres
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
root@master-n1/slave-n1:~# ll /home/
/*
drwxr-xr-x  3 root     root       22 Jan 10 18:58 ./
drwxr-xr-x 25 root     root     4096 Jan 10 20:11 ../
drwxr-x---  4 sysadmin sysadmin  137 Jan 10 19:08 sysadmin/
*/

-- Step 24.2 -->> On All Nodes (Fix The User-postgres login issue)
root@master-n1/slave-n1:~# mkdir -p /home/postgres
root@master-n1/slave-n1:~# chown postgres:postgres /home/postgres
root@master-n1/slave-n1:~# chmod 755 /home/postgres

-- Step 24.3 -->> On All Nodes (Fix The User-postgres login issue)
root@master-n1/slave-n1:~# vi /etc/passwd
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On All Nodes (Fix The User-postgres login issue)
root@master-n1/slave-n1:~# cat /etc/passwd | grep -i "postgres:x:1001:1001::/home/postgres:/bin/bash"
/*
postgres:x:1001:1001::/home/postgres:/bin/bash
*/

-- Step 24.5 -->> On All Nodes (Fix The User-postgres login issue)
root@master-n1/slave-n1:~# su - postgres
/*
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
*/

-- Step 25 -->> On All Nodes (Change the Data Directory)
postgres@master-n1/slave-n1:~$ psql
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
postgres@master-n1/slave-n1:~$ exit
/*
logout
*/

-- Step 25.2 -->> On All Nodes (Change the Data Directory)-(Default Location)
root@master-n1/slave-n1:~# ll /var/lib/postgresql/17/main/
/*
drwx------ 19 postgres postgres 4096 Jan 10 21:54 ./
drwxr-xr-x  3 postgres postgres   18 Jan 10 21:54 ../
drwx------  5 postgres postgres   33 Jan 10 21:54 base/
drwx------  2 postgres postgres 4096 Jan 10 21:57 global/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_commit_ts/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_dynshmem/
drwx------  4 postgres postgres   68 Jan 10 21:59 pg_logical/
drwx------  4 postgres postgres   36 Jan 10 21:54 pg_multixact/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_notify/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_replslot/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_serial/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_snapshots/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_stat/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_stat_tmp/
drwx------  2 postgres postgres   18 Jan 10 21:54 pg_subtrans/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_tblspc/
drwx------  2 postgres postgres    6 Jan 10 21:54 pg_twophase/
-rw-------  1 postgres postgres    3 Jan 10 21:54 PG_VERSION
drwx------  4 postgres postgres   77 Jan 10 21:54 pg_wal/
drwx------  2 postgres postgres   18 Jan 10 21:54 pg_xact/
-rw-------  1 postgres postgres   88 Jan 10 21:54 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Jan 10 21:54 postmaster.opts
-rw-------  1 postgres postgres  108 Jan 10 21:54 postmaster.pid
*/

-- Step 25.3 -->> On All Nodes (Change the Data Directory)-(Configure New Location for Data Directory)
root@master-n1/slave-n1:~# mkdir -p /data/postgres/17/data
root@master-n1/slave-n1:~# cd /data/
root@master-n1/slave-n1:/data# chown -R postgres:postgres postgres/
root@master-n1/slave-n1:/data# chmod -R 750 postgres/

-- Step 25.4 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# ll /data/postgres/17/data/
/*
drwxr-x--- 2 postgres postgres  6 Jan 10 22:01 ./
drwxr-x--- 3 postgres postgres 18 Jan 10 22:01 ../
*/

-- Step 25.5 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# systemctl stop postgresql

-- Step 25.6 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Fri 2025-01-10 22:01:54 +0545; 6s ago
   Duration: 7min 52.682s
   Main PID: 4774 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 10 21:54:01 master-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 21:54:01 master-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 10 22:01:54 master-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 10 22:01:54 master-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 25.7 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# cp /etc/postgresql/17/main/postgresql.conf /etc/postgresql/17/main/postgresql.conf.bk
root@master-n1/slave-n1:~# ll /etc/postgresql/17/main/ | grep postgresql
/*
-rw-r--r-- 1 postgres postgres 30977 Jan 10 21:54 postgresql.conf
-rw-r--r-- 1 root     root     30977 Jan 10 22:02 postgresql.conf.bk
*/

-- Step 25.8 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
data_directory = '/data/postgres/17/data' # use data in another directory
max_connections = 500                     # (change requires restart)
shared_buffers = 4GB                      # min 128kB
*/

-- Step 25.9 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "data_directory|max_connections = 500|shared_buffers = 4GB"
/*
data_directory = '/data/postgres/17/data' # use data in another directory
max_connections = 500                     # (change requires restart)
shared_buffers = 4GB                      # min 128kB
*/

-- Step 25.10 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:# cp -r /var/lib/postgresql/17/main/* /data/postgres/17/data/
--*/

-- Step 25.11 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:# ll /data/postgres/17/data/
/*
drwxr-x--- 19 postgres postgres 4096 Jan 10 22:04 ./
drwxr-x---  3 postgres postgres   18 Jan 10 22:01 ../
drwx------  5 root     root       33 Jan 10 22:04 base/
drwx------  2 root     root     4096 Jan 10 22:04 global/
drwx------  2 root     root        6 Jan 10 22:04 pg_commit_ts/
drwx------  2 root     root        6 Jan 10 22:04 pg_dynshmem/
drwx------  4 root     root       68 Jan 10 22:04 pg_logical/
drwx------  4 root     root       36 Jan 10 22:04 pg_multixact/
drwx------  2 root     root        6 Jan 10 22:04 pg_notify/
drwx------  2 root     root        6 Jan 10 22:04 pg_replslot/
drwx------  2 root     root        6 Jan 10 22:04 pg_serial/
drwx------  2 root     root        6 Jan 10 22:04 pg_snapshots/
drwx------  2 root     root       25 Jan 10 22:04 pg_stat/
drwx------  2 root     root        6 Jan 10 22:04 pg_stat_tmp/
drwx------  2 root     root       18 Jan 10 22:04 pg_subtrans/
drwx------  2 root     root        6 Jan 10 22:04 pg_tblspc/
drwx------  2 root     root        6 Jan 10 22:04 pg_twophase/
-rw-------  1 root     root        3 Jan 10 22:04 PG_VERSION
drwx------  4 root     root       77 Jan 10 22:04 pg_wal/
drwx------  2 root     root       18 Jan 10 22:04 pg_xact/
-rw-------  1 root     root       88 Jan 10 22:04 postgresql.auto.conf
-rw-------  1 root     root      130 Jan 10 22:04 postmaster.opts
*/

-- Step 25.12 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:# cd /var/lib/postgresql/17/main/

-- Step 25.13 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:/var/lib/postgresql/17/main# rm -rf *

-- Step 25.14 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:/var/lib/postgresql/17/main# cd /data/postgres/17/data/

-- Step 25.15 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:/data/postgres/17/data# chown -R postgres:postgres *

-- Step 25.16 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:/data/postgres/17/data# ll
/*
drwxr-x--- 19 postgres postgres 4096 Jan 10 22:04 ./
drwxr-x---  3 postgres postgres   18 Jan 10 22:01 ../
drwx------  5 postgres postgres   33 Jan 10 22:04 base/
drwx------  2 postgres postgres 4096 Jan 10 22:04 global/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_commit_ts/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_dynshmem/
drwx------  4 postgres postgres   68 Jan 10 22:04 pg_logical/
drwx------  4 postgres postgres   36 Jan 10 22:04 pg_multixact/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_notify/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_replslot/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_serial/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_snapshots/
drwx------  2 postgres postgres   25 Jan 10 22:04 pg_stat/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_stat_tmp/
drwx------  2 postgres postgres   18 Jan 10 22:04 pg_subtrans/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_tblspc/
drwx------  2 postgres postgres    6 Jan 10 22:04 pg_twophase/
-rw-------  1 postgres postgres    3 Jan 10 22:04 PG_VERSION
drwx------  4 postgres postgres   77 Jan 10 22:04 pg_wal/
drwx------  2 postgres postgres   18 Jan 10 22:04 pg_xact/
-rw-------  1 postgres postgres   88 Jan 10 22:04 postgresql.auto.conf
-rw-------  1 postgres postgres  130 Jan 10 22:04 postmaster.opts
*/

-- Step 25.17 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# du -sh /data/postgres/17/data/
/*
39M     /data/postgres/17/data/
*/

-- Step 25.18 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# du -sh /var/lib/postgresql/17/main/
/*
0       /var/lib/postgresql/17/main/
*/

-- Step 25.19 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# systemctl start postgresql

-- Step 25.20 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Fri 2025-01-10 22:06:56 +0545; 7s ago
    Process: 6023 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6023 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 10 22:06:56 master-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 22:06:56 master-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 25.21 -->> On All Nodes (Change the Data Directory)
root@master-n1/slave-n1:~# su - postgres

-- Step 25.22 -->> On All Nodes (Change the Data Directory)
postgres@master-n1/slave-n1:~$ psql
/*
postgres@master-n1:~$ psql
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
root@master-n1/slave-n1:~# systemctl stop postgresql

-- Step 26.1 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Fri 2025-01-10 22:09:23 +0545; 7s ago
   Duration: 2min 27.349s
    Process: 6023 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6023 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 10 22:06:56 master-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 22:06:56 master-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 10 22:09:23 master-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 10 22:09:23 master-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 27 -->> On All Nodes
root@master-n1/slave-n1:~# ping -c 2 192.168.21.22
root@master-n1/slave-n1:~# ping -c 2 192.178.21.23

-- Step 28 -->> On All Nodes
root@master-n1/slave-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
listen_addresses = '*'          # what IP address(es) to listen on;
wal_level = replica             # minimal, replica, or logical
wal_log_hints = on              # also do full page writes of non-critical updates
wal_compression = on            # enable compression of full-page writes
max_wal_size = 2GB
min_wal_size = 160MB
max_wal_senders = 10            # max number of walsender processes
hot_standby = on                # "off" disallows queries during recovery
synchronous_commit = on         # synchronization level;
archive_mode = on               # enables archiving; off, on, or always
archive_command = 'cp %p /log/postgres/17/archive/%f'           # command to use to archive a WAL file
wal_keep_size = 64              # in megabytes; 0 disables
summarize_wal = on              # run WAL summarizer process?
*/

-- Step 28.1 -->> On All Nodes
root@master-n1/slave-n1:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "listen_addresses = '*'|wal_level|wal_log_hints|wal_compression|max_wal_size|min_wal_size|max_wal_senders|hot_standby = on|synchronous_commit|wal_keep_size = 64|archive_mode|archive_command|summarize_wal = on"
/*
listen_addresses = '*'          # what IP address(es) to listen on;
wal_level = replica             # minimal, replica, or logical
wal_log_hints = on              # also do full page writes of non-critical updates
wal_compression = on            # enable compression of full-page writes
max_wal_size = 2GB
min_wal_size = 160MB
max_wal_senders = 10            # max number of walsender processes
hot_standby = on                # "off" disallows queries during recovery
synchronous_commit = on         # synchronization level;
archive_mode = on               # enables archiving; off, on, or always
archive_command = 'cp %p /log/postgres/17/archive/%f'           # command to use to archive a WAL file
wal_keep_size = 64              # in megabytes; 0 disables
summarize_wal = on              # run WAL summarizer process?
*/

-- Step 29 -->> On All Nodes
root@master-n1/slave-n1:~# mkdir -p /log/postgres/17/archive
root@master-n1/slave-n1:~# cd /log/
root@master-n1/slave-n1:/log# chmod -R 755 *
root@master-n1/slave-n1:/log# chown -R postgres:postgres *

-- Step 30 -->> On All Nodes (Configure PostgreSQL to use md5 password authentication by editing pg_hba.conf , this is important if you wish to connect remotely e.g. via PGADMIN :)
root@master-n1/slave-n1:~# sed -i '/^host/s/ident/md5/' /etc/postgresql/17/main/pg_hba.conf
root@master-n1/slave-n1:~# sed -i '/^local/s/peer/trust/' /etc/postgresql/17/main/pg_hba.conf
root@master-n1/slave-n1:~# echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/17/main/pg_hba.conf

-- Step 31 -->> On Node 1 (Allow Current Live IP in Current Backup)
root@master-n1:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.21.22 master-n1.unidev.org.com master-n1

# Slave Node 1 - DR
192.178.21.23 slave-n1.unidev.org.com slave-n1
*/

-- Step 31.2 -->> On Node 1
root@master-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.21.22/32          trust
host   replication      all             192.178.21.23/32          trust
*/

-- Step 31.3 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.21.22/32          trust
host    replication     all             192.178.21.23/32          trust
*/

-- Step 31.4 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.21.22 port=5432 user=replica_user password=Sys#605014#' # connection string to sending server
*/

-- Step 31.5 -->> On Node 2
root@slave-n1:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "primary_conninfo"
/*
primary_conninfo = 'host=192.168.21.22 port=5432 user=replica_user password=Sys#605014#' # connection string to sending server
*/

-- Step 32 -->> On Node 1
root@master-n1:~# systemctl start postgresql

-- Step 32.1 -->> On Node 1
root@master-n1:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Fri 2025-01-10 22:26:21 +0545; 9s ago
    Process: 6143 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6143 (code=exited, status=0/SUCCESS)
        CPU: 1ms

Jan 10 22:26:21 master-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 22:26:21 master-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 33 -->> On Node 1 (Create Replocation User)
root@master-n1:~# sudo -u postgres psql
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

postgres=# CREATE ROLE replica_user WITH REPLICATION LOGIN PASSWORD 'Sys#605014#';
CREATE ROLE

postgres=# \q
*/

-- Step 34 -->> On Node 2
root@slave-n1:~# systemctl status postgresql
/*
○ postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: inactive (dead) since Fri 2025-01-10 22:27:51 +0545; 57s ago
   Duration: 1min 27.989s
    Process: 6191 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6191 (code=exited, status=0/SUCCESS)
        CPU: 933us

Jan 10 22:26:23 slave-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 22:26:23 slave-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
Jan 10 22:27:51 slave-n1.unidev.org.com systemd[1]: postgresql.service: Deactivated successfully.
Jan 10 22:27:51 slave-n1.unidev.org.com systemd[1]: Stopped postgresql.service - PostgreSQL RDBMS.
*/

-- Step 35 -->> On Node 2
root@slave-n1:~# cd /data/postgres/17/
root@slave-n1:/data/postgres/17# mkdir postgres_data_bk
root@slave-n1:/data/postgres/17# cp -r data/ postgres_data_bk/
root@slave-n1:/data/postgres/17# cd data/
root@slave-n1:/data/postgres/17/data# rm -rf *
root@slave-n1:/data/postgres/17/data# ll
/*
drwxr-x--- 2 postgres postgres  6 Jan 10 22:29 ./
drwxr-x--- 4 postgres postgres 42 Jan 10 22:29 ../
*/

-- Step 36 -->> On Node 2
root@master-n1/slave-n1:~# telnet 192.168.21.22 5432
/*
Trying 192.168.21.22...
Connected to 192.168.21.22.
*/

-- Step 37 -->> On Node 2
root@slave-n1:~# sudo -u postgres pg_basebackup -h 192.168.21.22 -D /data/postgres/17/data/ -U replica_user -P -v -R -X stream
/*
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/2000028 on timeline 1
pg_basebackup: starting background WAL receiver
pg_basebackup: created temporary replication slot "pg_basebackup_6182"
23167/23167 kB (100%), 1/1 tablespace
pg_basebackup: write-ahead log end point: 0/2000120
pg_basebackup: waiting for background process to finish streaming ...
pg_basebackup: syncing data to disk ...
pg_basebackup: renaming backup_manifest.tmp to backup_manifest
pg_basebackup: base backup completed
*/

-- Step 38 -->> On Node 2
root@slave-n1:~# ll /data/postgres/17/data/
/*
drwxr-x--- 19 postgres postgres   4096 Jan 10 22:30 ./
drwxr-x---  3 postgres postgres     18 Jan 10 22:30 ../
-rw-r-----  1 postgres postgres    227 Jan 10 22:30 backup_label
-rw-r-----  1 postgres postgres 136936 Jan 10 22:30 backup_manifest
drwx------  5 postgres postgres     33 Jan 10 22:30 base/
drwx------  2 postgres postgres   4096 Jan 10 22:30 global/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_commit_ts/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_dynshmem/
drwx------  4 postgres postgres     68 Jan 10 22:30 pg_logical/
drwx------  4 postgres postgres     36 Jan 10 22:30 pg_multixact/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_notify/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_replslot/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_serial/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_snapshots/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_stat/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_stat_tmp/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_subtrans/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_tblspc/
drwx------  2 postgres postgres      6 Jan 10 22:30 pg_twophase/
-rw-------  1 postgres postgres      3 Jan 10 22:30 PG_VERSION
drwx------  4 postgres postgres     77 Jan 10 22:30 pg_wal/
drwx------  2 postgres postgres     18 Jan 10 22:30 pg_xact/
-rw-------  1 postgres postgres    436 Jan 10 22:30 postgresql.auto.conf
-rw-r-----  1 postgres postgres      0 Jan 10 22:30 standby.signal
*/


-- Step 39 -->> On Node 2
root@slave-n1:~# systemctl start postgresql

-- Step 39.1 -->> On Node 2
root@slave-n1:~# systemctl status postgresql
/*
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; preset: enabled)
     Active: active (exited) since Fri 2025-01-10 22:31:53 +0545; 7s ago
    Process: 6323 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 6323 (code=exited, status=0/SUCCESS)
        CPU: 892us

Jan 10 22:31:53 slave-n1.unidev.org.com systemd[1]: Starting postgresql.service - PostgreSQL RDBMS...
Jan 10 22:31:53 slave-n1.unidev.org.com systemd[1]: Finished postgresql.service - PostgreSQL RDBMS.
*/

-- Step 40 -->> On All Nodes
root@master-n1/slave-n1:~# telnet 192.168.21.22 5432 & telnet 192.178.21.23 5432 &
/*
Trying 192.168.21.22...
Trying 192.178.21.23...
Connected to 192.168.21.22.
Escape character is '^]'.
Connected to 192.178.21.23.
Escape character is '^]'.
*/

-- Step 41 -->> On Node 1 (Verification)
root@master-n1:~# sudo -u postgres psql
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

-[ RECORD 1 ]----+---------------------------------
pid              | 6192
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.178.21.23
client_hostname  |
client_port      | 42518
backend_start    | 2025-01-10 22:31:51.683068+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/3000060
write_lsn        | 0/3000060
flush_lsn        | 0/3000060
replay_lsn       | 0/3000060
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-10 22:34:11.626327+05:45

postgres=# \q
*/

-- Step 41.1 -->> On Node 2 (Verification)-(If it is streaming that means working fine)
root@slave-n1:~# sudo -u postgres psql
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
pid                   | 6310
status                | streaming
receive_start_lsn     | 0/3000000
receive_start_tli     | 1
written_lsn           | 0/3000060
flushed_lsn           | 0/3000060
received_tli          | 1
last_msg_send_time    | 2025-01-10 22:34:21.731598+05:45
last_msg_receipt_time | 2025-01-10 22:34:21.616857+05:45
latest_end_lsn        | 0/3000060
latest_end_time       | 2025-01-10 22:31:51.688762+05:45
slot_name             |
sender_host           | 192.168.21.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_versbalance_hosts=disable

postgres=# \q
*/

-- Step 41.2 -->> On Node 2 (Verification of Read Only)
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# CREATE DATABASE gdaengine;
ERROR:  cannot execute CREATE DATABASE in a read-only transaction

postgres=# \q
*/

-- Step 41.3 -->> On Node 1 (Verification - Replication)
root@master-n1:~# sudo -u postgres psql
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
CREATE ROLE

postgres=# CREATE DATABASE gdaengine;
CREATE DATABASE

postgres=#  \l
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

-- Step 41.4 -->> On Node 2 (Verification - Replication)
root@slave-n1:~# sudo -u postgres psql
/*
root@slave-n1:~# sudo -u postgres psql
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
 gdaengine | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 postgres  | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           |
 template0 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
 template1 | postgres | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |        |           | =c/postgres          +
           |          |          |                 |             |             |        |           | postgres=CTc/postgres
(4 rows)

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".

gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# \q
*/

-- Step 42 -->> On All Nodes
root@master-n1/slave-n1:~# cat /etc/postgresql/17/main/postgresql.conf | grep -E "port = 5432"
/*
port = 5432                             # (change requires restart)
*/

-- Step 42.1 -->> On All Nodes
root@master-n1/slave-n1:~# ufw status
/*
Status: inactive
*/

-- Step 42.2 -->> On All Nodes
root@master-n1/slave-n1:~# ufw enable
/*
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
*/

-- Step 42.3 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl start ufw

-- Step 42.4 -->> On All Nodes
root@master-n1/slave-n1:~# systemctl status ufw
/*
● ufw.service - Uncomplicated firewall
     Loaded: loaded (/usr/lib/systemd/system/ufw.service; enabled; preset: enabled)
     Active: active (exited) since Fri 2025-01-10 20:16:00 +0545; 2h 25min ago
       Docs: man:ufw(8)
   Main PID: 1076 (code=exited, status=0/SUCCESS)
        CPU: 4ms

Jan 10 20:16:00 master-n1.unidev.org.com systemd[1]: Starting ufw.service - Uncomplicated firewall...
Jan 10 20:16:00 master-n1.unidev.org.com systemd[1]: Finished ufw.service - Uncomplicated firewall.
*/

-- Step 42.5 -->> On All Nodes
root@master-n1/slave-n1:~# ufw status
/*
Status: active
*/

-- Step 42.6 -->> On All Nodes
root@master-n1/slave-n1:~# ufw allow 5432/tcp
/*
Rule added
Rule added (v6)
*/

-- Step 42.7 -->> On All Nodes
root@master-n1/slave-n1:~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
5432/tcp (v6)              ALLOW       Anywhere (v6)
*/

-- Step 42.8 -->> On All Nodes
root@master-n1/slave-n1:~# ufw allow from 10.0.131.3 to any port 22 proto tcp
/*
Rule added
*/

-- Step 42.9 -->> On All Nodes
root@master-n1/slave-n1:~# ufw reload
/*
Firewall reloaded
*/

-- Step 42.10 -->> On All Nodes
root@master-n1/slave-n1:~# ufw status
/*
Status: active

To                         Action      From
--                         ------      ----
5432/tcp                   ALLOW       Anywhere
22/tcp                     ALLOW       10.0.131.3
5432/tcp (v6)              ALLOW       Anywhere (v6)
*/

-- Step 01 -->> On All Nodes (status Using pg_ctl)
root@master-n1/slave-n1:~# sudo find / -name pg_ctl
/*
/usr/lib/postgresql/17/bin/pg_ctl
*/

-- Step 01.01 -->> On All Nodes
root@master-n1/slave-n1:~# /usr/lib/postgresql/17/bin/pg_ctl --version
/*
pg_ctl (PostgreSQL) 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
*/

-- Step 01.02 -->> On Node 1
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 6123)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 01.03 -->> On Node 2
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 6306)
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
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
/*
waiting for server to shut down.... done
server stopped
*/

-- Step 02.01 -->> On Node 2 (Shutting Down the Slave Node Log)
root@slave-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2025-01-10 23:06:08.483 +0545 [6306] LOG:  received smart shutdown request
2025-01-10 23:06:08.484 +0545 [6310] FATAL:  terminating walreceiver process due to administrator command
2025-01-10 23:06:08.488 +0545 [6307] LOG:  shutting down
2025-01-10 23:06:08.509 +0545 [6306] LOG:  database system is shut down
*/

-- Step 02.02 -->> On Node 1 (Shutting Down the Master Node)
-- Smart Shutdown: Waits for all active sessions to complete.
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data -m smart
/*
waiting for server to shut down.... done
server stopped
*/

-- Step 02.03 -->> On Node 1 (Shutting Down the Master Node Log)
root@master-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2025-01-10 23:06:26.923 +0545 [6123] LOG:  received smart shutdown request
2025-01-10 23:06:26.929 +0545 [6123] LOG:  background worker "logical replication launcher" (PID 6131) exited with exit code 1
2025-01-10 23:06:26.929 +0545 [6124] LOG:  shutting down
2025-01-10 23:06:26.951 +0545 [6124] LOG:  checkpoint starting: shutdown immediate
2025-01-10 23:06:27.051 +0545 [6124] LOG:  checkpoint complete: wrote 0 buffers (0.0%); 0 WAL file(s) added, 0 removed, 1 recycled; write=0.010 s, sync=0.001 s, total=0.105 s; sync files=0, longest=0.000 s, average=0.000 s; distance=16383 kB, estimate=16384 kB; lsn=0/6000028, redo lsn=0/6000028
2025-01-10 23:06:27.073 +0545 [6123] LOG:  database system is shut down
*/


--(Manully Startup master and slave Using pg_ctl)
--Replication Setup: The slave node needs to connect to the master node to start replicating data. If the master node is not running, the slave node won't be able to establish this connection.
--Avoiding Errors: Starting the master node first ensures that the slave node can properly synchronize with it, avoiding replication errors.
--So, the sequence should be:
--1. Start the master node.
--2. Start the slave node.

-- Step 03 -->> On Node 1 (Strating the Master Node)
--Strating the Master Node
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"
/*
waiting for server to start.... done
server started
*/

-- Step 03.01 -->> On Node 1 (Strating the Master Node Log)
root@master-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2025-01-10 23:06:55.147 +0545 [7303] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2025-01-10 23:06:55.147 +0545 [7303] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2025-01-10 23:06:55.147 +0545 [7303] LOG:  listening on IPv6 address "::", port 5432
2025-01-10 23:06:55.148 +0545 [7303] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2025-01-10 23:06:55.152 +0545 [7306] LOG:  database system was shut down at 2025-01-10 23:06:27 +0545
2025-01-10 23:06:55.157 +0545 [7303] LOG:  database system is ready to accept connections
*/

-- Step 03.02 -->> On Node 1 (Status of Master Node)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 7303)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 03.03 -->> On Node 2 (Strating of Slave Node)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"
/*
waiting for server to start.... done
server started
*/

-- Step 03.04 -->> On Node 2 (Strating of Slave Node Log)
root@slave-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log
/*
2025-01-10 23:07:34.429 +0545 [7165] LOG:  starting PostgreSQL 17.2 (Ubuntu 17.2-1.pgdg24.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0, 64-bit
2025-01-10 23:07:34.429 +0545 [7165] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2025-01-10 23:07:34.429 +0545 [7165] LOG:  listening on IPv6 address "::", port 5432
2025-01-10 23:07:34.430 +0545 [7165] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2025-01-10 23:07:34.433 +0545 [7168] LOG:  database system was shut down in recovery at 2025-01-10 23:06:08 +0545
2025-01-10 23:07:34.434 +0545 [7168] LOG:  entering standby mode
2025-01-10 23:07:34.435 +0545 [7168] LOG:  redo starts at 0/5000060
2025-01-10 23:07:34.435 +0545 [7168] LOG:  consistent recovery state reached at 0/5000168
2025-01-10 23:07:34.435 +0545 [7168] LOG:  invalid record length at 0/5000168: expected at least 24, got 0
2025-01-10 23:07:34.435 +0545 [7165] LOG:  database system is ready to accept read-only connections
2025-01-10 23:07:34.445 +0545 [7169] LOG:  started streaming WAL from primary at 0/5000000 on timeline 1
*/

-- Step 03.05 -->> On Node 2 (Status of Slave Node)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl status -D /data/postgres/17/data
/*
pg_ctl: server is running (PID: 7165)
/usr/lib/postgresql/17/bin/postgres "-D" "/data/postgres/17/data" "-c" "config_file=/etc/postgresql/17/main/postgresql.conf"
*/

-- Step 03.06 -->> On Node 1 (Master Node Verification)
root@master-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 7316
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.178.21.23
client_hostname  |
client_port      | 51610
backend_start    | 2025-01-10 23:07:34.556765+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/60000D8
write_lsn        | 0/60000D8
flush_lsn        | 0/60000D8
replay_lsn       | 0/60000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-10 23:08:24.619143+05:45

postgres=# \q
*/

-- Step 03.7 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 7169
status                | streaming
receive_start_lsn     | 0/5000000
receive_start_tli     | 1
written_lsn           | 0/60000D8
flushed_lsn           | 0/60000D8
received_tli          | 1
last_msg_send_time    | 2025-01-10 23:08:34.729048+05:45
last_msg_receipt_time | 2025-01-10 23:08:34.611704+05:45
latest_end_lsn        | 0/60000D8
latest_end_time       | 2025-01-10 23:07:34.562505+05:45
slot_name             |
sender_host           | 192.168.21.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.21.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 03.8 -->> On Node 1 (Master Node Verification) - (If master then return false else is slave then return true)
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 03.9 -->> On Node 2 (Slave Node Verification) - (If master then return false else is slave then return true)
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 03.10 -->> On Node 2 (Slave Node Verification) - (This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.)
root@slave-n1:~# sudo -u postgres psql -c "SELECT CASE
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
-- Switchover Steps from 192.168.21.22 master-n1.unidev.org.com to 192.178.21.23 slave-n1.unidev.org.com slave-n1
-- Prepare the Current Primary: (192.168.21.22 master-n1.unidev.org.com master-n1)
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@master-n1/slave-n1:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.21.22  master-n1.unidev.org.com master-n1

# Slave Node 1 - DR
192.178.21.23  slave-n1.unidev.org.com  slave-n1
*/

-- Step 04 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 04.01 -->> On Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 04.02 -->> On Node 2 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@slave-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 04.03 -->> On Node 1 (Master Node Verification)
root@master-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 7316
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.178.21.23
client_hostname  |
client_port      | 51610
backend_start    | 2025-01-10 23:07:34.556765+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/60000D8
write_lsn        | 0/60000D8
flush_lsn        | 0/60000D8
replay_lsn       | 0/60000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-10 23:10:24.664408+05:45

postgres=# \q
*/

-- Step 04.04 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 7169
status                | streaming
receive_start_lsn     | 0/5000000
receive_start_tli     | 1
written_lsn           | 0/60000D8
flushed_lsn           | 0/60000D8
received_tli          | 1
last_msg_send_time    | 2025-01-10 23:11:04.783385+05:45
last_msg_receipt_time | 2025-01-10 23:11:04.665853+05:45
latest_end_lsn        | 0/60000D8
latest_end_time       | 2025-01-10 23:07:34.562505+05:45
slot_name             |
sender_host           | 192.168.21.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.21.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 04.05 -->> On Node 1
root@master-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.21.22/32          trust
#host   replication      all             192.178.21.23/32          trust
*/

-- Step 04.06 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
host    replication     all             192.168.21.22/32          trust
#host    replication     all             192.178.21.23/32          trust
*/

-- Step 04.07 -->> On Node 1 - On the old primary server, stop the PostgreSQL service:
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 04.8 -->> On Node 2 - Promote the Standby - (On the standby server (192.178.21.23), promote it to primary using the pg_ctl command)
--root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_promote();"
/*
 pg_promote
------------
 t
(1 row)
*/

-- Step 04.9 -->> On Node 1 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@master-n1:~# su - postgres

-- Step 04.9.01 -->> On Node 1
postgres@master-n1:~$ touch /data/postgres/17/data/standby.signal

-- Step 04.9.02 -->> On Node 1
postgres@master-n1:~$ exit
/*
logout
*/

-- Step 04.9.03 -->> On Node 1
root@master-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres    0 Jan 10 23:14 standby.signal
*/


-- Step 04.10 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@master-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.178.21.23 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 04.10.01 -->> On Node 1
root@master-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.178.21.23 port=5432 user=replica_user password=Sys#605014#'      # connection string to sending server
*/

-- Step 04.11 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@slave-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
# primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.21.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 04.11.01 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
# primary_conninfo = 'host=192.168.21.22 port=5432 user=replica_user password=Sys#605014#'      # connection string to sending server
*/

-- Step 04.12 -->> On Node 1 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 04.13 -->> On Node 1 (Fresh Stop)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 04.13.01 -->> On Node 2 (Fresh Stop)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 04.14 -->> On Node 2 (Fresh Start)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 04.14.01 -->> On Node 1 (Fresh Start)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 04.14.02 -->> On All Nodes - Logs
root@slave-n1/master-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log


-- Step 04.15 -->> On Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 04.16 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 04.17 -->> On Node 1 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@master-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/


-- Step 04.18 -->> On Node 2 (Master Node Verification)
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 7297
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.21.22
client_hostname  |
client_port      | 48300
backend_start    | 2025-01-10 23:18:56.55758+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/8000220
write_lsn        | 0/8000220
flush_lsn        | 0/8000220
replay_lsn       | 0/8000220
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-10 23:19:49.994376+05:45

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".
gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# create table gdaauth.swich_test (sn int);
CREATE TABLE

gdaengine=# \dt gdaauth.*
            List of relations
 Schema  |    Name    | Type  |  Owner
---------+------------+-------+----------
 gdaauth | swich_test | table | postgres
(1 row)

gdaengine=# \q
*/

-- Step 04.19 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@master-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 7427
status                | streaming
receive_start_lsn     | 0/7000000
receive_start_tli     | 2
written_lsn           | 0/8009508
flushed_lsn           | 0/8009508
received_tli          | 2
last_msg_send_time    | 2025-01-10 23:20:41.188633+05:45
last_msg_receipt_time | 2025-01-10 23:20:41.307272+05:45
latest_end_lsn        | 0/8009508
latest_end_time       | 2025-01-10 23:20:41.188633+05:45
slot_name             |
sender_host           | 192.178.21.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.178.21.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".
gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# drop table gdaauth.swich_test;
ERROR:  cannot execute DROP TABLE in a read-only transaction

gdaengine=# \dt gdaauth.*
            List of relations
 Schema  |    Name    | Type  |  Owner
---------+------------+-------+----------
 gdaauth | swich_test | table | postgres
(1 row)

gdaengine=# \q
*/


-- Switchback Steps from 192.178.21.23 slave-n1.unidev.org.com slave-n1 to 192.168.21.22 master-n1.unidev.org.com master-n1
-- Prepare the Current Primary: 192.178.21.23 slave-n1.unidev.org.com slave-n1
-- Ensure the current primary is ready for switchover by checking for any pending transactions and ensuring replication is up-to-date:
root@master-n1/slave-n1:~# cat /etc/hosts
/*
# Master Node 1 - DC
192.168.21.22  master-n1.unidev.org.com master-n1

# Slave Node 1 - DR
192.178.21.23  slave-n1.unidev.org.com  slave-n1
*/

-- Step 05 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 05.01 -->> On Node 1- Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 05.02 -->> On Node 1 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@master-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 05.03 -->> On Node 2 (Master Node Verification)
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 7297
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.168.21.22
client_hostname  |
client_port      | 48300
backend_start    | 2025-01-10 23:18:56.55758+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/8009508
write_lsn        | 0/8009508
flush_lsn        | 0/8009508
replay_lsn       | 0/8009508
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-10 23:23:21.371474+05:45

postgres=# \q
*/

-- Step 05.04 -->> On Node 1 (Slave Node Verification) - If it is streaming that means working fine
root@master-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;

-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 7427
status                | streaming
receive_start_lsn     | 0/7000000
receive_start_tli     | 2
written_lsn           | 0/8009610
flushed_lsn           | 0/8009610
received_tli          | 2
last_msg_send_time    | 2025-01-10 23:23:53.955313+05:45
last_msg_receipt_time | 2025-01-10 23:23:54.074235+05:45
latest_end_lsn        | 0/8009610
latest_end_time       | 2025-01-10 23:23:53.955313+05:45
slot_name             |
sender_host           | 192.178.21.23
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.178.21.23 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \q
*/

-- Step 05.05 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.21.22/32          trust
host    replication     all             192.178.21.23/32          trust
*/

-- Step 05.06 -->> On Node 1
root@master-n1:~# vi /etc/postgresql/17/main/pg_hba.conf
/*
#host    replication     all             192.168.21.22/32          trust
host    replication     all             192.178.21.23/32          trust
*/

-- Step 05.07 -->> On Node 2 - On the old primary server, stop the PostgreSQL service:
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 05.08 -->> On Node 1 - Promote the Standby - (On the standby server (192.168.21.22), promote it to primary using the pg_ctl command)
--root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl promote -D /data/postgres/17/data/
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_promote();"
/*
 pg_promote
------------
 t
(1 row)
*/

-- Step 05.09 -->> On Node 2 - Create standby.signal File on the Old Primary (Create the standby.signal file to indicate that this server should start as a standby)
root@slave-n1:~# su - postgres

-- Step 05.10 -->> On Node 2
postgres@slave-n1:~$ touch /data/postgres/17/data/standby.signal

-- Step 05.10.01 -->> On Node 2
postgres@slave-n1:~$ exit
/*
logout
*/

-- Step 05.10.02 -->> On Node 2
root@slave-n1:~# ll /data/postgres/17/data/ | grep stan
/*
-rw-rw-r--  1 postgres postgres      0 Jan 10 23:27 standby.signal
*/


-- Step 05.11 -->> On Node 2 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@slave-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.168.21.22 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 05.11.01 -->> On Node 2
root@slave-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
primary_conninfo = 'host=192.168.21.22 port=5432 user=replica_user password=Sys#605014#'      # connection string to sending server
*/

-- Step 05.12 -->> On Node 1 - Update postgresql.auto.conf on the Old Primary (Ensure the primary_conninfo is set correctly)
root@master-n1:~# vi /data/postgres/17/data/postgresql.auto.conf
/*
# Do not edit this file manually!
# It will be overwritten by the ALTER SYSTEM command.
#primary_conninfo = 'user=replica_user passfile=''/home/postgres/.pgpass'' channel_binding=prefer host=192.178.21.23 port=5432 sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable'
*/

-- Step 05.12.01 -->> On Node 1
root@master-n1:~# vi /etc/postgresql/17/main/postgresql.conf
/*
#primary_conninfo = 'host=192.178.21.23 port=5432 user=replica_user password=Sys#605014#'      # connection string to sending server
*/

-- Step 05.13 -->> On Node 2 - Start the Old Primary as Standby (Start the PostgreSQL service on the old primary, now acting as standby)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 05.14 -->> On Node 2 (Fresh Stop)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 05.14.01 -->> On Node 1 (Fresh Stop)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl stop -D /data/postgres/17/data

-- Step 05.15 -->> On Node 1 (Fresh Start)
root@master-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 05.15.01 -->> On Node 2 (Fresh Start)
root@slave-n1:~# sudo -u postgres /usr/lib/postgresql/17/bin/pg_ctl start -D /data/postgres/17/data/ -l /var/log/postgresql/postgresql-17-main.log -o "-c config_file=/etc/postgresql/17/main/postgresql.conf"

-- Step 05.15.02 -->> On All Nodes - Logs
root@master-n1/slave-n1:~# tail -f /var/log/postgresql/postgresql-17-main.log

-- Step 05.16 -->> On Node 1 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@master-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 f
(1 row)
*/

-- Step 05.17 -->> On Node 2 - Verification - To verfy is Master or Slave (If master then return false else is slave then return true)
root@slave-n1:~# sudo -u postgres psql -c "SELECT pg_is_in_recovery();"
/*
 pg_is_in_recovery
-------------------
 t
(1 row)
*/

-- Step 05.18 -->> On Node 2 - Verification - This query compares the LSNs (Log Sequence Numbers) of received and replayed WAL (Write-Ahead Log) data, indicating the synchronization status.
root@slave-n1:~# sudo -u postgres psql -c "SELECT CASE
                                                                    WHEN pg_last_wal_receive_lsn() = pg_last_wal_replay_lsn() THEN 0
                                                                    ELSE EXTRACT(EPOCH FROM now() - pg_last_xact_replay_timestamp())
                                                                END AS log_delay;"
/*
 log_delay
-----------
         0
(1 row)
*/

-- Step 08.19 -->> On Node 1 (Master Node Verification)
root@master-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_replication;

-[ RECORD 1 ]----+------------------------------
pid              | 1808
usesysid         | 16388
usename          | replica_user
application_name | 17/main
client_addr      | 192.178.21.23
client_hostname  |
client_port      | 33966
backend_start    | 2025-01-11 00:12:50.778498+05:45
backend_xmin     |
state            | streaming
sent_lsn         | 0/90000D8
write_lsn        | 0/90000D8
flush_lsn        | 0/90000D8
replay_lsn       | 0/90000D8
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
reply_time       | 2025-01-11 00:13:41.417181+05:45

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".

gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# \dt gdaauth.*
            List of relations
 Schema  |    Name    | Type  |  Owner
---------+------------+-------+----------
 gdaauth | swich_test | table | postgres
(1 row)

gdaengine=# drop table gdaauth.swich_test;
DROP TABLE

gdaengine=# \dt gdaauth.*
Did not find any relation named "gdaauth.*".

gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# \q
*/

-- Step 08.20 -->> On Node 2 (Slave Node Verification) - If it is streaming that means working fine
root@slave-n1:~# sudo -u postgres psql
/*
psql (17.2 (Ubuntu 17.2-1.pgdg24.04+1))
Type "help" for help.

postgres=# \x
Expanded display is on.

postgres=# \pset columns 9999
Target width is 9999.

postgres=# SELECT * FROM pg_stat_wal_receiver;
-[ RECORD 1 ]---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
pid                   | 1766
status                | streaming
receive_start_lsn     | 0/8000000
receive_start_tli     | 2
written_lsn           | 0/9009CE0
flushed_lsn           | 0/9009CE0
received_tli          | 2
last_msg_send_time    | 2025-01-11 00:16:03.142298+05:45
last_msg_receipt_time | 2025-01-11 00:16:03.339254+05:45
latest_end_lsn        | 0/9009CE0
latest_end_time       | 2025-01-11 00:15:03.120737+05:45
slot_name             |
sender_host           | 192.168.21.22
sender_port           | 5432
conninfo              | user=replica_user passfile=/home/postgres/.pgpass channel_binding=prefer dbname=replication host=192.168.21.22 port=5432 fallback_application_name=17/main sslmode=prefer sslnegotiation=postgres sslcompression=0 sslcertmode=allow sslsni=1 ssl_min_protocol_version=TLSv1.2 gssencmode=prefer krbsrvname=postgres gssdelegation=0 target_session_attrs=any load_balance_hosts=disable

postgres=# \connect gdaengine
You are now connected to database "gdaengine" as user "postgres".

gdaengine=# \dn
       List of schemas
  Name   |       Owner
---------+-------------------
 gdaauth | postgres
 gdapii  | postgres
 public  | pg_database_owner
(3 rows)

gdaengine=# \dt gdaauth.*
Did not find any relation named "gdaauth.*".

gdaengine=# \q
*/
