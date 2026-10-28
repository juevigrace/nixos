# Aggregator for the shared home-manager configuration.
#
# Each app or service lives in its own file/folder. To disable something,
# comment out its import below.
{
  config,
  ...
}: let
  helpers = import ../../helpers {inherit config;};
in {
  _module.args.helpers = helpers;

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
