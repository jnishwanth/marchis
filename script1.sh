#!/bin/bash

## Variables
EFI_PART="/dev/sda1"
SWAP_PART="/dev/sda2"
ROOT_PART="/dev/sda3"
#TIMEZONE="Asia/Kolkata"
#HOSTNAME="arch"
#ADDITIONAL_PKGS="networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

## Format and turn on swap partition
mkswap $SWAP_PART
swapon $SWAP_PART

## Format and mount root partition
mkfs.ext4 $ROOT_PART
mount $ROOT_PART /mnt

## Changing pacman ParallelDownloads from 1 to 5
sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
## Installing the base
pacstrap /mnt base linux linux-firmware git

## Format and mount efi partition
mkfs.fat -F32 $EFI_PART
mkdir /mnt/boot/EFI
mount /dev/sda1 /mnt/boot/EFI

## Generate filesystem tab
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt
