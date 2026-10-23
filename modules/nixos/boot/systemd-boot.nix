{ ... }: {
  # Both machines use systemd-boot. If the installer used GRUB, the first
  # `nixos-rebuild switch` will install systemd-boot on the ESP mounted at
  # /boot.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
}
