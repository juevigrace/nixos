{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";

      # Keys only. If you ever lose the private keys, boot locally and set
      # this to true temporarily, or use `passwd`/`ssh-keygen` from a TTY.
      PasswordAuthentication = false;
    };
  };
}
