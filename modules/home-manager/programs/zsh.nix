{ config, lib, ... }: {
  programs.zsh = {
    enable = true;

    # Keep the traditional ~/.zshrc location instead of ~/.config/zsh.
    dotDir = config.home.homeDirectory;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "tmux"
        "themes"
        "man"
        "colored-man-pages"
        "colorize"
        "z"
        "fzf"
        "alias-finder"
      ];
    };

    initContent = lib.mkAfter ''
      # Nix provides jdk21 and gradle by default. SDKMAN is optional and can be
      # loaded on demand without shadowing the Nix toolchain in every shell.
      load-sdkman() {
        export SDKMAN_DIR="$HOME/.sdkman"
        if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
          source "$SDKMAN_DIR/bin/sdkman-init.sh"
        else
          echo "SDKMAN is not installed at $SDKMAN_DIR" >&2
        fi
      }
    '';
  };
}
