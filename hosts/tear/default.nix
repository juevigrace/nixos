{...}: {
  # Host-only configuration for tear (desktop).
  # Shared system configuration lives in modules/nixos/; shared hardware
  # modules live in hosts/hardware/.
  imports = [
    ./hardware-configuration.nix
    ../hardware/bluetooth.nix
    ../hardware/nvidia.nix
    ../../modules/nixos
    ../../users/juevigrace
  ];

  networking.hostName = "tear";

  # Dedicated 1 TB SATA SSD: the first 300 GiB are reserved for Windows,
  # the remaining partition is Btrfs storage.
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/8c392497-addf-46e4-bb11-7588b7ca4ce1";
    fsType = "btrfs";
    options = ["subvol=@storage" "compress=zstd:3" "noatime"];
  };
}
