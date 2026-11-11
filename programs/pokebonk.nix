{lib, osConfig, pkgs, ...}: let
  pname = "pokebonk";
  version = "1.4.0";

  # On the hybrid laptop, force Chromium onto the NVIDIA GPU via XWayland.
  # `nvidia-offload` alone is not enough: Electron's native Wayland backend
  # pins its render node to the Intel iGPU.
  useNvidia = osConfig.networking.hostName == "laila";
  nvidiaArgs = [
    "--add-flags" "--ozone-platform=x11"
    "--set" "__NV_PRIME_RENDER_OFFLOAD" "1"
    "--set" "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" "NVIDIA-G0"
    "--set" "__GLX_VENDOR_LIBRARY_NAME" "nvidia"
    "--set" "__VK_LAYER_NV_optimus" "NVIDIA_only"
  ];
  wrapperArgs =
    ["--add-flags" "--no-sandbox"]
    ++ lib.optionals useNvidia nvidiaArgs;

  # Official Linux desktop client. Upstream only publishes an AppImage; it is
  # an Electron shell around https://pokebonk.com, so the game content itself
  # stays up to date over the web.
  src = pkgs.fetchurl {
    url = "https://github.com/CharcherGit/pokebonk-app/releases/download/v${version}/PokeBonk-${version}-linux-x86_64.AppImage";
    hash = "sha256-LYXgl79p5k9FWzkgrdt1IlLlrGZsnWfgp5bRMhaevO0=";
  };

  # wrapType2 unpacks the AppImage and runs it in an FHS environment with the
  # Electron/Chromium libraries it expects. No FUSE, chmod, or manual extraction
  # is needed. extract is reused here only to install the bundled icon.
  app = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
  };

  extracted = pkgs.appimageTools.extract {
    inherit pname version src;
  };

  desktopItem = pkgs.makeDesktopItem {
    name = pname;
    desktopName = "PokéBonk";
    genericName = "Pokémon survivor game";
    comment = "Desktop client for the PokéBonk fan game";
    exec = "${pname} %U";
    icon = pname;
    terminal = false;
    categories = ["Game"];
    startupWMClass = "pokebonk";
  };

  package = pkgs.runCommand "${pname}-${version}" {
    nativeBuildInputs = [pkgs.makeWrapper];

    meta = {
      description = "Desktop client for the PokéBonk fan game";
      homepage = "https://pokebonk.com";
      mainProgram = pname;
      platforms = ["x86_64-linux"];
    };
  } ''
    mkdir -p $out/bin

    # Electron's bundled chrome-sandbox cannot be setuid in the Nix store, so
    # match the upstream .desktop file and run without the Chromium sandbox.
    makeWrapper ${app}/bin/${pname} $out/bin/${pname} \
      ${lib.escapeShellArgs wrapperArgs}

    install -Dm644 ${desktopItem}/share/applications/${pname}.desktop \
      $out/share/applications/${pname}.desktop

    install -Dm644 ${extracted}/usr/share/icons/hicolor/512x512/apps/PokeBonk.png \
      $out/share/icons/hicolor/512x512/apps/${pname}.png
  '';
in {
  home.packages = [package];
}
