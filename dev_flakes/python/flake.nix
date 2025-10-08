{
  description = "Python debug shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };

  };

  outputs = { nixpkgs, nixGL, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nixglPkgs = nixGL.packages.${system};
      glewLibPath = pkgs.lib.makeLibraryPath [ pkgs.glew ];

      shell = python_package: pkgs.mkShell rec {
        packages = with pkgs; [
          python_package
          python3Packages.debugpy
          libglvnd
          gcc.cc.lib
          xorg.libX11
          libudev-zero
          libz
          glib
          glfw
          libGL
          mesa
          wayland
          libxkbcommon
          glew
          mesa
          xwayland
          tbb_2021
          nodejs_24
        ] ++ [
          (import nixGL { inherit pkgs; }).nixGLIntel
        ];

        shellHook = ''
          export LD_LIBRARY_PATH="${nixpkgs.lib.makeLibraryPath packages}"
          export XDG_SESSION_TYPE=x11
          if [ ! -d .venv ]; then
            nixGLIntel python -m venv .venv
          fi
          source .venv/bin/activate
          fish
        '';
      };
    in
    {
      devShells.${system} = {
        python310 = shell pkgs.python310;
        python311 = shell pkgs.python311;
      };
    };
}
