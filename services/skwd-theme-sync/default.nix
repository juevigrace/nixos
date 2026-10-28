{
  config,
  lib,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
  cursor = config.home.pointerCursor;

  gtkTheme =
    if config.gtk.theme != null
    then config.gtk.theme.name
    else "Adwaita";

  gtkIconTheme =
    if config.gtk.iconTheme != null
    then config.gtk.iconTheme.name
    else "";

  setGtkTheme = pkgs.writeShellApplication {
    name = "skwd-gtk-sync";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.dconf
      pkgs.jq
    ];
    text = ''
      set -euo pipefail

      cfg="''${XDG_CONFIG_HOME:-$HOME/.config}/skwd-wall-v2/config.json"
      colors="''${XDG_CACHE_HOME:-$HOME/.cache}/skwd-wall-v2/colors.json"

      mode="$(jq -r '.theme.mode // empty' "$cfg" 2>/dev/null || true)"
      case "$mode" in
        dark|light) ;;
        *)
          # "auto"/"smart" is resolved against the wallpaper. The applied
          # background colour is the most reliable source for that choice.
          bg="$(jq -r '.background // .surface // empty' "$colors" 2>/dev/null || true)"
          bg="''${bg#\#}"
          if [ "''${#bg}" -ge 6 ]; then
            r=$((16#''${bg:0:2}))
            g=$((16#''${bg:2:2}))
            b=$((16#''${bg:4:2}))
            if [ $(((299 * r + 587 * g + 114 * b) / 1000)) -lt 128 ]; then
              mode=dark
            else
              mode=light
            fi
          else
            mode=dark
          fi
          ;;
      esac

      if [ "$mode" = "dark" ]; then
        prefer=1
        dconfScheme="'prefer-dark'"
      else
        prefer=0
        dconfScheme="'prefer-light'"
      fi

      writeSettings() {
        dest="$1"
        mkdir -p "$(dirname "$dest")"
        tmp="$(mktemp "$dest.XXXXXX")"
        {
          printf '%s\n' '[Settings]'
          printf 'gtk-cursor-theme-name=%s\n' '${cursor.name}'
          printf 'gtk-cursor-theme-size=%s\n' '${toString cursor.size}'
          printf 'gtk-theme-name=%s\n' '${gtkTheme}'
          ${lib.optionalString (gtkIconTheme != "") ''
            printf 'gtk-icon-theme-name=%s\n' '${gtkIconTheme}'
          ''}
          printf 'gtk-application-prefer-dark-theme=%s\n' "$prefer"
        } > "$tmp"
        chmod 0644 "$tmp"
        rm -f "$dest"
        mv "$tmp" "$dest"
      }

      writeSettings "''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
      writeSettings "''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0/settings.ini"

      # The portal and libadwaita listen to the dconf setting rather than the
      # GTK settings files.
      dconf write /org/gnome/desktop/interface/color-scheme "$dconfScheme" 2>/dev/null || true
    '';
  };
in {
  # Home Manager normally writes these as read-only store symlinks. The sync
  # script needs to rewrite them whenever skwd changes the applied palette.
  xdg.configFile."gtk-3.0/settings.ini".enable = false;
  xdg.configFile."gtk-4.0/settings.ini".enable = false;

  # Seed the files during activation as well. The systemd path unit handles
  # runtime wallpaper changes, but a rebuild should not wait for one.
  home.activation.skwdGtkSync = lib.hm.dag.entryBetween
    ["reloadSystemd"]
    ["linkGeneration" "skwdWallSeed"]
    ''
      $DRY_RUN_CMD ${setGtkTheme}/bin/skwd-gtk-sync
    '';

  systemd.user.services.skwd-gtk-sync = {
    Unit.Description = "Sync GTK light/dark mode with skwd-wall";
    Service = {
      Type = "oneshot";
      ExecStart = "${setGtkTheme}/bin/skwd-gtk-sync";
    };
    Install.WantedBy = ["default.target"];
  };

  systemd.user.paths.skwd-gtk-sync = {
    Unit.Description = "Watch skwd-wall for theme changes";
    Path = {
      PathChanged = [
        "${home}/.cache/skwd-wall-v2/colors.json"
        "${home}/.config/skwd-wall-v2/config.json"
      ];
      Unit = "skwd-gtk-sync.service";
    };
    Install.WantedBy = ["default.target"];
  };
}
