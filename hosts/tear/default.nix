{...}: {
  # Host-only configuration for tear (desktop).
  # Shared configuration lives in modules/nixos/.
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/nvidia.nix
  ];

  networking.hostName = "tear";
}
