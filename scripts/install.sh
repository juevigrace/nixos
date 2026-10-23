#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 <host> <disk> [repo]

  host   tear or laila
  disk   whole disk to erase, e.g. /dev/sda or /dev/nvme0n1
  repo   repo to copy into the new system (default: this repo)

Examples:
  sudo $0 tear /dev/sda
  sudo $0 laila /dev/nvme0n1

Run this from a NixOS installer. It erases the whole disk, creates the
Btrfs subvolume layout, copies the repo to /home/juevigrace/Projects/nixos,
and installs the flake. After installing, it asks you to set the
juevigrace password.
EOF
}

die() {
  echo "error: $*" >&2
  exit 1
}

[[ $# -ge 2 ]] || { usage; exit 1; }

host="$1"
disk="$2"
repo_arg="${3:-}"

case "$host" in
  tear|laila) ;;
  *) die "unknown host: $host (expected tear or laila)" ;;
esac

[[ "$disk" == /dev/* ]] || disk="/dev/$disk"
disk="$(readlink -f "$disk")"

[[ $EUID -eq 0 ]] || die "run as root: sudo $0 $host $disk"
[[ -b "$disk" ]] || die "not a block device: $disk"
[[ "$(lsblk -dno TYPE "$disk")" == "disk" ]] || die "not a whole disk: $disk"

for cmd in lsblk wipefs sgdisk partprobe mkfs.fat mkfs.btrfs btrfs \
  nixos-generate-config nixos-install nixos-enter; do
  command -v "$cmd" >/dev/null 2>&1 ||
    die "missing $cmd; run this from a NixOS installer"
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
default_repo="$(cd -- "$script_dir/.." && pwd)"
repo_src="${repo_arg:-$default_repo}"
repo_src="$(cd -- "$repo_src" && pwd)"

[[ -f "$repo_src/flake.nix" ]] || die "not a flake directory: $repo_src"
[[ -f "$repo_src/hosts/$host/default.nix" ]] ||
  die "missing $repo_src/hosts/$host/default.nix"
[[ "$repo_src" != /mnt/* ]] ||
  die "repo is under /mnt, which is the install target; mount it elsewhere"

echo "Host:  $host"
echo "Disk:  $disk"
lsblk -dno NAME,MODEL,SIZE "$disk"
echo "Repo:  $repo_src"
echo
echo "This will ERASE ALL DATA on $disk."
read -r -p "Type WIPE to erase $disk and install $host: " answer
[[ "$answer" == "WIPE" ]] || die "aborted"

echo "Unmounting anything already using $disk..."
swapoff -a 2>/dev/null || true
umount -R /mnt 2>/dev/null || true
while IFS= read -r mountpoint; do
  [[ -n "$mountpoint" ]] || continue
  umount -R "$mountpoint" 2>/dev/null || true
done < <(lsblk -lnpo MOUNTPOINT "$disk")

echo "Wiping $disk..."
wipefs -a "$disk"
sgdisk --zap-all "$disk"

echo "Partitioning $disk..."
sgdisk -n 1:0:+1G -t 1:ef00 -c 1:ESP "$disk"
sgdisk -n 2:0:0 -t 2:8300 -c 2:NIXOS "$disk"
partprobe "$disk"
udevadm settle

if [[ "$disk" == *nvme* || "$disk" == *mmcblk* ]]; then
  part_prefix="${disk}p"
else
  part_prefix="$disk"
fi

esp="${part_prefix}1"
root="${part_prefix}2"

[[ -b "$esp" ]] || die "ESP partition not found: $esp"
[[ -b "$root" ]] || die "root partition not found: $root"

echo "Formatting..."
mkfs.fat -F 32 -n BOOT "$esp"
mkfs.btrfs -f -L NIXOS "$root"

echo "Creating Btrfs subvolumes..."
mkdir -p /mnt
mount "$root" /mnt
for subvol in @ @home @nix @log @snapshots; do
  btrfs subvolume create "/mnt/$subvol"
done
umount /mnt

opts="compress=zstd:3,noatime"

echo "Mounting the new layout..."
mount -o "subvol=@,$opts" "$root" /mnt
mkdir -p /mnt/{home,nix,var/log,.snapshots,boot}

mount -o "subvol=@home,$opts" "$root" /mnt/home
mount -o "subvol=@nix,$opts" "$root" /mnt/nix
mount -o "subvol=@log,$opts" "$root" /mnt/var/log
mount -o "subvol=@snapshots,$opts" "$root" /mnt/.snapshots
mount -o umask=077 "$esp" /mnt/boot

findmnt -R /mnt

echo "Generating hardware configuration..."
nixos-generate-config --root /mnt

target="/mnt/home/juevigrace/Projects/nixos"
if [[ "$repo_src" == "$target" ]]; then
  die "repo is already the target directory: $target"
fi

echo "Copying repo to $target..."
install -d -m 0755 /mnt/home/juevigrace
install -d -m 0755 /mnt/home/juevigrace/Projects
cp -a "$repo_src/." "$target/"

cp /mnt/etc/nixos/hardware-configuration.nix \
  "$target/hosts/$host/hardware-configuration.nix"

# NixOS creates the first normal user as UID 1000 in the "users" group (GID 100).
# Do this after copying so the user can edit the repo and Home Manager can
# create ~/.config links on first login.
chown 1000:100 /mnt/home/juevigrace /mnt/home/juevigrace/Projects
chown -R 1000:100 "$target"

echo "Installing $host..."
echo "nixos-install will ask for the ROOT password."
# Use the path flake so untracked/uncommitted files are included. A plain
# git flake only includes tracked files.
nixos-install --flake "path:$target#$host"

echo
echo "Set the password for juevigrace:"
nixos-enter --root /mnt -c 'passwd juevigrace'

echo
echo "Installed $host."
echo "Reboot and log in as juevigrace with the password you just set."
