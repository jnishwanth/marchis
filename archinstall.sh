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
echo "Setting NTP..."
timedatectl set-ntp true

## Formatting and mounting
echo "Formatting partitions..."
mkfs.ext4 /dev/$root_part
mkswap /dev/$swap_part

mount /dev/$root_part /mnt
swpaon /dev/$swap_part

## Install base on mnt
echo "Installing base packages..."
pacstrap /mnt $base_pkgs

## Generate filesystem tab
echo "Generating fstab file..."
genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt

## Link your timezone and sync hwclock
echo "Setting timezone and clock..."
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

## Generate locale
echo "Setting up locale config..."
sed -i -e "s/#en_US.UTF/en_US.UTF/g" /etc/locale.gen
sed -i -e "s/#en_IN/en_IN/g" /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" >> /etc/locale.conf

## Set hostname and hosts file
echo "Setting hostname and hosts file..."
echo $hostname >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname"

## Installing additional packages
echo "Installing additional packages..."
pacman -S $additional_pkgs

echo "Done"
