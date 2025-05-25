{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings.shell = "fish";
    # font.size = 10.0;
  };
}
