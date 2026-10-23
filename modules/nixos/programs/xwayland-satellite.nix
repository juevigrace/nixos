{ pkgs, ... }: {
  # Niri integrates with xwayland-satellite automatically. Do not enable
  # programs.xwayland: X11 is handled by the satellite on demand.
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
