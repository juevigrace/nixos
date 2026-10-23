{ pkgs, ... }: {
  # ── User packages ──────────────────────────────────────────────────────
  home.packages = with pkgs; [
    ghostty          # terminal
    pwvucontrol      # PipeWire GUI mixer
    wiremix          # PipeWire TUI mixer (front/rear mic ports)
    wireplumber      # provides wpctl, used by the Niri keybinds
    playerctl        # media keys
    brightnessctl    # laptop brightness keys
    waypaper         # GUI wallpaper chooser
    swaybg           # wallpaper backend used by Waypaper
    networkmanagerapplet
    grim
    slurp
    satty
    wl-clipboard
    unstable.opencode
    firefox
  ];

  # ── Bar ────────────────────────────────────────────────────────────────
  # Do not generate Waybar's config/style from Nix. The real files live in
  # ./files/waybar/ and are linked into ~/.config/waybar/.
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = { };
    style = null;
  };

  # ── Notifications ──────────────────────────────────────────────────────
  # Keep the mako module for its D-Bus integration; files.nix provides the
  # actual config file.
  services.mako.enable = true;

  # ── Launcher ───────────────────────────────────────────────────────────
  # The fuzzel module installs the package; files.nix provides the ini file.
  programs.fuzzel.enable = true;

  # ── Lock / idle ────────────────────────────────────────────────────────
  programs.swaylock.enable = true;

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      }
    ];
    events = {
      "before-sleep" = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };

  # ── Clipboard history ──────────────────────────────────────────────────
  services.cliphist.enable = true;

  # ── Desktop integration ────────────────────────────────────────────────
  services.polkit-gnome.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
}
