{ pkgs, config, inputs, ... }:

let
  colors = config.lib.stylix.colors;

  # Rust service checker
  servicesScriptDerivation = pkgs.rustPlatform.buildRustPackage {
    pname = "check-services-statuses";
    version = "1.0.0";
    src = ./check_services;
    cargoLock.lockFile = ./check_services/Cargo.lock;
  };

  servicesScript = "${servicesScriptDerivation}/bin/check-services-statuses";

  # PCO client context listener
  pcoClientPackage = inputs.pco.packages.${pkgs.system}.pco-client;
  contextsScript = "${pcoClientPackage}/bin/client listen-for-contexts";

  # Inline Eww config as a string

  ewwYuck = builtins.readFile ./eww.yuck;
  # Inline SCSS for styling
  ewwScss = ''
  '';

in
{
  xdg.configFile."eww/eww.yuck".text = builtins.replaceStrings [ "@pco-client" ] [ "${contextsScript}" ] ewwYuck;
  xdg.configFile."eww/eww.scss".text = ewwScss;

  home.packages = with pkgs; [
    pamixer
    pavucontrol
    jq
    coreutils
    procps
    gnugrep
    gawk
    networkmanager
    eww
  ];

  wayland.windowManager.sway.config.startup = [
    {
      command = "eww daemon";
      always = true;
    }
    {
      command = "eww open mainbar";
    }
  ];
}
  






