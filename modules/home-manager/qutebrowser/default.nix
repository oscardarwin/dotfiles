{ pkgs, ... }: {
  programs.rofi.enable = true;

  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      g = "https://www.google.com/search?hl=en&q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      np = "https://search.nixos.org/packages?channel=24.11&size=50&sort=relevance&type=options&query={}";
    };

    quickmarks = {
      cheatsheet = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
      nixvim = "https://nix-community.github.io/nixvim";
      home-manager = "https://nix-community.github.io/home-manager/options.xhtml";
      beeper = "https://chat.beeper.com/";
      chatgpt = "https://chatgpt.com";
      calendar = "https://calendar.google.com/calendar/u/0/r";
      gmail = "https://mail.google.com/mail/u/0/#inbox";
      settings = "https://www.qutebrowser.org/doc/help/settings.html";
      github = "https://github.com";
    };

    settings = {
      colors.webpage = {
        darkmode.enabled = true;
        preferred_color_scheme = "dark";
      };
      content.cookies.accept = "all";
      auto_save.session = true;
      tabs.show = "never";

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
