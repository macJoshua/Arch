#!/bin/bash

#EDIT SYSTEM CONFIGURATION PRIOR TO RUNNING SCRIPT
##Specifically hostname and account information in brackets
##Also review partition information in Bootloader setup

##########################################################
####################System Configuration##################
##########################################################

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen #English Char
echo "en_US ISO-8859-1" >> /etc/locale.gen  #English Char
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "framework" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 framework.localdomain framework" >> /etc/hosts
#sudo timedatectl set-ntp true
echo root:[password] | chpasswd
useradd -mG wheel [username]
echo [username]:[password] | chpasswd
echo "[username] ALL=(ALL) ALL" >> /etc/sudoers.d/[username]

##########################################################
###################Package Installation###################
##########################################################

#Installs Arch yay package manager in /opt
#cd /opt
#git clone https://aur.archlinux.org/yay.git
#cd yay/
#makepkg -si --noconfirm

#removes yay directory after install
#cd /opt
#rm -rf yay

#Standard System Packages
pacman -S --noconfirm efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh acpi acpi_call tlp os-prober ntfs-3g terminus-font tlp firefox vlc libreoffice-fresh net-tools openvpn networkmanager-openvpn steam

# Uncomment the necessary packages
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

#KDE specific packages
pacman -S --noconfirm konsole dolphin plasma-wayland-session sddm plasma plasma-desktop plasma-workspace plasma-pa plasma-nm kde-system-meta 

#AUR specific packages
#brave-bin ttf-ms-fonts zramd
#Enable packages in systemctl 
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp 
systemctl enable fstrim.timer
systemctl enable acpid
systemctl enable sddm
#systemctl enable zramd

printf "\e[1;32mDon't forget to modify bootloader information prior to reboot!\e[0m"

##########################################################
#####################Bootloader Setup#####################
##########################################################

#This fixes the security hole warning when installing systemd
#umount /boot
#sudo mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /boot

#Install systemd bootloader
bootctl --path=/boot install 
echo "timeout  3" >> /boot/loader/loader.conf
echo "default  Arch" >> /boot/loader/loader.conf

#Configuring default Arch image
#crypt should be replaced with whatever the encrypted drive is mounted as
#refer to the bracketed section /dev/mapper/[crypt]
#UUID can be retrieved via "blkid" command
echo "title  Arch Linux" >> /boot/loader/entries/arch.conf
echo "linux  /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options  cryptdevice=UUID=XX[nvme]XX:crypt root=UUID=XX[/dev/mapper/crypt]XX rootflags=subvol=@ rw" >> /boot/loader/entries/arch.conf

#Configuring fallback Arch image
echo "title  Arch Linux" >> /boot/loader/entries/arch-fallback.conf
echo "linux  /vmlinuz-linux" >> /boot/loader/entries/arch-fallback.conf
echo "initrd  /initramfs-linux-fallback.img" >> /boot/loader/entries/arch-fallback.conf
echo "options  cryptdevice=UUID=XX[nvme]XX:crypt root=UUID=XX[/dev/mapper/crypt]XX rootflags=subvol=@ rw" >> /boot/loader/entries/arch-fallback.conf
