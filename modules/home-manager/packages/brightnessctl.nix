{ pkgs, ... }: {
  # Laptop brightness keys.
  home.packages = [ pkgs.brightnessctl ];
}
