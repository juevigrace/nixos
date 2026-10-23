# ⚠ PLACEHOLDER — REPLACE THIS FILE AFTER INSTALLING NIXOS ON laila.
#
# This file is intentionally not shared with tear: disks, CPU, kernel
# modules, and boot entries are host-specific.
#
# After booting the installed system, generate the real file:
#
#   sudo nixos-generate-config --show-hardware-config \
#     > ~/Projects/nixos/hosts/laila/hardware-configuration.nix
#
# or copy /etc/nixos/hardware-configuration.nix over this file.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}
