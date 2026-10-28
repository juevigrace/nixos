{helpers, ...}: {
  programs.fuzzel.enable = true;
  xdg.configFile."fuzzel/fuzzel.ini".source =
    helpers.liveConfig "programs/fuzzel/fuzzel.ini";
}
