{ lib, pkgs, ... }: {
  # Niri enables GNOME Keyring (for the Secret portal). GNOME Keyring also
  # defaults to its gcr SSH agent, which conflicts with programs.ssh.startAgent
  # in common.nix. Keep the normal OpenSSH agent used by the rest of the system.
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  # ── Niri ───────────────────────────────────────────────────────────────
  programs.niri = {
    enable = true;

    # Use the GTK file chooser. If you want Nautilus as the file chooser
    # instead, set this to true and add `nautilus` to home.packages.
    useNautilus = false;
  };

  # ── Login manager ──────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    useTextGreeter = true;

    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${pkgs.niri}/bin/niri-session";
  };

  # ── Audio ──────────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ── Bluetooth ──────────────────────────────────────────────────────────
  # hardware.bluetooth.enable enables the BlueZ service as well.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ── Power / graphics ───────────────────────────────────────────────────
  services.upower.enable = true;
  hardware.graphics.enable = true;

  # Niri integrates with xwayland-satellite automatically. Do not enable
  # programs.xwayland: X11 is handled by the satellite on demand.
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # ── Fonts ──────────────────────────────────────────────────────────────
  # Broad fallback coverage plus Nerd Fonts for Waybar/Ghostty icons.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    dejavu_fonts
    liberation_ttf
    unifont
    cantarell-fonts
    inter
    roboto
    font-awesome
    material-icons
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans" "DejaVu Sans" ];
    serif = [ "Noto Serif" "DejaVu Serif" ];
    monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Useful for file chooser / removable media integration.
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
