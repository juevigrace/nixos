{ pkgs, ... }: {
  # Waypaper chooses the wallpaper; swaybg applies it (see services/swaybg/default.nix).
  home.packages = [ pkgs.waypaper ];
}
