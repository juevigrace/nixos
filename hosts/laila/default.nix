{pkgs, ...}: {
  # Host-only configuration for laila (laptop).
  # Shared configuration lives in modules/nixos/.
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/nvidia.nix
  ];

  networking.hostName = "laila";

  # HP EliteBook 650 G10: Intel i7-1355U + NVIDIA RTX 2050 (hybrid).
  # Niri runs on the Intel GPU; the NVIDIA GPU is available through
  # `nvidia-offload` for applications that need it.
  hardware.nvidia.prime = {
    sync.enable = false;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";

    offload.enable = true;
    offload.enableOffloadCmd = true;
  };

  services.xserver.videoDrivers = ["modesetting"];

  # Intel media acceleration for video playback.
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];
}
