{
  description = "Personal Context Orchestrator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, rust-overlay, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          };

          rustToolchain = pkgs.rust-bin.stable.latest.default;

          rustPlatform = pkgs.makeRustPlatform {
            cargo = rustToolchain;
            rustc = rustToolchain;
          };
          commonArgs = {
            pname = "pco";
            version = "0.1.0";
            src = ./.;

            cargoLock = {
              lockFile = ./Cargo.lock;
            };
          };

        in
        {
          packages = {
            pco-client = rustPlatform.buildRustPackage (commonArgs // {
              pname = "pco-client";
              cargoBuildFlags = [ "--bin" "client" ];
              cargoInstallFlags = [ "--bin" "client" ];
            });

            pco-daemon = rustPlatform.buildRustPackage (commonArgs // {
              pname = "pco-daemon";
              cargoBuildFlags = [ "--bin" "daemon" ];
              cargoInstallFlags = [ "--bin" "daemon" ];
            });
          };
          devShells.default = pkgs.mkShell {
            packages = [
              rustToolchain
              pkgs.socat
            ];
          };
        };

      flake = {
        homeManagerModules.pco = import ./module.nix;
      };
    };
}
