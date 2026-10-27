{...}: {
  # Host-only configuration for tear (desktop).
  # Shared configuration lives in modules/nixos/.
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/nvidia.nix
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
