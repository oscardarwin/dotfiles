{ pkgs, ... }: {
  programs = {
    fish = {
      enable = true;
      loginShellInit = "fish_vi_key_bindings";
      shellAliases = {
        sshs = "eval (ssh-agent -c)
	          ssh-add ~/.ssh/github";
        lg = "lazygit";
        rb = "sudo nixos-rebuild switch --flake .#squirtle --show-trace";
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
