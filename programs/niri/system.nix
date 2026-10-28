# NixOS-side Niri setup. The Home Manager configuration lives in
# default.nix and is imported separately by Home Manager.
{...}: {
  programs.niri = {
    enable = true;

    # Use Nautilus as the file chooser. Set this to false for the GTK chooser.
    useNautilus = true;
  };
}
