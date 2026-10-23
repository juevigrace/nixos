{ pkgs, ... }: {
  # Host-only configuration for tear (desktop).
  # Shared configuration lives in modules/nixos/.
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "tear";

  # AMD Ryzen 7 5800XT + NVIDIA RTX 4060 Ti.
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
