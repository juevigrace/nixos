{ pkgs, ... }: {
  # Mason installs unpatched prebuilt binaries (clangd, rust-analyzer,
  # lua-language-server, codelldb, kotlin-lsp, prettierd, ...). nix-ld supplies
  # the FHS loader and libraries those binaries expect on NixOS.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      cups
      dbus
      expat
      fontconfig
      freetype
      glib
      libGL
      libpulseaudio
      libxkbcommon
      libice
      libsm
      libx11
      libxau
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxdmcp
      libxext
      libxfixes
      libxi
      libxinerama
      libxrandr
      libxrender
      libxtst
    ];
  };
}
