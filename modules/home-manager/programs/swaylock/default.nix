{ config, lib, pkgs, ... }:
let
  home = config.home.homeDirectory;
  configPath = "${home}/.config/swaylock/config";
  colorsPath = "${home}/.config/swaylock/colors.conf";

  # Skwd writes the current wallpaper into the base config. Matugen writes the
  # colour palette to a separate file. Swaylock only accepts one config file,
  # so merge them at lock time instead of hardcoding either one.
  swaylockThemed = pkgs.writeShellScriptBin "swaylock-themed" ''
    set -eu
    runtime="''${XDG_RUNTIME_DIR:-/tmp}"
    merged="$runtime/swaylock-themed-$USER"
    umask 077
    ${pkgs.coreutils}/bin/cat \
      "$HOME/.config/swaylock/config" \
      "$HOME/.config/swaylock/colors.conf" > "$merged"
    exec ${pkgs.swaylock-effects}/bin/swaylock -C "$merged" "$@"
  '';
in {
  programs.swaylock = {
    enable = true;
    package = swaylockThemed;
  };

  # Skwd needs a regular, writable file here so it can point swaylock at the
  # current wallpaper. Keep the repo copy as the seed for fresh installs.
  home.activation.swaylockConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -L "${configPath}" ]; then
      rm -f "${configPath}"
    fi
    if [ ! -e "${configPath}" ]; then
      mkdir -p "$(dirname "${configPath}")"
      install -m 0600 ${./config} "${configPath}"
    fi

    # Existing installs predate the blur setting; add it once without
    # overriding a custom effect-blur line.
    if ! ${pkgs.gnugrep}/bin/grep -q '^effect-blur=' "${configPath}"; then
      printf '\neffect-blur=20x3\n' >> "${configPath}"
    fi
  '';

  # Matugen replaces the colour file; seed it only when it does not exist so
  # the next rebuild does not undo the current wallpaper's palette.
  home.activation.swaylockColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e "${colorsPath}" ]; then
      mkdir -p "$(dirname "${colorsPath}")"
      install -m 0644 ${./colors.conf} "${colorsPath}"
    fi
  '';
}
