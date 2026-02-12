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
  };

  outputs = { nixpkgs, nixpkgs-unstable, stylix, home-manager, nixos-hardware, ... }@inputs:
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

      execute_in_workspace = (import ./modules/home-manager/window-manager/execute_in_workspace.nix) pkgs;

      specialArgs = { inherit inputs unstable-pkgs execute_in_workspace; };

      makeNixosModules = { config, nixosModules, users, hardware }: nixosModules ++ [
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

      importHomeModules = moduleNames: map (name: ./home_modules + "/${name}") moduleNames;
      importNixosModules = moduleNames: map (name: ./nixos_modules + "/${name}") moduleNames;

      makeNixosSystem = makeHostModules: nixpkgs.lib.nixosSystem {
        inherit system specialArgs pkgs;
        modules = makeHostModules { inherit inputs stylix nixos-hardware makeNixosModules importHomeModules importNixosModules; };
      };
    in
    {
      # nixosConfigurations.squirtle = nixpkgs.lib.nixosSystem {
      #   inherit specialArgs system pkgs;

      #   modules = nixos_modules ++ [
      #     ./squirtle_configuration.nix
      #     ./hardware/squirtle.nix
      #     inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd
      #   ];
      # };

      nixosConfigurations = {
        squirtle = makeNixosSystem (import ./hosts/squirtle.nix);
        tyranitar = makeNixosSystem (import ./hosts/tyranitar.nix);
      };
      # nixosConfigurations.tyranitar = nixpkgs.lib.nixosSystem {
      #   inherit specialArgs system pkgs;

      #   modules = nixos_modules ++ [ ./tyranitar_configuration.nix ./hardware/tyranitar.nix ] ++ nixos_home [ ./modules/home-manager/tyranitar/keyboard.nix ];


      homeConfigurations.oscar = home-manager.lib.homeManagerConfiguration {
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
