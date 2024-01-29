{
  description = "hallayus system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix = {
      url = "github:danth/stylix/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-config = {
      url = "github:hallayus/neovim_config/main";
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
            ./modules/theme
            ./modules/git.nix
            ./modules/audio.nix
            ./hardware/squirtle.nix
            ./modules/neovim
            inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd 
          ];
        };
      };
    };
}
