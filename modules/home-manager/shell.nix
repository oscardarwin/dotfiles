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
        ls = "eza -a";
        cat = "bat";
        pl = "export OP_SESSION=$(op signin --raw) && systemctl --user import-environment OP_SESSION";
        op_setup = "op account add --address my.1password.com --email oscar.henry.darwin@gmail.com";
        hotspot = "${connect_hotspot}";
        bs = "brightnessctl set";
        mn = "rclone mount gdrive:notes ~/notes --daemon --vfs-cache-mode full --buffer-size 256M --dir-cache-time 72h --drive-chunk-size 32M";
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

    btop.enable = true;

    jq.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    ssh.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };

    ncspot = {
      enable = true;
      settings = {
        keybindings = {
          "Ctrl+s" = "focus search";
          "Ctrl+q" = "focus queue";
          "Ctrl+l" = "focus library";
        };
      };
    };

    bat.enable = true;
    fd.enable = true;
    feh.enable = true; # Image Viewer
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
    grim
    slurp
  ];
}
