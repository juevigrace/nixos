{ pkgs, ... }: {
  # PipeWire GUI mixer.
  home.packages = [ pkgs.pwvucontrol ];
}
