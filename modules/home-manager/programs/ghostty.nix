{ config, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Matugen writes this file; the repo contains the Catppuccin fallback.
      "config-file" = "${config.home.homeDirectory}/.config/ghostty/colors.conf";

      "font-family" = "JetBrainsMono Nerd Font";
      "font-style" = "Regular";
      "font-size" = 12;

      "background-opacity" = 0.90;

      "window-theme" = "ghostty";
      "window-decoration" = false;
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
  };
}
