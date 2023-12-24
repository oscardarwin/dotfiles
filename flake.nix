{
  description = "hallayus system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
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
            ./hardware/squirtle.nix 
          ];
        };
      };
    };
}
