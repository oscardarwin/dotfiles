{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    python-dev-flake = {
      url = "path:./dev_flakes/python";
      flake = true;
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, stylix, home-manager, nixos-hardware, haumea, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = (import nixpkgs) {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          permittedInsecurePackages = [ "openssl-1.1.1w" ];
        };
      };

      unstable-pkgs = (import nixpkgs-unstable) {
        inherit system;
      };

      executeInWorkspace = (import ./home_modules/sway/execute_in_workspace.nix) pkgs;

      specialArgs = { inherit inputs unstable-pkgs executeInWorkspace; };

      makeNixosSystem = { config, nixosModules, users, hardware }: nixpkgs.lib.nixosSystem {

        inherit system specialArgs pkgs;
        modules = nixosModules ++ [
          { nix.settings.experimental-features = [ "nix-command" "flakes" ]; }
          hardware
          config
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              inherit users;
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              backupFileExtension = "backup";
            };
          }
        ];
      };
      importHomeModules = moduleNames: map (name: ./home_modules + "/${name}") moduleNames;
      importNixosModules = moduleNames: map (name: ./nixos_modules + "/${name}") moduleNames;

      makeNixosSystemFromHostName = hostName:
        let
          makeHost = import (./hosts + "/${hostName}.nix");
        in
        makeHost { inherit inputs stylix nixos-hardware makeNixosSystem importHomeModules importNixosModules; };
    in
    {
      nixosConfigurations = pkgs.lib.genAttrs [ "squirtle" "tyranitar" "porygon" ] makeNixosSystemFromHostName;

      homeConfigurations.gastly = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;

        modules =
          let
            hostModules = (import ./hosts/gastly.nix) { inherit inputs stylix importHomeModules; };
          in
          hostModules.homeModules ++
          [
            hostModules.config
          ];
      };
    };
}
