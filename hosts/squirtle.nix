{ nixos-hardware, stylix, pkgs, ... }: {
  homeModules = [
    ./modules/home-manager/fonts.nix
    ./modules/home-manager/firefox.nix
    ./modules/home-manager/git.nix
    ./modules/home-manager/window-manager
    ./modules/home-manager/nixvim
    ./modules/home-manager/startup.nix
    ./modules/home-manager/shell.nix
    ./modules/home-manager/terminal.nix
    ./modules/home-manager/screen.nix
    ./modules/home-manager/qutebrowser
    ./modules/home-manager/packages.nix
    stylix.homeModules.stylix
    ./modules/home-manager/stylix.nix
    ./modules/home-manager/wofi.nix

    /social_media.nix
    /swaylock.nix
  ];

  nixosModules = [
    /lockscreen.nix
    /display-manager.nix
    /bootloader.nix
    /ssh.nix
    /audio.nix
    /networking.nix
    /locale.nix
    /screensharing.nix
    /docker.nix

    /squirtle_configuration.nix
    /squirtle_hardware.nix
    nixos-hardware.nixosModules.microsoft-surface-laptop-amd
  ];

  options = {
    programs.dconf.enable = true;
    services.printing.enable = true;

    environment.systemPackages = with pkgs; [ brightnessctl ];
    # Configure keymap in X11 -- can remove??
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.hallayus = {
      isNormalUser = true;
      description = "hallayus";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
  };
}
