{ pkgs, ... }: {
  # Disk usage analyzer with an ncurses interface.
  home.packages = [ pkgs.ncdu ];
}
