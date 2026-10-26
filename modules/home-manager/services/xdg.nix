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
  ];
}
