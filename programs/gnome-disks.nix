{pkgs, ...}: {
  # GNOME Disks ("Disks") is the udisks2 GUI for inspecting, partitioning,
  # formatting, and mounting internal disks and USB drives.
  #
  # The NTFS/exFAT helpers live in modules/nixos/filesystems.nix because
  # UDisks runs as a system service and must find them on the system PATH.
  home.packages = [pkgs.gnome-disk-utility];
}
