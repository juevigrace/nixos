# Shared user configuration for juevigrace on both machines.
{ config, pkgs, ... }: {
  # ── Per-user packages ──────────────────────────────────────────────────
  #
  # `pkgs` is the stable set. To take ONE package from unstable while the
  # rest stays stable, use `pkgs.unstable.<name>`, for example:
  #   pkgs.unstable.firefox
  home.packages = with pkgs; [
    neovim # program only; the config is cloned separately (see the note below)
    ripgrep
    fd
    fzf
    tree
    nautilus
  ];

  # ── Git ────────────────────────────────────────────────────────────────
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

  # ── SSH client ─────────────────────────────────────────────────────────
  #
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

  # Reload systemd user units when home-manager changes them.
  systemd.user.startServices = "sd-switch";

  # ⚠ Do NOT enable programs.neovim here.
  # ~/.config/nvim is a git clone of the separate nvim repo. Enabling
  # programs.neovim would try to manage that directory. The `neovim` program
  # itself is installed through home.packages above.
}
