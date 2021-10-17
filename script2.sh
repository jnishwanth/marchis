#!/bin/bash

## Variables
#efi_part= "/dev/sda1"
#swap_part= "/dev/sda2"
#root_part= "/dev/sda3"
#timezone= "Asia/Kolkata"
#hostname= "arch"
#additional_pkgs= "networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

## timezone and hwclock
echo "Setting timezone and clock..."
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

## Set locale
echo "Setting up locale config..."
sed -i -e "s/#en_US.UTF/en_US.UTF/g" /etc/locale.gen
sed -i -e "s/#en_IN/en_IN/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname and hosts file
echo "Setting hostname and hosts file..."
echo "archvbx" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archvbx.localdomain archvbx" >> /etc/hosts

## Additional packages and desktop environment
echo "Installing additional packages..."
pacman -S grub efibootmgr networkmanager lxdm lxde-common lxsession openbox alacritty xorg
systemctl enable NetworkManager
systemctl enable lxdm.service

## GRUB
echo "Installing GRUB bootloader..."
grub-install --target=x86_64-efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

## Set root password
passwd

## exit
exit
umount -R /mnt

echo "################--> Done!"
