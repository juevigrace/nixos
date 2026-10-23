{ lib, ... }: {
  # Niri enables GNOME Keyring (for the Secret portal). GNOME Keyring also
  # defaults to its gcr SSH agent, which conflicts with programs.ssh.startAgent
  # in modules/nixos/programs/ssh-agent.nix. Keep the normal OpenSSH agent used
  # by the rest of the system.
  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
}
