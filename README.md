# Arch
Attempt to create a personal Arch install script/guide

# LUKS Partition/Encryption Guide
* Run lsblk to list available drives
* Run cfdisk to create a boot and data partition
  * Run "mkfs.fat -F32 /dev/nvmen1p1" to format boot partition
  * Run "cryptsetup luksFormat /dev/nvmen1p2" to encrypt the data partition
  * Run "cryptsetup luksOpen /dev/nvmen1p2 crypt" to decrypt the drive
  * Run "mount /dev/mapper/crypt /mnt" to mount to /mnt
  * Run "mkfs.btrfs /dev/mapper/crypt" to format the encrypted drive with BTRFS filesystem
  * Run "cd /mnt" to enter the /mnt directory
  * Run "btrfs subvolume create @" to create the root subvolume
  * Run "btrfs subvolume create @home" to create the home subvolume
  * Run "umount /mnt" to unmount the unencryptyed drive  
