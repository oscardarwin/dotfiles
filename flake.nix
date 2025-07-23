{
  description = "hallayus system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wofi-1password-picker = {
      url = "github:oscardarwin/wofi_1password_picker/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    python-dev-flake = {
      url = "path:./dev_flakes/python";
      flake = true;
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, stylix, home-manager, ... }@inputs:
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

      specialArgs = { inherit inputs unstable-pkgs; };

      gastly_home = home_modules: home_modules ++ [
        {
          home.username = "oscar";
          home.homeDirectory = "/home/oscar";
          home.stateVersion = "23.11";
          programs.home-manager.enable = true;
        }
      ];

      nixos_home = home_modules: [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            backupFileExtension = "backup";
            users.hallayus = {
              imports = home_modules;
              home.stateVersion = "21.11";
            };
          };
        }
      ];

      home_modules = [
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
        # ./modules/home-manager/khal.nix
      ];

      nixos_home_modules = [
        ./modules/home-manager/social_media.nix
        ./modules/home-manager/swaylock.nix
      ];

      nixos_modules = [
        ./modules/nixos/lockscreen.nix
        ./modules/nixos/display-manager.nix
        ./modules/nixos/bootloader.nix
        ./modules/nixos/ssh.nix
        ./modules/nixos/audio.nix
        ./modules/nixos/networking.nix
        ./modules/nixos/locale.nix
        ./modules/nixos/screensharing.nix
      ] ++ nixos_home (home_modules ++ nixos_home_modules);

    in
    {
      nixosConfigurations.squirtle = nixpkgs.lib.nixosSystem {
        inherit specialArgs system pkgs;

        modules = nixos_modules ++ [
          ./squirtle_configuration.nix
          ./hardware/squirtle.nix
          inputs.nixos-hardware.nixosModules.microsoft-surface-laptop-amd
        ];
      };

      nixosConfigurations.tyranitar = nixpkgs.lib.nixosSystem {
        inherit specialArgs system pkgs;

        modules = nixos_modules ++ [ ./tyranitar_configuration.nix ./hardware/tyranitar.nix ./modules/nixos/minecraft.nix ] ++ nixos_home [ ./modules/home-manager/tyranitar/keyboard.nix ];
      };

      homeConfigurations.oscar = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = specialArgs;

        modules = gastly_home ([
          ./modules/home-manager/uai-keybindings.nix
          ./modules/home-manager/chrome.nix
          ./modules/home-manager/nixGL.nix
          ./modules/home-manager/gastly_settings.nix
        ] ++ home_modules);
      };

    };
}
