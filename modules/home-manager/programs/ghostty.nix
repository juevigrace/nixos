{ ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "miku";

      "font-family" = "JetBrainsMono Nerd Font";
      "font-style" = "Regular";
      "font-size" = 12;

      "background-opacity" = 0.90;

      "window-theme" = "ghostty";
      "window-padding-x" = 14;
      "window-padding-y" = 14;
      "confirm-close-surface" = false;
      "resize-overlay" = "never";
      "gtk-toolbar-style" = "flat";

      "cursor-style" = "block";
      "cursor-style-blink" = false;
      "shell-integration-features" = "no-cursor,ssh-env";

      keybind = [
        "shift+insert=paste_from_clipboard"
        "control+insert=copy_to_clipboard"
        "shift+enter=csi:13;2u"
        "alt+shift+enter=csi:13;4u"
        "super+control+shift+alt+arrow_down=resize_split:down,100"
        "super+control+shift+alt+arrow_up=resize_split:up,100"
        "super+control+shift+alt+arrow_left=resize_split:left,100"
        "super+control+shift+alt+arrow_right=resize_split:right,100"
      ];

      "mouse-scroll-multiplier" = 0.95;
      "async-backend" = "epoll";
    };

    themes.miku = {
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      "cursor-color" = "#dae0f7";
      "selection-background" = "#353543";
      "selection-foreground" = "#dae0f7";

      palette = [
        "0=#1e1e2e"
        "1=#f38ba8"
        "2=#a6e3a1"
        "3=#f9e2af"
        "4=#89b4fa"
        "5=#cba6f7"
        "6=#94e2d5"
        "7=#cdd6f4"
        "8=#45475a"
        "9=#f38ba8"
        "10=#a6e3a1"
        "11=#f9e2af"
        "12=#89b4fa"
        "13=#cba6f7"
        "14=#94e2d5"
        "15=#dae0f7"
      ];
    };
  };
}
