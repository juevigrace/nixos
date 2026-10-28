{ pkgs, ... }: {
  # Program only; ~/.config/nvim is a separate git clone.
  home.packages = [ pkgs.neovim ];
}
