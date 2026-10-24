{ pkgs, ... }: {
  # Epic/GOG/Amazon Games launcher. Heroic manages its own Wine and Proton
  # builds; the system Steam runtime supplies the 32-bit graphics libraries.
  home.packages = [ pkgs.unstable.heroic ];
}
