# ⚠ PLACEHOLDER — REPLACE THIS FILE AFTER INSTALLING NIXOS ON tear.
#
# This file is intentionally not shared with laila: disks, CPU, kernel
# modules, and boot entries are host-specific.
#
# `scripts/install.sh tear /dev/sda` replaces this file automatically during install.
# To regenerate it later:
#
#   sudo nixos-generate-config --show-hardware-config \
#     > ~/Projects/nixos/hosts/tear/hardware-configuration.nix
#
# or copy /etc/nixos/hardware-configuration.nix over this file.
#
# Layout created by `scripts/install.sh tear /dev/sda`:
#   sda1  ~1 GiB vfat  -> /boot  (ESP)
#   sda2  remaining    -> /      (Btrfs: @, @home, @nix, @log, @snapshots)
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}
