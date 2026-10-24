{pkgs, ...}: {
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "miku";
      save_config_on_exit = false;
    };

    themes.miku = ./miku.theme;
    extraConfig = builtins.readFile ./btop.conf;

    package = pkgs.btop.override {cudaSupport = true;};
  };
}
