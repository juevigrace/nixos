{ pkgs, ... }: {
  # 64-bit Wine with WoW64 support for 32-bit Windows applications.
  home.packages = with pkgs.unstable; [
    wineWow64Packages.stable
    winetricks
  ];
}
