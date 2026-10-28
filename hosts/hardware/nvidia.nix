{
  config,
  lib,
  pkgs,
  ...
}: let
  # The unstable nvidia-x11 package ships a malformed nvidia-smi binary on
  # Linux 7.3 (its ELF dynamic section is mapped read-only, so ld-linux
  # segfaults before it can talk to the driver). The stable 595.71.05 binary
  # works when paired with the matching 595.104.02 NVML userspace library.
  # Keep the rest of the NVIDIA stack on the kernel package set; this wrapper
  # only replaces the monitoring tool.
  unstableNvidia = config.boot.kernelPackages.nvidiaPackages.stable;
  stableNvidiaSmi = pkgs.linuxPackages_latest.nvidiaPackages.stable.bin;
  nvidiaSmi = pkgs.writeShellScriptBin "nvidia-smi" ''
    export LD_LIBRARY_PATH="${unstableNvidia}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec "${stableNvidiaSmi}/bin/nvidia-smi" "$@"
  '';
in {
  imports = [./graphics.nix];

  environment.systemPackages = [(lib.hiPrio nvidiaSmi)];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = ["nvidia"];
}
