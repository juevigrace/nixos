{ pkgs, ... }:
let
  miku-cursor-linux = pkgs.stdenvNoCC.mkDerivation {
    pname = "miku-cursor-linux";
    version = "unstable";

    src = ./miku-cursor-linux;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/share/icons"
      cp -a "$src" "$out/share/icons/miku-cursor-linux"
      runHook postInstall
    '';
  };
in {
  home.pointerCursor = {
    enable = true;
    package = miku-cursor-linux;
    name = "miku-cursor-linux";
    size = 24;
    gtk.enable = true;
  };

  # Apply the cursor theme to GTK 3/4 applications as well.
  gtk.enable = true;
}
