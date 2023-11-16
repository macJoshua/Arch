#!/bin/bash

ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "framework" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 framework.localdomain framework" >> /etc/hosts
sudo timedatectl set-ntp true

echo root:[password] | chpasswd

#Installs Arch yay package manager
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm

#Standard System Packages
yay -S --noconfirm efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh acpi acpi_call acipd tlp os-prober ntfs-3g terminus-font tlp firefox vlc libreoffice-fresh net-tools libreoffice-fresh

# Uncomment the necessary packages
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

#KDE specific packages
yay -S --noconfirm konsole dolphin plasma-wayland-session sddm plasma plasma-desktop plasma-workspace plasma-pa plasma-nm kde-system-meta

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp 
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid
sudo systemctl enable sddm

useradd -mG [username]
echo [username]:[password] | chpasswd
echo "[username] ALL=(ALL) ALL" >> /etc/sudoers.d/username

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
