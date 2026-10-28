{ config, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "JueViGrace";
        email = "juev1grace@gmail.com";
      };
      init.defaultBranch = "master";
    };

    # Sign commits/tags with the GitHub SSH key.
    # On GitHub, add this public key as a SIGNING key too (not only as an
    # authentication key).
    signing = {
      key = "${config.home.homeDirectory}/.ssh/personal/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
  };
}
