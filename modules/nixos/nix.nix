{ ... }: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    # Channels are not used; the flake inputs are the source of truth.
    channel.enable = false;
  };
}
