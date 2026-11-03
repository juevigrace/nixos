{ pkgs, ... }: {
  # Count lines of code, comments, and blank lines by language.
  home.packages = [ pkgs.cloc ];
}
