{ ... }: {
  programs = {
    fish = {
      enable = true;
      loginShellInit = ''
        fish_vi_key_bindings
      '';
      shellInit = ''
        set fish_cursor_default block      
        set fish_cursor_insert line       
        set fish_cursor_replace_one underscore 
        set fish_cursor_visual block
      '';
      shellAliases = {
        sshs = "eval (ssh-agent -c)
	          ssh-add ~/.ssh/github";
        lg = "lazygit";
        rb = "sudo nixos-rebuild switch --flake .#squirtle --show-trace";
        gl = "git log --all --decorate --oneline --graph";
      };
    };
    nushell.enable = true;
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
  };
}
