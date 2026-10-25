{ config, osConfig, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";

  host = osConfig.networking.hostName;
  outputConfig = {
    tear = "programs/niri/outputs/tear.kdl";
    laila = "programs/niri/outputs/laila.kdl";
  }.${host} or (throw "No Niri output configuration for host '${host}'");
in {
  # Niri has no Home Manager `settings` option, so this is a plain KDL file
  # symlinked into ~/.config/niri/config.kdl.
  xdg.configFile."niri/config.kdl".source = liveConfig "programs/niri/config.kdl";

  # Per-host monitor layout. The main config includes this by name.
  xdg.configFile."niri/outputs.kdl".source = liveConfig outputConfig;
}
