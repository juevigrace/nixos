{helpers, pkgs, ...}: {
  # Do not generate Waybar's config/style from Nix. The real files live next
  # to this module and are linked into ~/.config/waybar/.
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {};
    style = null;
  };

  xdg.configFile."waybar/config" = {
    source = helpers.liveConfig "programs/waybar/config.json";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/style.css" = {
    source = helpers.liveConfig "programs/waybar/style.css";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/power-menu.xml" = {
    source = helpers.liveConfig "programs/waybar/power-menu.xml";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/battery-menu.xml" = {
    source = helpers.liveConfig "programs/waybar/battery-menu.xml";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
}
