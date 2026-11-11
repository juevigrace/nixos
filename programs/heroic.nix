{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  # Heroic starts the game processes itself, so the offload environment must
  # be on Heroic in order for its Wine/Proton children to inherit it.
  useNvidia = osConfig.networking.hostName == "laila";
  heroic = pkgs.unstable.heroic;

  nvidiaArgs = [
    "--set" "__NV_PRIME_RENDER_OFFLOAD" "1"
    "--set" "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" "NVIDIA-G0"
    "--set" "__GLX_VENDOR_LIBRARY_NAME" "nvidia"
    "--set" "__VK_LAYER_NV_optimus" "NVIDIA_only"
  ];

  package =
    if useNvidia
    then
      pkgs.symlinkJoin {
        name = "heroic-nvidia";
        paths = [heroic];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          mv "$out/bin/heroic" "$out/bin/.heroic-unwrapped"
          makeWrapper "$out/bin/.heroic-unwrapped" "$out/bin/heroic" \
            ${lib.escapeShellArgs nvidiaArgs}
        '';
      }
    else heroic;
in {
  # Epic/GOG/Amazon Games launcher. Heroic manages its own Wine and Proton
  # builds; the system Steam runtime supplies the 32-bit graphics libraries.
  home.packages = [package];
}
