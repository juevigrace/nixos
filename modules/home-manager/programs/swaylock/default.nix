{ config, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";
in {
  programs.swaylock.enable = true;
  xdg.configFile."swaylock/config".source = liveConfig "programs/swaylock/config";
}
