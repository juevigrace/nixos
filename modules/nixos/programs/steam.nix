{ pkgs, ... }: {
  # Steam's NixOS module also enables 32-bit graphics and 32-bit PipeWire,
  # which Wine, Proton, and Heroic need.
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
  };

  # On-demand CPU/GPU performance mode for games launched with gamemoderun.
  programs.gamemode.enable = true;
}
