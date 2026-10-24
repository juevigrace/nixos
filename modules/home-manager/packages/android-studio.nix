{ pkgs, ... }:
let
  # tiling_wm sets _JAVA_AWT_WM_NONREPARENTING=1, which avoids the blank-window
  # and dialog-placement problems Java apps have under Niri.
  androidStudio =
    (pkgs.unstable.androidStudioPackages.override { tiling_wm = true; }).stable;
in {
  # IDE only. Install the Android SDK and platform tools through Android
  # Studio's SDK Manager, or use the separate android-tools package.
  home.packages = [ androidStudio ];
}
