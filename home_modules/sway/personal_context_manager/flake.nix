{
  description = "Sway context IPC service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, rust-overlay, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [ "x86_64-linux" "aarch64-linux" ];

      perSystem = { system, pkgs, ... }:
        let
          overlays = [ rust-overlay.overlays.default ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };

          rustToolchain = pkgs.rust-bin.stable.latest.default;
        in
        {
          packages.contextd = pkgs.rustPlatform.buildRustPackage {
            pname = "contextd";
            version = "0.1.0";
            src = ".";

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            nativeBuildInputs = [ rustToolchain ];
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [
              rustToolchain
              pkgs.socat
            ];
          };
        };

      flake = {
        homeManagerModules.contextd = import ./module.nix;
      };
    };
}
