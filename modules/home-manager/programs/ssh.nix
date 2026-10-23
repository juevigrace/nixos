{ ... }: {
  # This writes ~/.ssh/config. Private keys are NOT managed here; copy them
  # to ~/.ssh after installing (see README.md).
  programs.ssh = {
    enable = true;

    # Do not add home-manager's old default host block. We define the global
    # defaults we want in settings."*" below.
    enableDefaultConfig = false;

    settings = {
      # Global defaults for every host. This block is emitted last.
      "*" = {
        AddKeysToAgent = "yes";
        ServerAliveInterval = 60;
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/personal/id_ed25519";
        IdentitiesOnly = true;
      };

      "laila" = {
        HostName = "192.168.1.196";
        User = "juevigrace";
        IdentityFile = "~/.ssh/lan";
        IdentitiesOnly = true;
      };

      "tear" = {
        # Wired. Wi-Fi is 192.168.1.174; change this line if you use Wi-Fi.
        HostName = "192.168.1.23";
        User = "juevigrace";
        IdentityFile = "~/.ssh/lan";
        IdentitiesOnly = true;
      };
    };
  };
}
