# ⚠ PLACEHOLDER — REPLACE THIS FILE AFTER INSTALLING NIXOS ON tear.
#
# This file is intentionally not shared with laila: disks, CPU, kernel
# modules, and boot entries are host-specific.
#
# After booting the installed system, generate the real file:
#
#   sudo nixos-generate-config --show-hardware-config \
#     > ~/Projects/nixos/hosts/tear/hardware-configuration.nix
#
# or copy /etc/nixos/hardware-configuration.nix over this file.
#
# Expected layout on /dev/sda (do not touch sda2/sda3/sda4 or nvme0n1):
#   sda5  ~1 GiB vfat  -> /boot  (new ESP)
#   sda6  remaining    -> /      (ext4, or LUKS + btrfs)
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}
