{config}: let
  repo = "${config.home.homeDirectory}/Projects/nixos";
in {
  inherit repo;

  liveConfig = path:
    config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
}
