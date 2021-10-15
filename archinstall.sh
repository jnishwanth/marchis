#!bin/bash

## Variables
efi_part = "vda1"
swap_part = "vda2"
root_part = "vda3"
base_pkgs = "base linux linux-firmware"
timezone = "Asia/Kolkata"
hostname = "arch"
additional_pkgs = "git nvim lxde-common lxsession xmonad xmonad-contrib xterm alacritty xorg pulseaudio pulseaudio-alsa alsa-plugins alsa-utils automake autoconf dosfstools mtools basedevel"

## NTP
timedatectl set-ntp true

## Formatting and mounting
mkfs.ext4 /dev/$root_part
mkswap /dev/$swap_part

mount /dev/$root_part /mnt
swpaon /dev/$swap_part

## Install base on mnt
pacstrap /mnt $base_pkgs

## Generate filesystem tab
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
arch-chroot /mnt

## Link your timezone and sync hwclock
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

## Generate locale
sed -i -e "s/#en_US.UTF/en_US.UTF/g" /etc/locale.gen
sed -i -e "s/#en_IN/en_IN/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname and hosts file
echo $hostname >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname"

## Installing additional packages
pacman -S $additional_pkgs
