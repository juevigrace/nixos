# Aggregator for the shared NixOS modules.
#
# Each app, service, or hardware concern lives in its own file. Add a new
# module by dropping a file in the matching folder and importing it here.
{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.default

    ./boot.nix
    ./nix-ld.nix
    ./desktop/fonts/fonts.nix
  ];

  # System-wide packages. These are available to every user and to services.
  #
  # User-level CLI tools belong in programs/ instead.
  # You can take one package from unstable without moving everything:
  #   pkgs.unstable.some-package
  environment.systemPackages = with pkgs; [
    # NixOS's system path tolerates the clang/gcc bin/cc and bin/c++
    # collisions, so clang can live here while gcc stays in the
    # home-manager toolchain.
    clang
    git
    curl
    wget
    zip
    unzip
  ];

  # nixpkgs-wide settings and the stable/unstable overlay.
  #
  # Everything here applies to BOTH machines. Per-host differences belong in
  # hosts/<host>/default.nix.

  # Both machines are x86_64. The generated hardware file also sets this with
  # lib.mkDefault, so a future host can override it without editing this file.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Needed later for Steam, Discord, NVIDIA drivers, etc.
  nixpkgs.config.allowUnfree = true;

  # ── Stable + unstable side by side ──────────────────────────────────────
  #
  # `pkgs` remains the stable package set:
  #   pkgs.firefox
  #
  # The same package from unstable is available as:
  #   pkgs.unstable.firefox
  #
  # The unstable set gets the same nixpkgs config (allowUnfree, etc.), but it
  # is a separate package set, so mixing the two cannot break stable packages.
  nixpkgs.overlays = [
    (final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.stdenv.hostPlatform.system;
        config = final.config;
      };
    })
  ];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    # Channels are not used; the flake inputs are the source of truth.
    channel.enable = false;

    # Make `<nixpkgs>` resolve to the flake input so tools like
    # `nix-shell -p` see the same package set as the system.
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };

  system.stateVersion = "26.05";
}
