命令记录

创建一个虚拟软盘
fallocate -l 1474560 floppy.vfd
mkfs.vfat floppy.vfd
sudo mount -o loop floppy.vfd /mnt/fd0

