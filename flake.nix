{
  description = "hallayus system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      pkgs-unstable = (import inputs.nixpkgs-unstable) {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      specialArgs = { inherit inputs pkgs-unstable; };

      desktop-system = "x86_64-linux";
      desktop-pkgs = (import nixpkgs) {
        system = desktop-system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          permittedInsecurePackages = [ "openssl-1.1.1w" ];
        };
      };

      ghastly-home = home-modules: home-modules ++ [
        {
          home.username = "oscar";
          home.homeDirectory = "/home/oscar";
          home.stateVersion = "23.11";
          programs.home-manager.enable = true;
        }
      ];

      squirtle-home = home-modules: [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs pkgs-unstable; };
            users.hallayus = {
              imports = home-modules;
              nixpkgs.config.allowUnfree = true;
              home.stateVersion = "21.11";
            };
          };
        }
      ];

      nixos-modules = [
        ./modules/nixos/tools.nix
        ./modules/nixos/lockscreen.nix
        ./modules/nixos/display-manager.nix
        ./modules/nixos/password-manager
        ./modules/nixos/bootloader.nix
        ./modules/nixos/ssh.nix
        ./modules/nixos/wikipedia.nix
        ./modules/nixos/audio.nix
        ./modules/nixos/networking.nix
        ./modules/nixos/locale.nix
        ./modules/nixos/screensharing.nix
        ./modules/nixos/rclone.nix
        ./modules/nixos/resource-monitoring.nix
        ./modules/nixos/chat.nix
      ] ++ squirtle-home [
        ./modules/home-manager/keybindings.nix
        ./modules/home-manager/theme
        ./modules/home-manager/firefox.nix
        ./modules/home-manager/git.nix
        ./modules/home-manager/window-manager
        ./modules/home-manager/editor
        ./modules/home-manager/startup.nix
        ./modules/home-manager/shell.nix
        ./modules/home-manager/terminal.nix
      ];

    in
    {
      nixosConfigurations.squirtle = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = desktop-system;
        pkgs = desktop-pkgs;

        modules = nixos-modules ++ [ ./squirtle_configuration.nix ./hardware/squirtle.nix inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd ];
      };

      nixosConfigurations.tyranitar = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = desktop-system;
        pkgs = desktop-pkgs;

        modules = nixos-modules ++ [ ./tyranitar_configuration.nix ./hardware/tyranitar.nix ];
      };

      homeConfigurations.oscar = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = desktop-pkgs;
        extraSpecialArgs = { inherit inputs pkgs-unstable; };

        modules = ghastly-home [
          # ./modules/home-manager/theme
          ./modules/home-manager/uai-keybindings.nix
          ./modules/home-manager/keybindings.nix
          ./modules/home-manager/uai-ubuntu-config.nix
          ./modules/home-manager/firefox.nix
          ./modules/home-manager/chrome.nix
          ./modules/home-manager/neovim
          ./modules/home-manager/window-manager
          ./modules/home-manager/shell.nix
          ./modules/home-manager/terminal.nix
          ./modules/home-manager/nixGL.nix
        ];
      };

    };
}
