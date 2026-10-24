{pkgs, ...}: {
  # Build/runtime dependencies for Mason. Mason still installs the actual LSPs,
  # formatters, linters, and DAP adapters itself.
  home.packages = with pkgs; [
    # Native build toolchain used by cargo, npm, and Go packages.
    # gcc is the default cc/c++; clang is installed system-wide because both
    # provide bin/cc and bin/c++, which conflict inside home-manager's buildEnv.
    gcc
    gnumake
    pkg-config

    # Mason's PyPI packages use `python3 -m pip` and `python3 -m venv`.
    (python3.withPackages (ps: [
      ps.pip
      ps.setuptools
      ps.wheel
      ps.virtualenv
    ]))

    # Mason's npm, Go, and cargo packages.
    nodejs
    go
    rustc
    cargo

    # Java-based Mason packages (jdtls, kotlin-lsp, gradle-language-server,
    # google-java-format, ktlint) use the SDKMAN JBR configured in
    # modules/home-manager/programs/zsh.nix.
  ];
}
