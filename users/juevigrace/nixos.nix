{...}: {
  imports = [
    # System services
    ../../services/networkmanager
    ../../services/ssh
    ../../services/docker
    ../../services/gnome-keyring
    ../../services/udisks2
    ../../services/upower
    ../../services/power

    # Required system program
    ../../programs/zsh/system.nix
  ];

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
}
