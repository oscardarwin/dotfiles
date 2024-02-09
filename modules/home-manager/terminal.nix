{ lib, ... }: {
  # environment.variables.TERM = "alacritty";

  programs.alacritty = {
    enable = true;

    settings = {
      # General
      shell.program = "fish";

      # UI
      cursor.style = { shape = "Beam"; };

      window = {
        padding = {
          x = 12;
          y = 10;
        };
        opacity = lib.mkForce 0.9;
      };
    };
  };
}
