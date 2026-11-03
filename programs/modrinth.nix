{pkgs, ...}: let
  modrinth-app = pkgs.symlinkJoin {
    name = "modrinth-app-x11";
    paths = [pkgs.unstable.modrinth-app];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      mv "$out/bin/ModrinthApp" "$out/bin/.ModrinthApp-unwrapped"

      makeWrapper "$out/bin/.ModrinthApp-unwrapped" "$out/bin/ModrinthApp" \
        --argv0 ModrinthApp \
        --set XDG_SESSION_TYPE x11 \
        --set SDL_VIDEO_DRIVER x11
    '';
  };
in {
  # Minecraft mod manager and launcher (unfree).
  home.packages = [modrinth-app];
}
