{ ... }: {
  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      g = "https://www.google.com/search?hl=en&q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      np = "https://search.nixos.org/packages?channel=24.11&size=50&sort=relevance&type=options&query={}";
      nv = "https://nix-community.github.io/nixvim/search/?option_scope=0&query={}";
    };

    quickmarks = {
      cheatsheet = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
      nixvim = "https://nix-community.github.io/nixvim";
      home-manager = "https://home-manager-options.extranix.com";
      beeper = "https://chat.beeper.com/";
      chatgpt = "https://chatgpt.com";
      calendar = "https://calendar.google.com/calendar/u/0/r";
      gmail = "https://mail.google.com/mail/u/0/#inbox";
      settings = "https://www.qutebrowser.org/doc/help/settings.html";
      github = "https://github.com";
      german-translate = "https://www.deepl.com/en/translator/l/en/de";
      maps = "https://www.google.de/maps/@48.0005734,7.8578012,15z";
      drive = "https://drive.google.com/drive/my-drive";
    };
    settings = {
      qt.chromium.process_model = "process-per-site";
      colors.webpage = {
        darkmode.enabled = true;
        preferred_color_scheme = "dark";
      };
      content = {
        cookies.accept = "all";
        blocking.method = "both";
        register_protocol_handler = false;
      };
      auto_save.session = true;
      tabs.show = "never";

      downloads = {
        location = {
          directory = "~/downloads";
          prompt = false;
          remember = false;
        };
      };

      url.start_pages = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
    };

    aliases = {
      t = "tab-select";
      f = "spawn --userscript 1password.sh";
    };
  };

  home.file.".config/qutebrowser/userscripts/1password.sh" = {
    source = ./1password.sh;
    executable = true;
  };
}
