{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nixos.nix

    # NixOS desktop/gaming prerequisites
    ../../services/blueman
    ../../services/greetd
    ../../services/pipewire
    ../../services/xdg
    ../../services/gvfs

    ../../programs/niri/system.nix
    ../../programs/steam.nix
    ../../programs/droidcam.nix
  ];

  # The one user shared by both machines.
  users.users.juevigrace = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "docker"];

    # Incoming SSH access to both tear and laila. These are PUBLIC keys.
    # The matching private keys still have to be copied to ~/.ssh by hand.
    openssh.authorizedKeys.keys =
      lib.filter (line: line != "" && !(lib.hasPrefix "#" line))
      (lib.splitString "\n" (builtins.readFile ./programs/ssh/authorized_keys));
  };

  home-manager.users.juevigrace = {
    imports = [./home.nix];
  };

  environment.systemPackages = with pkgs; [
    # SQLite CLI + shared library.
    sqlite
    sqlite.out

    # Legacy libcrypt ABI compatibility.
    libxcrypt-legacy
  ];
}
