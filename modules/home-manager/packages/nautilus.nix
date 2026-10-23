{ pkgs, ... }: {
  # Used by Niri's `useNautilus` file chooser and as the GUI file manager.
  home.packages = [ pkgs.nautilus ];
}
