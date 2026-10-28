{ ... }: {
  programs.tmux = {
    enable = true;

    sensibleOnTop = false;
    secureSocket = false;
    clock24 = true;

    mouse = true;
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 50000;
    focusEvents = true;
    aggressiveResize = true;
    terminal = "tmux-256color";

    extraConfig = builtins.readFile ./tmux.conf;
  };
}
