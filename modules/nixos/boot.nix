{ pkgs, ... }: {
  # Track the latest upstream stable kernel. The stable package set currently
  # ships NVIDIA 595.71.05, whose kernel modules do not compile against Linux
  # 7.3; unstable carries the matching 595.104.02 driver. Using the unstable
  # kernel package set keeps the kernel and every out-of-tree module (including
  # NVIDIA) built against the same kernel while the rest of the system remains
  # on stable.
  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;

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

  # Do not let one stuck service hold the shutdown forever. systemd sends
  # SIGKILL after this timeout and continues.
  systemd.settings.Manager.DefaultTimeoutStopSec = "45s";

  # If systemd itself wedges during shutdown, reboot through the hardware
  # watchdog instead of hanging indefinitely. Boards without a watchdog
  # simply ignore this.
  systemd.settings.Manager.ShutdownWatchdogSec = "10min";

  # Capture the final shutdown path on the console. This is intentionally
  # verbose for diagnosing the intermittent poweroff hang; it can be lowered
  # again once the cause is known.
  systemd.settings.Manager.LogLevel = "info";
  systemd.settings.Manager.LogTarget = "journal+console";
  boot.consoleLogLevel = 6;

  # Allow Alt+SysRq+B (and friends) to recover if the final poweroff hangs.
  boot.kernel.sysctl."kernel.sysrq" = 1;
}
