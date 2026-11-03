{ lib, pkgs, ... }: let
  # The nixpkgs wrapper only puts X11 libraries on LD_LIBRARY_PATH. In a
  # Wayland session SDL3 then falls back to XWayland, while LWJGL (used by
  # Minecraft 26.x) selects EGL based on XDG_SESSION_TYPE=wayland. Minecraft
  # passes the EGL library to SDL's X11 backend, which needs GLX, and dies
  # with "Could not retrieve OpenGL functions". Adding the Wayland client
  # libraries lets SDL use Wayland, matching LWJGL's EGL backend.
  modrinth-app = pkgs.unstable.modrinth-app.overrideAttrs (old: {
    runtimeDependencies = old.runtimeDependencies + ":" + lib.makeLibraryPath (with pkgs.unstable; [
      wayland
      libxkbcommon
      libdecor
    ]);
  });
in {
  # Minecraft mod manager and launcher (unfree).
  home.packages = [modrinth-app];
}
