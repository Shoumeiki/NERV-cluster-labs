# NERV Cluster Lab
*WIP* - come back later
I don't know how to use git so please let me know if I'm making major mistakes.
## Manual Installation Guide
**Prerequisites**
- NixOs installation USB
- Working internet connection
- Target system
**Preparation**
```bash
# Set root password
sudo passwd

# Test internet connection
ping google.com

# SSH into the node
ssh root@<node-IP>

# Create disk layout manually
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 1025MiB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 1025MiB 100%

# Format partitions
mkfs.fat -F 32 -n BOOT /dev/sda1
mkfs.btrfs -L nixos /dev/sda2

# Create sub volumes
btrfs subvolume create /mnt/rootfs
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/var-log
btrfs subvolume create /mnt/var-lib-rancher
btrfs subvolume create /mnt/var-lib-longhorn

# Mount volumes
umount /mnt
mount -o compress=zstd:1,noatime,subvol=rootfs /dev/sda2 /mnt
mkdir -p /mnt/{boot,nix,var/log,var/lib/rancher,var/lib/longhorn}
mount /dev/sda1 /mnt/boot
mount -o compress=zstd:1,noatime,space_cache=v2,subvol=nix /dev/sda2 /mnt/nix
mount -o compress=zstd:3,noatime,subvol=var-log /dev/sda2 /mnt/var/log
mount -o compress=zstd:1,noatime,subvol=var-lib-rancher /dev/sda2 /mnt/var/lib/rancher
mount -o noatime,space_cache=v2,subvol=var-lib-longhorn /dev/sda2 /mnt/var/lib/longhorn

# Setup configuration files
nixos-generate-config --root /mnt
export NIX_CONFIG="experimental-features = nix-command flakes"
cd /mnt/etc/nixos
mkdir -p modules/{base,services,security,hardware-profiles,disko}
rm configuration.nix

# Setup configuration files either with git clone or nano
# Make sure to use the manual install flake.nix and appropriate hardware profile

# Install!
nixos-install --flake /tmp/nerv-config#misato

# Set root password when prompted
# Reboot and remove media
sudo reboot