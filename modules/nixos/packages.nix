{ pkgs, ... }: {
  # System-wide packages. These are available to every user and to services.
  #
  # User-level CLI tools belong in modules/home-manager/packages/ instead.
  # You can take one package from unstable without moving everything:
  #   pkgs.unstable.some-package
  environment.systemPackages = with pkgs; [
    # NixOS's system path tolerates the clang/gcc bin/cc and bin/c++
    # collisions, so clang can live here while gcc stays in the
    # home-manager toolchain.
    clang
    git
    curl
    wget
    zip
    unzip
  ];
}
