{ config, lib, ... }:
let
  home = config.home.homeDirectory;

  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink
      "${home}/Projects/nixos/modules/home-manager/${path}";

  seed = src: dest: ''
    if [ ! -e "${dest}" ]; then
      mkdir -p "$(dirname "${dest}")"
      install -m 0644 ${src} "${dest}"
    fi
  '';
in {
  # Keep Skwd's mutable state in the repo. mkOutOfStoreSymlink means settings
  # changes made in the picker are written back to these tracked files.
  xdg.configFile."skwd-wall-v2/config.json" = {
    source = liveConfig "programs/skwd-wall/config.json";
    force = true;
  };

  xdg.configFile."skwd-wall-v2/matugen/templates" = {
    source = liveConfig "programs/skwd-wall/matugen/templates";
    force = true;
  };

  # The currently selected wallpaper is copied into the repo so a fresh
  # install can restore it.
  home.file."Pictures/Wallpapers/wallhaven-6l56mx.png" = {
    source = ./wallpapers/wallhaven-6l56mx.png;
    force = true;
  };

  # Matugen writes these files. Seed Catppuccin fallbacks only when they do
  # not exist so a wallpaper change is not undone on the next rebuild.
  home.activation.skwdWallSeed = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${seed ../waybar/colors.css "${home}/.config/waybar/colors.css"}
    ${seed ../niri/colors.kdl "${home}/.config/niri/colors.kdl"}
    ${seed ../ghostty/colors.conf "${home}/.config/ghostty/colors.conf"}
    ${seed ../btop/fallback.theme "${home}/.config/btop/themes/skwd.theme"}
    ${seed ../fuzzel/colors.ini "${home}/.config/fuzzel/colors.ini"}
    ${seed ../../services/mako/colors "${home}/.config/mako/colors"}

    cache_dir="${home}/.cache/skwd-wall-v2"
    wallpaper="${home}/Pictures/Wallpapers/wallhaven-6l56mx.png"
    mkdir -p "$cache_dir"

    if [ ! -e "$cache_dir/last-wallpaper.json" ]; then
      cat > "$cache_dir/last-wallpaper.json" <<EOF
{"mute":true,"path":"$wallpaper","thumb":"$wallpaper","type":"static","volume":100,"we_id":""}
EOF
      chmod 0600 "$cache_dir/last-wallpaper.json"
    fi

    if [ ! -e "$cache_dir/last-applied.json" ]; then
      cat > "$cache_dir/last-applied.json" <<EOF
{"any":{"path":"$wallpaper","type":"static","we_id":""},"landscape":null,"portrait":null}
EOF
      chmod 0600 "$cache_dir/last-applied.json"
    fi
  '';
}
