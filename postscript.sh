#!/usr/bin/env bash

## Variables
timezone = "Asia/Kolkata"
hostname = "arch"
additional_pkgs = "networkmanager efibootmgr git nvim lxde-common lxsession xmonad xmonad-contrib xterm alacritty xorg pulseaudio pulseaudio-alsa alsa-plugins alsa-utils automake autoconf dosfstools mtools basedevel"

## Chroot into mnt
#echo "Chrooting into install..."
#arch-chroot /mnt
#read a

## timezone and hwclock
echo "Setting timezone and clock..."
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
read a

## locale
echo "Setting up locale config..."
sed -i -e "s/#en_US.UTF/en_US.UTF/g" /etc/locale.gen
sed -i -e "s/#en_IN/en_IN/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf
read a

## hostname and hosts file
echo "Setting hostname and hosts file..."
echo $hostname >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
read a

## Additional packages
echo "Installing additional packages..."
pacman -S $additional_pkgs
systemctl enable NetworkManager
read a

## GRUB
echo "Installing GRUB..."
grub-install --target=x86_64-efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg
read a

echo "################--> Done!"
