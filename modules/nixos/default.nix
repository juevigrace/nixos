# Aggregator for the shared NixOS modules.
#
# Add new shared system modules to this list. Keeping the flake entry as
# `./modules/nixos` means flake.nix does not need to change when you split
# common.nix into more files later.
{ ... }: {
  imports = [
    ./nixpkgs.nix
    ./common.nix
    ./packages.nix
    ./services.nix
    ./desktop.nix
  ];
}
