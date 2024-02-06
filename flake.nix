{
  description = "hallayus system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      url = "github:danth/stylix/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
            extraSpecialArgs = { inherit inputs; };

            users.hallayus = {
              imports = home-modules;
              nixpkgs.config.allowUnfree = true;
              home.stateVersion = "21.11";
            };
          };
        }
      ];

    in
    {
      nixosConfigurations.squirtle = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = desktop-system;
        pkgs = desktop-pkgs;
        modules = [
          ./configuration.nix
          ./modules/nixos/lockscreen.nix
          ./modules/spotify
          ./modules/display-manager.nix
          ./modules/password-manager
          ./modules/nixos/bootloader.nix
          ./modules/ssh.nix
          ./modules/terminal.nix
          ./modules/shell.nix
          ./modules/theme
          ./modules/wikipedia.nix
          ./modules/audio.nix
          ./hardware/squirtle.nix
          ./modules/browser.nix
          inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd
        ] ++ squirtle-home [
          ./modules/home-manager/git.nix
          ./modules/home-manager/window-manager.nix
          ./modules/home-manager/neovim.nix
          ./modules/home-manager/startup.nix
        ];
      };

      homeConfigurations.oscar = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = desktop-pkgs;

        modules = ghastly-home [
          ./modules/home-manager/neovim.nix
          ./modules/home-manager/window-manager.nix
        ];
      };

    };
}
