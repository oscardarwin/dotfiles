{ pkgs, ... }:
let
  connect_hotspot = pkgs.writeScript "hotspot.sh" (builtins.readFile ./hotspot.sh);
in
{
  programs = {
    fish = {
      enable = true;
      shellInit = ''
        set fish_cursor_default block      
        set fish_cursor_insert line       
        set fish_cursor_replace_one underscore 
        set fish_cursor_visual block
        fish_vi_key_bindings
      '';
      shellAliases = {
        sshs = "eval (ssh-agent -c) && ssh-add ~/.ssh/github";
        lg = "lazygit";
        rb = "sudo nixos-rebuild switch --flake";
        gl = "git log --all --decorate --oneline --graph";
        pl = "export OP_SESSION=$(op signin --raw) && systemctl --user import-environment OP_SESSION";
        op_setup = "op account add --address my.1password.com --email oscar.henry.darwin@gmail.com";
        hotspot = "${connect_hotspot}";
      };
    };
    ripgrep.enable = true;

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };

    htop.enable = true;

    jq.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    ssh = {
      enable = true;
      extraConfig = ''IdentityAgent ~/.1password/agent.sock'';
      # addKeysToAgent = "~/.ssh/github";
    };
  };

  services.ssh-agent = {
    enable = true;
  };

  home.packages = with pkgs; [
    wl-clipboard
    nixd
    nixdoc
    unzip
    manix
    du-dust
    wiki-tui

    _1password-cli
  ];
}
