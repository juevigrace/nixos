# The one home-manager profile, shared by tear and laila.
#
# This file is intentionally small: it only wires the shared modules together
# and declares the fixed user identity. Add user configuration in
# modules/home-manager/.
{ config, pkgs, ... }: {
  imports = [
    ../modules/home-manager/common.nix
    ../modules/home-manager/programs.nix
    ../modules/home-manager/desktop.nix
    ../modules/home-manager/files.nix
  ];

  home = {
    username = "juevigrace";
    homeDirectory = "/home/juevigrace";

    # Keep this at the release you installed; do not bump it on every update.
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
