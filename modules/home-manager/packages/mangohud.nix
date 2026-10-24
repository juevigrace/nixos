{ pkgs, ... }: {
  # Vulkan/OpenGL performance overlay for games.
  home.packages = [ pkgs.unstable.mangohud ];
}
