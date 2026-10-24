{ pkgs, ... }: {
  # Database GUI client (unfree).
  home.packages = [ pkgs.unstable.tableplus ];
}
