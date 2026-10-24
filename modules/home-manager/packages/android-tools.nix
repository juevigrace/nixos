{ pkgs, ... }: {
  # adb, fastboot, and other Android platform tools. Useful alongside Android
  # Studio and for debugging physical devices.
  home.packages = [ pkgs.unstable.android-tools ];
}
