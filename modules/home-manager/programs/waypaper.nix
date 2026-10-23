{ pkgs, ... }: {
  # Waypaper chooses the wallpaper; swaybg applies it (see packages/swaybg.nix).
  home.packages = [ pkgs.waypaper ];
}
