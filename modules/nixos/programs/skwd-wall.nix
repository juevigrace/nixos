{inputs, pkgs, ...}: {
  imports = [inputs.skwd-wall.nixosModules.default];

  services.skwd-deck = {
    enable = true;

    # skwd-wall's Smart palette needs Matugen 4.2+, which is newer than the
    # version in the stable 26.05 package set. The upstream module puts these
    # packages in both the system PATH and the wallpaper daemon's PATH.
    #
    # The daemon runs Matugen integration reload hooks through `sh -c`, so its
    # PATH also needs a shell plus the commands used by the hooks.
    extraPackages = [
      pkgs.unstable.matugen
      pkgs.bash
      pkgs.procps
      pkgs.niri
      pkgs.mako
      pkgs.libnotify
    ];
  };

  # The upstream module wants graphical-session.target. Niri starts that
  # target, but also pull the daemon in with niri.service so a manual session
  # start does not leave it behind.
  systemd.user.services.skwd-walld = {
    wantedBy = ["niri.service"];
    after = ["niri.service"];
  };
}
