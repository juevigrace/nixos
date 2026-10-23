# nixpkgs-wide settings and the stable/unstable overlay.
#
# Everything here applies to BOTH machines. Per-host differences belong in
# hosts/<host>/default.nix.
{ inputs, lib, ... }: {
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
}
