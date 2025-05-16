{ ... }: {
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
        sshs = "eval (ssh-agent -c)
	          ssh-add ~/.ssh/github";
        lg = "lazygit";
        rb = "sudo nixos-rebuild switch --flake";
        gl = "git log --all --decorate --oneline --graph";
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

    htop.enable = true;

    jq.enable = true;

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
