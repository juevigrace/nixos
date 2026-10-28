{ inputs, ... }: {
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      DontCheckDefaultBrowser = true;

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{242af0bb-db11-4734-b7a0-61cb8a9b20fb}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/malwarebytes/latest.xpi";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
        };
        "vpn@proton.ch" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-vpn-firefox-extension/latest.xpi";
        };
      };
    };

    profiles.default.settings = {
      # Restore the previous session on launch.
      "zen.workspaces.continue-where-left-off" = true;

      # Enable the Firefox Sync engines. You still sign in manually.
      "services.sync.engine.addons" = true;
      "services.sync.engine.tabs" = true;
      "services.sync.engine.workspaces" = true;
    };

    # If Firefox Sync does not restore your Spaces/pins, add declarative
    # profiles.default.spaces and .pins here. Close Zen before rebuilding.
  };
}
