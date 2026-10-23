# Keep this at the release you installed. Do not bump it on every update.
#
# If your installer ISO is 25.05 instead of 26.05, change this and the flake
# inputs to 25.05 before the first rebuild.
{ ... }: {
  system.stateVersion = "26.05";
}
