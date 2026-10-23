{ ... }: {
  # The one user shared by both machines.
  users.users.juevigrace = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];

    # Incoming SSH access to both tear and laila. These are PUBLIC keys.
    # The matching private keys still have to be copied to ~/.ssh by hand.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/XboS4moZj74BM1tI2Zle71nZHQiK0FOAAab/+6Fvw tear-to-laila"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeO4ZEemFxFMQK/C/X/zP44A+aXYuOh2luKX03hug3y juev1grace@gmail.com"
    ];
  };
}
