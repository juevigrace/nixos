{ ... }: {
  environment.sessionVariables.EDITOR = "nvim";

  # Bash for now. When you want zsh:
  #   1. enable programs.zsh in modules/home-manager/
  #   2. set users.users.juevigrace.shell = pkgs.zsh in
  #      modules/nixos/users/juevigrace.nix
}
