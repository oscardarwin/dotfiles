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

    in {
      nixosConfigurations = {
        squirtle = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = desktop-system;
          pkgs = desktop-pkgs;
          modules = [ 
            ./configuration.nix
            ./modules/window-manager.nix
            ./modules/home-manager.nix
	    ./modules/password-manager.nix 
            ./modules/browser.nix
	    ./modules/ssh.nix
	    ./modules/terminal.nix
	    ./modules/shell.nix
            ./modules/theme
            ./modules/git.nix
            ./modules/audio.nix
            ./hardware/squirtle.nix
            ./modules/home
            inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd 
          ];
        };
      };

      homeConfigurations."oscar" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = desktop-pkgs;

        modules = [ ./modules/home-ubuntu-uai.nix ./modules/home/neovim.nix ];
      };

    };
}
