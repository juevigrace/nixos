{ pkgs, ... }: {
  # Spotify desktop client (unfree).
  home.packages = [ pkgs.unstable.spotify ];
}
