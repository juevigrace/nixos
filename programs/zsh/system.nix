# NixOS-side Zsh setup. Required by users.users.<name>.shell = pkgs.zsh.
{...}: {
  programs.zsh.enable = true;
}
