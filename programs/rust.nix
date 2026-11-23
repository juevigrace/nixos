{ pkgs, ... }: {
  # All Rust tooling lives here. Toolchains are managed by rustup so versions
  # can be pinned per project. rustup also provides the rust-analyzer proxy,
  # so no separate nixpkgs rust-analyzer is installed (their bin/rust-analyzer
  # paths would collide inside the Home Manager build environment).
  #
  # After the first switch, install the default toolchain and components:
  #   rustup default stable
  #   rustup component add rust-src rust-analyzer
  home.packages = [pkgs.rustup];

  # rustup puts its rustc/cargo shims in ~/.cargo/bin. This must come before
  # ~/.nix-profile/bin so the shims win (there are no Nix rustc/cargo).
  home.sessionPath = ["$HOME/.cargo/bin"];
}
