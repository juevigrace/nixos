{pkgs, ...}: {
  programs.btop = {
    enable = true;

    settings = {
      # Matugen writes ~/.config/btop/themes/skwd.theme; the repo contains
      # the Catppuccin fallback used to seed it.
      color_theme = "skwd";
      save_config_on_exit = false;
    };

    extraConfig = builtins.readFile ./btop.conf;

    package = pkgs.btop.override {cudaSupport = true;};
  };
}
