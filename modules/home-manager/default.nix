# Aggregator for the shared home-manager configuration.
#
# Each app or service lives in its own file/folder. To disable something,
# comment out its import below.
{ ... }: {
  imports = [
    # CLI tools
    ./packages/brightnessctl.nix
    ./packages/fd.nix
    ./packages/fzf.nix
    ./packages/lazydocker.nix
    ./packages/neovim.nix
    ./packages/neovim-toolchain.nix
    ./packages/nixd.nix
    ./packages/opencode.nix
    ./packages/playerctl.nix
    ./packages/ripgrep.nix
    ./packages/tree.nix
    ./packages/wl-clipboard.nix

    # Desktop apps
    ./packages/grim.nix
    ./packages/nautilus.nix
    ./packages/satty.nix
    ./packages/slurp.nix
    ./packages/swaybg.nix

    # Audio tools
    ./packages/pwvucontrol.nix
    ./packages/wiremix.nix
    ./packages/wireplumber.nix

    # Configured programs
    ./programs/git.nix
    ./programs/ssh.nix
    ./programs/ghostty.nix
    ./programs/zsh.nix
    ./programs/waypaper.nix
    ./programs/zen.nix

    ./programs/waybar
    ./programs/niri
    ./programs/fuzzel
    ./programs/swaylock
    ./programs/tmux
    ./programs/btop
    ./programs/cursor

    ./services/mako
    ./services/swayidle.nix
    ./services/cliphist.nix
    ./services/polkit-gnome.nix
    ./services/network-manager-applet.nix
    ./services/blueman-applet.nix
  ];

  # Reload systemd user units when home-manager changes them.
  systemd.user.startServices = "sd-switch";

  # Optional programs. Uncomment the setting and add a matching module/import
  # when you want it.
  #
  # programs.bash.enable = true;
  # programs.starship.enable = true;
  # programs.direnv.enable = true;
  # programs.fzf.enable = true;
  # programs.bat.enable = true;
  #
  # ⚠ Do NOT enable programs.neovim: ~/.config/nvim is a separate git clone.
}
