{ config, pkgs, ... }:
let
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/${path}";
in {
  # Do not generate Waybar's config/style from Nix. The real files live next
  # to this module and are linked into ~/.config/waybar/.
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {};
    style = null;
  };

  xdg.configFile."waybar/config" = {
    source = liveConfig "programs/waybar/config.json";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/style.css" = {
    source = liveConfig "programs/waybar/style.css";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/power-menu.xml" = {
    source = liveConfig "programs/waybar/power-menu.xml";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/battery-menu.xml" = {
    source = liveConfig "programs/waybar/battery-menu.xml";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
}
