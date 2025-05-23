{ lib, ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      # General
      terminal.shell.program = "fish";

      window = {
        padding = {
          x = 12;
          y = 10;
        };
      };

      font.size = lib.mkForce 10.0;
    };
  };
}
