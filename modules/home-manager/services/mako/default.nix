{ config, pkgs, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";
in {
  # Keep the mako module for its D-Bus integration; the config file lives next
  # to this module.
  services.mako.enable = true;

  xdg.configFile."mako/config" = {
    source = liveConfig "services/mako/config";
    onChange = "${pkgs.mako}/bin/makoctl reload || true";
  };
}
