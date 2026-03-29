{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/25.11.tar.gz";
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

    pco = {
      url = "path:./home_modules/sway/personal_context_orchestrator";
      inputs.nixpkgs.follows = "nixpkgs";
      flake = true;
    };
  };

  outputs = { nixpkgs, stylix, home-manager, nixos-hardware, clan-core, ... }@inputs:
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

      specialArgs = { inherit inputs; };
      nixSettings = {
        experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
        http2 = false;
      };

      makeClanMachine = { config, nixosModules, users, hardware }: {
        nixpkgs.hostPlatform = system;
        nixpkgs.pkgs = pkgs;
        imports = nixosModules ++ [
          { nix.settings = nixSettings; }
          hardware
          config
          home-manager.nixosModules.home-manager
        ];
        home-manager = {
          inherit users;
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          backupFileExtension = "backup";
        };
      };

      importHomeModules = moduleNames: map (name: ./home_modules + "/${name}") moduleNames;
      importNixosModules = moduleNames: map (name: ./nixos_modules + "/${name}") moduleNames;

      makeNixosSystemFromHostName = hostName:
        let
          makeHost = import (./hosts + "/${hostName}.nix");
        in
        makeHost { inherit inputs stylix nixos-hardware makeClanMachine importHomeModules importNixosModules; };

      clan = clan-core.lib.clan {
        self = inputs.self;
        inherit specialArgs;
        meta.name = "dotfiles";
        meta.domain = "oscar"; # can be anything unique
        machines = pkgs.lib.genAttrs [ "squirtle" "tyranitar" "porygon" ] (hostName: {
          imports = [ (makeNixosSystemFromHostName hostName) ];
          clan.core.networking.targetHost = "${hostName}.local";
          networking.hostName = hostName;
        });
      };
    in
    {
      inherit (clan.config) nixosConfigurations clanInternals;
      clan = clan.config;

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
            nixSettings
          ];
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [ clan-core.packages.${system}.clan-cli ];
      };
    };
}
