{pkgs, ...}: {
  # Steam's NixOS module also enables 32-bit graphics and 32-bit PipeWire,
  # which Wine, Proton, and Heroic need.
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    extraCompatPackages = [pkgs.unstable.proton-ge-bin];

    # Offer a Steam session that runs inside gamescope. It is useful on both
    # the desktop and the laptop and can be launched from greetd when needed.
    gamescopeSession.enable = true;
  };

  # Let gamescope request realtime scheduling and give it the capability it
  # needs. The NixOS module installs the wrapped binary in the security
  # wrapper directory.
  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = ["--rt"];
  };

  # On-demand CPU/GPU performance mode for games launched with gamemoderun.
  programs.gamemode.enable = true;

  # A few games and some Proton titles map more than the NixOS default. It
  # costs no memory unless a process actually uses the mappings.
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;
}
