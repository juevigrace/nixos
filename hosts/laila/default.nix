{pkgs, ...}: let
  # PRIME render-offload environment for game launchers on this host.
  nvidiaEnv = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };
in {
  # Host-only configuration for laila (laptop).
  # Shared system configuration lives in modules/nixos/; shared hardware
  # modules live in hosts/hardware/.
  imports = [
    ./hardware-configuration.nix
    ../hardware/bluetooth.nix
    ../hardware/nvidia.nix
    ../../modules/nixos
    ../../users/juevigrace
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

  # btop's Intel GPU backend reads the i915 PMU through perf events, which
  # needs CAP_PERFMON; CPU wattage needs CAP_DAC_READ_SEARCH. The wrapper in
  # /run/wrappers/bin takes precedence over the Home Manager btop in PATH.
  security.wrappers.btop = {
    source = "${pkgs.btop.override {cudaSupport = true;}}/bin/btop";
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon,cap_dac_read_search+ep";
  };

  # Put Steam and every game it launches on the RTX 2050. The environment is
  # inherited by the client and its child game processes. This also covers the
  # greetd gamescope session.
  programs.steam.package = pkgs.steam.override {
    extraEnv = nvidiaEnv;
  };

  programs.steam.gamescopeSession.env = nvidiaEnv;

  services.xserver.videoDrivers = ["modesetting"];

  # Intel media acceleration for video playback.
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];
}
