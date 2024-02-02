{ lib, ... }: {
  environment.variables.TERM = "alacritty";

  home-manager.users.hallayus.programs.alacritty = {
    enable = true;

    settings = {
      # General
      shell.program = "nu";

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
