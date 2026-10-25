{ config, pkgs, ... }:
let
  lock = "${config.programs.swaylock.package}/bin/swaylock-themed";
in {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 3600; # 1 hour
        command = "${lock} -f";
      }
      {
        timeout = 4500; # 1 hour 15 minutes
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];
    events = {
      "before-sleep" = "${lock} -f";
    };
  };
}
