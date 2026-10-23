{ config, pkgs, ... }:
let
  # Live links back into this repo. Editing ~/.config/... edits the tracked
  # file directly, so it applies without a rebuild (reload the app if needed).
  #
  # If you move the repo somewhere else, update this path.
  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Projects/nixos/modules/home-manager/files/${path}";
in {
  # ── Waybar ─────────────────────────────────────────────────────────────
  # `programs.waybar` is enabled in desktop.nix with empty settings, so these
  # files are the single source of truth.
  xdg.configFile."waybar/config" = {
    source = liveConfig "waybar/config.json";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };
  xdg.configFile."waybar/style.css" = {
    source = liveConfig "waybar/style.css";
    onChange = "${pkgs.procps}/bin/pkill -u $USER -USR2 waybar || true";
  };

  # ── Notifications ──────────────────────────────────────────────────────
  xdg.configFile."mako/config" = {
    source = liveConfig "mako/config";
    onChange = "${pkgs.mako}/bin/makoctl reload || true";
  };

  # ── Launcher ───────────────────────────────────────────────────────────
  xdg.configFile."fuzzel/fuzzel.ini".source = liveConfig "fuzzel/fuzzel.ini";

  # ── Lock screen ────────────────────────────────────────────────────────
  xdg.configFile."swaylock/config".source = liveConfig "swaylock/config";

  # ── Niri ───────────────────────────────────────────────────────────────
  # Niri has no Home Manager `settings` option, so this is a plain KDL file
  # symlinked into ~/.config/niri/config.kdl.
  xdg.configFile."niri/config.kdl".source = liveConfig "niri/config.kdl";
}
