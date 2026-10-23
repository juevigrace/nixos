{ config, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";
in {
  programs.fuzzel.enable = true;
  xdg.configFile."fuzzel/fuzzel.ini".source = liveConfig "programs/fuzzel/fuzzel.ini";
}
