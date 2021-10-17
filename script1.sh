#!/bin/bash

## Variables
#efi_part= "/dev/sda1"
#swap_part= "/dev/sda2"
#root_part= "/dev/sda3"
#timezone= "Asia/Kolkata"
#hostname= "arch"
#additional_pkgs= "networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

## Format and turn on swap partition
mkswap /dev/sda2
swapon /dev/sda2

## Format and mount root partition
mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt

## Changing pacman ParallelDownloads from 1 to 5
sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
## Installing the base
pacstrap /mnt base linux linux-firmware

## Format and mount efi partition
mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

## Generate filesystem tab
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt
