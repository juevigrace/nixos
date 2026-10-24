{ inputs, ... }: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    # Channels are not used; the flake inputs are the source of truth.
    channel.enable = false;

    # Make `<nixpkgs>` resolve to the flake input so tools like
    # `nix-shell -p` see the same package set as the system.
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
