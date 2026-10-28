{pkgs, ...}: {
  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = ["zen-beta.desktop"];
      "x-scheme-handler/https" = ["zen-beta.desktop"];
      "x-scheme-handler/about" = ["zen-beta.desktop"];
      "x-scheme-handler/unknown" = ["zen-beta.desktop"];
      "text/html" = ["zen-beta.desktop"];
    };
  };

  home.packages = with pkgs; [
    xdg-utils
    desktop-file-utils
    shared-mime-info

    # xdg-open and desktop integrations expect gio/gdbus on PATH. NixOS ships
    # libglib without its binaries in the system profile, so add the bin output
    # explicitly.
    glib.bin
  ];
}
