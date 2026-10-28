{helpers, pkgs, ...}: {
  # Keep the mako module for its D-Bus integration; the config file lives next
  # to this module.
  services.mako.enable = true;

  xdg.configFile."mako/config" = {
    source = helpers.liveConfig "services/mako/config";
    onChange = "${pkgs.mako}/bin/makoctl reload || true";
  };
}
