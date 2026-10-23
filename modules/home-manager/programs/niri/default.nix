{ config, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";
in {
  # Niri has no Home Manager `settings` option, so this is a plain KDL file
  # symlinked into ~/.config/niri/config.kdl.
  xdg.configFile."niri/config.kdl".source = liveConfig "programs/niri/config.kdl";
}
