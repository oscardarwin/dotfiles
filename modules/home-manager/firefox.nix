{ inputs, pkgs, ... }: {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      DefaultDownloadDirectory = "\${home}/downloads";
    };

    profiles.hallayus = {
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks";
            toolbar = true;
            bookmarks = import ./browser-bookmarks/firefox-bookmarks.nix ++ import ./browser-bookmarks/uai-bookmarks.nix;
          }
        ];
      };
      extensions.packages = with inputs.firefox-addons.packages."${pkgs.system}"; [
        ublock-origin
        privacy-badger
        vimium
        simple-translate
        darkreader
      ];
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.disableResetPrompt" = true;
        "browser.download.panel.shown" = true;
        "browser.download.useDownloadDir" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.startup.homepage" = "https://www.google.com";
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","downloads-button","library-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":18,"newElementCount":4}'';
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
        "privacy.trackingprotection.enabled" = true;
        "signon.rememberSignons" = false;
      };
    };
  };

}
