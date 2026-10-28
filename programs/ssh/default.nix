{
  config,
  helpers,
  pkgs,
  ...
}: let
  user = config.home.username;
in {
  # The SSH client configuration is user-specific and lives in the user's
  # folder. Keep it as a live symlink so edits do not need a rebuild.
  home.packages = [pkgs.openssh];

  home.file.".ssh/config".source =
    helpers.liveConfig "users/${user}/programs/ssh/config";
}
