{ pkgs, ... }: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];
    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}
