{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      # General
      shell.program = "fish";

      window = {
        padding = {
          x = 12;
          y = 10;
        };
      };

    };
  };
}
