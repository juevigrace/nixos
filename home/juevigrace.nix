# The one home-manager profile, shared by tear and laila.
#
# This file is intentionally small: it wires the shared home modules together
# and declares the fixed user identity. Add user configuration in
# modules/home-manager/.
{ ... }: {
  imports = [
    ../modules/home-manager
  ];

  home = {
    username = "juevigrace";
    homeDirectory = "/home/juevigrace";

    # Keep this at the release you installed; do not bump it on every update.
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
