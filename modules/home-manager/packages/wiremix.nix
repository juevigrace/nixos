{ pkgs, ... }: {
  # PipeWire TUI mixer, useful for front/rear mic ports.
  home.packages = [ pkgs.wiremix ];
}
