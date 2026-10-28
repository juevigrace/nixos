{
  config,
  helpers,
  lib,
  ...
}: let
  home = config.home.homeDirectory;

  seed = src: dest: ''
    if [ ! -e "${dest}" ]; then
      mkdir -p "$(dirname "${dest}")"
      install -m 0644 ${src} "${dest}"
    fi
  '';
in {
  imports = [./service.nix];

  # Keep Skwd's mutable state in the repo. mkOutOfStoreSymlink means settings
  # changes made in the picker are written back to these tracked files.
  xdg.configFile."skwd-wall-v2/config.json" = {
    source = helpers.liveConfig "programs/skwd-wall/config.json";
    force = true;
  };

  xdg.configFile."skwd-wall-v2/matugen/templates" = {
    source = helpers.liveConfig "programs/skwd-wall/matugen/templates";
    force = true;
  };

  # The currently selected wallpaper is copied into the repo so a fresh
  # install can restore it. It must be a real file: the skwd scanner ignores
  # symlinks, which made the picker report an empty library even though the
  # daemon could still restore the wallpaper from the cache.
  #
  # Matugen writes these files. Seed Catppuccin fallbacks only when they do
  # not exist so a wallpaper change is not undone on the next rebuild.
  #
  # This must run after linkGeneration but before onFilesChange/reloadSystemd:
  # the onChange hooks validate/reload programs that read these files (Ghostty
  # in particular), and sd-switch may start Waybar before the seed would
  # otherwise have run. On a fresh home the missing files would make the whole
  # activation abort.
  home.activation.skwdWallSeed = lib.hm.dag.entryBetween
    ["onFilesChange" "reloadSystemd"]
    ["linkGeneration"]
    ''
        ${seed ../waybar/colors.css "${home}/.config/waybar/colors.css"}
        ${seed ../niri/colors.kdl "${home}/.config/niri/colors.kdl"}
        ${seed ../ghostty/colors.conf "${home}/.config/ghostty/colors.conf"}
        ${seed ../btop/fallback.theme "${home}/.config/btop/themes/skwd.theme"}
        ${seed ../fuzzel/colors.ini "${home}/.config/fuzzel/colors.ini"}
        ${seed ../../services/mako/colors "${home}/.config/mako/colors"}

        cache_dir="${home}/.cache/skwd-wall-v2"
        wallpaper="${home}/Pictures/Wallpapers/wallhaven-r735gq.png"

        # The skwd scanner deliberately skips symlinks. Replace the old
        # Home Manager link with a real seeded copy, but never overwrite a
        # wallpaper the user has already chosen.
        if [ -L "$wallpaper" ] || [ ! -e "$wallpaper" ]; then
          mkdir -p "$(dirname "$wallpaper")"
          rm -f "$wallpaper"
          install -m 0644 ${./wallpapers/wallhaven-r735gq.png} "$wallpaper"
        fi

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
