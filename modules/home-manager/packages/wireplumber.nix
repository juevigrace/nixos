{ pkgs, ... }: {
  # Provides wpctl, used by the Niri keybinds.
  home.packages = [ pkgs.wireplumber ];
}
