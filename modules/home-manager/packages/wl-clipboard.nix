{ pkgs, ... }: {
  # wl-copy / wl-paste, used by the clipboard history setup.
  home.packages = [ pkgs.wl-clipboard ];
}
