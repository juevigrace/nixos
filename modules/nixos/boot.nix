{ ... }: {
  # Both machines use Limine on the ESP mounted at /boot.
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 10;
    enableEditor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # zram instead of a disk swap partition.
  zramSwap.enable = true;
}
