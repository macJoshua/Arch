# Linux Install Guide(s?)
This is my personal Arch Install Guide and script(s) collection.
So far I have instructions for how to do a single install of Arch on a LUKS encrypted drive.

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
 
 # Installing base Arch Linux packages 
  * Run "pacstrap /mnt base linux linux-firmware nano git amd-ucode btrfs-progs" to install the base packages
  * Run "genfstab -U /mnt >> /mnt/etc/fstab" to generate fstab table in the Arch install
  * Run "arch-chroot /mnt" to enter the install
  * Run "nano /etc/mkinitcpio.conf" to edit the mkinitcpio config
  * Add "btrfs" to the modules
  * Add "encrypt" to the Hooks before filesystems
  * Run "mkinitcpio -p linux" to recreate initramfs
  * Run "git clone https://github.com/macJoshua/ArchInstall/" for the install script
  * Modify the needed sections
  * Run "chmod +x KDE_Install.sh"



