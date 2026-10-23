# Shared system configuration for both machines.
#
# Put things here when tear and laila should behave the same way.
# Put host-specific things (GPU, hostname, disks) in hosts/<host>/.
{ config, lib, pkgs, ... }: {
  # ── Nix ────────────────────────────────────────────────────────────────
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Channels are not used; the flake inputs are the source of truth.
    channel.enable = false;
  };

  # ── Boot ───────────────────────────────────────────────────────────────
  # Both machines use systemd-boot. If the installer used GRUB, the first
  # `nixos-rebuild switch` will install systemd-boot on the ESP mounted at
  # /boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # zram instead of a disk swap partition.
  zramSwap.enable = true;

  # ── Networking ─────────────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  # ── The one user shared by both machines ───────────────────────────────
  users.users.juevigrace = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];

    # Incoming SSH access to both tear and laila. These are PUBLIC keys.
    # The matching private keys still have to be copied to ~/.ssh by hand.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/XboS4moZj74BM1tI2Zle71nZHQiK0FOAAab/+6Fvw tear-to-laila"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeO4ZEemFxFMQK/C/X/zP44A+aXYuOh2luKX03hug3y juev1grace@gmail.com"
    ];
  };

  # ── SSH server (incoming) ──────────────────────────────────────────────
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";

      # Keys only. If you ever lose the private keys, boot locally and set
      # this to true temporarily, or use `passwd`/`ssh-keygen` from a TTY.
      PasswordAuthentication = false;
    };
  };

  # ssh-agent for git and outgoing SSH.
  programs.ssh.startAgent = true;

  # ── Locale and time ────────────────────────────────────────────────────
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };
  time.timeZone = "America/Caracas";

  # ── Shell ──────────────────────────────────────────────────────────────
  # Bash for now. When you want zsh:
  #   1. enable programs.zsh in modules/home-manager/programs.nix
  #   2. uncomment the next line
  # users.users.juevigrace.shell = pkgs.zsh;

  environment.sessionVariables.EDITOR = "nvim";

  # ── State version ──────────────────────────────────────────────────────
  # Keep this at the release you installed. Do not bump it on every update.
  # If your installer ISO is 25.05 instead of 26.05, change this and the
  # flake inputs to 25.05 before the first rebuild.
  system.stateVersion = "26.05";
}
