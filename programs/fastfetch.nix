{...}: {
  # Fastfetch is actively maintained and much faster than neofetch (which is
  # archived upstream). Keep the output useful on both the desktop and laptop.
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          top = 1;
          right = 2;
        };
      };

      display = {
        separator = "  ";
        color = "blue";
      };

      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
        "de"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "break"
        "colors"
      ];
    };
  };
}
