#!/usr/bin/env bash

## Variables
efi_part = "vda1"
swap_part = "vda2"
root_part = "vda3"
base_pkgs = "base linux linux-firmware"
timezone = "Asia/Kolkata"
hostname = "arch"
additional_pkgs = "networkmanager efibootmgr git nvim lxde-common lxsession xmonad xmonad-contrib xterm alacritty xorg pulseaudio pulseaudio-alsa alsa-plugins alsa-utils automake autoconf dosfstools mtools basedevel"

## NTP
echo "Setting NTP..."
timedatectl set-ntp true
read a

## Formatting
echo "Formatting partitions..."
mkfs.fat -F32 /dev/$efi_part
mkfs.ext4 /dev/$root_part
mkswap /dev/$swap_part

mount /dev/$root_part /mnt
swpaon /dev/$swap_part
read a

## Install base on mnt
echo "Installing base packages..."
pacstrap /mnt $base_pkgs
mkdir /mnt/boot/EFI
mount /dev/$efi_part /mnt/boot/EFI
read a

## filesystem tab
echo "Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab
read a

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt
read a

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
echo "127.0.1.1 $hostname.localdomain $hostname"
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
