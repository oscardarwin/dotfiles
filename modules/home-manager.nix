{ inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.hallayus = {
      nixpkgs.config.allowUnfree = true;
      home.stateVersion = "21.11";
    };
  };
}
