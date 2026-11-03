{pkgs, ...}: let
  # The nixpkgs wrapper only puts X11 libraries on LD_LIBRARY_PATH. With
  # SDL3, Minecraft's Java process also needs the Wayland client libraries;
  # otherwise SDL falls back to XWayland even when a Wayland session is
  # available. Adding them to the launcher's runtime dependencies makes them
  # available to every process Modrinth App starts.
  modrinth-app-base = pkgs.unstable.modrinth-app.overrideAttrs (old: {
    runtimeDependencies =
      old.runtimeDependencies
      + ":"
      + pkgs.lib.makeLibraryPath (with pkgs.unstable; [
        wayland
        libxkbcommon
        libdecor
      ]);
  });

  modrinth-app = pkgs.symlinkJoin {
    name = "modrinth-app-wayland";
    paths = [modrinth-app-base];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      mv "$out/bin/ModrinthApp" "$out/bin/.ModrinthApp-unwrapped"

      # X11 enforcement is disabled so SDL can select Wayland when available.
      makeWrapper "$out/bin/.ModrinthApp-unwrapped" "$out/bin/ModrinthApp" \
        --argv0 ModrinthApp \
        # --set XDG_SESSION_TYPE x11 \
        # --set SDL_VIDEO_DRIVER x11
    '';
  };
in {
  # Minecraft mod manager and launcher (unfree).
  home.packages = [modrinth-app];
}
