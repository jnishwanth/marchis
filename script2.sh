#!/bin/bash

## Variables
#EFI_PART="/dev/sda1"
#SWAP_PART="/dev/sda2"
#ROOT_PART="/dev/sda3"
TIMEZONE="Asia/Kolkata"
HOSTNAME="arch"
ADDITIONAL_PKGS="networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"


## timezone and hwclock
echo "Setting timezone and clock..."
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

## Set locale
echo "Setting up locale config..."
sed -i -e "s/#en_US.UTF/en_US.UTF/g" /etc/locale.gen
sed -i -e "s/#en_IN/en_IN/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname and hosts file
echo "Setting hostname and hosts file..."
echo $HOSTNAME >> /etc/hostname

echo "127.0.0.1 localhost
::1       localhost
127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

## Additional packages and desktop environment
echo "Installing additional packages..."
sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
pacman -S "$ADDITIONAL_PKGS"
systemctl enable NetworkManager
systemctl enable lxdm.service

## GRUB
echo "Installing GRUB bootloader..."
grub-install --target=x86_64-efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

## Set root password
echo "Setting password fot root user"
passwd

## exit
exit
umount -R /mnt

echo "################--> Done!"
