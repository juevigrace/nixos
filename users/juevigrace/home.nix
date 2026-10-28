# The one home-manager profile, shared by tear and laila.
#
# This file wires the user's chosen Home Manager programs and services.
{pkgs, ...}: {
  imports = [
    ../../modules/home-manager

    # CLI tools
    ../../programs/android-tools.nix
    ../../programs/brightnessctl.nix
    ../../programs/caligula.nix
    ../../programs/fd.nix
    ../../programs/fzf.nix
    ../../programs/lazydocker.nix
    ../../programs/neovim.nix
    ../../programs/neovim-toolchain.nix
    ../../programs/nixd.nix
    ../../programs/opencode.nix
    ../../programs/playerctl.nix
    ../../programs/ripgrep.nix
    ../../programs/tree.nix
    ../../programs/wl-clipboard.nix
    ../../programs/yt-dlp.nix

    # Desktop apps
    ../../programs/android-studio.nix
    ../../programs/discord.nix
    ../../programs/grim.nix
    ../../programs/nautilus.nix
    ../../programs/satty.nix
    ../../programs/slurp.nix
    ../../programs/spotify.nix
    ../../programs/tableplus.nix
    ../../programs/vlc.nix

    # Gaming
    ../../programs/heroic.nix
    ../../programs/mangohud.nix
    ../../programs/modrinth.nix
    ../../programs/wine.nix

    # Audio tools
    ../../programs/pwvucontrol.nix
    ../../programs/wiremix.nix
    ../../services/pipewire/home.nix

    # Configured programs
    ../../programs/git.nix
    ../../programs/ssh
    ../../programs/ghostty
    ../../programs/zsh
    ../../programs/waypaper.nix
    ../../programs/chromium.nix
    ../../programs/firefox.nix
    ../../programs/zen.nix
    ../../programs/obs-studio

    ../../programs/waybar
    ../../programs/niri
    ../../programs/fuzzel
    ../../programs/swaylock
    ../../programs/skwd-wall
    ../../services/skwd-theme-sync
    ../../programs/tmux
    ../../programs/btop
    ../../programs/fastfetch.nix
    ../../programs/cursor
    ../../programs/blueman-applet.nix
    ../../programs/network-manager-applet.nix

    # User services
    ../../services/mako
    ../../services/xdg/home.nix
    ../../services/swayidle
    ../../services/cliphist
    ../../services/polkit-gnome
    ../../services/swaybg
  ];

  home = {
    username = "juevigrace";
    homeDirectory = "/home/juevigrace";

    # Keep this at the release you installed; do not bump it on every update.
    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";

      # Keep compiled shaders between game launches. This removes a large part
      # of the first-run stutter, especially with Proton/DXVK.
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      MESA_SHADER_CACHE_MAX_SIZE = "12G";
    };

    packages = [
      pkgs.xwayland-satellite
    ];
  };

  services.ssh-agent.enable = true;

  programs.home-manager.enable = true;
}
