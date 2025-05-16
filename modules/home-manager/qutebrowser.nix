{ inputs, pkgs-unstable, ... }: {
  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      g = "https://www.google.com/search?hl=en&q={}";
      w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      np = "https://search.nixos.org/packages?channel=24.11&size=50&sort=relevance&type=options&query={}";
    };

    quickmarks = {
      nixvim = "https://nix-community.github.io/nixvim/";
      home-manager = "https://nix-community.github.io/home-manager/options.xhtml";
      beeper = "https://chat.beeper.com/";
      chatgpt = "https://chatgpt.com";
    };

    colors.webpage.preferred_color_scheme = "dark";
  };
}
