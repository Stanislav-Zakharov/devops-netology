###node_exporter
1. Sparse files
>В разряженных файлах последовательности нулевых байтов (дыры) не занимают пространства в блоках данных, 
> а информация о "дырах" содержится в таблице fs.  
>При этом мы получаем экономию диского пространства, но более дорогие операции i/o
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
>Не могут, так как жесткая ссылка - это указатель на исходный объект в файловой системе, имеющая идентичный inode
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```bash
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x49a05bb3.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

```
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
```bash
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb > sdb.dump
vagrant@vagrant:~$ cat sdb.dump
label: dos
label-id: 0x49a05bb3
device: /dev/sdb
unit: sectors

/dev/sdb1 : start=        2048, size=     4194304, type=83
/dev/sdb2 : start=     4196352, size=     1046528, type=83
vagrant@vagrant:~$ sudo sfdisk /dev/sdc < sdb.dump
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x49a05bb3.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x49a05bb3

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
6. Соберите mdadm RAID1 на паре разделов 2 Гб.
```bash
vagrant@vagrant:~$ sudo mdadm --create /dev/md0 -l1 -n2 /dev/sd{b1,c1}
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
vagrant@vagrant:~$ lsblk /dev/sd{b,c}
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb       8:16   0  2.5G  0 disk
├─sdb1    8:17   0    2G  0 part
│ └─md0   9:0    0    2G  0 raid1
└─sdb2    8:18   0  511M  0 part
sdc       8:32   0  2.5G  0 disk
├─sdc1    8:33   0    2G  0 part
│ └─md0   9:0    0    2G  0 raid1
└─sdc2    8:34   0  511M  0 part
```
7. Соберите mdadm RAID0 на второй паре маленьких разделов.
```bash
vagrant@vagrant:~$ sudo mdadm --create /dev/md1 -l0 -n2 /dev/sd{b2,c2}
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$ lsblk /dev/sd{b,c}
NAME    MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sdb       8:16   0  2.5G  0 disk
├─sdb1    8:17   0    2G  0 part
│ └─md0   9:0    0    2G  0 raid1
└─sdb2    8:18   0  511M  0 part
  └─md1   9:1    0 1018M  0 raid0
sdc       8:32   0  2.5G  0 disk
├─sdc1    8:33   0    2G  0 part
│ └─md0   9:0    0    2G  0 raid1
└─sdc2    8:34   0  511M  0 part
  └─md1   9:1    0 1018M  0 raid0
```
8. Создайте 2 независимых PV на получившихся md-устройствах.
```bash
vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
vagrant@vagrant:~$ sudo pvdisplay /dev/md*
  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               IOCbBd-TLKw-eRFb-BioM-n9CJ-6GP8-D3DXCq

  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               TgM66w-r0Vr-axWz-zYNJ-ImkI-Vxep-TqLshA
```
9. Создайте общую volume-group на этих двух PV.
```bash
vagrant@vagrant:~$ sudo vgcreate vg01 /dev/md0 /dev/md1
  Volume group "vg01" successfully created
vagrant@vagrant:~$ sudo vgdisplay vg01
  --- Volume group ---
  VG Name               vg01
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               omQPy7-KHwX-rBkR-hX76-mpIx-1J96-Cwdtet
```
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```bash
vagrant@vagrant:~$ sudo lvcreate -L 100 -n lv01 /dev/vg01 /dev/md1
  Logical volume "lv01" created.
vagrant@vagrant:~$ sudo lvdisplay /dev/vg01
  --- Logical volume ---
  LV Path                /dev/vg01/lv01
  LV Name                lv01
  VG Name                vg01
  LV UUID                NSBvA0-YZQ3-IGr6-07Te-llyB-vnFe-uK25w2
  LV Write Access        read/write
  LV Creation host, time vagrant, 2022-03-31 20:09:52 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:1
```
11. Создайте mkfs.ext4 ФС на получившемся LV.
```bash
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vg01/lv01
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```
12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
```bash
vagrant@vagrant:~$ mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/vg01/lv01 /tmp/new
```
13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
```bash
vagrant@vagrant:/tmp/new$ sudo chmod a+w /tmp/new
vagrant@vagrant:/tmp/new$ wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-03-31 20:19:06--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22416316 (21M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                                  100%[==========================================================================================================>]  21.38M  23.9MB/s    in 0.9s

2022-03-31 20:19:07 (23.9 MB/s) - ‘/tmp/new/test.gz’ saved [22416316/22416316]
```
14. Прикрепите вывод lsblk.
```bash
vagrant@vagrant:/tmp/new$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 43.6M  1 loop  /snap/snapd/15177
loop4                       7:4    0 55.5M  1 loop  /snap/core18/2344
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1405
loop6                       7:6    0 67.8M  1 loop  /snap/lxd/22753
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─vg01-lv01           253:1    0  100M  0 lvm   /tmp/new
```
15. Протестируйте целостность файла:
```bash
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```bash
vagrant@vagrant:~$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 100.00%
```
17. Сделайте --fail на устройство в вашем RAID1 md.
```bash
vagrant@vagrant:~$ sudo mdadm --fail /dev/md0 /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```
18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
```bash
[ 3939.276421] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```bash
vagrant@vagrant:~$ gzip -t /tmp/new/test.gz
vagrant@vagrant:~$ echo $?
0
```
