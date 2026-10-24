{ pkgs, ... }: {
  # Minecraft mod manager and launcher (unfree).
  home.packages = [ pkgs.unstable.modrinth-app ];
}
