{
  config,
  lib,
  ...
}: {
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
      # SDKMAN owns the Java and Gradle versions. It is installed once by
      # hand because it manages mutable toolchains under ~/.sdkman.
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
    '';
  };

  # Make the SDKMAN candidates visible outside interactive zsh too, so Mason
  # and GUI-launched programs find the JBR and Gradle.
  home.sessionVariables.JAVA_HOME = "${config.home.homeDirectory}/.sdkman/candidates/java/current";

  home.sessionPath = [
    "${config.home.homeDirectory}/.sdkman/candidates/java/current/bin"
    "${config.home.homeDirectory}/.sdkman/candidates/gradle/current/bin"
  ];
}
