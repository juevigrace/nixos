# Aggregator for the shared NixOS modules.
#
# Each app, service, or hardware concern lives in its own file. Add a new
# module by dropping a file in the matching folder and importing it here.
{ ... }: {
  imports = [
    ./nixpkgs.nix
    ./packages.nix

    ./nix.nix
    ./state.nix
    ./locale.nix
    ./environment.nix

    ./boot/systemd-boot.nix
    ./boot/zram.nix

    ./networking/networkmanager.nix
    ./users/juevigrace.nix

    ./services/openssh.nix
    ./programs/ssh-agent.nix

    ./hardware/bluetooth.nix
    ./services/blueman.nix
    ./hardware/graphics.nix
    ./hardware/fonts.nix
    ./services/upower.nix
    ./services/gvfs.nix
    ./services/udisks2.nix
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/gnome-keyring.nix

    ./programs/niri.nix
    ./programs/xwayland-satellite.nix
  ];
}
