#!/bin/bash

## Variables
EFI_PART="sda1"
SWAP_PART="sda2"
ROOT_PART="sda3"
#TIMEZONE="Asia/Kolkata"
#HOSTNAME="arch"
#ADDITIONAL_PKGS="networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

## Format and turn on swap partition
echo "Formatting partitions, mounting partitions and installing base..."
mkswap /dev/$SWAP_PART
swapon /dev/$SWAP_PART

## Format and mount root partition
mkfs.ext4 /dev/$ROOT_PART
mount /dev/$ROOT_PART /mnt

## Changing pacman ParallelDownloads from 1 to 5
sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
## Installing the base
pacstrap /mnt base linux linux-firmware git

## Format and mount efi partition
mkfs.fat -F32 /dev/$EFI_PART
mkdir /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

## Generate filesystem tab
echo "Generating filesystem tab..."
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt
