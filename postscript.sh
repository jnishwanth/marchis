#!/bin/bash

## Variables
#efi_part= "/dev/sda1"
#swap_part= "/dev/sda2"
#root_part= "/dev/sda3"
#timezone= "Asia/Kolkata"
#hostname= "arch"
#additional_pkgs= "networkmanager efibootmgr git neovim lxde-common lxsession openbox alacritty xorg"

mkswap /dev/sda2
swapon /dev/sda2

mkfs.ext4 /dev/sda3
mount /dev/sda3 /mnt

sed -i -e "s/#ParallelDown/ParallelDown/g" /etc/pacman.conf
pacstrap /mnt base linux linux-firmware

mkfs.fat -F32 /dev/sda1
mount /dev/sda1 /mnt/boot/
mkdir /mnt/boot/EFI

genfstab -U /mnt >> /mnt/etc/fstab

## Chroot into mnt
echo "Chrooting into install..."
arch-chroot /mnt
read a

## timezone and hwclock
echo "Setting timezone and clock..."
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
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
echo "archvbx" >> /etc/hostname

echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 archvbx.localdomain archvbx" >> /etc/hosts
read a

## Additional packages
echo "Installing additional packages..."
pacman -S grub efibootmgr networkmanager lxdm lxde-common lxsession openbox alacritty xorg
systemctl enable NetworkManager
systemctl enable lxdm.service

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
