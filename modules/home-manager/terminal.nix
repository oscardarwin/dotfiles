{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "fish";
      window_padding_width = 4;
    };
  };
}
