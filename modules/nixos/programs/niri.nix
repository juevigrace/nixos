{ ... }: {
  programs.niri = {
    enable = true;

    # Use Nautilus as the file chooser. Set this to false for the GTK chooser.
    useNautilus = true;
  };
}
