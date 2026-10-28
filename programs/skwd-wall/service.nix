{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.skwd-deck;
  system = pkgs.stdenv.hostPlatform.system;
  skwd = inputs.skwd-wall.packages.${system};
in {
  # Home Manager module for skwd-wall. Upstream indexes its packages with
  # the deprecated `pkgs.system` attribute, which makes every evaluation print
  # a Nixpkgs warning. Use `pkgs.stdenv.hostPlatform.system` instead.
  options.services.skwd-deck = {
    enable = lib.mkEnableOption "Skwd Deck user service";

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Optional Deck backends such as skwd-deck-steamworks.";
    };

    modelPackage = lib.mkOption {
      type = lib.types.package;
      default = skwd.skwd-lens-model;
      description = "Semantic model pack used by Skwd Lens. The default SigLIP 2 pack is installed with the suite.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [skwd.default cfg.modelPackage] ++ cfg.extraPackages;

      home.sessionVariables.SKWD_LENS_HOME =
        "${cfg.modelPackage}/share/skwd-lens/models/semantic";

      systemd.user.services.skwd-walld = {
        Unit = {
          Description = "skwd-wall control daemon";
          Conflicts = ["skwd-daemon.service"];
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };

        Service = {
          Environment = [
            "SKWD_LENS_HOME=${cfg.modelPackage}/share/skwd-lens/models/semantic"
            "PATH=${lib.makeBinPath ([skwd.paper skwd.lens] ++ cfg.extraPackages)}"
          ];
          ExecStart = "${skwd.deck}/bin/skwd-walld";
          Restart = "on-failure";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    })

    {
      services.skwd-deck = {
        enable = true;

        # skwd-wall's Smart palette needs Matugen 4.2+, which is newer than the
        # version in the stable 26.05 package set. The module puts these
        # packages in both the user PATH and the wallpaper daemon's PATH.
        #
        # The daemon runs Matugen integration reload hooks through `sh -c`, so
        # its PATH also needs a shell plus the commands used by the hooks.
        extraPackages = [
          pkgs.unstable.matugen
          pkgs.bash
          pkgs.procps
          pkgs.niri
          pkgs.mako
          pkgs.libnotify
        ];
      };

      # The module wants graphical-session.target. Niri starts that target, but
      # also pull the daemon in with niri.service so a manual session start
      # does not leave it behind.
      systemd.user.services.skwd-walld = {
        Unit.After = ["niri.service"];
        Install.WantedBy = ["niri.service"];

        # The daemon owns a GPU render context. Do not let a stuck teardown
        # hold logout or a full system shutdown open indefinitely.
        Service.TimeoutStopSec = "15s";
      };
    }
  ];
}
