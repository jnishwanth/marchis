#!/bin/bash

## Variables
efi_part= "/dev/sda1"
swap_part= "/dev/sda2"
root_part= "/dev/sda3"
timezone= "Asia/Kolkata"
hostname= "arch"
additional_pkgs= "networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

mkswap $swap_part
swapon $swap_part

mkfs.ext4 $root_part
mount $root_part /mnt

sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
pacstrap /mnt base linux linux-firmware

mkfs.fat -F32 $efi_part
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot/EFI

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
echo "$hostname" >> /etc/hostname

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

passwd
exit
umount -R /mnt

echo "################--> Done!"
