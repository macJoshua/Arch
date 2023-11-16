# Arch Install Guide
Attempt to create a personal Arch install script/guide

# LUKS Partition/Encryption Guide
* Run lsblk to list available drives
* Run cfdisk to create a boot and data partition
  * Run "mkfs.fat -F32 /dev/nvme0n1p1" to format boot partition
  * Run "cryptsetup luksFormat /dev/nvme0n1p2" to encrypt the data partition
  * Run "cryptsetup luksOpen /dev/nvme0n1p2 crypt" to decrypt the drive  
  * Run "mkfs.btrfs /dev/mapper/crypt" to format the encrypted drive with BTRFS filesystem
  * Run "mount /dev/mapper/crypt /mnt" to mount to /mnt
  * Run "cd /mnt" to enter the /mnt directory
  * Run "btrfs subvolume create @" to create the root subvolume
  * Run "btrfs subvolume create @home" to create the home subvolume
  * Run "cd" to exit /mnt directory
  * Run "umount /mnt" to unmount the unencrypted drive
  * Run "mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/mapper/crypt /mnt" to mount the root subvolume under /mnt
  * Run "mkdir /mnt/{boot,home}" to create the home and boot directories on the root subvolume
  * Run "mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/mapper/crypt /mnt/home" to mount the home subvolume under /mnt/home
  * Run "mount /dev/nvme0n1p1 /mnt/boot" to mount the boot partition under /mnt/boot
 
 #Installing base Arch Linux packages 
  * Run "pacstrap /mnt base linux linux-firmware nano git amd-ucode" to install the base packages
  * Run "genfstab -U /mnt >> /mnt/etc/fstab" to generate fstab table in the Arch install
  * Run "arch-chroot /mnt" to enter the install
  * Run "nano /etc/mkinitcpio.conf" to edit the mkinitcpio config
  * Add "btrfs" to the modules
  * Add "encrypt" to the Hooks before filesystems
  * Run "mkinitcpio -p linux" to recreate initramfs
  * Run "ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime" to set local timezone
  * Run "hwclock --systohc" to sync system clock with hardware clock
  * Run "nano /etc/locale.gen" and uncomment the lines for "en_US.UTF-8"
  * Run "echo "LANG=en_US.UTF-8" >> /etc/locale.conf" to set language
  * Run "echo "framework" >> /etc/hostname" to set hostname
  * Run "echo "127.0.0.1 localhost" >> /etc/hosts"
  * Run "echo "::1       localhost" >> /etc/hosts"
  * Run "echo "127.0.1.1 framework.localdomain framework" >> /etc/hosts"

#Systemd setup
* umount /boot
* mount -o uid=0,gid=0,fmask=0077,dmask=0077 /dev/nvme0n1p1 /boot
* bootctl --path=/boot/ install
* nano /boot/loader/loader.conf
* add "timeout 3" "default Arch"
* nano /boot/loader/entries/arch.conf
* title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options cryptdevice=UUID=c922ba7d-d096-424b-8b0a-3621ecc257a8:crypt root=UUID=fb771f94-ff7b-42be-9cbf-a17c1be77472 rootflags=subvol=@



